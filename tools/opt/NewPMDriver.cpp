//===- NewPMDriver.cpp - Driver for opt with new PM -----------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
///
/// This file is just a split of the code that logically belongs in opt.cpp but
/// that includes the new pass manager headers.
///
//===----------------------------------------------------------------------===//

#include "NewPMDriver.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/CGSCCPassManager.h"
#include "llvm/Bitcode/BitcodeWriterPass.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/IRPrintingPasses.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/ToolOutputFile.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Transforms/IPO/ThinLTOBitcodeWriter.h"
#include "llvm/Transforms/Scalar/LoopPassManager.h"

using namespace llvm;
using namespace opt_tool;

static cl::opt<bool>
    DebugPM("debug-pass-manager", cl::Hidden,
            cl::desc("Print pass management debugging information"));

// This flag specifies a textual description of the alias analysis pipeline to
// use when querying for aliasing information. It only works in concert with
// the "passes" flag above.
static cl::opt<std::string>
    AAPipeline("aa-pipeline",
               cl::desc("A textual description of the alias analysis "
                        "pipeline for handling managed aliasing queries"),
               cl::Hidden);

/// {{@ These options accept textual pipeline descriptions which will be
/// inserted into default pipelines at the respective extension points
static cl::opt<std::string> PeepholeEPPipeline(
    "passes-ep-peephole",
    cl::desc("A textual description of the function pass pipeline inserted at "
             "the Peephole extension points into default pipelines"),
    cl::Hidden);
static cl::opt<std::string> LateLoopOptimizationsEPPipeline(
    "passes-ep-late-loop-optimizations",
    cl::desc(
        "A textual description of the loop pass pipeline inserted at "
        "the LateLoopOptimizations extension point into default pipelines"),
    cl::Hidden);
static cl::opt<std::string> LoopOptimizerEndEPPipeline(
    "passes-ep-loop-optimizer-end",
    cl::desc("A textual description of the loop pass pipeline inserted at "
             "the LoopOptimizerEnd extension point into default pipelines"),
    cl::Hidden);
static cl::opt<std::string> ScalarOptimizerLateEPPipeline(
    "passes-ep-scalar-optimizer-late",
    cl::desc("A textual description of the function pass pipeline inserted at "
             "the ScalarOptimizerLate extension point into default pipelines"),
    cl::Hidden);
static cl::opt<std::string> CGSCCOptimizerLateEPPipeline(
    "passes-ep-cgscc-optimizer-late",
    cl::desc("A textual description of the cgscc pass pipeline inserted at "
             "the CGSCCOptimizerLate extension point into default pipelines"),
    cl::Hidden);
static cl::opt<std::string> VectorizerStartEPPipeline(
    "passes-ep-vectorizer-start",
    cl::desc("A textual description of the function pass pipeline inserted at "
             "the VectorizerStart extension point into default pipelines"),
    cl::Hidden);
/// @}}

/// If one of the EPPipeline command line options was given, register callbacks
/// for parsing and inserting the given pipeline
static void registerEPCallbacks(PassBuilder &PB, bool VerifyEachPass,
                                bool DebugLogging) {
  if (!PeepholeEPPipeline.empty())
    PB.registerPeepholeEPCallback([&PB, VerifyEachPass, DebugLogging](
        FunctionPassManager &PM, PassBuilder::OptimizationLevel Level) {
      return PB.parsePassPipeline(PM, PeepholeEPPipeline, VerifyEachPass,
                                  DebugPM);
    });
  if (!LateLoopOptimizationsEPPipeline.empty())
    PB.registerLateLoopOptimizationsEPCallback(
        [&PB, VerifyEachPass, DebugLogging](
            LoopPassManager &PM, PassBuilder::OptimizationLevel Level) {
          return PB.parsePassPipeline(PM, LateLoopOptimizationsEPPipeline,
                                      VerifyEachPass, DebugPM);
        });
  if (!LoopOptimizerEndEPPipeline.empty())
    PB.registerLoopOptimizerEndEPCallback([&PB, VerifyEachPass, DebugLogging](
        LoopPassManager &PM, PassBuilder::OptimizationLevel Level) {
      return PB.parsePassPipeline(PM, LoopOptimizerEndEPPipeline,
                                  VerifyEachPass, DebugPM);
    });
  if (!ScalarOptimizerLateEPPipeline.empty())
    PB.registerScalarOptimizerLateEPCallback(
        [&PB, VerifyEachPass, DebugLogging](
            FunctionPassManager &PM, PassBuilder::OptimizationLevel Level) {
          return PB.parsePassPipeline(PM, ScalarOptimizerLateEPPipeline,
                                      VerifyEachPass, DebugPM);
        });
  if (!CGSCCOptimizerLateEPPipeline.empty())
    PB.registerCGSCCOptimizerLateEPCallback([&PB, VerifyEachPass, DebugLogging](
        CGSCCPassManager &PM, PassBuilder::OptimizationLevel Level) {
      return PB.parsePassPipeline(PM, CGSCCOptimizerLateEPPipeline,
                                  VerifyEachPass, DebugPM);
    });
  if (!VectorizerStartEPPipeline.empty())
    PB.registerVectorizerStartEPCallback([&PB, VerifyEachPass, DebugLogging](
        FunctionPassManager &PM, PassBuilder::OptimizationLevel Level) {
      return PB.parsePassPipeline(PM, VectorizerStartEPPipeline, VerifyEachPass,
                                  DebugPM);
    });
}

