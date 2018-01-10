; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s

; TODO: the quality of the generated code is poor

define void @test() nounwind {
; RV32I-LABEL: test:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, 74565
; RV32I-NEXT:    addi a0, a0, 1664
; RV32I-NEXT:    sub sp, sp, a0
; RV32I-NEXT:    lui a0, 74565
; RV32I-NEXT:    addi a0, a0, 1660
; RV32I-NEXT:    add a0, sp, a0
; RV32I-NEXT:    sw ra, 0(a0)
; RV32I-NEXT:    lui a0, 74565
; RV32I-NEXT:    addi a0, a0, 1656
; RV32I-NEXT:    add a0, sp, a0
; RV32I-NEXT:    sw s0, 0(a0)
; RV32I-NEXT:    lui a0, 74565
; RV32I-NEXT:    addi a0, a0, 1664
; RV32I-NEXT:    add s0, sp, a0
; RV32I-NEXT:    lui a0, 74565
; RV32I-NEXT:    addi a0, a0, 1656
; RV32I-NEXT:    add a0, sp, a0
; RV32I-NEXT:    lw s0, 0(a0)
; RV32I-NEXT:    lui a0, 74565
; RV32I-NEXT:    addi a0, a0, 1660
; RV32I-NEXT:    add a0, sp, a0
; RV32I-NEXT:    lw ra, 0(a0)
; RV32I-NEXT:    lui a0, 74565
; RV32I-NEXT:    addi a0, a0, 1664
; RV32I-NEXT:    add sp, sp, a0
; RV32I-NEXT:    ret
  %tmp = alloca [ 305419896 x i8 ] , align 4
  ret void
}
