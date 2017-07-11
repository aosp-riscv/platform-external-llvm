; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVXB --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx512f | FileCheck %s --check-prefix=AVXB --check-prefix=AVX3

define <4 x double> @load_factorf64_4(<16 x double>* %ptr) {
; AVX-LABEL: load_factorf64_4:
; AVX:       # BB#0:
; AVX-NEXT:    vmovupd (%rdi), %ymm0
; AVX-NEXT:    vmovupd 32(%rdi), %ymm1
; AVX-NEXT:    vmovupd 64(%rdi), %ymm2
; AVX-NEXT:    vmovupd 96(%rdi), %ymm3
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm4 = ymm0[0,1],ymm2[0,1]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm5 = ymm1[0,1],ymm3[0,1]
; AVX-NEXT:    vhaddpd %ymm5, %ymm4, %ymm4
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX-NEXT:    vunpcklpd {{.*#+}} ymm2 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX-NEXT:    vaddpd %ymm2, %ymm4, %ymm2
; AVX-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX-NEXT:    vaddpd %ymm0, %ymm2, %ymm0
; AVX-NEXT:    retq
;
; AVXB-LABEL: load_factorf64_4:
; AVXB:       # BB#0:
; AVXB-NEXT:    vmovupd (%rdi), %ymm0
; AVXB-NEXT:    vmovupd 32(%rdi), %ymm1
; AVXB-NEXT:    vmovupd 64(%rdi), %ymm2
; AVXB-NEXT:    vmovupd 96(%rdi), %ymm3
; AVXB-NEXT:    vperm2f128 {{.*#+}} ymm4 = ymm0[0,1],ymm2[0,1]
; AVXB-NEXT:    vperm2f128 {{.*#+}} ymm5 = ymm1[0,1],ymm3[0,1]
; AVXB-NEXT:    vhaddpd %ymm5, %ymm4, %ymm4
; AVXB-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVXB-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVXB-NEXT:    vunpcklpd {{.*#+}} ymm2 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVXB-NEXT:    vaddpd %ymm2, %ymm4, %ymm2
; AVXB-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVXB-NEXT:    vaddpd %ymm0, %ymm2, %ymm0
; AVXB-NEXT:    retq
  %wide.vec = load <16 x double>, <16 x double>* %ptr, align 16
  %strided.v0 = shufflevector <16 x double> %wide.vec, <16 x double> undef, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.v1 = shufflevector <16 x double> %wide.vec, <16 x double> undef, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.v2 = shufflevector <16 x double> %wide.vec, <16 x double> undef, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.v3 = shufflevector <16 x double> %wide.vec, <16 x double> undef, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %add1 = fadd <4 x double> %strided.v0, %strided.v1
  %add2 = fadd <4 x double> %add1, %strided.v2
  %add3 = fadd <4 x double> %add2, %strided.v3
  ret <4 x double> %add3
}

define <4 x double> @load_factorf64_2(<16 x double>* %ptr) {
; AVX-LABEL: load_factorf64_2:
; AVX:       # BB#0:
; AVX-NEXT:    vmovupd (%rdi), %ymm0
; AVX-NEXT:    vmovupd 32(%rdi), %ymm1
; AVX-NEXT:    vmovupd 64(%rdi), %ymm2
; AVX-NEXT:    vmovupd 96(%rdi), %ymm3
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm4 = ymm0[0,1],ymm2[0,1]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm5 = ymm1[0,1],ymm3[0,1]
; AVX-NEXT:    vunpcklpd {{.*#+}} ymm4 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX-NEXT:    vmulpd %ymm0, %ymm4, %ymm0
; AVX-NEXT:    retq
;
; AVXB-LABEL: load_factorf64_2:
; AVXB:       # BB#0:
; AVXB-NEXT:    vmovupd (%rdi), %ymm0
; AVXB-NEXT:    vmovupd 32(%rdi), %ymm1
; AVXB-NEXT:    vmovupd 64(%rdi), %ymm2
; AVXB-NEXT:    vmovupd 96(%rdi), %ymm3
; AVXB-NEXT:    vperm2f128 {{.*#+}} ymm4 = ymm0[0,1],ymm2[0,1]
; AVXB-NEXT:    vperm2f128 {{.*#+}} ymm5 = ymm1[0,1],ymm3[0,1]
; AVXB-NEXT:    vunpcklpd {{.*#+}} ymm4 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVXB-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVXB-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVXB-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVXB-NEXT:    vmulpd %ymm0, %ymm4, %ymm0
; AVXB-NEXT:    retq
  %wide.vec = load <16 x double>, <16 x double>* %ptr, align 16
  %strided.v0 = shufflevector <16 x double> %wide.vec, <16 x double> undef, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.v3 = shufflevector <16 x double> %wide.vec, <16 x double> undef, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %mul = fmul <4 x double> %strided.v0, %strided.v3
  ret <4 x double> %mul
}

define <4 x double> @load_factorf64_1(<16 x double>* %ptr) {
; AVX-LABEL: load_factorf64_1:
; AVX:       # BB#0:
; AVX-NEXT:    vmovupd (%rdi), %ymm0
; AVX-NEXT:    vmovupd 32(%rdi), %ymm1
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[0,1],mem[0,1]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[0,1],mem[0,1]
; AVX-NEXT:    vunpcklpd {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX-NEXT:    vmulpd %ymm0, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVXB-LABEL: load_factorf64_1:
; AVXB:       # BB#0:
; AVXB-NEXT:    vmovupd (%rdi), %ymm0
; AVXB-NEXT:    vmovupd 32(%rdi), %ymm1
; AVXB-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[0,1],mem[0,1]
; AVXB-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[0,1],mem[0,1]
; AVXB-NEXT:    vunpcklpd {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVXB-NEXT:    vmulpd %ymm0, %ymm0, %ymm0
; AVXB-NEXT:    retq
  %wide.vec = load <16 x double>, <16 x double>* %ptr, align 16
  %strided.v0 = shufflevector <16 x double> %wide.vec, <16 x double> undef, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.v3 = shufflevector <16 x double> %wide.vec, <16 x double> undef, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %mul = fmul <4 x double> %strided.v0, %strided.v3
  ret <4 x double> %mul
}

define <4 x i64> @load_factori64_4(<16 x i64>* %ptr) {
; AVX1-LABEL: load_factori64_4:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovupd (%rdi), %ymm0
; AVX1-NEXT:    vmovupd 32(%rdi), %ymm1
; AVX1-NEXT:    vmovupd 64(%rdi), %ymm2
; AVX1-NEXT:    vmovupd 96(%rdi), %ymm3
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm4 = ymm0[0,1],ymm2[0,1]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm5 = ymm1[0,1],ymm3[0,1]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX1-NEXT:    vunpcklpd {{.*#+}} ymm2 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVX1-NEXT:    vunpcklpd {{.*#+}} ymm3 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX1-NEXT:    vunpckhpd {{.*#+}} ymm4 = ymm4[1],ymm5[1],ymm4[3],ymm5[3]
; AVX1-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX1-NEXT:    vextractf128 $1, %ymm4, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm5
; AVX1-NEXT:    vpaddq %xmm3, %xmm4, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm3
; AVX1-NEXT:    vpaddq %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm3
; AVX1-NEXT:    vpaddq %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpaddq %xmm1, %xmm5, %xmm1
; AVX1-NEXT:    vpaddq %xmm0, %xmm4, %xmm0
; AVX1-NEXT:    vpaddq %xmm0, %xmm2, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVXB-LABEL: load_factori64_4:
; AVXB:       # BB#0:
; AVXB-NEXT:    vmovdqu (%rdi), %ymm0
; AVXB-NEXT:    vmovdqu 32(%rdi), %ymm1
; AVXB-NEXT:    vmovdqu 64(%rdi), %ymm2
; AVXB-NEXT:    vmovdqu 96(%rdi), %ymm3
; AVXB-NEXT:    vperm2i128 {{.*#+}} ymm4 = ymm0[0,1],ymm2[0,1]
; AVXB-NEXT:    vperm2i128 {{.*#+}} ymm5 = ymm1[0,1],ymm3[0,1]
; AVXB-NEXT:    vperm2i128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVXB-NEXT:    vperm2i128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVXB-NEXT:    vpunpcklqdq {{.*#+}} ymm2 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVXB-NEXT:    vpunpcklqdq {{.*#+}} ymm3 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVXB-NEXT:    vpunpckhqdq {{.*#+}} ymm4 = ymm4[1],ymm5[1],ymm4[3],ymm5[3]
; AVXB-NEXT:    vpaddq %ymm3, %ymm4, %ymm3
; AVXB-NEXT:    vpunpckhqdq {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVXB-NEXT:    vpaddq %ymm0, %ymm3, %ymm0
; AVXB-NEXT:    vpaddq %ymm0, %ymm2, %ymm0
; AVXB-NEXT:    retq
  %wide.vec = load <16 x i64>, <16 x i64>* %ptr, align 16
  %strided.v0 = shufflevector <16 x i64> %wide.vec, <16 x i64> undef, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.v1 = shufflevector <16 x i64> %wide.vec, <16 x i64> undef, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.v2 = shufflevector <16 x i64> %wide.vec, <16 x i64> undef, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.v3 = shufflevector <16 x i64> %wide.vec, <16 x i64> undef, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %add1 = add <4 x i64> %strided.v0, %strided.v1
  %add2 = add <4 x i64> %add1, %strided.v2
  %add3 = add <4 x i64> %add2, %strided.v3
  ret <4 x i64> %add3
}

define void @store_factorf64_4(<16 x double>* %ptr, <4 x double> %v0, <4 x double> %v1, <4 x double> %v2, <4 x double> %v3) {
; AVX-LABEL: store_factorf64_4:
; AVX:       # BB#0:
; AVX-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm4
; AVX-NEXT:    vinsertf128 $1, %xmm3, %ymm1, %ymm5
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX-NEXT:    vunpcklpd {{.*#+}} ymm2 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVX-NEXT:    vunpcklpd {{.*#+}} ymm3 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX-NEXT:    vunpckhpd {{.*#+}} ymm4 = ymm4[1],ymm5[1],ymm4[3],ymm5[3]
; AVX-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX-NEXT:    vmovupd %ymm0, 96(%rdi)
; AVX-NEXT:    vmovupd %ymm3, 64(%rdi)
; AVX-NEXT:    vmovupd %ymm4, 32(%rdi)
; AVX-NEXT:    vmovupd %ymm2, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX3-LABEL: store_factorf64_4:
; AVX3:       # BB#0:
; AVX3-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm4
; AVX3-NEXT:    vinsertf128 $1, %xmm3, %ymm1, %ymm5
; AVX3-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX3-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX3-NEXT:    vunpcklpd {{.*#+}} ymm2 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVX3-NEXT:    vunpcklpd {{.*#+}} ymm3 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX3-NEXT:    vunpckhpd {{.*#+}} ymm4 = ymm4[1],ymm5[1],ymm4[3],ymm5[3]
; AVX3-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX3-NEXT:    vinsertf64x4 $1, %ymm4, %zmm2, %zmm1
; AVX3-NEXT:    vinsertf64x4 $1, %ymm0, %zmm3, %zmm0
; AVX3-NEXT:    vmovupd %zmm0, 64(%rdi)
; AVX3-NEXT:    vmovupd %zmm1, (%rdi)
; AVX3-NEXT:    vzeroupper
; AVX3-NEXT:    retq
  %s0 = shufflevector <4 x double> %v0, <4 x double> %v1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %s1 = shufflevector <4 x double> %v2, <4 x double> %v3, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec = shufflevector <8 x double> %s0, <8 x double> %s1, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>
  store <16 x double> %interleaved.vec, <16 x double>* %ptr, align 16
  ret void
}

define void @store_factori64_4(<16 x i64>* %ptr, <4 x i64> %v0, <4 x i64> %v1, <4 x i64> %v2, <4 x i64> %v3) {
; AVX1-LABEL: store_factori64_4:
; AVX1:       # BB#0:
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm4
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm1, %ymm5
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX1-NEXT:    vunpcklpd {{.*#+}} ymm2 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVX1-NEXT:    vunpcklpd {{.*#+}} ymm3 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX1-NEXT:    vunpckhpd {{.*#+}} ymm4 = ymm4[1],ymm5[1],ymm4[3],ymm5[3]
; AVX1-NEXT:    vunpckhpd {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX1-NEXT:    vmovupd %ymm0, 96(%rdi)
; AVX1-NEXT:    vmovupd %ymm3, 64(%rdi)
; AVX1-NEXT:    vmovupd %ymm4, 32(%rdi)
; AVX1-NEXT:    vmovupd %ymm2, (%rdi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: store_factori64_4:
; AVX2:       # BB#0:
; AVX2-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm4
; AVX2-NEXT:    vinserti128 $1, %xmm3, %ymm1, %ymm5
; AVX2-NEXT:    vperm2i128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX2-NEXT:    vperm2i128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} ymm2 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} ymm3 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX2-NEXT:    vpunpckhqdq {{.*#+}} ymm4 = ymm4[1],ymm5[1],ymm4[3],ymm5[3]
; AVX2-NEXT:    vpunpckhqdq {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX2-NEXT:    vmovdqu %ymm0, 96(%rdi)
; AVX2-NEXT:    vmovdqu %ymm3, 64(%rdi)
; AVX2-NEXT:    vmovdqu %ymm4, 32(%rdi)
; AVX2-NEXT:    vmovdqu %ymm2, (%rdi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX3-LABEL: store_factori64_4:
; AVX3:       # BB#0:
; AVX3-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm4
; AVX3-NEXT:    vinserti128 $1, %xmm3, %ymm1, %ymm5
; AVX3-NEXT:    vperm2i128 {{.*#+}} ymm0 = ymm0[2,3],ymm2[2,3]
; AVX3-NEXT:    vperm2i128 {{.*#+}} ymm1 = ymm1[2,3],ymm3[2,3]
; AVX3-NEXT:    vpunpcklqdq {{.*#+}} ymm2 = ymm4[0],ymm5[0],ymm4[2],ymm5[2]
; AVX3-NEXT:    vpunpcklqdq {{.*#+}} ymm3 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
; AVX3-NEXT:    vpunpckhqdq {{.*#+}} ymm4 = ymm4[1],ymm5[1],ymm4[3],ymm5[3]
; AVX3-NEXT:    vpunpckhqdq {{.*#+}} ymm0 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX3-NEXT:    vinserti64x4 $1, %ymm4, %zmm2, %zmm1
; AVX3-NEXT:    vinserti64x4 $1, %ymm0, %zmm3, %zmm0
; AVX3-NEXT:    vmovdqu64 %zmm0, 64(%rdi)
; AVX3-NEXT:    vmovdqu64 %zmm1, (%rdi)
; AVX3-NEXT:    vzeroupper
; AVX3-NEXT:    retq
  %s0 = shufflevector <4 x i64> %v0, <4 x i64> %v1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %s1 = shufflevector <4 x i64> %v2, <4 x i64> %v3, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec = shufflevector <8 x i64> %s0, <8 x i64> %s1, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>
  store <16 x i64> %interleaved.vec, <16 x i64>* %ptr, align 16
  ret void
}


define void @interleaved_store_vf32_i8_stride4(<32 x i8> %x1, <32 x i8> %x2, <32 x i8> %x3, <32 x i8> %x4, <128 x i8>* %p) {
; AVX1-LABEL: interleaved_store_vf32_i8_stride4:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpunpcklbw {{.*#+}} xmm4 = xmm2[0],xmm3[0],xmm2[1],xmm3[1],xmm2[2],xmm3[2],xmm2[3],xmm3[3],xmm2[4],xmm3[4],xmm2[5],xmm3[5],xmm2[6],xmm3[6],xmm2[7],xmm3[7]
; AVX1-NEXT:    vpunpckhwd {{.*#+}} xmm5 = xmm0[4],xmm4[4],xmm0[5],xmm4[5],xmm0[6],xmm4[6],xmm0[7],xmm4[7]
; AVX1-NEXT:    vpunpcklwd {{.*#+}} xmm4 = xmm0[0],xmm4[0],xmm0[1],xmm4[1],xmm0[2],xmm4[2],xmm0[3],xmm4[3]
; AVX1-NEXT:    vinsertf128 $1, %xmm5, %ymm4, %ymm5
; AVX1-NEXT:    vmovaps {{.*#+}} ymm4 = [65535,0,65535,0,65535,0,65535,0,65535,0,65535,0,65535,0,65535,0]
; AVX1-NEXT:    vandnps %ymm5, %ymm4, %ymm5
; AVX1-NEXT:    vpunpcklbw {{.*#+}} xmm6 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; AVX1-NEXT:    vpunpckhwd {{.*#+}} xmm7 = xmm6[4],xmm0[4],xmm6[5],xmm0[5],xmm6[6],xmm0[6],xmm6[7],xmm0[7]
; AVX1-NEXT:    vpmovzxwd {{.*#+}} xmm6 = xmm6[0],zero,xmm6[1],zero,xmm6[2],zero,xmm6[3],zero
; AVX1-NEXT:    vinsertf128 $1, %xmm7, %ymm6, %ymm6
; AVX1-NEXT:    vandps %ymm4, %ymm6, %ymm6
; AVX1-NEXT:    vorps %ymm5, %ymm6, %ymm8
; AVX1-NEXT:    vpunpckhbw {{.*#+}} xmm6 = xmm2[8],xmm3[8],xmm2[9],xmm3[9],xmm2[10],xmm3[10],xmm2[11],xmm3[11],xmm2[12],xmm3[12],xmm2[13],xmm3[13],xmm2[14],xmm3[14],xmm2[15],xmm3[15]
; AVX1-NEXT:    vpunpckhwd {{.*#+}} xmm7 = xmm0[4],xmm6[4],xmm0[5],xmm6[5],xmm0[6],xmm6[6],xmm0[7],xmm6[7]
; AVX1-NEXT:    vpunpcklwd {{.*#+}} xmm6 = xmm0[0],xmm6[0],xmm0[1],xmm6[1],xmm0[2],xmm6[2],xmm0[3],xmm6[3]
; AVX1-NEXT:    vinsertf128 $1, %xmm7, %ymm6, %ymm6
; AVX1-NEXT:    vandnps %ymm6, %ymm4, %ymm6
; AVX1-NEXT:    vpunpckhbw {{.*#+}} xmm7 = xmm0[8],xmm1[8],xmm0[9],xmm1[9],xmm0[10],xmm1[10],xmm0[11],xmm1[11],xmm0[12],xmm1[12],xmm0[13],xmm1[13],xmm0[14],xmm1[14],xmm0[15],xmm1[15]
; AVX1-NEXT:    vpunpckhwd {{.*#+}} xmm5 = xmm7[4],xmm0[4],xmm7[5],xmm0[5],xmm7[6],xmm0[6],xmm7[7],xmm0[7]
; AVX1-NEXT:    vpmovzxwd {{.*#+}} xmm7 = xmm7[0],zero,xmm7[1],zero,xmm7[2],zero,xmm7[3],zero
; AVX1-NEXT:    vinsertf128 $1, %xmm5, %ymm7, %ymm5
; AVX1-NEXT:    vandps %ymm4, %ymm5, %ymm5
; AVX1-NEXT:    vorps %ymm6, %ymm5, %ymm9
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm3
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm2
; AVX1-NEXT:    vpunpcklbw {{.*#+}} xmm5 = xmm2[0],xmm3[0],xmm2[1],xmm3[1],xmm2[2],xmm3[2],xmm2[3],xmm3[3],xmm2[4],xmm3[4],xmm2[5],xmm3[5],xmm2[6],xmm3[6],xmm2[7],xmm3[7]
; AVX1-NEXT:    vpunpckhwd {{.*#+}} xmm7 = xmm0[4],xmm5[4],xmm0[5],xmm5[5],xmm0[6],xmm5[6],xmm0[7],xmm5[7]
; AVX1-NEXT:    vpunpcklwd {{.*#+}} xmm5 = xmm0[0],xmm5[0],xmm0[1],xmm5[1],xmm0[2],xmm5[2],xmm0[3],xmm5[3]
; AVX1-NEXT:    vinsertf128 $1, %xmm7, %ymm5, %ymm5
; AVX1-NEXT:    vandnps %ymm5, %ymm4, %ymm5
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpunpcklbw {{.*#+}} xmm7 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; AVX1-NEXT:    vpunpckhwd {{.*#+}} xmm6 = xmm7[4],xmm0[4],xmm7[5],xmm0[5],xmm7[6],xmm0[6],xmm7[7],xmm0[7]
; AVX1-NEXT:    vpmovzxwd {{.*#+}} xmm7 = xmm7[0],zero,xmm7[1],zero,xmm7[2],zero,xmm7[3],zero
; AVX1-NEXT:    vinsertf128 $1, %xmm6, %ymm7, %ymm6
; AVX1-NEXT:    vandps %ymm4, %ymm6, %ymm6
; AVX1-NEXT:    vorps %ymm5, %ymm6, %ymm5
; AVX1-NEXT:    vpunpckhbw {{.*#+}} xmm2 = xmm2[8],xmm3[8],xmm2[9],xmm3[9],xmm2[10],xmm3[10],xmm2[11],xmm3[11],xmm2[12],xmm3[12],xmm2[13],xmm3[13],xmm2[14],xmm3[14],xmm2[15],xmm3[15]
; AVX1-NEXT:    vpunpckhwd {{.*#+}} xmm3 = xmm0[4],xmm2[4],xmm0[5],xmm2[5],xmm0[6],xmm2[6],xmm0[7],xmm2[7]
; AVX1-NEXT:    vpunpcklwd {{.*#+}} xmm2 = xmm0[0],xmm2[0],xmm0[1],xmm2[1],xmm0[2],xmm2[2],xmm0[3],xmm2[3]
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm2, %ymm2
; AVX1-NEXT:    vandnps %ymm2, %ymm4, %ymm2
; AVX1-NEXT:    vpunpckhbw {{.*#+}} xmm0 = xmm0[8],xmm1[8],xmm0[9],xmm1[9],xmm0[10],xmm1[10],xmm0[11],xmm1[11],xmm0[12],xmm1[12],xmm0[13],xmm1[13],xmm0[14],xmm1[14],xmm0[15],xmm1[15]
; AVX1-NEXT:    vpunpckhwd {{.*#+}} xmm1 = xmm0[4,4,5,5,6,6,7,7]
; AVX1-NEXT:    vpmovzxwd {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    vandps %ymm4, %ymm0, %ymm0
; AVX1-NEXT:    vorps %ymm2, %ymm0, %ymm0
; AVX1-NEXT:    vmovaps %ymm0, 96(%rdi)
; AVX1-NEXT:    vmovaps %ymm5, 64(%rdi)
; AVX1-NEXT:    vmovaps %ymm9, 32(%rdi)
; AVX1-NEXT:    vmovaps %ymm8, (%rdi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVXB-LABEL: interleaved_store_vf32_i8_stride4:
; AVXB:       # BB#0:
; AVXB-NEXT:    vpunpcklbw {{.*#+}} xmm4 = xmm2[0],xmm3[0],xmm2[1],xmm3[1],xmm2[2],xmm3[2],xmm2[3],xmm3[3],xmm2[4],xmm3[4],xmm2[5],xmm3[5],xmm2[6],xmm3[6],xmm2[7],xmm3[7]
; AVXB-NEXT:    vpunpckhwd {{.*#+}} xmm5 = xmm0[4],xmm4[4],xmm0[5],xmm4[5],xmm0[6],xmm4[6],xmm0[7],xmm4[7]
; AVXB-NEXT:    vpunpcklwd {{.*#+}} xmm4 = xmm0[0],xmm4[0],xmm0[1],xmm4[1],xmm0[2],xmm4[2],xmm0[3],xmm4[3]
; AVXB-NEXT:    vinserti128 $1, %xmm5, %ymm4, %ymm4
; AVXB-NEXT:    vpunpcklbw {{.*#+}} xmm5 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; AVXB-NEXT:    vpunpckhwd {{.*#+}} xmm6 = xmm5[4],xmm0[4],xmm5[5],xmm0[5],xmm5[6],xmm0[6],xmm5[7],xmm0[7]
; AVXB-NEXT:    vpmovzxwd {{.*#+}} xmm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero
; AVXB-NEXT:    vinserti128 $1, %xmm6, %ymm5, %ymm5
; AVXB-NEXT:    vpblendw {{.*#+}} ymm8 = ymm5[0],ymm4[1],ymm5[2],ymm4[3],ymm5[4],ymm4[5],ymm5[6],ymm4[7],ymm5[8],ymm4[9],ymm5[10],ymm4[11],ymm5[12],ymm4[13],ymm5[14],ymm4[15]
; AVXB-NEXT:    vpunpckhbw {{.*#+}} xmm5 = xmm2[8],xmm3[8],xmm2[9],xmm3[9],xmm2[10],xmm3[10],xmm2[11],xmm3[11],xmm2[12],xmm3[12],xmm2[13],xmm3[13],xmm2[14],xmm3[14],xmm2[15],xmm3[15]
; AVXB-NEXT:    vpunpckhwd {{.*#+}} xmm6 = xmm0[4],xmm5[4],xmm0[5],xmm5[5],xmm0[6],xmm5[6],xmm0[7],xmm5[7]
; AVXB-NEXT:    vpunpcklwd {{.*#+}} xmm5 = xmm0[0],xmm5[0],xmm0[1],xmm5[1],xmm0[2],xmm5[2],xmm0[3],xmm5[3]
; AVXB-NEXT:    vinserti128 $1, %xmm6, %ymm5, %ymm5
; AVXB-NEXT:    vpunpckhbw {{.*#+}} xmm6 = xmm0[8],xmm1[8],xmm0[9],xmm1[9],xmm0[10],xmm1[10],xmm0[11],xmm1[11],xmm0[12],xmm1[12],xmm0[13],xmm1[13],xmm0[14],xmm1[14],xmm0[15],xmm1[15]
; AVXB-NEXT:    vpunpckhwd {{.*#+}} xmm7 = xmm6[4],xmm0[4],xmm6[5],xmm0[5],xmm6[6],xmm0[6],xmm6[7],xmm0[7]
; AVXB-NEXT:    vpmovzxwd {{.*#+}} xmm6 = xmm6[0],zero,xmm6[1],zero,xmm6[2],zero,xmm6[3],zero
; AVXB-NEXT:    vinserti128 $1, %xmm7, %ymm6, %ymm6
; AVXB-NEXT:    vpblendw {{.*#+}} ymm5 = ymm6[0],ymm5[1],ymm6[2],ymm5[3],ymm6[4],ymm5[5],ymm6[6],ymm5[7],ymm6[8],ymm5[9],ymm6[10],ymm5[11],ymm6[12],ymm5[13],ymm6[14],ymm5[15]
; AVXB-NEXT:    vextracti128 $1, %ymm3, %xmm3
; AVXB-NEXT:    vextracti128 $1, %ymm2, %xmm2
; AVXB-NEXT:    vpunpcklbw {{.*#+}} xmm6 = xmm2[0],xmm3[0],xmm2[1],xmm3[1],xmm2[2],xmm3[2],xmm2[3],xmm3[3],xmm2[4],xmm3[4],xmm2[5],xmm3[5],xmm2[6],xmm3[6],xmm2[7],xmm3[7]
; AVXB-NEXT:    vpunpckhwd {{.*#+}} xmm7 = xmm0[4],xmm6[4],xmm0[5],xmm6[5],xmm0[6],xmm6[6],xmm0[7],xmm6[7]
; AVXB-NEXT:    vpunpcklwd {{.*#+}} xmm6 = xmm0[0],xmm6[0],xmm0[1],xmm6[1],xmm0[2],xmm6[2],xmm0[3],xmm6[3]
; AVXB-NEXT:    vinserti128 $1, %xmm7, %ymm6, %ymm6
; AVXB-NEXT:    vextracti128 $1, %ymm1, %xmm1
; AVXB-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVXB-NEXT:    vpunpcklbw {{.*#+}} xmm7 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; AVXB-NEXT:    vpunpckhwd {{.*#+}} xmm4 = xmm7[4],xmm0[4],xmm7[5],xmm0[5],xmm7[6],xmm0[6],xmm7[7],xmm0[7]
; AVXB-NEXT:    vpmovzxwd {{.*#+}} xmm7 = xmm7[0],zero,xmm7[1],zero,xmm7[2],zero,xmm7[3],zero
; AVXB-NEXT:    vinserti128 $1, %xmm4, %ymm7, %ymm4
; AVXB-NEXT:    vpblendw {{.*#+}} ymm4 = ymm4[0],ymm6[1],ymm4[2],ymm6[3],ymm4[4],ymm6[5],ymm4[6],ymm6[7],ymm4[8],ymm6[9],ymm4[10],ymm6[11],ymm4[12],ymm6[13],ymm4[14],ymm6[15]
; AVXB-NEXT:    vpunpckhbw {{.*#+}} xmm2 = xmm2[8],xmm3[8],xmm2[9],xmm3[9],xmm2[10],xmm3[10],xmm2[11],xmm3[11],xmm2[12],xmm3[12],xmm2[13],xmm3[13],xmm2[14],xmm3[14],xmm2[15],xmm3[15]
; AVXB-NEXT:    vpunpckhwd {{.*#+}} xmm3 = xmm0[4],xmm2[4],xmm0[5],xmm2[5],xmm0[6],xmm2[6],xmm0[7],xmm2[7]
; AVXB-NEXT:    vpunpcklwd {{.*#+}} xmm2 = xmm0[0],xmm2[0],xmm0[1],xmm2[1],xmm0[2],xmm2[2],xmm0[3],xmm2[3]
; AVXB-NEXT:    vinserti128 $1, %xmm3, %ymm2, %ymm2
; AVXB-NEXT:    vpunpckhbw {{.*#+}} xmm0 = xmm0[8],xmm1[8],xmm0[9],xmm1[9],xmm0[10],xmm1[10],xmm0[11],xmm1[11],xmm0[12],xmm1[12],xmm0[13],xmm1[13],xmm0[14],xmm1[14],xmm0[15],xmm1[15]
; AVXB-NEXT:    vpunpckhwd {{.*#+}} xmm1 = xmm0[4,4,5,5,6,6,7,7]
; AVXB-NEXT:    vpmovzxwd {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
; AVXB-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVXB-NEXT:    vpblendw {{.*#+}} ymm0 = ymm0[0],ymm2[1],ymm0[2],ymm2[3],ymm0[4],ymm2[5],ymm0[6],ymm2[7],ymm0[8],ymm2[9],ymm0[10],ymm2[11],ymm0[12],ymm2[13],ymm0[14],ymm2[15]
; AVXB-NEXT:    vmovdqa %ymm0, 96(%rdi)
; AVXB-NEXT:    vmovdqa %ymm4, 64(%rdi)
; AVXB-NEXT:    vmovdqa %ymm5, 32(%rdi)
; AVXB-NEXT:    vmovdqa %ymm8, (%rdi)
; AVXB-NEXT:    vzeroupper
; AVXB-NEXT:    retq
  %v1 = shufflevector <32 x i8> %x1, <32 x i8> %x2, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %v2 = shufflevector <32 x i8> %x3, <32 x i8> %x4, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %interleaved.vec = shufflevector <64 x i8> %v1, <64 x i8> %v2, <128 x i32> <i32 0, i32 32, i32 64, i32 96, i32 1, i32 33, i32 65, i32 97, i32 2, i32 34, i32 66, i32 98, i32 3, i32 35, i32 67, i32 99, i32 4, i32 36, i32 68, i32 100, i32 5, i32 37, i32 69, i32 101, i32 6, i32 38, i32 70, i32 102, i32 7, i32 39, i32 71, i32 103, i32 8, i32 40, i32 72, i32 104, i32 9, i32 41, i32 73, i32 105, i32 10, i32 42, i32 74, i32 106, i32 11, i32 43, i32 75, i32 107, i32 12, i32 44, i32 76, i32 108, i32 13, i32 45, i32 77, i32 109, i32 14, i32 46, i32 78, i32 110, i32 15, i32 47, i32 79, i32 111, i32 16, i32 48, i32 80, i32 112, i32 17, i32 49, i32 81, i32 113, i32 18, i32 50, i32 82, i32 114, i32 19, i32 51, i32 83, i32 115, i32 20, i32 52, i32 84, i32 116, i32 21, i32 53, i32 85, i32 117, i32 22, i32 54, i32 86, i32 118, i32 23, i32 55, i32 87, i32 119, i32 24, i32 56, i32 88, i32 120, i32 25, i32 57, i32 89, i32 121, i32 26, i32 58, i32 90, i32 122, i32 27, i32 59, i32 91, i32 123, i32 28, i32 60, i32 92, i32 124, i32 29, i32 61, i32 93, i32 125, i32 30, i32 62, i32 94, i32 126, i32 31, i32 63, i32 95, i32 127>
  store <128 x i8> %interleaved.vec, <128 x i8>* %p
ret void
}

