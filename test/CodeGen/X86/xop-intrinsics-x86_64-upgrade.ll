; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx,+fma4,+xop | FileCheck %s

define <2 x double> @test_int_x86_xop_vpermil2pd(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2) {
; CHECK-LABEL: test_int_x86_xop_vpermil2pd:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpermil2pd $1, %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x double> @llvm.x86.xop.vpermil2pd(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2, i8 1) ;  [#uses=1]
  ret <2 x double> %res
}
define <2 x double> @test_int_x86_xop_vpermil2pd_mr(<2 x double> %a0, <2 x double>* %a1, <2 x double> %a2) {
; CHECK-LABEL: test_int_x86_xop_vpermil2pd_mr:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpermil2pd $1, %xmm1, (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %vec = load <2 x double>, <2 x double>* %a1
  %res = call <2 x double> @llvm.x86.xop.vpermil2pd(<2 x double> %a0, <2 x double> %vec, <2 x double> %a2, i8 1) ;  [#uses=1]
  ret <2 x double> %res
}
define <2 x double> @test_int_x86_xop_vpermil2pd_rm(<2 x double> %a0, <2 x double> %a1, <2 x double>* %a2) {
; CHECK-LABEL: test_int_x86_xop_vpermil2pd_rm:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpermil2pd $1, (%rdi), %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %vec = load <2 x double>, <2 x double>* %a2
  %res = call <2 x double> @llvm.x86.xop.vpermil2pd(<2 x double> %a0, <2 x double> %a1, <2 x double> %vec, i8 1) ;  [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.xop.vpermil2pd(<2 x double>, <2 x double>, <2 x double>, i8) nounwind readnone

define <4 x double> @test_int_x86_xop_vpermil2pd_256(<4 x double> %a0, <4 x double> %a1, <4 x double> %a2) {
; CHECK-LABEL: test_int_x86_xop_vpermil2pd_256:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpermil2pd $2, %ymm2, %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %res = call <4 x double> @llvm.x86.xop.vpermil2pd.256(<4 x double> %a0, <4 x double> %a1, <4 x double> %a2, i8 2) ;
  ret <4 x double> %res
}
define <4 x double> @test_int_x86_xop_vpermil2pd_256_mr(<4 x double> %a0, <4 x double>* %a1, <4 x double> %a2) {
; CHECK-LABEL: test_int_x86_xop_vpermil2pd_256_mr:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpermil2pd $2, %ymm1, (%rdi), %ymm0, %ymm0
; CHECK-NEXT:    retq
  %vec = load <4 x double>, <4 x double>* %a1
  %res = call <4 x double> @llvm.x86.xop.vpermil2pd.256(<4 x double> %a0, <4 x double> %vec, <4 x double> %a2, i8 2) ;
  ret <4 x double> %res
}
define <4 x double> @test_int_x86_xop_vpermil2pd_256_rm(<4 x double> %a0, <4 x double> %a1, <4 x double>* %a2) {
; CHECK-LABEL: test_int_x86_xop_vpermil2pd_256_rm:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpermil2pd $2, (%rdi), %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %vec = load <4 x double>, <4 x double>* %a2
  %res = call <4 x double> @llvm.x86.xop.vpermil2pd.256(<4 x double> %a0, <4 x double> %a1, <4 x double> %vec, i8 2) ;
  ret <4 x double> %res
}
declare <4 x double> @llvm.x86.xop.vpermil2pd.256(<4 x double>, <4 x double>, <4 x double>, i8) nounwind readnone

define <4 x float> @test_int_x86_xop_vpermil2ps(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2) {
; CHECK-LABEL: test_int_x86_xop_vpermil2ps:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpermil2ps $3, %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x float> @llvm.x86.xop.vpermil2ps(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2, i8 3) ;
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.xop.vpermil2ps(<4 x float>, <4 x float>, <4 x float>, i8) nounwind readnone

define <8 x float> @test_int_x86_xop_vpermil2ps_256(<8 x float> %a0, <8 x float> %a1, <8 x float> %a2) {
; CHECK-LABEL: test_int_x86_xop_vpermil2ps_256:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpermil2ps $4, %ymm2, %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %res = call <8 x float> @llvm.x86.xop.vpermil2ps.256(<8 x float> %a0, <8 x float> %a1, <8 x float> %a2, i8 4) ;
  ret <8 x float> %res
}
declare <8 x float> @llvm.x86.xop.vpermil2ps.256(<8 x float>, <8 x float>, <8 x float>, i8) nounwind readnone

define <16 x i8> @test_int_x86_xop_vpcomeqb(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomeqb:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomeqb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.xop.vpcomeqb(<16 x i8> %a0, <16 x i8> %a1) ;
  ret <16 x i8> %res
}
define <16 x i8> @test_int_x86_xop_vpcomeqb_mem(<16 x i8> %a0, <16 x i8>* %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomeqb_mem:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomeqb (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %vec = load <16 x i8>, <16 x i8>* %a1
  %res = call <16 x i8> @llvm.x86.xop.vpcomeqb(<16 x i8> %a0, <16 x i8> %vec) ;
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.xop.vpcomeqb(<16 x i8>, <16 x i8>) nounwind readnone

define <8 x i16> @test_int_x86_xop_vpcomeqw(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomeqw:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomeqw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.xop.vpcomeqw(<8 x i16> %a0, <8 x i16> %a1) ;
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.xop.vpcomeqw(<8 x i16>, <8 x i16>) nounwind readnone

define <4 x i32> @test_int_x86_xop_vpcomeqd(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomeqd:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomeqd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.xop.vpcomeqd(<4 x i32> %a0, <4 x i32> %a1) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.xop.vpcomeqd(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcomeqq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomeqq:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomeqq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcomeqq(<2 x i64> %a0, <2 x i64> %a1) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcomeqq(<2 x i64>, <2 x i64>) nounwind readnone

define <16 x i8> @test_int_x86_xop_vpcomequb(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomequb:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomequb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.xop.vpcomequb(<16 x i8> %a0, <16 x i8> %a1) ;
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.xop.vpcomequb(<16 x i8>, <16 x i8>) nounwind readnone

define <4 x i32> @test_int_x86_xop_vpcomequd(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomequd:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomequd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.xop.vpcomequd(<4 x i32> %a0, <4 x i32> %a1) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.xop.vpcomequd(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcomequq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomequq:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomequq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcomequq(<2 x i64> %a0, <2 x i64> %a1) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcomequq(<2 x i64>, <2 x i64>) nounwind readnone

define <8 x i16> @test_int_x86_xop_vpcomequw(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomequw:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomequw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.xop.vpcomequw(<8 x i16> %a0, <8 x i16> %a1) ;
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.xop.vpcomequw(<8 x i16>, <8 x i16>) nounwind readnone

define <16 x i8> @test_int_x86_xop_vpcomfalseb(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomfalseb:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomfalseb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.xop.vpcomfalseb(<16 x i8> %a0, <16 x i8> %a1) ;
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.xop.vpcomfalseb(<16 x i8>, <16 x i8>) nounwind readnone

define <4 x i32> @test_int_x86_xop_vpcomfalsed(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomfalsed:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomfalsed %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.xop.vpcomfalsed(<4 x i32> %a0, <4 x i32> %a1) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.xop.vpcomfalsed(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcomfalseq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomfalseq:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomfalseq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcomfalseq(<2 x i64> %a0, <2 x i64> %a1) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcomfalseq(<2 x i64>, <2 x i64>) nounwind readnone

define <16 x i8> @test_int_x86_xop_vpcomfalseub(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomfalseub:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomfalseub %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.xop.vpcomfalseub(<16 x i8> %a0, <16 x i8> %a1) ;
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.xop.vpcomfalseub(<16 x i8>, <16 x i8>) nounwind readnone

define <4 x i32> @test_int_x86_xop_vpcomfalseud(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomfalseud:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomfalseud %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.xop.vpcomfalseud(<4 x i32> %a0, <4 x i32> %a1) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.xop.vpcomfalseud(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcomfalseuq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomfalseuq:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomfalseuq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcomfalseuq(<2 x i64> %a0, <2 x i64> %a1) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcomfalseuq(<2 x i64>, <2 x i64>) nounwind readnone

define <8 x i16> @test_int_x86_xop_vpcomfalseuw(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomfalseuw:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomfalseuw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.xop.vpcomfalseuw(<8 x i16> %a0, <8 x i16> %a1) ;
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.xop.vpcomfalseuw(<8 x i16>, <8 x i16>) nounwind readnone

define <8 x i16> @test_int_x86_xop_vpcomfalsew(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomfalsew:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomfalsew %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.xop.vpcomfalsew(<8 x i16> %a0, <8 x i16> %a1) ;
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.xop.vpcomfalsew(<8 x i16>, <8 x i16>) nounwind readnone

define <16 x i8> @test_int_x86_xop_vpcomgeb(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomgeb:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomgeb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.xop.vpcomgeb(<16 x i8> %a0, <16 x i8> %a1) ;
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.xop.vpcomgeb(<16 x i8>, <16 x i8>) nounwind readnone

define <4 x i32> @test_int_x86_xop_vpcomged(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomged:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomged %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.xop.vpcomged(<4 x i32> %a0, <4 x i32> %a1) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.xop.vpcomged(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcomgeq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomgeq:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomgeq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcomgeq(<2 x i64> %a0, <2 x i64> %a1) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcomgeq(<2 x i64>, <2 x i64>) nounwind readnone

define <16 x i8> @test_int_x86_xop_vpcomgeub(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomgeub:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomgeub %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.xop.vpcomgeub(<16 x i8> %a0, <16 x i8> %a1) ;
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.xop.vpcomgeub(<16 x i8>, <16 x i8>) nounwind readnone

define <4 x i32> @test_int_x86_xop_vpcomgeud(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomgeud:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomgeud %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.xop.vpcomgeud(<4 x i32> %a0, <4 x i32> %a1) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.xop.vpcomgeud(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcomgeuq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomgeuq:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomgeuq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcomgeuq(<2 x i64> %a0, <2 x i64> %a1) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcomgeuq(<2 x i64>, <2 x i64>) nounwind readnone

define <8 x i16> @test_int_x86_xop_vpcomgeuw(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomgeuw:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomgeuw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.xop.vpcomgeuw(<8 x i16> %a0, <8 x i16> %a1) ;
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.xop.vpcomgeuw(<8 x i16>, <8 x i16>) nounwind readnone

define <8 x i16> @test_int_x86_xop_vpcomgew(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomgew:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomgew %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.xop.vpcomgew(<8 x i16> %a0, <8 x i16> %a1) ;
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.xop.vpcomgew(<8 x i16>, <8 x i16>) nounwind readnone

define <16 x i8> @test_int_x86_xop_vpcomgtb(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomgtb:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomgtb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.xop.vpcomgtb(<16 x i8> %a0, <16 x i8> %a1) ;
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.xop.vpcomgtb(<16 x i8>, <16 x i8>) nounwind readnone

define <4 x i32> @test_int_x86_xop_vpcomgtd(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomgtd:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomgtd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.xop.vpcomgtd(<4 x i32> %a0, <4 x i32> %a1) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.xop.vpcomgtd(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcomgtq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomgtq:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomgtq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcomgtq(<2 x i64> %a0, <2 x i64> %a1) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcomgtq(<2 x i64>, <2 x i64>) nounwind readnone

define <16 x i8> @test_int_x86_xop_vpcomgtub(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomgtub:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomgtub %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.xop.vpcomgtub(<16 x i8> %a0, <16 x i8> %a1) ;
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.xop.vpcomgtub(<16 x i8>, <16 x i8>) nounwind readnone

define <4 x i32> @test_int_x86_xop_vpcomgtud(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomgtud:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomgtud %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.xop.vpcomgtud(<4 x i32> %a0, <4 x i32> %a1) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.xop.vpcomgtud(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcomgtuq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomgtuq:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomgtuq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcomgtuq(<2 x i64> %a0, <2 x i64> %a1) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcomgtuq(<2 x i64>, <2 x i64>) nounwind readnone

define <8 x i16> @test_int_x86_xop_vpcomgtuw(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomgtuw:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomgtuw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.xop.vpcomgtuw(<8 x i16> %a0, <8 x i16> %a1) ;
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.xop.vpcomgtuw(<8 x i16>, <8 x i16>) nounwind readnone

define <8 x i16> @test_int_x86_xop_vpcomgtw(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomgtw:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomgtw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.xop.vpcomgtw(<8 x i16> %a0, <8 x i16> %a1) ;
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.xop.vpcomgtw(<8 x i16>, <8 x i16>) nounwind readnone

define <16 x i8> @test_int_x86_xop_vpcomleb(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomleb:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomleb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.xop.vpcomleb(<16 x i8> %a0, <16 x i8> %a1) ;
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.xop.vpcomleb(<16 x i8>, <16 x i8>) nounwind readnone

define <4 x i32> @test_int_x86_xop_vpcomled(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomled:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomled %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.xop.vpcomled(<4 x i32> %a0, <4 x i32> %a1) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.xop.vpcomled(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcomleq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomleq:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomleq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcomleq(<2 x i64> %a0, <2 x i64> %a1) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcomleq(<2 x i64>, <2 x i64>) nounwind readnone

define <16 x i8> @test_int_x86_xop_vpcomleub(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomleub:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomleub %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.xop.vpcomleub(<16 x i8> %a0, <16 x i8> %a1) ;
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.xop.vpcomleub(<16 x i8>, <16 x i8>) nounwind readnone

define <4 x i32> @test_int_x86_xop_vpcomleud(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomleud:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomleud %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.xop.vpcomleud(<4 x i32> %a0, <4 x i32> %a1) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.xop.vpcomleud(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcomleuq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomleuq:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomleuq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcomleuq(<2 x i64> %a0, <2 x i64> %a1) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcomleuq(<2 x i64>, <2 x i64>) nounwind readnone

define <8 x i16> @test_int_x86_xop_vpcomleuw(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomleuw:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomleuw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.xop.vpcomleuw(<8 x i16> %a0, <8 x i16> %a1) ;
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.xop.vpcomleuw(<8 x i16>, <8 x i16>) nounwind readnone

define <8 x i16> @test_int_x86_xop_vpcomlew(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomlew:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomlew %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.xop.vpcomlew(<8 x i16> %a0, <8 x i16> %a1) ;
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.xop.vpcomlew(<8 x i16>, <8 x i16>) nounwind readnone

define <16 x i8> @test_int_x86_xop_vpcomltb(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomltb:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomltb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.xop.vpcomltb(<16 x i8> %a0, <16 x i8> %a1) ;
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.xop.vpcomltb(<16 x i8>, <16 x i8>) nounwind readnone

define <4 x i32> @test_int_x86_xop_vpcomltd(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomltd:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomltd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.xop.vpcomltd(<4 x i32> %a0, <4 x i32> %a1) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.xop.vpcomltd(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcomltq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomltq:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomltq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcomltq(<2 x i64> %a0, <2 x i64> %a1) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcomltq(<2 x i64>, <2 x i64>) nounwind readnone

define <16 x i8> @test_int_x86_xop_vpcomltub(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomltub:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomltub %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.xop.vpcomltub(<16 x i8> %a0, <16 x i8> %a1) ;
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.xop.vpcomltub(<16 x i8>, <16 x i8>) nounwind readnone

define <4 x i32> @test_int_x86_xop_vpcomltud(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomltud:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomltud %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.xop.vpcomltud(<4 x i32> %a0, <4 x i32> %a1) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.xop.vpcomltud(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcomltuq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomltuq:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomltuq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcomltuq(<2 x i64> %a0, <2 x i64> %a1) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcomltuq(<2 x i64>, <2 x i64>) nounwind readnone

define <8 x i16> @test_int_x86_xop_vpcomltuw(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomltuw:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomltuw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.xop.vpcomltuw(<8 x i16> %a0, <8 x i16> %a1) ;
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.xop.vpcomltuw(<8 x i16>, <8 x i16>) nounwind readnone

define <8 x i16> @test_int_x86_xop_vpcomltw(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomltw:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomltw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.xop.vpcomltw(<8 x i16> %a0, <8 x i16> %a1) ;
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.xop.vpcomltw(<8 x i16>, <8 x i16>) nounwind readnone

define <16 x i8> @test_int_x86_xop_vpcomneb(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomneb:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomneqb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.xop.vpcomneb(<16 x i8> %a0, <16 x i8> %a1) ;
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.xop.vpcomneb(<16 x i8>, <16 x i8>) nounwind readnone

define <4 x i32> @test_int_x86_xop_vpcomned(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomned:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomneqd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.xop.vpcomned(<4 x i32> %a0, <4 x i32> %a1) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.xop.vpcomned(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcomneq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomneq:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomneqq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcomneq(<2 x i64> %a0, <2 x i64> %a1) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcomneq(<2 x i64>, <2 x i64>) nounwind readnone

define <16 x i8> @test_int_x86_xop_vpcomneub(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomneub:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomnequb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.xop.vpcomneub(<16 x i8> %a0, <16 x i8> %a1) ;
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.xop.vpcomneub(<16 x i8>, <16 x i8>) nounwind readnone

define <4 x i32> @test_int_x86_xop_vpcomneud(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomneud:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomnequd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.xop.vpcomneud(<4 x i32> %a0, <4 x i32> %a1) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.xop.vpcomneud(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcomneuq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomneuq:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomnequq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcomneuq(<2 x i64> %a0, <2 x i64> %a1) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcomneuq(<2 x i64>, <2 x i64>) nounwind readnone

define <8 x i16> @test_int_x86_xop_vpcomneuw(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomneuw:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomnequw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.xop.vpcomneuw(<8 x i16> %a0, <8 x i16> %a1) ;
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.xop.vpcomneuw(<8 x i16>, <8 x i16>) nounwind readnone

define <8 x i16> @test_int_x86_xop_vpcomnew(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomnew:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomneqw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.xop.vpcomnew(<8 x i16> %a0, <8 x i16> %a1) ;
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.xop.vpcomnew(<8 x i16>, <8 x i16>) nounwind readnone

define <16 x i8> @test_int_x86_xop_vpcomtrueb(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomtrueb:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomtrueb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.xop.vpcomtrueb(<16 x i8> %a0, <16 x i8> %a1) ;
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.xop.vpcomtrueb(<16 x i8>, <16 x i8>) nounwind readnone

define <4 x i32> @test_int_x86_xop_vpcomtrued(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomtrued:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomtrued %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.xop.vpcomtrued(<4 x i32> %a0, <4 x i32> %a1) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.xop.vpcomtrued(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcomtrueq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomtrueq:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomtrueq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcomtrueq(<2 x i64> %a0, <2 x i64> %a1) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcomtrueq(<2 x i64>, <2 x i64>) nounwind readnone

define <16 x i8> @test_int_x86_xop_vpcomtrueub(<16 x i8> %a0, <16 x i8> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomtrueub:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomtrueub %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <16 x i8> @llvm.x86.xop.vpcomtrueub(<16 x i8> %a0, <16 x i8> %a1) ;
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.xop.vpcomtrueub(<16 x i8>, <16 x i8>) nounwind readnone

define <4 x i32> @test_int_x86_xop_vpcomtrueud(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomtrueud:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomtrueud %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.xop.vpcomtrueud(<4 x i32> %a0, <4 x i32> %a1) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.xop.vpcomtrueud(<4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcomtrueuq(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomtrueuq:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomtrueuq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcomtrueuq(<2 x i64> %a0, <2 x i64> %a1) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcomtrueuq(<2 x i64>, <2 x i64>) nounwind readnone

define <8 x i16> @test_int_x86_xop_vpcomtrueuw(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomtrueuw:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomtrueuw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.xop.vpcomtrueuw(<8 x i16> %a0, <8 x i16> %a1) ;
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.xop.vpcomtrueuw(<8 x i16>, <8 x i16>) nounwind readnone

define <8 x i16> @test_int_x86_xop_vpcomtruew(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: test_int_x86_xop_vpcomtruew:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcomtruew %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.xop.vpcomtruew(<8 x i16> %a0, <8 x i16> %a1) ;
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.xop.vpcomtruew(<8 x i16>, <8 x i16>) nounwind readnone

define <2 x i64> @test_int_x86_xop_vpcmov(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2) {
; CHECK-LABEL: test_int_x86_xop_vpcmov:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmov %xmm2, %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.xop.vpcmov(<2 x i64> %a0, <2 x i64> %a1, <2 x i64> %a2) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.xop.vpcmov(<2 x i64>, <2 x i64>, <2 x i64>) nounwind readnone

define <4 x i64> @test_int_x86_xop_vpcmov_256(<4 x i64> %a0, <4 x i64> %a1, <4 x i64> %a2) {
; CHECK-LABEL: test_int_x86_xop_vpcmov_256:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmov %ymm2, %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %res = call <4 x i64> @llvm.x86.xop.vpcmov.256(<4 x i64> %a0, <4 x i64> %a1, <4 x i64> %a2) ;
  ret <4 x i64> %res
}
define <4 x i64> @test_int_x86_xop_vpcmov_256_mr(<4 x i64> %a0, <4 x i64>* %a1, <4 x i64> %a2) {
; CHECK-LABEL: test_int_x86_xop_vpcmov_256_mr:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmov %ymm1, (%rdi), %ymm0, %ymm0
; CHECK-NEXT:    retq
  %vec = load <4 x i64>, <4 x i64>* %a1
  %res = call <4 x i64> @llvm.x86.xop.vpcmov.256(<4 x i64> %a0, <4 x i64> %vec, <4 x i64> %a2) ;
  ret <4 x i64> %res
}
define <4 x i64> @test_int_x86_xop_vpcmov_256_rm(<4 x i64> %a0, <4 x i64> %a1, <4 x i64>* %a2) {
; CHECK-LABEL: test_int_x86_xop_vpcmov_256_rm:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmov (%rdi), %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
 %vec = load <4 x i64>, <4 x i64>* %a2
 %res = call <4 x i64> @llvm.x86.xop.vpcmov.256(<4 x i64> %a0, <4 x i64> %a1, <4 x i64> %vec) ;
  ret <4 x i64> %res
}
declare <4 x i64> @llvm.x86.xop.vpcmov.256(<4 x i64>, <4 x i64>, <4 x i64>) nounwind readnone

