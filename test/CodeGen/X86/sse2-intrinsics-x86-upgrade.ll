; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin -mattr=+sse2 | FileCheck %s

define <2 x i64> @test_x86_sse2_psll_dq_bs(<2 x i64> %a0) {
; CHECK-LABEL: test_x86_sse2_psll_dq_bs:
; CHECK:       ## BB#0:
; CHECK-NEXT:    pslldq {{.*#+}} xmm0 = zero,zero,zero,zero,zero,zero,zero,xmm0[0,1,2,3,4,5,6,7,8]
; CHECK-NEXT:    retl
  %res = call <2 x i64> @llvm.x86.sse2.psll.dq.bs(<2 x i64> %a0, i32 7) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse2.psll.dq.bs(<2 x i64>, i32) nounwind readnone


define <2 x i64> @test_x86_sse2_psrl_dq_bs(<2 x i64> %a0) {
; CHECK-LABEL: test_x86_sse2_psrl_dq_bs:
; CHECK:       ## BB#0:
; CHECK-NEXT:    psrldq {{.*#+}} xmm0 = xmm0[7,8,9,10,11,12,13,14,15],zero,zero,zero,zero,zero,zero,zero
; CHECK-NEXT:    retl
  %res = call <2 x i64> @llvm.x86.sse2.psrl.dq.bs(<2 x i64> %a0, i32 7) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse2.psrl.dq.bs(<2 x i64>, i32) nounwind readnone

define <2 x i64> @test_x86_sse2_psll_dq(<2 x i64> %a0) {
; CHECK-LABEL: test_x86_sse2_psll_dq:
; CHECK:       ## BB#0:
; CHECK-NEXT:    pslldq {{.*#+}} xmm0 = zero,xmm0[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
; CHECK-NEXT:    retl
  %res = call <2 x i64> @llvm.x86.sse2.psll.dq(<2 x i64> %a0, i32 8) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse2.psll.dq(<2 x i64>, i32) nounwind readnone


define <2 x i64> @test_x86_sse2_psrl_dq(<2 x i64> %a0) {
; CHECK-LABEL: test_x86_sse2_psrl_dq:
; CHECK:       ## BB#0:
; CHECK-NEXT:    psrldq {{.*#+}} xmm0 = xmm0[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],zero
; CHECK-NEXT:    retl
  %res = call <2 x i64> @llvm.x86.sse2.psrl.dq(<2 x i64> %a0, i32 8) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse2.psrl.dq(<2 x i64>, i32) nounwind readnone


define <2 x double> @test_x86_sse2_cvtdq2pd(<4 x i32> %a0) {
; CHECK-LABEL: test_x86_sse2_cvtdq2pd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    cvtdq2pd %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = call <2 x double> @llvm.x86.sse2.cvtdq2pd(<4 x i32> %a0) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse2.cvtdq2pd(<4 x i32>) nounwind readnone


define <2 x double> @test_x86_sse2_cvtps2pd(<4 x float> %a0) {
; CHECK-LABEL: test_x86_sse2_cvtps2pd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    cvtps2pd %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = call <2 x double> @llvm.x86.sse2.cvtps2pd(<4 x float> %a0) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse2.cvtps2pd(<4 x float>) nounwind readnone


define void @test_x86_sse2_storel_dq(i8* %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_x86_sse2_storel_dq:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movlps %xmm0, (%eax)
; CHECK-NEXT:    retl
  call void @llvm.x86.sse2.storel.dq(i8* %a0, <4 x i32> %a1)
  ret void
}
declare void @llvm.x86.sse2.storel.dq(i8*, <4 x i32>) nounwind


define void @test_x86_sse2_storeu_dq(i8* %a0, <16 x i8> %a1) {
  ; add operation forces the execution domain.
; CHECK-LABEL: test_x86_sse2_storeu_dq:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    paddb LCPI7_0, %xmm0
; CHECK-NEXT:    movdqu %xmm0, (%eax)
; CHECK-NEXT:    retl
  %a2 = add <16 x i8> %a1, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  call void @llvm.x86.sse2.storeu.dq(i8* %a0, <16 x i8> %a2)
  ret void
}
declare void @llvm.x86.sse2.storeu.dq(i8*, <16 x i8>) nounwind


define void @test_x86_sse2_storeu_pd(i8* %a0, <2 x double> %a1) {
  ; fadd operation forces the execution domain.
; CHECK-LABEL: test_x86_sse2_storeu_pd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    pslldq {{.*#+}} xmm1 = zero,zero,zero,zero,zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7]
; CHECK-NEXT:    addpd %xmm0, %xmm1
; CHECK-NEXT:    movupd %xmm1, (%eax)
; CHECK-NEXT:    retl
  %a2 = fadd <2 x double> %a1, <double 0x0, double 0x4200000000000000>
  call void @llvm.x86.sse2.storeu.pd(i8* %a0, <2 x double> %a2)
  ret void
}
declare void @llvm.x86.sse2.storeu.pd(i8*, <2 x double>) nounwind

define <4 x i32> @test_x86_sse2_pshuf_d(<4 x i32> %a) {
; CHECK-LABEL: test_x86_sse2_pshuf_d:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[3,2,1,0]
; CHECK-NEXT:    retl
entry:
  %res = call <4 x i32> @llvm.x86.sse2.pshuf.d(<4 x i32> %a, i8 27) nounwind readnone
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.sse2.pshuf.d(<4 x i32>, i8) nounwind readnone

define <8 x i16> @test_x86_sse2_pshufl_w(<8 x i16> %a) {
; CHECK-LABEL: test_x86_sse2_pshufl_w:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[3,2,1,0,4,5,6,7]
; CHECK-NEXT:    retl
entry:
  %res = call <8 x i16> @llvm.x86.sse2.pshufl.w(<8 x i16> %a, i8 27) nounwind readnone
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.sse2.pshufl.w(<8 x i16>, i8) nounwind readnone

define <8 x i16> @test_x86_sse2_pshufh_w(<8 x i16> %a) {
; CHECK-LABEL: test_x86_sse2_pshufh_w:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    pshufhw {{.*#+}} xmm0 = xmm0[0,1,2,3,7,6,5,4]
; CHECK-NEXT:    retl
entry:
  %res = call <8 x i16> @llvm.x86.sse2.pshufh.w(<8 x i16> %a, i8 27) nounwind readnone
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.sse2.pshufh.w(<8 x i16>, i8) nounwind readnone

define <16 x i8> @max_epu8(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: max_epu8:
; CHECK:       ## BB#0:
; CHECK-NEXT:    pmaxub %xmm1, %xmm0
; CHECK-NEXT:    retl
  %res = call <16 x i8> @llvm.x86.sse2.pmaxu.b(<16 x i8> %a0, <16 x i8> %a1)
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.sse2.pmaxu.b(<16 x i8>, <16 x i8>) nounwind readnone

define <16 x i8> @min_epu8(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: min_epu8:
; CHECK:       ## BB#0:
; CHECK-NEXT:    pminub %xmm1, %xmm0
; CHECK-NEXT:    retl
  %res = call <16 x i8> @llvm.x86.sse2.pminu.b(<16 x i8> %a0, <16 x i8> %a1)
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.sse2.pminu.b(<16 x i8>, <16 x i8>) nounwind readnone

define <8 x i16> @max_epi16(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: max_epi16:
; CHECK:       ## BB#0:
; CHECK-NEXT:    pmaxsw %xmm1, %xmm0
; CHECK-NEXT:    retl
  %res = call <8 x i16> @llvm.x86.sse2.pmaxs.w(<8 x i16> %a0, <8 x i16> %a1)
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.sse2.pmaxs.w(<8 x i16>, <8 x i16>) nounwind readnone

define <8 x i16> @min_epi16(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: min_epi16:
; CHECK:       ## BB#0:
; CHECK-NEXT:    pminsw %xmm1, %xmm0
; CHECK-NEXT:    retl
  %res = call <8 x i16> @llvm.x86.sse2.pmins.w(<8 x i16> %a0, <8 x i16> %a1)
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.sse2.pmins.w(<8 x i16>, <8 x i16>) nounwind readnone

define <2 x double> @test_x86_sse2_add_sd(<2 x double> %a0, <2 x double> %a1) {
; SSE-LABEL: test_x86_sse2_add_sd:
; SSE:       ## BB#0:
; SSE-NEXT:    addsd %xmm1, %xmm0 ## encoding: [0xf2,0x0f,0x58,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse2_add_sd:
; AVX2:       ## BB#0:
; AVX2-NEXT:    vaddsd %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xfb,0x58,0xc1]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse2_add_sd:
; SKX:       ## BB#0:
; SKX-NEXT:    vaddsd %xmm1, %xmm0, %xmm0 ## encoding: [0x62,0xf1,0xff,0x08,0x58,0xc1]
; SKX-NEXT:    retl ## encoding: [0xc3]
; CHECK-LABEL: test_x86_sse2_add_sd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    addsd %xmm1, %xmm0
; CHECK-NEXT:    retl
  %res = call <2 x double> @llvm.x86.sse2.add.sd(<2 x double> %a0, <2 x double> %a1) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse2.add.sd(<2 x double>, <2 x double>) nounwind readnone


define <2 x double> @test_x86_sse2_sub_sd(<2 x double> %a0, <2 x double> %a1) {
; SSE-LABEL: test_x86_sse2_sub_sd:
; SSE:       ## BB#0:
; SSE-NEXT:    subsd %xmm1, %xmm0 ## encoding: [0xf2,0x0f,0x5c,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse2_sub_sd:
; AVX2:       ## BB#0:
; AVX2-NEXT:    vsubsd %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xfb,0x5c,0xc1]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse2_sub_sd:
; SKX:       ## BB#0:
; SKX-NEXT:    vsubsd %xmm1, %xmm0, %xmm0 ## encoding: [0x62,0xf1,0xff,0x08,0x5c,0xc1]
; SKX-NEXT:    retl ## encoding: [0xc3]
; CHECK-LABEL: test_x86_sse2_sub_sd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    subsd %xmm1, %xmm0
; CHECK-NEXT:    retl
  %res = call <2 x double> @llvm.x86.sse2.sub.sd(<2 x double> %a0, <2 x double> %a1) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse2.sub.sd(<2 x double>, <2 x double>) nounwind readnone


define <2 x double> @test_x86_sse2_mul_sd(<2 x double> %a0, <2 x double> %a1) {
; SSE-LABEL: test_x86_sse2_mul_sd:
; SSE:       ## BB#0:
; SSE-NEXT:    mulsd %xmm1, %xmm0 ## encoding: [0xf2,0x0f,0x59,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse2_mul_sd:
; AVX2:       ## BB#0:
; AVX2-NEXT:    vmulsd %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xfb,0x59,0xc1]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse2_mul_sd:
; SKX:       ## BB#0:
; SKX-NEXT:    vmulsd %xmm1, %xmm0, %xmm0 ## encoding: [0x62,0xf1,0xff,0x08,0x59,0xc1]
; SKX-NEXT:    retl ## encoding: [0xc3]
; CHECK-LABEL: test_x86_sse2_mul_sd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    mulsd %xmm1, %xmm0
; CHECK-NEXT:    retl
  %res = call <2 x double> @llvm.x86.sse2.mul.sd(<2 x double> %a0, <2 x double> %a1) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse2.mul.sd(<2 x double>, <2 x double>) nounwind readnone


define <2 x double> @test_x86_sse2_div_sd(<2 x double> %a0, <2 x double> %a1) {
; SSE-LABEL: test_x86_sse2_div_sd:
; SSE:       ## BB#0:
; SSE-NEXT:    divsd %xmm1, %xmm0 ## encoding: [0xf2,0x0f,0x5e,0xc1]
; SSE-NEXT:    retl ## encoding: [0xc3]
;
; AVX2-LABEL: test_x86_sse2_div_sd:
; AVX2:       ## BB#0:
; AVX2-NEXT:    vdivsd %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xfb,0x5e,0xc1]
; AVX2-NEXT:    retl ## encoding: [0xc3]
;
; SKX-LABEL: test_x86_sse2_div_sd:
; SKX:       ## BB#0:
; SKX-NEXT:    vdivsd %xmm1, %xmm0, %xmm0 ## encoding: [0x62,0xf1,0xff,0x08,0x5e,0xc1]
; SKX-NEXT:    retl ## encoding: [0xc3]
; CHECK-LABEL: test_x86_sse2_div_sd:
; CHECK:       ## BB#0:
; CHECK-NEXT:    divsd %xmm1, %xmm0
; CHECK-NEXT:    retl
  %res = call <2 x double> @llvm.x86.sse2.div.sd(<2 x double> %a0, <2 x double> %a1) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse2.div.sd(<2 x double>, <2 x double>) nounwind readnone



