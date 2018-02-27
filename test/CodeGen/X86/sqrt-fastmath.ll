; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=CHECK --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefix=CHECK --check-prefix=AVX

declare double @__sqrt_finite(double)
declare float @__sqrtf_finite(float)
declare x86_fp80 @__sqrtl_finite(x86_fp80)
declare float @llvm.sqrt.f32(float)
declare <4 x float> @llvm.sqrt.v4f32(<4 x float>)
declare <8 x float> @llvm.sqrt.v8f32(<8 x float>)


define double @finite_f64_no_estimate(double %d) #0 {
; SSE-LABEL: finite_f64_no_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtsd %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: finite_f64_no_estimate:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %call = tail call double @__sqrt_finite(double %d) #2
  ret double %call
}

; No estimates for doubles.

define double @finite_f64_estimate(double %d) #1 {
; SSE-LABEL: finite_f64_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtsd %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: finite_f64_estimate:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %call = tail call double @__sqrt_finite(double %d) #2
  ret double %call
}

define float @finite_f32_no_estimate(float %f) #0 {
; SSE-LABEL: finite_f32_no_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtss %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: finite_f32_no_estimate:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %call = tail call float @__sqrtf_finite(float %f) #2
  ret float %call
}

define float @finite_f32_estimate(float %f) #1 {
; SSE-LABEL: finite_f32_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    rsqrtss %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm0, %xmm2
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    movss {{.*#+}} xmm3 = mem[0],zero,zero,zero
; SSE-NEXT:    mulss %xmm2, %xmm3
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    addss {{.*}}(%rip), %xmm2
; SSE-NEXT:    mulss %xmm3, %xmm2
; SSE-NEXT:    xorps %xmm1, %xmm1
; SSE-NEXT:    cmpeqss %xmm1, %xmm0
; SSE-NEXT:    andnps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: finite_f32_estimate:
; AVX:       # %bb.0:
; AVX-NEXT:    vrsqrtss %xmm0, %xmm0, %xmm1
; AVX-NEXT:    vmulss %xmm1, %xmm0, %xmm2
; AVX-NEXT:    vmulss %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vaddss {{.*}}(%rip), %xmm1, %xmm1
; AVX-NEXT:    vmulss {{.*}}(%rip), %xmm2, %xmm2
; AVX-NEXT:    vmulss %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; AVX-NEXT:    vcmpeqss %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vandnps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %call = tail call float @__sqrtf_finite(float %f) #2
  ret float %call
}

define x86_fp80 @finite_f80_no_estimate(x86_fp80 %ld) #0 {
; CHECK-LABEL: finite_f80_no_estimate:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fldt {{[0-9]+}}(%rsp)
; CHECK-NEXT:    fsqrt
; CHECK-NEXT:    retq
  %call = tail call x86_fp80 @__sqrtl_finite(x86_fp80 %ld) #2
  ret x86_fp80 %call
}

; Don't die on the impossible.

define x86_fp80 @finite_f80_estimate_but_no(x86_fp80 %ld) #1 {
; CHECK-LABEL: finite_f80_estimate_but_no:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fldt {{[0-9]+}}(%rsp)
; CHECK-NEXT:    fsqrt
; CHECK-NEXT:    retq
  %call = tail call x86_fp80 @__sqrtl_finite(x86_fp80 %ld) #2
  ret x86_fp80 %call
}

; PR34994 - https://bugs.llvm.org/show_bug.cgi?id=34994

