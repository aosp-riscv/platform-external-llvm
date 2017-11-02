//===- MachineBlockFrequencyInfo.cpp - MBB Frequency Analysis -------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Loops should be simplified before this analysis.
//
//===----------------------------------------------------------------------===//

#include "llvm/CodeGen/MachineBlockFrequencyInfo.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/None.h"
#include "llvm/ADT/iterator.h"
#include "llvm/Analysis/BlockFrequencyInfoImpl.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineBranchProbabilityInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineLoopInfo.h"
#include "llvm/Pass.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/GraphWriter.h"
#include <string>

using namespace llvm;

#define DEBUG_TYPE "machine-block-freq"

static cl::opt<GVDAGType> ViewMachineBlockFreqPropagationDAG(
    "view-machine-block-freq-propagation-dags", cl::Hidden,
    cl::desc("Pop up a window to show a dag displaying how machine block "
             "frequencies propagate through the CFG."),
    cl::values(clEnumValN(GVDT_None, "none", "do not display graphs."),
               clEnumValN(GVDT_Fraction, "fraction",
                          "display a graph using the "
                          "fractional block frequency representation."),
               clEnumValN(GVDT_Integer, "integer",
                          "display a graph using the raw "
                          "integer fractional block frequency representation."),
               clEnumValN(GVDT_Count, "count", "display a graph using the real "
                                               "profile count if available.")));

// Similar option above, but used to control BFI display only after MBP pass
cl::opt<GVDAGType> ViewBlockLayoutWithBFI(
    "view-block-layout-with-bfi", cl::Hidden,
    cl::desc(
        "Pop up a window to show a dag displaying MBP layout and associated "
        "block frequencies of the CFG."),
    cl::values(clEnumValN(GVDT_None, "none", "do not display graphs."),
               clEnumValN(GVDT_Fraction, "fraction",
                          "display a graph using the "
                          "fractional block frequency representation."),
               clEnumValN(GVDT_Integer, "integer",
                          "display a graph using the raw "
                          "integer fractional block frequency representation."),
               clEnumValN(GVDT_Count, "count",
                          "display a graph using the real "
                          "profile count if available.")));

// Command line option to specify the name of the function for CFG dump
// Defined in Analysis/BlockFrequencyInfo.cpp:  -view-bfi-func-name=
extern cl::opt<std::string> ViewBlockFreqFuncName;

// Command line option to specify hot frequency threshold.
// Defined in Analysis/BlockFrequencyInfo.cpp:  -view-hot-freq-perc=
extern cl::opt<unsigned> ViewHotFreqPercent;

static cl::opt<bool> PrintMachineBlockFreq(
    "print-machine-bfi", cl::init(false), cl::Hidden,
    cl::desc("Print the machine block frequency info."));

// Command line option to specify the name of the function for block frequency
// dump. Defined in Analysis/BlockFrequencyInfo.cpp.
extern cl::opt<std::string> PrintBlockFreqFuncName;

static GVDAGType getGVDT() {
  if (ViewBlockLayoutWithBFI != GVDT_None)
    return ViewBlockLayoutWithBFI;

  return ViewMachineBlockFreqPropagationDAG;
}

namespace llvm {

template <> struct GraphTraits<MachineBlockFrequencyInfo *> {
  using NodeRef = const MachineBasicBlock *;
  using ChildIteratorType = MachineBasicBlock::const_succ_iterator;
  using nodes_iterator = pointer_iterator<MachineFunction::const_iterator>;

  static NodeRef getEntryNode(const MachineBlockFrequencyInfo *G) {
    return &G->getFunction()->front();
  }

  static ChildIteratorType child_begin(const NodeRef N) {
    return N->succ_begin();
  }

  static ChildIteratorType child_end(const NodeRef N) { return N->succ_end(); }

  static nodes_iterator nodes_begin(const MachineBlockFrequencyInfo *G) {
    return nodes_iterator(G->getFunction()->begin());
  }

  static nodes_iterator nodes_end(const MachineBlockFrequencyInfo *G) {
    return nodes_iterator(G->getFunction()->end());
  }
};

using MBFIDOTGraphTraitsBase =
    BFIDOTGraphTraitsBase<MachineBlockFrequencyInfo,
                          MachineBranchProbabilityInfo>;

template <>
struct DOTGraphTraits<MachineBlockFrequencyInfo *>
    : public MBFIDOTGraphTraitsBase {
  const MachineFunction *CurFunc = nullptr;
  DenseMap<const MachineBasicBlock *, int> LayoutOrderMap;

  explicit DOTGraphTraits(bool isSimple = false)
      : MBFIDOTGraphTraitsBase(isSimple) {}

  std::string getNodeLabel(const MachineBasicBlock *Node,
                           const MachineBlockFrequencyInfo *Graph) {
    int layout_order = -1;
    // Attach additional ordering information if 'isSimple' is false.
    if (!isSimple()) {
      const MachineFunction *F = Node->getParent();
      if (!CurFunc || F != CurFunc) {
        if (CurFunc)
          LayoutOrderMap.clear();

        CurFunc = F;
        int O = 0;
        for (auto MBI = F->begin(); MBI != F->end(); ++MBI, ++O) {
          LayoutOrderMap[&*MBI] = O;
        }
      }
      layout_order = LayoutOrderMap[Node];
    }
    return MBFIDOTGraphTraitsBase::getNodeLabel(Node, Graph, getGVDT(),
                                                layout_order);
  }

  std::string getNodeAttributes(const MachineBasicBlock *Node,
                                const MachineBlockFrequencyInfo *Graph) {
    return MBFIDOTGraphTraitsBase::getNodeAttributes(Node, Graph,
                                                     ViewHotFreqPercent);
  }

  std::string getEdgeAttributes(const MachineBasicBlock *Node, EdgeIter EI,
                                const MachineBlockFrequencyInfo *MBFI) {
    return MBFIDOTGraphTraitsBase::getEdgeAttributes(
        Node, EI, MBFI, MBFI->getMBPI(), ViewHotFreqPercent);
  }
};

} // end namespace llvm

