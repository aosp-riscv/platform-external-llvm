; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX

; fold (mul x, 0) -> 0
define <4 x i32> @combine_vec_mul_zero(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_zero:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_zero:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = mul <4 x i32> %x, zeroinitializer
  ret <4 x i32> %1
}

; fold (mul x, 1) -> x
define <4 x i32> @combine_vec_mul_one(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_one:
; SSE:       # %bb.0:
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_one:
; AVX:       # %bb.0:
; AVX-NEXT:    retq
  %1 = mul <4 x i32> %x, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %1
}

; fold (mul x, -1) -> 0-x
define <4 x i32> @combine_vec_mul_negone(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_negone:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    psubd %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_negone:
; AVX:       # %bb.0:
; AVX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = mul <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %1
}

; fold (mul x, (1 << c)) -> x << c
define <4 x i32> @combine_vec_mul_pow2a(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_pow2a:
; SSE:       # %bb.0:
; SSE-NEXT:    paddd %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_pow2a:
; AVX:       # %bb.0:
; AVX-NEXT:    vpaddd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = mul <4 x i32> %x, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %1
}

define <4 x i32> @combine_vec_mul_pow2b(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_pow2b:
; SSE:       # %bb.0:
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_pow2b:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsllvd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = mul <4 x i32> %x, <i32 1, i32 2, i32 4, i32 16>
  ret <4 x i32> %1
}