define float @sqrtf_check_denorms(float %x) #3 {
; SSE-LABEL: sqrtf_check_denorms:
; SSE:       # %bb.0:
; SSE-NEXT:    rsqrtss %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm0, %xmm2
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    movss {{.*#+}} xmm3 = mem[0],zero,zero,zero
; SSE-NEXT:    mulss %xmm2, %xmm3
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    addss {{.*}}(%rip), %xmm2
; SSE-NEXT:    mulss %xmm3, %xmm2
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    cmpltss {{.*}}(%rip), %xmm0
; SSE-NEXT:    andnps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: sqrtf_check_denorms:
; AVX:       # %bb.0:
; AVX-NEXT:    vrsqrtss %xmm0, %xmm0, %xmm1
; AVX-NEXT:    vmulss %xmm1, %xmm0, %xmm2
; AVX-NEXT:    vmulss %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vaddss {{.*}}(%rip), %xmm1, %xmm1
; AVX-NEXT:    vmulss {{.*}}(%rip), %xmm2, %xmm2
; AVX-NEXT:    vmulss %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vcmpltss {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vandnps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %call = tail call float @__sqrtf_finite(float %x) #2
  ret float %call
}

define <4 x float> @sqrt_v4f32_check_denorms(<4 x float> %x) #3 {
; SSE-LABEL: sqrt_v4f32_check_denorms:
; SSE:       # %bb.0:
; SSE-NEXT:    rsqrtps %xmm0, %xmm2
; SSE-NEXT:    movaps %xmm0, %xmm1
; SSE-NEXT:    mulps %xmm2, %xmm1
; SSE-NEXT:    movaps {{.*#+}} xmm3 = [-5.000000e-01,-5.000000e-01,-5.000000e-01,-5.000000e-01]
; SSE-NEXT:    mulps %xmm1, %xmm3
; SSE-NEXT:    mulps %xmm2, %xmm1
; SSE-NEXT:    addps {{.*}}(%rip), %xmm1
; SSE-NEXT:    mulps %xmm3, %xmm1
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    movaps {{.*#+}} xmm2 = [1.175494e-38,1.175494e-38,1.175494e-38,1.175494e-38]
; SSE-NEXT:    cmpleps %xmm0, %xmm2
; SSE-NEXT:    andps %xmm2, %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: sqrt_v4f32_check_denorms:
; AVX:       # %bb.0:
; AVX-NEXT:    vrsqrtps %xmm0, %xmm1
; AVX-NEXT:    vmulps %xmm1, %xmm0, %xmm2
; AVX-NEXT:    vmulps {{.*}}(%rip), %xmm2, %xmm3
; AVX-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vaddps {{.*}}(%rip), %xmm1, %xmm1
; AVX-NEXT:    vmulps %xmm1, %xmm3, %xmm1
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vmovaps {{.*#+}} xmm2 = [1.175494e-38,1.175494e-38,1.175494e-38,1.175494e-38]
; AVX-NEXT:    vcmpleps %xmm0, %xmm2, %xmm0
; AVX-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %call = tail call <4 x float> @llvm.sqrt.v4f32(<4 x float> %x) #2
  ret <4 x float> %call
}

define float @f32_no_estimate(float %x) #0 {
; SSE-LABEL: f32_no_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtss %xmm0, %xmm1
; SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    divss %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: f32_no_estimate:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vdivss %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %sqrt = tail call float @llvm.sqrt.f32(float %x)
  %div = fdiv fast float 1.0, %sqrt
  ret float %div
}

define float @f32_estimate(float %x) #1 {
; SSE-LABEL: f32_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    rsqrtss %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm2
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    mulss %xmm0, %xmm2
; SSE-NEXT:    addss {{.*}}(%rip), %xmm2
; SSE-NEXT:    mulss {{.*}}(%rip), %xmm1
; SSE-NEXT:    mulss %xmm2, %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: f32_estimate:
; AVX:       # %bb.0:
; AVX-NEXT:    vrsqrtss %xmm0, %xmm0, %xmm1
; AVX-NEXT:    vmulss %xmm1, %xmm1, %xmm2
; AVX-NEXT:    vmulss %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vaddss {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vmulss {{.*}}(%rip), %xmm1, %xmm1
; AVX-NEXT:    vmulss %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %sqrt = tail call float @llvm.sqrt.f32(float %x)
  %div = fdiv fast float 1.0, %sqrt
  ret float %div
}

define <4 x float> @v4f32_no_estimate(<4 x float> %x) #0 {
; SSE-LABEL: v4f32_no_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtps %xmm0, %xmm1
; SSE-NEXT:    movaps {{.*#+}} xmm0 = [1.000000e+00,1.000000e+00,1.000000e+00,1.000000e+00]
; SSE-NEXT:    divps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: v4f32_no_estimate:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtps %xmm0, %xmm0
; AVX-NEXT:    vmovaps {{.*#+}} xmm1 = [1.000000e+00,1.000000e+00,1.000000e+00,1.000000e+00]
; AVX-NEXT:    vdivps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %sqrt = tail call <4 x float> @llvm.sqrt.v4f32(<4 x float> %x)
  %div = fdiv fast <4 x float> <float 1.0, float 1.0, float 1.0, float 1.0>, %sqrt
  ret <4 x float> %div
}

define <4 x float> @v4f32_estimate(<4 x float> %x) #1 {
; SSE-LABEL: v4f32_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    rsqrtps %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm2
; SSE-NEXT:    mulps %xmm1, %xmm2
; SSE-NEXT:    mulps %xmm0, %xmm2
; SSE-NEXT:    addps {{.*}}(%rip), %xmm2
; SSE-NEXT:    mulps {{.*}}(%rip), %xmm1
; SSE-NEXT:    mulps %xmm2, %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: v4f32_estimate:
; AVX:       # %bb.0:
; AVX-NEXT:    vrsqrtps %xmm0, %xmm1
; AVX-NEXT:    vmulps %xmm1, %xmm1, %xmm2
; AVX-NEXT:    vmulps %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vaddps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vmulps {{.*}}(%rip), %xmm1, %xmm1
; AVX-NEXT:    vmulps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %sqrt = tail call <4 x float> @llvm.sqrt.v4f32(<4 x float> %x)
  %div = fdiv fast <4 x float> <float 1.0, float 1.0, float 1.0, float 1.0>, %sqrt
  ret <4 x float> %div
}

define <8 x float> @v8f32_no_estimate(<8 x float> %x) #0 {
; SSE-LABEL: v8f32_no_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtps %xmm1, %xmm2
; SSE-NEXT:    sqrtps %xmm0, %xmm3
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [1.000000e+00,1.000000e+00,1.000000e+00,1.000000e+00]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    divps %xmm3, %xmm0
; SSE-NEXT:    divps %xmm2, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: v8f32_no_estimate:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtps %ymm0, %ymm0
; AVX-NEXT:    vmovaps {{.*#+}} ymm1 = [1.000000e+00,1.000000e+00,1.000000e+00,1.000000e+00,1.000000e+00,1.000000e+00,1.000000e+00,1.000000e+00]
; AVX-NEXT:    vdivps %ymm0, %ymm1, %ymm0
; AVX-NEXT:    retq
  %sqrt = tail call <8 x float> @llvm.sqrt.v8f32(<8 x float> %x)
  %div = fdiv fast <8 x float> <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>, %sqrt
  ret <8 x float> %div
}

define <8 x float> @v8f32_estimate(<8 x float> %x) #1 {
; SSE-LABEL: v8f32_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    rsqrtps %xmm0, %xmm3
; SSE-NEXT:    movaps {{.*#+}} xmm4 = [-5.000000e-01,-5.000000e-01,-5.000000e-01,-5.000000e-01]
; SSE-NEXT:    movaps %xmm3, %xmm2
; SSE-NEXT:    mulps %xmm3, %xmm2
; SSE-NEXT:    mulps %xmm0, %xmm2
; SSE-NEXT:    movaps {{.*#+}} xmm0 = [-3.000000e+00,-3.000000e+00,-3.000000e+00,-3.000000e+00]
; SSE-NEXT:    addps %xmm0, %xmm2
; SSE-NEXT:    mulps %xmm4, %xmm2
; SSE-NEXT:    mulps %xmm3, %xmm2
; SSE-NEXT:    rsqrtps %xmm1, %xmm5
; SSE-NEXT:    movaps %xmm5, %xmm3
; SSE-NEXT:    mulps %xmm5, %xmm3
; SSE-NEXT:    mulps %xmm1, %xmm3
; SSE-NEXT:    addps %xmm0, %xmm3
; SSE-NEXT:    mulps %xmm4, %xmm3
; SSE-NEXT:    mulps %xmm5, %xmm3
; SSE-NEXT:    movaps %xmm2, %xmm0
; SSE-NEXT:    movaps %xmm3, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: v8f32_estimate:
; AVX:       # %bb.0:
; AVX-NEXT:    vrsqrtps %ymm0, %ymm1
; AVX-NEXT:    vmulps %ymm1, %ymm1, %ymm2
; AVX-NEXT:    vmulps %ymm2, %ymm0, %ymm0
; AVX-NEXT:    vaddps {{.*}}(%rip), %ymm0, %ymm0
; AVX-NEXT:    vmulps {{.*}}(%rip), %ymm1, %ymm1
; AVX-NEXT:    vmulps %ymm0, %ymm1, %ymm0
; AVX-NEXT:    retq
  %sqrt = tail call <8 x float> @llvm.sqrt.v8f32(<8 x float> %x)
  %div = fdiv fast <8 x float> <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>, %sqrt
  ret <8 x float> %div
}


attributes #0 = { "unsafe-fp-math"="true" "reciprocal-estimates"="!sqrtf,!vec-sqrtf,!divf,!vec-divf" }
attributes #1 = { "unsafe-fp-math"="true" "reciprocal-estimates"="sqrt,vec-sqrt" }
attributes #2 = { nounwind readnone }
attributes #3 = { "unsafe-fp-math"="true" "reciprocal-estimates"="sqrt,vec-sqrt" "denormal-fp-math"="ieee" }

