; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=DEFAULTCPU
; RUN: llc < %s -mcpu=x86-64 -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=X64CPU

define void @merge_8_float_zero_stores(float* %ptr) {
; DEFAULTCPU-LABEL: merge_8_float_zero_stores:
; DEFAULTCPU:       # BB#0:
; DEFAULTCPU-NEXT:    movq $0, (%rdi)
; DEFAULTCPU-NEXT:    movq $0, 8(%rdi)
; DEFAULTCPU-NEXT:    movq $0, 16(%rdi)
; DEFAULTCPU-NEXT:    movq $0, 24(%rdi)
; DEFAULTCPU-NEXT:    retq
;
; X64CPU-LABEL: merge_8_float_zero_stores:
; X64CPU:       # BB#0:
; X64CPU-NEXT:    xorps %xmm0, %xmm0
; X64CPU-NEXT:    movups %xmm0, (%rdi)
; X64CPU-NEXT:    movups %xmm0, 16(%rdi)
; X64CPU-NEXT:    retq
  %idx0 = getelementptr float, float* %ptr, i64 0
  %idx1 = getelementptr float, float* %ptr, i64 1
  %idx2 = getelementptr float, float* %ptr, i64 2
  %idx3 = getelementptr float, float* %ptr, i64 3
  %idx4 = getelementptr float, float* %ptr, i64 4
  %idx5 = getelementptr float, float* %ptr, i64 5
  %idx6 = getelementptr float, float* %ptr, i64 6
  %idx7 = getelementptr float, float* %ptr, i64 7
  store float 0.0, float* %idx0, align 4
  store float 0.0, float* %idx1, align 4
  store float 0.0, float* %idx2, align 4
  store float 0.0, float* %idx3, align 4
  store float 0.0, float* %idx4, align 4
  store float 0.0, float* %idx5, align 4
  store float 0.0, float* %idx6, align 4
  store float 0.0, float* %idx7, align 4
  ret void
}
