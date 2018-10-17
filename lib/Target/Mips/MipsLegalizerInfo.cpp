//===- MipsLegalizerInfo.cpp ------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the Machinelegalizer class for Mips.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "MipsLegalizerInfo.h"
#include "MipsTargetMachine.h"
#include "llvm/CodeGen/GlobalISel/LegalizerHelper.h"

using namespace llvm;

MipsLegalizerInfo::MipsLegalizerInfo(const MipsSubtarget &ST) {
  using namespace TargetOpcode;

  const LLT s32 = LLT::scalar(32);
  const LLT s64 = LLT::scalar(64);
  const LLT p0 = LLT::pointer(0, 32);

  getActionDefinitionsBuilder(G_ADD)
      .legalFor({s32})
      .minScalar(0, s32)
      .customFor({s64});

  getActionDefinitionsBuilder({G_LOAD, G_STORE})
      .legalForCartesianProduct({p0, s32}, {p0});

  getActionDefinitionsBuilder({G_AND, G_OR, G_XOR, G_SHL, G_ASHR, G_LSHR})
      .legalFor({s32});

  getActionDefinitionsBuilder(G_ICMP)
      .legalFor({{s32, s32}})
      .minScalar(0, s32);

  getActionDefinitionsBuilder(G_CONSTANT)
      .legalFor({s32})
      .minScalar(0, s32)
      .customFor({s64});

  getActionDefinitionsBuilder(G_GEP)
      .legalFor({{p0, s32}});

  getActionDefinitionsBuilder(G_FRAME_INDEX)
      .legalFor({p0});

  getActionDefinitionsBuilder(G_GLOBAL_VALUE)
      .legalFor({p0});

  computeTables();
  verify(*ST.getInstrInfo());
}

bool MipsLegalizerInfo::legalizeCustom(MachineInstr &MI,
                                       MachineRegisterInfo &MRI,
                                       MachineIRBuilder &MIRBuilder) const {

  using namespace TargetOpcode;

  MIRBuilder.setInstr(MI);

  switch (MI.getOpcode()) {
  case G_ADD: {
    unsigned Size = MRI.getType(MI.getOperand(0).getReg()).getSizeInBits();

    const LLT sHalf = LLT::scalar(Size / 2);

    unsigned RHSLow = MRI.createGenericVirtualRegister(sHalf);
    unsigned RHSHigh = MRI.createGenericVirtualRegister(sHalf);
    unsigned LHSLow = MRI.createGenericVirtualRegister(sHalf);
    unsigned LHSHigh = MRI.createGenericVirtualRegister(sHalf);
    unsigned ResLow = MRI.createGenericVirtualRegister(sHalf);
    unsigned ResHigh = MRI.createGenericVirtualRegister(sHalf);
    unsigned Carry = MRI.createGenericVirtualRegister(sHalf);
    unsigned TmpResHigh = MRI.createGenericVirtualRegister(sHalf);

    MIRBuilder.buildUnmerge({RHSHigh, RHSLow}, MI.getOperand(2).getReg());
    MIRBuilder.buildUnmerge({LHSHigh, LHSLow}, MI.getOperand(1).getReg());

    MIRBuilder.buildAdd(TmpResHigh, LHSHigh, RHSHigh);
    MIRBuilder.buildAdd(ResLow, LHSLow, RHSLow);
    MIRBuilder.buildICmp(CmpInst::ICMP_ULT, Carry, ResLow, LHSLow);
    MIRBuilder.buildAdd(ResHigh, TmpResHigh, Carry);

    MIRBuilder.buildMerge(MI.getOperand(0).getReg(), {ResHigh, ResLow});

    MI.eraseFromParent();
    break;
  }
  case G_CONSTANT: {

    unsigned Size = MRI.getType(MI.getOperand(0).getReg()).getSizeInBits();
    const LLT sHalf = LLT::scalar(Size / 2);

    const APInt &CImmValue = MI.getOperand(1).getCImm()->getValue();

    unsigned ResLow = MRI.createGenericVirtualRegister(sHalf);
    unsigned ResHigh = MRI.createGenericVirtualRegister(sHalf);
    MIRBuilder.buildConstant(
        ResLow, *ConstantInt::get(MI.getMF()->getFunction().getContext(),
                                  CImmValue.trunc(Size / 2)));
    MIRBuilder.buildConstant(
        ResHigh, *ConstantInt::get(MI.getMF()->getFunction().getContext(),
                                   CImmValue.lshr(Size / 2).trunc(Size / 2)));

    MIRBuilder.buildMerge(MI.getOperand(0).getReg(), {ResHigh, ResLow});

    MI.eraseFromParent();
    break;
  }
  default:
    return false;
  }

  return true;
}