define <4 x i64> @combine_vec_mul_pow2c(<4 x i64> %x) {
; SSE-LABEL: combine_vec_mul_pow2c:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm2
; SSE-NEXT:    psllq $1, %xmm2
; SSE-NEXT:    pblendw {{.*#+}} xmm2 = xmm0[0,1,2,3],xmm2[4,5,6,7]
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    psllq $4, %xmm0
; SSE-NEXT:    psllq $2, %xmm1
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1,2,3],xmm0[4,5,6,7]
; SSE-NEXT:    movdqa %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_pow2c:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsllvq {{.*}}(%rip), %ymm0, %ymm0
; AVX-NEXT:    retq
  %1 = mul <4 x i64> %x, <i64 1, i64 2, i64 4, i64 16>
  ret <4 x i64> %1
}

; fold (mul x, -(1 << c)) -> -(x << c) or (-x) << c
define <4 x i32> @combine_vec_mul_negpow2a(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_negpow2a:
; SSE:       # %bb.0:
; SSE-NEXT:    paddd %xmm0, %xmm0
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    psubd %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_negpow2a:
; AVX:       # %bb.0:
; AVX-NEXT:    vpaddd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = mul <4 x i32> %x, <i32 -2, i32 -2, i32 -2, i32 -2>
  ret <4 x i32> %1
}

define <4 x i32> @combine_vec_mul_negpow2b(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_negpow2b:
; SSE:       # %bb.0:
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_negpow2b:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmulld {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = mul <4 x i32> %x, <i32 -1, i32 -2, i32 -4, i32 -16>
  ret <4 x i32> %1
}

define <4 x i64> @combine_vec_mul_negpow2c(<4 x i64> %x) {
; SSE-LABEL: combine_vec_mul_negpow2c:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [4294967295,4294967295]
; SSE-NEXT:    movdqa %xmm0, %xmm3
; SSE-NEXT:    pmuludq %xmm2, %xmm3
; SSE-NEXT:    movdqa %xmm0, %xmm4
; SSE-NEXT:    psrlq $32, %xmm4
; SSE-NEXT:    movdqa {{.*#+}} xmm5 = [18446744073709551615,18446744073709551614]
; SSE-NEXT:    pmuludq %xmm5, %xmm4
; SSE-NEXT:    paddq %xmm3, %xmm4
; SSE-NEXT:    psllq $32, %xmm4
; SSE-NEXT:    pmuludq %xmm5, %xmm0
; SSE-NEXT:    paddq %xmm4, %xmm0
; SSE-NEXT:    pmuludq %xmm1, %xmm2
; SSE-NEXT:    movdqa %xmm1, %xmm3
; SSE-NEXT:    psrlq $32, %xmm3
; SSE-NEXT:    movdqa {{.*#+}} xmm4 = [18446744073709551612,18446744073709551600]
; SSE-NEXT:    pmuludq %xmm4, %xmm3
; SSE-NEXT:    paddq %xmm2, %xmm3
; SSE-NEXT:    psllq $32, %xmm3
; SSE-NEXT:    pmuludq %xmm4, %xmm1
; SSE-NEXT:    paddq %xmm3, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_negpow2c:
; AVX:       # %bb.0:
; AVX-NEXT:    vpbroadcastq {{.*#+}} ymm1 = [4294967295,4294967295,4294967295,4294967295]
; AVX-NEXT:    vpmuludq %ymm1, %ymm0, %ymm1
; AVX-NEXT:    vpsrlq $32, %ymm0, %ymm2
; AVX-NEXT:    vmovdqa {{.*#+}} ymm3 = [18446744073709551615,18446744073709551614,18446744073709551612,18446744073709551600]
; AVX-NEXT:    vpmuludq %ymm3, %ymm2, %ymm2
; AVX-NEXT:    vpaddq %ymm2, %ymm1, %ymm1
; AVX-NEXT:    vpsllq $32, %ymm1, %ymm1
; AVX-NEXT:    vpmuludq %ymm3, %ymm0, %ymm0
; AVX-NEXT:    vpaddq %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %1 = mul <4 x i64> %x, <i64 -1, i64 -2, i64 -4, i64 -16>
  ret <4 x i64> %1
}

; (mul (shl X, c1), c2) -> (mul X, c2 << c1)
define <4 x i32> @combine_vec_mul_shl_const(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_shl_const:
; SSE:       # %bb.0:
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_shl_const:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmulld {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shl <4 x i32> %x, <i32 1, i32 2, i32 8, i32 16>
  %2 = mul <4 x i32> %1, <i32 1, i32 3, i32 5, i32 7>
  ret <4 x i32> %2
}

; (mul (shl X, C), Y) -> (shl (mul X, Y), C) when the shift has one use.
define <4 x i32> @combine_vec_mul_shl_oneuse0(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_mul_shl_oneuse0:
; SSE:       # %bb.0:
; SSE-NEXT:    pmulld %xmm1, %xmm0
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_shl_oneuse0:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmulld %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpsllvd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shl <4 x i32> %x, <i32 1, i32 2, i32 8, i32 16>
  %2 = mul <4 x i32> %1, %y
  ret <4 x i32> %2
}

define <4 x i32> @combine_vec_mul_shl_oneuse1(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_mul_shl_oneuse1:
; SSE:       # %bb.0:
; SSE-NEXT:    pmulld %xmm1, %xmm0
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_shl_oneuse1:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmulld %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpsllvd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shl <4 x i32> %x, <i32 1, i32 2, i32 8, i32 16>
  %2 = mul <4 x i32> %y, %1
  ret <4 x i32> %2
}

define <4 x i32> @combine_vec_mul_shl_multiuse0(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_mul_shl_multiuse0:
; SSE:       # %bb.0:
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE-NEXT:    pmulld %xmm0, %xmm1
; SSE-NEXT:    paddd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_shl_multiuse0:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsllvd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpmulld %xmm1, %xmm0, %xmm1
; AVX-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shl <4 x i32> %x, <i32 1, i32 2, i32 8, i32 16>
  %2 = mul <4 x i32> %1, %y
  %3 = add <4 x i32> %1, %2
  ret <4 x i32> %3
}

define <4 x i32> @combine_vec_mul_shl_multiuse1(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_mul_shl_multiuse1:
; SSE:       # %bb.0:
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE-NEXT:    pmulld %xmm0, %xmm1
; SSE-NEXT:    paddd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_shl_multiuse1:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsllvd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpmulld %xmm0, %xmm1, %xmm1
; AVX-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shl <4 x i32> %x, <i32 1, i32 2, i32 8, i32 16>
  %2 = mul <4 x i32> %y, %1
  %3 = add <4 x i32> %1, %2
  ret <4 x i32> %3
}

; fold (mul (add x, c1), c2) -> (add (mul x, c2), c1*c2)

define <4 x i32> @combine_vec_mul_add(<4 x i32> %x) {
; SSE-LABEL: combine_vec_mul_add:
; SSE:       # %bb.0:
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm0
; SSE-NEXT:    paddd {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_mul_add:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmulld {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpaddd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = add <4 x i32> %x, <i32 1, i32 2, i32 8, i32 16>
  %2 = mul <4 x i32> %1, <i32 4, i32 6, i32 2, i32 0>
  ret <4 x i32> %2
}

; This would infinite loop because DAGCombiner wants to turn this into a shift,
; but x86 lowering wants to avoid non-uniform vector shift amounts.

define <16 x i8> @PR35579(<16 x i8> %x) {
; SSE-LABEL: PR35579:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [0,1,2,1,4,1,2,1,8,1,2,1,4,1,2,1]
; SSE-NEXT:    punpckhbw {{.*#+}} xmm2 = xmm2[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15]
; SSE-NEXT:    pmovzxbw {{.*#+}} xmm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; SSE-NEXT:    punpckhbw {{.*#+}} xmm0 = xmm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15]
; SSE-NEXT:    pmullw %xmm2, %xmm0
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,255,255,255,255,255,255]
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    pmullw {{.*}}(%rip), %xmm1
; SSE-NEXT:    pand %xmm2, %xmm1
; SSE-NEXT:    packuswb %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: PR35579:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; AVX-NEXT:    vpmullw {{.*}}(%rip), %ymm0, %ymm0
; AVX-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX-NEXT:    vmovdqa {{.*#+}} xmm2 = <0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u>
; AVX-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %r = mul <16 x i8> %x, <i8 0, i8 1, i8 2, i8 1, i8 4, i8 1, i8 2, i8 1, i8 8, i8 1, i8 2, i8 1, i8 4, i8 1, i8 2, i8 1>
  ret <16 x i8> %r
}

