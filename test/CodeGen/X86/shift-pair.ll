; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s

define i64 @test(i64 %A) {
; CHECK-LABEL: test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    shrq $54, %rdi
; CHECK-NEXT:    andq $-4, %rdi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
    %B = lshr i64 %A, 56
    %C = shl i64 %B, 2
    ret i64 %C
}
