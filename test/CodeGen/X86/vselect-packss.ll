; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2      | FileCheck %s --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2    | FileCheck %s --check-prefix=SSE --check-prefix=SSE42
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx       | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2      | FileCheck %s --check-prefix=AVX --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f   | FileCheck %s --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl  | FileCheck %s --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512VL

define <16 x i8> @vselect_packss(<16 x i16> %a0, <16 x i16> %a1, <16 x i8> %a2, <16 x i8> %a3) {
; SSE-LABEL: vselect_packss:
; SSE:       # BB#0:
; SSE-NEXT:    pcmpeqw %xmm3, %xmm1
; SSE-NEXT:    pcmpeqw %xmm2, %xmm0
; SSE-NEXT:    packsswb %xmm1, %xmm0
; SSE-NEXT:    pand %xmm0, %xmm4
; SSE-NEXT:    pandn %xmm5, %xmm0
; SSE-NEXT:    por %xmm4, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: vselect_packss:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm5
; AVX1-NEXT:    vpcmpeqw %xmm4, %xmm5, %xmm4
; AVX1-NEXT:    vpcmpeqw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpacksswb %xmm4, %xmm0, %xmm0
; AVX1-NEXT:    vpand %xmm2, %xmm0, %xmm1
; AVX1-NEXT:    vpandn %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vpor %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: vselect_packss:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpcmpeqw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpand %xmm2, %xmm0, %xmm1
; AVX2-NEXT:    vpandn %xmm3, %xmm0, %xmm0
; AVX2-NEXT:    vpor %xmm0, %xmm1, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: vselect_packss:
; AVX512:       # BB#0:
; AVX512-NEXT:    vpcmpeqw %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX512-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vpand %xmm2, %xmm0, %xmm1
; AVX512-NEXT:    vpandn %xmm3, %xmm0, %xmm0
; AVX512-NEXT:    vpor %xmm0, %xmm1, %xmm0
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %1 = icmp eq <16 x i16> %a0, %a1
  %2 = sext <16 x i1> %1 to <16 x i16>
  %3 = shufflevector <16 x i16> %2, <16 x i16> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %4 = shufflevector <16 x i16> %2, <16 x i16> undef, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %5 = tail call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> %3, <8 x i16> %4)
  %6 = and <16 x i8> %5, %a2
  %7 = xor <16 x i8> %5, <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  %8 = and <16 x i8> %7, %a3
  %9 = or <16 x i8> %6, %8
  ret <16 x i8> %9
}
declare <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16>, <8 x i16>)
