; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX

; fold (sub x, 0) -> x
define <4 x i32> @combine_vec_sub_zero(<4 x i32> %a) {
; SSE-LABEL: combine_vec_sub_zero:
; SSE:       # BB#0:
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sub_zero:
; AVX:       # BB#0:
; AVX-NEXT:    retq
  %1 = sub <4 x i32> %a, zeroinitializer
  ret <4 x i32> %1
}

; fold (sub x, x) -> 0
define <4 x i32> @combine_vec_sub_self(<4 x i32> %a) {
; SSE-LABEL: combine_vec_sub_self:
; SSE:       # BB#0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sub_self:
; AVX:       # BB#0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = sub <4 x i32> %a, %a
  ret <4 x i32> %1
}

; fold (sub x, c) -> (add x, -c)
define <4 x i32> @combine_vec_sub_constant(<4 x i32> %x) {
; SSE-LABEL: combine_vec_sub_constant:
; SSE:       # BB#0:
; SSE-NEXT:    psubd {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sub_constant:
; AVX:       # BB#0:
; AVX-NEXT:    vpsubd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = sub <4 x i32> %x, <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i32> %1
}

; Canonicalize (sub -1, x) -> ~x, i.e. (xor x, -1)
define <4 x i32> @combine_vec_sub_negone(<4 x i32> %x) {
; SSE-LABEL: combine_vec_sub_negone:
; SSE:       # BB#0:
; SSE-NEXT:    pcmpeqd %xmm1, %xmm1
; SSE-NEXT:    pxor %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sub_negone:
; AVX:       # BB#0:
; AVX-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = sub <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, %x
  ret <4 x i32> %1
}

; fold A-(A-B) -> B
define <4 x i32> @combine_vec_sub_sub(<4 x i32> %a, <4 x i32> %b) {
; SSE-LABEL: combine_vec_sub_sub:
; SSE:       # BB#0:
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sub_sub:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = sub <4 x i32> %a, %b
  %2 = sub <4 x i32> %a, %1
  ret <4 x i32> %2
}

; fold (A+B)-A -> B
define <4 x i32> @combine_vec_sub_add0(<4 x i32> %a, <4 x i32> %b) {
; SSE-LABEL: combine_vec_sub_add0:
; SSE:       # BB#0:
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sub_add0:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = add <4 x i32> %a, %b
  %2 = sub <4 x i32> %1, %a
  ret <4 x i32> %2
}

; fold (A+B)-B -> A
define <4 x i32> @combine_vec_sub_add1(<4 x i32> %a, <4 x i32> %b) {
; SSE-LABEL: combine_vec_sub_add1:
; SSE:       # BB#0:
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sub_add1:
; AVX:       # BB#0:
; AVX-NEXT:    retq
  %1 = add <4 x i32> %a, %b
  %2 = sub <4 x i32> %1, %b
  ret <4 x i32> %2
}

; fold C2-(A+C1) -> (C2-C1)-A
define <4 x i32> @combine_vec_sub_constant_add(<4 x i32> %a) {
; SSE-LABEL: combine_vec_sub_constant_add:
; SSE:       # BB#0:
; SSE-NEXT:    paddd {{.*}}(%rip), %xmm0
; SSE-NEXT:    movdqa {{.*#+}} xmm1 = [3,2,1,0]
; SSE-NEXT:    psubd %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sub_constant_add:
; AVX:       # BB#0:
; AVX-NEXT:    vpaddd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [3,2,1,0]
; AVX-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = add <4 x i32> %a, <i32 0, i32 1, i32 2, i32 3>
  %2 = sub <4 x i32> <i32 3, i32 2, i32 1, i32 0>, %1
  ret <4 x i32> %2
}

; fold ((A+(B+C))-B) -> A+C
define <4 x i32> @combine_vec_sub_add_add(<4 x i32> %a, <4 x i32> %b, <4 x i32> %c) {
; SSE-LABEL: combine_vec_sub_add_add:
; SSE:       # BB#0:
; SSE-NEXT:    paddd %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sub_add_add:
; AVX:       # BB#0:
; AVX-NEXT:    vpaddd %xmm2, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = add <4 x i32> %b, %c
  %2 = add <4 x i32> %a, %1
  %3 = sub <4 x i32> %2, %b
  ret <4 x i32> %3
}

; fold ((A+(B-C))-B) -> A-C
define <4 x i32> @combine_vec_sub_add_sub(<4 x i32> %a, <4 x i32> %b, <4 x i32> %c) {
; SSE-LABEL: combine_vec_sub_add_sub:
; SSE:       # BB#0:
; SSE-NEXT:    psubd %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sub_add_sub:
; AVX:       # BB#0:
; AVX-NEXT:    vpsubd %xmm2, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = sub <4 x i32> %b, %c
  %2 = add <4 x i32> %a, %1
  %3 = sub <4 x i32> %2, %b
  ret <4 x i32> %3
}

; fold ((A-(B-C))-C) -> A-B
define <4 x i32> @combine_vec_sub_sub_sub(<4 x i32> %a, <4 x i32> %b, <4 x i32> %c) {
; SSE-LABEL: combine_vec_sub_sub_sub:
; SSE:       # BB#0:
; SSE-NEXT:    psubd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sub_sub_sub:
; AVX:       # BB#0:
; AVX-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = sub <4 x i32> %b, %c
  %2 = sub <4 x i32> %a, %1
  %3 = sub <4 x i32> %2, %c
  ret <4 x i32> %3
}

; fold undef-A -> undef
define <4 x i32> @combine_vec_sub_undef0(<4 x i32> %a) {
; SSE-LABEL: combine_vec_sub_undef0:
; SSE:       # BB#0:
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sub_undef0:
; AVX:       # BB#0:
; AVX-NEXT:    retq
  %1 = sub <4 x i32> undef, %a
  ret <4 x i32> %1
}

; fold A-undef -> undef
define <4 x i32> @combine_vec_sub_undef1(<4 x i32> %a) {
; SSE-LABEL: combine_vec_sub_undef1:
; SSE:       # BB#0:
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sub_undef1:
; AVX:       # BB#0:
; AVX-NEXT:    retq
  %1 = sub <4 x i32> %a, undef
  ret <4 x i32> %1
}

; sub X, (sext Y i1) -> add X, (and Y 1)
define <4 x i32> @combine_vec_add_sext(<4 x i32> %x, <4 x i1> %y) {
; SSE-LABEL: combine_vec_add_sext:
; SSE:       # BB#0:
; SSE-NEXT:    pslld $31, %xmm1
; SSE-NEXT:    psrad $31, %xmm1
; SSE-NEXT:    psubd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_add_sext:
; AVX:       # BB#0:
; AVX-NEXT:    vpslld $31, %xmm1, %xmm1
; AVX-NEXT:    vpsrad $31, %xmm1, %xmm1
; AVX-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = sext <4 x i1> %y to <4 x i32>
  %2 = sub <4 x i32> %x, %1
  ret <4 x i32> %2
}

; sub X, (sextinreg Y i1) -> add X, (and Y 1)
define <4 x i32> @combine_vec_sub_sextinreg(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_sub_sextinreg:
; SSE:       # BB#0:
; SSE-NEXT:    pslld $31, %xmm1
; SSE-NEXT:    psrad $31, %xmm1
; SSE-NEXT:    psubd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_sub_sextinreg:
; AVX:       # BB#0:
; AVX-NEXT:    vpslld $31, %xmm1, %xmm1
; AVX-NEXT:    vpsrad $31, %xmm1, %xmm1
; AVX-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = shl <4 x i32> %y, <i32 31, i32 31, i32 31, i32 31>
  %2 = ashr <4 x i32> %1, <i32 31, i32 31, i32 31, i32 31>
  %3 = sub <4 x i32> %x, %2
  ret <4 x i32> %3
}
