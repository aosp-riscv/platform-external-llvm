; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,AVX,AVX2-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2,+fast-variable-shuffle | FileCheck %s --check-prefixes=CHECK,AVX,AVX2-FAST

; fold (sra 0, x) -> 0
define <4 x i32> @combine_vec_ashr_zero(<4 x i32> %x) {
; SSE-LABEL: combine_vec_ashr_zero:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_ashr_zero:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = ashr <4 x i32> zeroinitializer, %x
  ret <4 x i32> %1
}

; fold (sra -1, x) -> -1
define <4 x i32> @combine_vec_ashr_allones(<4 x i32> %x) {
; SSE-LABEL: combine_vec_ashr_allones:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpeqd %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_ashr_allones:
; AVX:       # %bb.0:
; AVX-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = ashr <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, %x
  ret <4 x i32> %1
}

; fold (sra x, c >= size(x)) -> undef
define <4 x i32> @combine_vec_ashr_outofrange0(<4 x i32> %x) {
; CHECK-LABEL: combine_vec_ashr_outofrange0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %1 = ashr <4 x i32> %x, <i32 33, i32 33, i32 33, i32 33>
  ret <4 x i32> %1
}

define <4 x i32> @combine_vec_ashr_outofrange1(<4 x i32> %x) {
; CHECK-LABEL: combine_vec_ashr_outofrange1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %1 = ashr <4 x i32> %x, <i32 33, i32 34, i32 35, i32 36>
  ret <4 x i32> %1
}

; fold (sra x, 0) -> x
define <4 x i32> @combine_vec_ashr_by_zero(<4 x i32> %x) {
; CHECK-LABEL: combine_vec_ashr_by_zero:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %1 = ashr <4 x i32> %x, zeroinitializer
  ret <4 x i32> %1
}

; fold (sra (sra x, c1), c2) -> (sra x, (add c1, c2))
define <4 x i32> @combine_vec_ashr_ashr0(<4 x i32> %x) {
; SSE-LABEL: combine_vec_ashr_ashr0:
; SSE:       # %bb.0:
; SSE-NEXT:    psrad $6, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_ashr_ashr0:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsrad $6, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = ashr <4 x i32> %x, <i32 2, i32 2, i32 2, i32 2>
  %2 = ashr <4 x i32> %1, <i32 4, i32 4, i32 4, i32 4>
  ret <4 x i32> %2
}