bool llvm::runPassPipeline(StringRef Arg0, Module &M, TargetMachine *TM,
                           tool_output_file *Out,
                           tool_output_file *ThinLTOLinkOut,
                           StringRef PassPipeline, OutputKind OK,
                           VerifierKind VK,
                           bool ShouldPreserveAssemblyUseListOrder,
                           bool ShouldPreserveBitcodeUseListOrder,
                           bool EmitSummaryIndex, bool EmitModuleHash) {
  bool VerifyEachPass = VK == VK_VerifyEachPass;
  PassBuilder PB(TM);
  registerEPCallbacks(PB, VerifyEachPass, DebugPM);

  // Specially handle the alias analysis manager so that we can register
  // a custom pipeline of AA passes with it.
  AAManager AA;
  if (!PB.parseAAPipeline(AA, AAPipeline)) {
    errs() << Arg0 << ": unable to parse AA pipeline description.\n";
    return false;
  }

  LoopAnalysisManager LAM(DebugPM);
  FunctionAnalysisManager FAM(DebugPM);
  CGSCCAnalysisManager CGAM(DebugPM);
  ModuleAnalysisManager MAM(DebugPM);

  // Register the AA manager first so that our version is the one used.
  FAM.registerPass([&] { return std::move(AA); });

  // Register all the basic analyses with the managers.
  PB.registerModuleAnalyses(MAM);
  PB.registerCGSCCAnalyses(CGAM);
  PB.registerFunctionAnalyses(FAM);
  PB.registerLoopAnalyses(LAM);
  PB.crossRegisterProxies(LAM, FAM, CGAM, MAM);

  ModulePassManager MPM(DebugPM);
  if (VK > VK_NoVerifier)
    MPM.addPass(VerifierPass());

  if (!PB.parsePassPipeline(MPM, PassPipeline, VerifyEachPass, DebugPM)) {
    errs() << Arg0 << ": unable to parse pass pipeline description.\n";
    return false;
  }

  if (VK > VK_NoVerifier)
    MPM.addPass(VerifierPass());

  // Add any relevant output pass at the end of the pipeline.
  switch (OK) {
  case OK_NoOutput:
    break; // No output pass needed.
  case OK_OutputAssembly:
    MPM.addPass(
        PrintModulePass(Out->os(), "", ShouldPreserveAssemblyUseListOrder));
    break;
  case OK_OutputBitcode:
    MPM.addPass(BitcodeWriterPass(Out->os(), ShouldPreserveBitcodeUseListOrder,
                                  EmitSummaryIndex, EmitModuleHash));
    break;
  case OK_OutputThinLTOBitcode:
    MPM.addPass(ThinLTOBitcodeWriterPass(
        Out->os(), ThinLTOLinkOut ? &ThinLTOLinkOut->os() : nullptr));
    break;
  }

  // Before executing passes, print the final values of the LLVM options.
  cl::PrintOptionValues();

  // Now that we have all of the passes ready, run them.
  MPM.run(M, MAM);

  // Declare success.
  if (OK != OK_NoOutput) {
    Out->keep();
    if (OK == OK_OutputThinLTOBitcode && ThinLTOLinkOut)
      ThinLTOLinkOut->keep();
  }
  return true;
}
