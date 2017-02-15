; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx,+xop | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx,+xop | FileCheck %s --check-prefix=X64

;
; VPPERM
;

define <16 x i8> @vpperm_shuffle_unary(<16 x i8> %a0) {
; X32-LABEL: vpperm_shuffle_unary:
; X32:       # BB#0:
; X32-NEXT:    vpperm {{.*#+}} xmm0 = xmm0[15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
; X32-NEXT:    retl
;
; X64-LABEL: vpperm_shuffle_unary:
; X64:       # BB#0:
; X64-NEXT:    vpperm {{.*#+}} xmm0 = xmm0[15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
; X64-NEXT:    retq
  %1 = tail call <16 x i8> @llvm.x86.xop.vpperm(<16 x i8> %a0, <16 x i8> %a0, <16 x i8> <i8 31, i8 14, i8 29, i8 12, i8 27, i8 10, i8 25, i8 8, i8 23, i8 6, i8 21, i8 4, i8 19, i8 2, i8 17, i8 0>)
  ret <16 x i8> %1
}

define <16 x i8> @vpperm_shuffle_unary_undef(<16 x i8> %a0) {
; X32-LABEL: vpperm_shuffle_unary_undef:
; X32:       # BB#0:
; X32-NEXT:    vpperm {{.*#+}} xmm0 = xmm0[15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
; X32-NEXT:    retl
;
; X64-LABEL: vpperm_shuffle_unary_undef:
; X64:       # BB#0:
; X64-NEXT:    vpperm {{.*#+}} xmm0 = xmm0[15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
; X64-NEXT:    retq
  %1 = tail call <16 x i8> @llvm.x86.xop.vpperm(<16 x i8> %a0, <16 x i8> undef, <16 x i8> <i8 31, i8 14, i8 29, i8 12, i8 27, i8 10, i8 25, i8 8, i8 23, i8 6, i8 21, i8 4, i8 19, i8 2, i8 17, i8 0>)
  ret <16 x i8> %1
}

define <16 x i8> @vpperm_shuffle_unary_zero(<16 x i8> %a0) {
; X32-LABEL: vpperm_shuffle_unary_zero:
; X32:       # BB#0:
; X32-NEXT:    vpperm {{.*#+}} xmm0 = xmm0[15,14,13,12,11,10,9,8,7,6,5,4,3],zero,xmm0[1],zero
; X32-NEXT:    retl
;
; X64-LABEL: vpperm_shuffle_unary_zero:
; X64:       # BB#0:
; X64-NEXT:    vpperm {{.*#+}} xmm0 = xmm0[15,14,13,12,11,10,9,8,7,6,5,4,3],zero,xmm0[1],zero
; X64-NEXT:    retq
  %1 = tail call <16 x i8> @llvm.x86.xop.vpperm(<16 x i8> %a0, <16 x i8> %a0, <16 x i8> <i8 31, i8 14, i8 29, i8 12, i8 27, i8 10, i8 25, i8 8, i8 23, i8 6, i8 21, i8 4, i8 19, i8 130, i8 17, i8 128>)
  ret <16 x i8> %1
}

define <16 x i8> @vpperm_shuffle_binary(<16 x i8> %a0, <16 x i8> %a1) {
; X32-LABEL: vpperm_shuffle_binary:
; X32:       # BB#0:
; X32-NEXT:    vpperm {{.*#+}} xmm0 = xmm1[15],xmm0[14],xmm1[13],xmm0[12],xmm1[11],xmm0[10],xmm1[9],xmm0[8],xmm1[7],xmm0[6],xmm1[5],xmm0[4],xmm1[3],xmm0[2],xmm1[1],xmm0[0]
; X32-NEXT:    retl
;
; X64-LABEL: vpperm_shuffle_binary:
; X64:       # BB#0:
; X64-NEXT:    vpperm {{.*#+}} xmm0 = xmm1[15],xmm0[14],xmm1[13],xmm0[12],xmm1[11],xmm0[10],xmm1[9],xmm0[8],xmm1[7],xmm0[6],xmm1[5],xmm0[4],xmm1[3],xmm0[2],xmm1[1],xmm0[0]
; X64-NEXT:    retq
  %1 = tail call <16 x i8> @llvm.x86.xop.vpperm(<16 x i8> %a0, <16 x i8> %a1, <16 x i8> <i8 31, i8 14, i8 29, i8 12, i8 27, i8 10, i8 25, i8 8, i8 23, i8 6, i8 21, i8 4, i8 19, i8 2, i8 17, i8 0>)
  ret <16 x i8> %1
}

define <16 x i8> @vpperm_shuffle_binary_zero(<16 x i8> %a0, <16 x i8> %a1) {
; X32-LABEL: vpperm_shuffle_binary_zero:
; X32:       # BB#0:
; X32-NEXT:    vpperm {{.*#+}} xmm0 = xmm1[15],xmm0[14],xmm1[13],xmm0[12],xmm1[11],xmm0[10],xmm1[9],xmm0[8],xmm1[7],xmm0[6],xmm1[5],xmm0[4],zero,zero,zero,zero
; X32-NEXT:    retl
;
; X64-LABEL: vpperm_shuffle_binary_zero:
; X64:       # BB#0:
; X64-NEXT:    vpperm {{.*#+}} xmm0 = xmm1[15],xmm0[14],xmm1[13],xmm0[12],xmm1[11],xmm0[10],xmm1[9],xmm0[8],xmm1[7],xmm0[6],xmm1[5],xmm0[4],zero,zero,zero,zero
; X64-NEXT:    retq
  %1 = tail call <16 x i8> @llvm.x86.xop.vpperm(<16 x i8> %a0, <16 x i8> %a1, <16 x i8> <i8 31, i8 14, i8 29, i8 12, i8 27, i8 10, i8 25, i8 8, i8 23, i8 6, i8 21, i8 4, i8 147, i8 130, i8 145, i8 128>)
  ret <16 x i8> %1
}

; we can't decode vpperm's other permute ops
define <16 x i8> @vpperm_shuffle_general(<16 x i8> %a0, <16 x i8> %a1) {
; X32-LABEL: vpperm_shuffle_general:
; X32:       # BB#0:
; X32-NEXT:    vpperm {{\.LCPI.*}}, %xmm0, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: vpperm_shuffle_general:
; X64:       # BB#0:
; X64-NEXT:    vpperm {{.*}}(%rip), %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = tail call <16 x i8> @llvm.x86.xop.vpperm(<16 x i8> %a0, <16 x i8> %a0, <16 x i8> <i8 31, i8 14, i8 29, i8 12, i8 27, i8 10, i8 25, i8 8, i8 23, i8 6, i8 21, i8 4, i8 179, i8 162, i8 177, i8 160>)
  ret <16 x i8> %1
}

;
; VPERMIL2
;

; Note: _mm_permute2_pd shouldn't be used for constant shuffles as there will always
; be a quicker (and smaller) alternative.
define <2 x double> @vpermil2pd_21(<2 x double> %a0, <2 x double> %a1) {
; X32-LABEL: vpermil2pd_21:
; X32:       # BB#0:
; X32-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; X32-NEXT:    vunpcklpd {{.*#+}} xmm0 = xmm1[0],xmm0[0]
; X32-NEXT:    retl
;
; X64-LABEL: vpermil2pd_21:
; X64:       # BB#0:
; X64-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; X64-NEXT:    vunpcklpd {{.*#+}} xmm0 = xmm1[0],xmm0[0]
; X64-NEXT:    retq
  %1 = call <2 x double> @llvm.x86.xop.vpermil2pd(<2 x double> %a0, <2 x double> %a1, <2 x i64> <i64 10, i64 1>, i8 2)
  ret <2 x double> %1
}

define <4 x double> @vpermil2pd256_0062(<4 x double> %a0, <4 x double> %a1) {
; X32-LABEL: vpermil2pd256_0062:
; X32:       # BB#0:
; X32-NEXT:    vpermil2pd {{.*#+}} ymm0 = ymm0[0,0],ymm1[2],ymm0[2]
; X32-NEXT:    retl
;
; X64-LABEL: vpermil2pd256_0062:
; X64:       # BB#0:
; X64-NEXT:    vpermil2pd {{.*#+}} ymm0 = ymm0[0,0],ymm1[2],ymm0[2]
; X64-NEXT:    retq
  %1 = call <4 x double> @llvm.x86.xop.vpermil2pd.256(<4 x double> %a0, <4 x double> %a1, <4 x i64> <i64 0, i64 0, i64 4, i64 0>, i8 0)
  ret <4 x double> %1
}

define <4 x double> @vpermil2pd256_zz73(<4 x double> %a0, <4 x double> %a1) {
; X32-LABEL: vpermil2pd256_zz73:
; X32:       # BB#0:
; X32-NEXT:    vpermil2pd {{.*#+}} ymm0 = zero,zero,ymm1[3],ymm0[3]
; X32-NEXT:    retl
;
; X64-LABEL: vpermil2pd256_zz73:
; X64:       # BB#0:
; X64-NEXT:    vpermil2pd {{.*#+}} ymm0 = zero,zero,ymm1[3],ymm0[3]
; X64-NEXT:    retq
  %1 = call <4 x double> @llvm.x86.xop.vpermil2pd.256(<4 x double> %a0, <4 x double> %a1, <4 x i64> <i64 0, i64 0, i64 14, i64 10>, i8 3)
  ret <4 x double> %1
}

define <4 x float> @vpermil2ps_0561(<4 x float> %a0, <4 x float> %a1) {
; X32-LABEL: vpermil2ps_0561:
; X32:       # BB#0:
; X32-NEXT:    vpermil2ps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2],xmm0[1]
; X32-NEXT:    retl
;
; X64-LABEL: vpermil2ps_0561:
; X64:       # BB#0:
; X64-NEXT:    vpermil2ps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2],xmm0[1]
; X64-NEXT:    retq
  %1 = call <4 x float> @llvm.x86.xop.vpermil2ps(<4 x float> %a0, <4 x float> %a1, <4 x i32> <i32 0, i32 5, i32 6, i32 1>, i8 0)
  ret <4 x float> %1
}

define <8 x float> @vpermil2ps256_098144FE(<8 x float> %a0, <8 x float> %a1) {
; X32-LABEL: vpermil2ps256_098144FE:
; X32:       # BB#0:
; X32-NEXT:    vpermil2ps {{.*#+}} ymm0 = ymm0[0],ymm1[1,0],ymm0[1,4,4],ymm1[7,6]
; X32-NEXT:    retl
;
; X64-LABEL: vpermil2ps256_098144FE:
; X64:       # BB#0:
; X64-NEXT:    vpermil2ps {{.*#+}} ymm0 = ymm0[0],ymm1[1,0],ymm0[1,4,4],ymm1[7,6]
; X64-NEXT:    retq
  %1 = call <8 x float> @llvm.x86.xop.vpermil2ps.256(<8 x float> %a0, <8 x float> %a1, <8 x i32> <i32 0, i32 5, i32 4, i32 1, i32 0, i32 0, i32 7, i32 6>, i8 0)
  ret <8 x float> %1
}

define <8 x float> @vpermil2ps256_0zz8BzzA(<8 x float> %a0, <8 x float> %a1) {
; X32-LABEL: vpermil2ps256_0zz8BzzA:
; X32:       # BB#0:
; X32-NEXT:    vpermil2ps {{.*#+}} ymm0 = ymm0[0],zero,zero,ymm1[0,7],zero,zero,ymm1[6]
; X32-NEXT:    retl
;
; X64-LABEL: vpermil2ps256_0zz8BzzA:
; X64:       # BB#0:
; X64-NEXT:    vpermil2ps {{.*#+}} ymm0 = ymm0[0],zero,zero,ymm1[0,7],zero,zero,ymm1[6]
; X64-NEXT:    retq
  %1 = call <8 x float> @llvm.x86.xop.vpermil2ps.256(<8 x float> %a0, <8 x float> %a1, <8 x i32> <i32 0, i32 8, i32 8, i32 4, i32 7, i32 8, i32 8, i32 6>, i8 2)
  ret <8 x float> %1
}

declare <2 x double> @llvm.x86.xop.vpermil2pd(<2 x double>, <2 x double>, <2 x i64>, i8) nounwind readnone
declare <4 x double> @llvm.x86.xop.vpermil2pd.256(<4 x double>, <4 x double>, <4 x i64>, i8) nounwind readnone

declare <4 x float> @llvm.x86.xop.vpermil2ps(<4 x float>, <4 x float>, <4 x i32>, i8) nounwind readnone
declare <8 x float> @llvm.x86.xop.vpermil2ps.256(<8 x float>, <8 x float>, <8 x i32>, i8) nounwind readnone

declare <16 x i8> @llvm.x86.xop.vpperm(<16 x i8>, <16 x i8>, <16 x i8>) nounwind readnone