INITIALIZE_PASS_BEGIN(MachineBlockFrequencyInfo, DEBUG_TYPE,
                      "Machine Block Frequency Analysis", true, true)
INITIALIZE_PASS_DEPENDENCY(MachineBranchProbabilityInfo)
INITIALIZE_PASS_DEPENDENCY(MachineLoopInfo)
INITIALIZE_PASS_END(MachineBlockFrequencyInfo, DEBUG_TYPE,
                    "Machine Block Frequency Analysis", true, true)

char MachineBlockFrequencyInfo::ID = 0;

MachineBlockFrequencyInfo::MachineBlockFrequencyInfo()
    : MachineFunctionPass(ID) {
  initializeMachineBlockFrequencyInfoPass(*PassRegistry::getPassRegistry());
}

MachineBlockFrequencyInfo::~MachineBlockFrequencyInfo() = default;

void MachineBlockFrequencyInfo::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.addRequired<MachineBranchProbabilityInfo>();
  AU.addRequired<MachineLoopInfo>();
  AU.setPreservesAll();
  MachineFunctionPass::getAnalysisUsage(AU);
}

void MachineBlockFrequencyInfo::calculate(
    const MachineFunction &F, const MachineBranchProbabilityInfo &MBPI,
    const MachineLoopInfo &MLI) {
  if (!MBFI)
    MBFI.reset(new ImplType);
  MBFI->calculate(F, MBPI, MLI);
  if (ViewMachineBlockFreqPropagationDAG != GVDT_None &&
      (ViewBlockFreqFuncName.empty() ||
       F.getName().equals(ViewBlockFreqFuncName))) {
    view("MachineBlockFrequencyDAGS." + F.getName());
  }
  if (PrintMachineBlockFreq &&
      (PrintBlockFreqFuncName.empty() ||
       F.getName().equals(PrintBlockFreqFuncName))) {
    MBFI->print(dbgs());
  }
}

bool MachineBlockFrequencyInfo::runOnMachineFunction(MachineFunction &F) {
  MachineBranchProbabilityInfo &MBPI =
      getAnalysis<MachineBranchProbabilityInfo>();
  MachineLoopInfo &MLI = getAnalysis<MachineLoopInfo>();
  calculate(F, MBPI, MLI);
  return false;
}

void MachineBlockFrequencyInfo::releaseMemory() { MBFI.reset(); }

/// Pop up a ghostview window with the current block frequency propagation
/// rendered using dot.
void MachineBlockFrequencyInfo::view(const Twine &Name, bool isSimple) const {
  // This code is only for debugging.
  ViewGraph(const_cast<MachineBlockFrequencyInfo *>(this), Name, isSimple);
}

BlockFrequency
MachineBlockFrequencyInfo::getBlockFreq(const MachineBasicBlock *MBB) const {
  return MBFI ? MBFI->getBlockFreq(MBB) : 0;
}

Optional<uint64_t> MachineBlockFrequencyInfo::getBlockProfileCount(
    const MachineBasicBlock *MBB) const {
  const Function *F = MBFI->getFunction()->getFunction();
  return MBFI ? MBFI->getBlockProfileCount(*F, MBB) : None;
}

Optional<uint64_t>
MachineBlockFrequencyInfo::getProfileCountFromFreq(uint64_t Freq) const {
  const Function *F = MBFI->getFunction()->getFunction();
  return MBFI ? MBFI->getProfileCountFromFreq(*F, Freq) : None;
}

bool
MachineBlockFrequencyInfo::isIrrLoopHeader(const MachineBasicBlock *MBB) {
  assert(MBFI && "Expected analysis to be available");
  return MBFI->isIrrLoopHeader(MBB);
}

const MachineFunction *MachineBlockFrequencyInfo::getFunction() const {
  return MBFI ? MBFI->getFunction() : nullptr;
}

const MachineBranchProbabilityInfo *MachineBlockFrequencyInfo::getMBPI() const {
  return MBFI ? &MBFI->getBPI() : nullptr;
}

raw_ostream &
MachineBlockFrequencyInfo::printBlockFreq(raw_ostream &OS,
                                          const BlockFrequency Freq) const {
  return MBFI ? MBFI->printBlockFreq(OS, Freq) : OS;
}

raw_ostream &
MachineBlockFrequencyInfo::printBlockFreq(raw_ostream &OS,
                                          const MachineBasicBlock *MBB) const {
  return MBFI ? MBFI->printBlockFreq(OS, MBB) : OS;
}

uint64_t MachineBlockFrequencyInfo::getEntryFreq() const {
  return MBFI ? MBFI->getEntryFreq() : 0;
}
