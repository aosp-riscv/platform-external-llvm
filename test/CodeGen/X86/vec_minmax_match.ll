; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s

; These are actually tests of ValueTracking, and so may have test coverage in InstCombine or other
; IR opt passes, but ValueTracking also affects the backend via SelectionDAGBuilder::visitSelect().

define <4 x i32> @smin_vec1(<4 x i32> %x) {
; CHECK-LABEL: smin_vec1:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpminsd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
;
  %not_x = xor <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %cmp = icmp sgt <4 x i32> %x, zeroinitializer
  %sel = select <4 x i1> %cmp, <4 x i32> %not_x, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %sel
}

define <4 x i32> @smin_vec2(<4 x i32> %x) {
; CHECK-LABEL: smin_vec2:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpminsd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
;
  %not_x = xor <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %cmp = icmp slt <4 x i32> %x, zeroinitializer
  %sel = select <4 x i1> %cmp, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> %not_x
  ret <4 x i32> %sel
}

define <4 x i32> @smax_vec1(<4 x i32> %x) {
; CHECK-LABEL: smax_vec1:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
;
  %not_x = xor <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %cmp = icmp slt <4 x i32> %x, zeroinitializer
  %sel = select <4 x i1> %cmp, <4 x i32> %not_x, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %sel
}

define <4 x i32> @smax_vec2(<4 x i32> %x) {
; CHECK-LABEL: smax_vec2:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
;
  %not_x = xor <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %cmp = icmp sgt <4 x i32> %x, zeroinitializer
  %sel = select <4 x i1> %cmp, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> %not_x
  ret <4 x i32> %sel
}

; FIXME: These are unsigned min/max ops.

define <4 x i32> @umax_vec1(<4 x i32> %x) {
; CHECK-LABEL: umax_vec1:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpcmpgtd %xmm0, %xmm1, %xmm1
; CHECK-NEXT:    vmovaps {{.*#+}} xmm2 = [2147483647,2147483647,2147483647,2147483647]
; CHECK-NEXT:    vblendvps %xmm1, %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    retq
;
  %cmp = icmp slt <4 x i32> %x, zeroinitializer
  %sel = select <4 x i1> %cmp, <4 x i32> %x, <4 x i32> <i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647>
  ret <4 x i32> %sel
}

define <4 x i32> @umax_vec2(<4 x i32> %x) {
; CHECK-LABEL: umax_vec2:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpcmpgtd %xmm1, %xmm0, %xmm1
; CHECK-NEXT:    vblendvps %xmm1, {{.*}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    retq
;
  %cmp = icmp sgt <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %sel = select <4 x i1> %cmp, <4 x i32> <i32 2147483648, i32 2147483648, i32 2147483648, i32 2147483648>, <4 x i32> %x
  ret <4 x i32> %sel
}

define <4 x i32> @umin_vec1(<4 x i32> %x) {
; CHECK-LABEL: umin_vec1:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpcmpgtd %xmm0, %xmm1, %xmm1
; CHECK-NEXT:    vblendvps %xmm1, {{.*}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    retq
;
  %cmp = icmp slt <4 x i32> %x, zeroinitializer
  %sel = select <4 x i1> %cmp, <4 x i32> <i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647>, <4 x i32> %x
  ret <4 x i32> %sel
}

define <4 x i32> @umin_vec2(<4 x i32> %x) {
; CHECK-LABEL: umin_vec2:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpcmpgtd %xmm1, %xmm0, %xmm1
; CHECK-NEXT:    vmovaps {{.*#+}} xmm2 = [2147483648,2147483648,2147483648,2147483648]
; CHECK-NEXT:    vblendvps %xmm1, %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    retq
;
  %cmp = icmp sgt <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %sel = select <4 x i1> %cmp, <4 x i32> %x, <4 x i32> <i32 2147483648, i32 2147483648, i32 2147483648, i32 2147483648>
  ret <4 x i32> %sel
}