define <4 x i32> @combine_vec_ashr_ashr1(<4 x i32> %x) {
; SSE-LABEL: combine_vec_ashr_ashr1:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrad $10, %xmm1
; SSE-NEXT:    movdqa %xmm0, %xmm2
; SSE-NEXT:    psrad $6, %xmm2
; SSE-NEXT:    pblendw {{.*#+}} xmm2 = xmm2[0,1,2,3],xmm1[4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrad $8, %xmm1
; SSE-NEXT:    psrad $4, %xmm0
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3],xmm0[4,5],xmm2[6,7]
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_ashr_ashr1:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsravd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = ashr <4 x i32> %x, <i32 0, i32 1, i32 2, i32 3>
  %2 = ashr <4 x i32> %1, <i32 4, i32 5, i32 6, i32 7>
  ret <4 x i32> %2
}

define <4 x i32> @combine_vec_ashr_ashr2(<4 x i32> %x) {
; SSE-LABEL: combine_vec_ashr_ashr2:
; SSE:       # %bb.0:
; SSE-NEXT:    psrad $31, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_ashr_ashr2:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsrad $31, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = ashr <4 x i32> %x, <i32 17, i32 18, i32 19, i32 20>
  %2 = ashr <4 x i32> %1, <i32 25, i32 26, i32 27, i32 28>
  ret <4 x i32> %2
}

define <4 x i32> @combine_vec_ashr_ashr3(<4 x i32> %x) {
; SSE-LABEL: combine_vec_ashr_ashr3:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrad $27, %xmm1
; SSE-NEXT:    movdqa %xmm0, %xmm2
; SSE-NEXT:    psrad $15, %xmm2
; SSE-NEXT:    pblendw {{.*#+}} xmm2 = xmm2[0,1,2,3],xmm1[4,5,6,7]
; SSE-NEXT:    psrad $31, %xmm0
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3],xmm0[4,5],xmm2[6,7]
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_ashr_ashr3:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsravd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = ashr <4 x i32> %x, <i32  1, i32  5, i32 50, i32 27>
  %2 = ashr <4 x i32> %1, <i32 33, i32 10, i32 33, i32  0>
  ret <4 x i32> %2
}

; fold (sra x, (trunc (and y, c))) -> (sra x, (and (trunc y), (trunc c))).
define <4 x i32> @combine_vec_ashr_trunc_and(<4 x i32> %x, <4 x i64> %y) {
; SSE-LABEL: combine_vec_ashr_trunc_and:
; SSE:       # %bb.0:
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,2],xmm2[0,2]
; SSE-NEXT:    andps {{.*}}(%rip), %xmm1
; SSE-NEXT:    pshuflw {{.*#+}} xmm2 = xmm1[2,3,3,3,4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm3
; SSE-NEXT:    psrad %xmm2, %xmm3
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[2,3,0,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm4 = xmm2[2,3,3,3,4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm5
; SSE-NEXT:    psrad %xmm4, %xmm5
; SSE-NEXT:    pblendw {{.*#+}} xmm5 = xmm3[0,1,2,3],xmm5[4,5,6,7]
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm1[0,1,1,1,4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm3
; SSE-NEXT:    psrad %xmm1, %xmm3
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm2[0,1,1,1,4,5,6,7]
; SSE-NEXT:    psrad %xmm1, %xmm0
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm3[0,1,2,3],xmm0[4,5,6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm5[2,3],xmm0[4,5],xmm5[6,7]
; SSE-NEXT:    retq
;
; AVX2-SLOW-LABEL: combine_vec_ashr_trunc_and:
; AVX2-SLOW:       # %bb.0:
; AVX2-SLOW-NEXT:    vpshufd {{.*#+}} ymm1 = ymm1[0,2,2,3,4,6,6,7]
; AVX2-SLOW-NEXT:    vpermq {{.*#+}} ymm1 = ymm1[0,2,2,3]
; AVX2-SLOW-NEXT:    vpand {{.*}}(%rip), %xmm1, %xmm1
; AVX2-SLOW-NEXT:    vpsravd %xmm1, %xmm0, %xmm0
; AVX2-SLOW-NEXT:    vzeroupper
; AVX2-SLOW-NEXT:    retq
;
; AVX2-FAST-LABEL: combine_vec_ashr_trunc_and:
; AVX2-FAST:       # %bb.0:
; AVX2-FAST-NEXT:    vmovdqa {{.*#+}} ymm2 = [0,2,4,6,4,6,6,7]
; AVX2-FAST-NEXT:    vpermd %ymm1, %ymm2, %ymm1
; AVX2-FAST-NEXT:    vpand {{.*}}(%rip), %xmm1, %xmm1
; AVX2-FAST-NEXT:    vpsravd %xmm1, %xmm0, %xmm0
; AVX2-FAST-NEXT:    vzeroupper
; AVX2-FAST-NEXT:    retq
  %1 = and <4 x i64> %y, <i64 15, i64 255, i64 4095, i64 65535>
  %2 = trunc <4 x i64> %1 to <4 x i32>
  %3 = ashr <4 x i32> %x, %2
  ret <4 x i32> %3
}

; fold (sra (trunc (srl x, c1)), c2) -> (trunc (sra x, c1 + c2))
;      if c1 is equal to the number of bits the trunc removes
define <4 x i32> @combine_vec_ashr_trunc_lshr(<4 x i64> %x) {
; SSE-LABEL: combine_vec_ashr_trunc_lshr:
; SSE:       # %bb.0:
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,3],xmm1[1,3]
; SSE-NEXT:    movaps %xmm0, %xmm2
; SSE-NEXT:    movaps %xmm0, %xmm1
; SSE-NEXT:    psrad $2, %xmm1
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; SSE-NEXT:    psrad $3, %xmm0
; SSE-NEXT:    psrad $1, %xmm2
; SSE-NEXT:    pblendw {{.*#+}} xmm2 = xmm2[0,1,2,3],xmm0[4,5,6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX2-SLOW-LABEL: combine_vec_ashr_trunc_lshr:
; AVX2-SLOW:       # %bb.0:
; AVX2-SLOW-NEXT:    vpsrlq $32, %ymm0, %ymm0
; AVX2-SLOW-NEXT:    vpshufd {{.*#+}} ymm0 = ymm0[0,2,2,3,4,6,6,7]
; AVX2-SLOW-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; AVX2-SLOW-NEXT:    vpsravd {{.*}}(%rip), %xmm0, %xmm0
; AVX2-SLOW-NEXT:    vzeroupper
; AVX2-SLOW-NEXT:    retq
;
; AVX2-FAST-LABEL: combine_vec_ashr_trunc_lshr:
; AVX2-FAST:       # %bb.0:
; AVX2-FAST-NEXT:    vpsrlq $32, %ymm0, %ymm0
; AVX2-FAST-NEXT:    vmovdqa {{.*#+}} ymm1 = [0,2,4,6,4,6,6,7]
; AVX2-FAST-NEXT:    vpermd %ymm0, %ymm1, %ymm0
; AVX2-FAST-NEXT:    vpsravd {{.*}}(%rip), %xmm0, %xmm0
; AVX2-FAST-NEXT:    vzeroupper
; AVX2-FAST-NEXT:    retq
  %1 = lshr <4 x i64> %x, <i64 32, i64 32, i64 32, i64 32>
  %2 = trunc <4 x i64> %1 to <4 x i32>
  %3 = ashr <4 x i32> %2, <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i32> %3
}

; fold (sra (trunc (sra x, c1)), c2) -> (trunc (sra x, c1 + c2))
;      if c1 is equal to the number of bits the trunc removes
define <4 x i32> @combine_vec_ashr_trunc_ashr(<4 x i64> %x) {
; SSE-LABEL: combine_vec_ashr_trunc_ashr:
; SSE:       # %bb.0:
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,3],xmm1[1,3]
; SSE-NEXT:    movaps %xmm0, %xmm2
; SSE-NEXT:    movaps %xmm0, %xmm1
; SSE-NEXT:    psrad $2, %xmm1
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; SSE-NEXT:    psrad $3, %xmm0
; SSE-NEXT:    psrad $1, %xmm2
; SSE-NEXT:    pblendw {{.*#+}} xmm2 = xmm2[0,1,2,3],xmm0[4,5,6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX2-SLOW-LABEL: combine_vec_ashr_trunc_ashr:
; AVX2-SLOW:       # %bb.0:
; AVX2-SLOW-NEXT:    vpshufd {{.*#+}} ymm0 = ymm0[1,3,2,3,5,7,6,7]
; AVX2-SLOW-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; AVX2-SLOW-NEXT:    vpsravd {{.*}}(%rip), %xmm0, %xmm0
; AVX2-SLOW-NEXT:    vzeroupper
; AVX2-SLOW-NEXT:    retq
;
; AVX2-FAST-LABEL: combine_vec_ashr_trunc_ashr:
; AVX2-FAST:       # %bb.0:
; AVX2-FAST-NEXT:    vmovdqa {{.*#+}} ymm1 = [1,3,5,7,5,7,6,7]
; AVX2-FAST-NEXT:    vpermd %ymm0, %ymm1, %ymm0
; AVX2-FAST-NEXT:    vpsravd {{.*}}(%rip), %xmm0, %xmm0
; AVX2-FAST-NEXT:    vzeroupper
; AVX2-FAST-NEXT:    retq
  %1 = ashr <4 x i64> %x, <i64 32, i64 32, i64 32, i64 32>
  %2 = trunc <4 x i64> %1 to <4 x i32>
  %3 = ashr <4 x i32> %2, <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i32> %3
}

; If the sign bit is known to be zero, switch this to a SRL.
define <4 x i32> @combine_vec_ashr_positive(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_ashr_positive:
; SSE:       # %bb.0:
; SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE-NEXT:    pshuflw {{.*#+}} xmm2 = xmm1[2,3,3,3,4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm3
; SSE-NEXT:    psrld %xmm2, %xmm3
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[2,3,0,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm4 = xmm2[2,3,3,3,4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm5
; SSE-NEXT:    psrld %xmm4, %xmm5
; SSE-NEXT:    pblendw {{.*#+}} xmm5 = xmm3[0,1,2,3],xmm5[4,5,6,7]
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm1[0,1,1,1,4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm3
; SSE-NEXT:    psrld %xmm1, %xmm3
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm2[0,1,1,1,4,5,6,7]
; SSE-NEXT:    psrld %xmm1, %xmm0
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm3[0,1,2,3],xmm0[4,5,6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm5[2,3],xmm0[4,5],xmm5[6,7]
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_ashr_positive:
; AVX:       # %bb.0:
; AVX-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpsrlvd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = and <4 x i32> %x, <i32 15, i32 255, i32 4095, i32 65535>
  %2 = ashr <4 x i32> %1, %y
  ret <4 x i32> %2
}

define <4 x i32> @combine_vec_ashr_positive_splat(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_ashr_positive_splat:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_ashr_positive_splat:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = and <4 x i32> %x, <i32 1023, i32 1023, i32 1023, i32 1023>
  %2 = ashr <4 x i32> %1, <i32 10, i32 10, i32 10, i32 10>
  ret <4 x i32> %2
}
