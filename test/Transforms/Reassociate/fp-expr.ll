; RUN: opt -S -reassociate < %s | FileCheck %s

define void @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[T1:%.*]] = tail call <4 x float> @blam()
; CHECK-NEXT:    [[T1_NEG:%.*]] = fsub fast <4 x float> <float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00>, [[T1]]
; CHECK-NEXT:    [[T24:%.*]] = fadd fast <4 x float> [[T1_NEG]], fadd (<4 x float> undef, <4 x float> undef)
; CHECK-NEXT:    tail call void @wombat(<4 x float> [[T24]])
; CHECK-NEXT:    ret void
;
  %t1 = tail call <4 x float> @blam()
  %t23 = fsub fast <4 x float> undef, %t1
  %t24 = fadd fast <4 x float> %t23, undef
  tail call void @wombat(<4 x float> %t24)
  ret void
}

define half @test2() {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[T15:%.*]] = fsub fast half undef, undef
; CHECK-NEXT:    [[T15_NEG:%.*]] = fsub fast half 0xH8000, [[T15]]
; CHECK-NEXT:    [[T18:%.*]] = fadd fast half [[T15_NEG]], fadd (half undef, half undef)
; CHECK-NEXT:    ret half [[T18]]
;
  %t15 = fsub fast half undef, undef
  %t17 = fsub fast half undef, %t15
  %t18 = fadd fast half undef, %t17
  ret half %t18
}



; Function Attrs: optsize
declare <4 x float> @blam()

; Function Attrs: optsize
declare void @wombat(<4 x float>)

