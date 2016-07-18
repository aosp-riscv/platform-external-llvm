; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx | FileCheck %s

define <8 x i32> @test(<8 x float> %a, <8 x float> %b) {
; CHECK-LABEL: test:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vaddps %ymm1, %ymm0, %ymm2
; CHECK-NEXT:    vmulps %ymm0, %ymm1, %ymm1
; CHECK-NEXT:    vsubps %ymm2, %ymm1, %ymm3
; CHECK-NEXT:    vcmpltps %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vcmpltps %ymm3, %ymm2, %ymm1
; CHECK-NEXT:    vandps {{.*}}(%rip), %ymm1, %ymm1
; CHECK-NEXT:    vandps %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
 %c1 = fadd <8 x float> %a, %b
 %b1 = fmul <8 x float> %b, %a
 %d  = fsub <8 x float> %b1, %c1
 %res1 = fcmp olt <8 x float> %a, %b1
 %res2 = fcmp olt <8 x float> %c1, %d
 %andr = and <8 x i1>%res1, %res2
 %ex = zext <8 x i1> %andr to <8 x i32>
 ret <8 x i32>%ex
}


