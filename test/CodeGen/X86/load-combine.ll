; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-unknown | FileCheck %s --check-prefix=CHECK64

; i8* p;
; (i32) p[0] | ((i32) p[1] << 8) | ((i32) p[2] << 16) | ((i32) p[3] << 24)
define i32 @load_i32_by_i8(i32* %arg) {
; CHECK-LABEL: load_i32_by_i8:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl (%eax), %eax
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: load_i32_by_i8:
; CHECK64:       # BB#0:
; CHECK64-NEXT:    movl (%rdi), %eax
; CHECK64-NEXT:    retq

  %tmp = bitcast i32* %arg to i8*
  %tmp1 = load i8, i8* %tmp, align 1
  %tmp2 = zext i8 %tmp1 to i32
  %tmp3 = getelementptr inbounds i8, i8* %tmp, i32 1
  %tmp4 = load i8, i8* %tmp3, align 1
  %tmp5 = zext i8 %tmp4 to i32
  %tmp6 = shl nuw nsw i32 %tmp5, 8
  %tmp7 = or i32 %tmp6, %tmp2
  %tmp8 = getelementptr inbounds i8, i8* %tmp, i32 2
  %tmp9 = load i8, i8* %tmp8, align 1
  %tmp10 = zext i8 %tmp9 to i32
  %tmp11 = shl nuw nsw i32 %tmp10, 16
  %tmp12 = or i32 %tmp7, %tmp11
  %tmp13 = getelementptr inbounds i8, i8* %tmp, i32 3
  %tmp14 = load i8, i8* %tmp13, align 1
  %tmp15 = zext i8 %tmp14 to i32
  %tmp16 = shl nuw nsw i32 %tmp15, 24
  %tmp17 = or i32 %tmp12, %tmp16
  ret i32 %tmp17
}

; i8* p;
; ((i32) p[0] << 24) | ((i32) p[1] << 16) | ((i32) p[2] << 8) | (i32) p[3]
define i32 @load_i32_by_i8_bswap(i32* %arg) {
; CHECK-LABEL: load_i32_by_i8_bswap:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl (%eax), %eax
; CHECK-NEXT:    bswapl %eax
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: load_i32_by_i8_bswap:
; CHECK64:       # BB#0:
; CHECK64-NEXT:    movl (%rdi), %eax
; CHECK64-NEXT:    bswapl %eax
; CHECK64-NEXT:    retq

  %tmp = bitcast i32* %arg to i8*
  %tmp1 = load i8, i8* %tmp, align 1
  %tmp2 = zext i8 %tmp1 to i32
  %tmp3 = shl nuw nsw i32 %tmp2, 24
  %tmp4 = getelementptr inbounds i8, i8* %tmp, i32 1
  %tmp5 = load i8, i8* %tmp4, align 1
  %tmp6 = zext i8 %tmp5 to i32
  %tmp7 = shl nuw nsw i32 %tmp6, 16
  %tmp8 = or i32 %tmp7, %tmp3
  %tmp9 = getelementptr inbounds i8, i8* %tmp, i32 2
  %tmp10 = load i8, i8* %tmp9, align 1
  %tmp11 = zext i8 %tmp10 to i32
  %tmp12 = shl nuw nsw i32 %tmp11, 8
  %tmp13 = or i32 %tmp8, %tmp12
  %tmp14 = getelementptr inbounds i8, i8* %tmp, i32 3
  %tmp15 = load i8, i8* %tmp14, align 1
  %tmp16 = zext i8 %tmp15 to i32
  %tmp17 = or i32 %tmp13, %tmp16
  ret i32 %tmp17
}

; i16* p;
; (i32) p[0] | ((i32) p[1] << 16)
define i32 @load_i32_by_i16(i32* %arg) {
; CHECK-LABEL: load_i32_by_i16:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl (%eax), %eax
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: load_i32_by_i16:
; CHECK64:       # BB#0:
; CHECK64-NEXT:    movl (%rdi), %eax
; CHECK64-NEXT:    retq

  %tmp = bitcast i32* %arg to i16*
  %tmp1 = load i16, i16* %tmp, align 1
  %tmp2 = zext i16 %tmp1 to i32
  %tmp3 = getelementptr inbounds i16, i16* %tmp, i32 1
  %tmp4 = load i16, i16* %tmp3, align 1
  %tmp5 = zext i16 %tmp4 to i32
  %tmp6 = shl nuw nsw i32 %tmp5, 16
  %tmp7 = or i32 %tmp6, %tmp2
  ret i32 %tmp7
}

; i16* p_16;
; i8* p_8 = (i8*) p_16;
; (i32) p_16[0] | ((i32) p[2] << 16) | ((i32) p[3] << 24)
define i32 @load_i32_by_i16_i8(i32* %arg) {
; CHECK-LABEL: load_i32_by_i16_i8:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl (%eax), %eax
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: load_i32_by_i16_i8:
; CHECK64:       # BB#0:
; CHECK64-NEXT:    movl (%rdi), %eax
; CHECK64-NEXT:    retq

  %tmp = bitcast i32* %arg to i16*
  %tmp1 = bitcast i32* %arg to i8*
  %tmp2 = load i16, i16* %tmp, align 1
  %tmp3 = zext i16 %tmp2 to i32
  %tmp4 = getelementptr inbounds i8, i8* %tmp1, i32 2
  %tmp5 = load i8, i8* %tmp4, align 1
  %tmp6 = zext i8 %tmp5 to i32
  %tmp7 = shl nuw nsw i32 %tmp6, 16
  %tmp8 = getelementptr inbounds i8, i8* %tmp1, i32 3
  %tmp9 = load i8, i8* %tmp8, align 1
  %tmp10 = zext i8 %tmp9 to i32
  %tmp11 = shl nuw nsw i32 %tmp10, 24
  %tmp12 = or i32 %tmp7, %tmp11
  %tmp13 = or i32 %tmp12, %tmp3
  ret i32 %tmp13
}


; i8* p;
; (i32) ((i16) p[0] | ((i16) p[1] << 8)) | (((i32) ((i16) p[3] | ((i16) p[4] << 8)) << 16)
define i32 @load_i32_by_i16_by_i8(i32* %arg) {
; CHECK-LABEL: load_i32_by_i16_by_i8:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl (%eax), %eax
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: load_i32_by_i16_by_i8:
; CHECK64:       # BB#0:
; CHECK64-NEXT:    movl (%rdi), %eax
; CHECK64-NEXT:    retq

  %tmp = bitcast i32* %arg to i8*
  %tmp1 = load i8, i8* %tmp, align 1
  %tmp2 = zext i8 %tmp1 to i16
  %tmp3 = getelementptr inbounds i8, i8* %tmp, i32 1
  %tmp4 = load i8, i8* %tmp3, align 1
  %tmp5 = zext i8 %tmp4 to i16
  %tmp6 = shl nuw nsw i16 %tmp5, 8
  %tmp7 = or i16 %tmp6, %tmp2
  %tmp8 = getelementptr inbounds i8, i8* %tmp, i32 2
  %tmp9 = load i8, i8* %tmp8, align 1
  %tmp10 = zext i8 %tmp9 to i16
  %tmp11 = getelementptr inbounds i8, i8* %tmp, i32 3
  %tmp12 = load i8, i8* %tmp11, align 1
  %tmp13 = zext i8 %tmp12 to i16
  %tmp14 = shl nuw nsw i16 %tmp13, 8
  %tmp15 = or i16 %tmp14, %tmp10
  %tmp16 = zext i16 %tmp7 to i32
  %tmp17 = zext i16 %tmp15 to i32
  %tmp18 = shl nuw nsw i32 %tmp17, 16
  %tmp19 = or i32 %tmp18, %tmp16
  ret i32 %tmp19
}

; i8* p;
; ((i32) (((i16) p[0] << 8) | (i16) p[1]) << 16) | (i32) (((i16) p[3] << 8) | (i16) p[4])
define i32 @load_i32_by_i16_by_i8_bswap(i32* %arg) {
; CHECK-LABEL: load_i32_by_i16_by_i8_bswap:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl (%eax), %eax
; CHECK-NEXT:    bswapl %eax
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: load_i32_by_i16_by_i8_bswap:
; CHECK64:       # BB#0:
; CHECK64-NEXT:    movl (%rdi), %eax
; CHECK64-NEXT:    bswapl %eax
; CHECK64-NEXT:    retq

  %tmp = bitcast i32* %arg to i8*
  %tmp1 = load i8, i8* %tmp, align 1
  %tmp2 = zext i8 %tmp1 to i16
  %tmp3 = getelementptr inbounds i8, i8* %tmp, i32 1
  %tmp4 = load i8, i8* %tmp3, align 1
  %tmp5 = zext i8 %tmp4 to i16
  %tmp6 = shl nuw nsw i16 %tmp2, 8
  %tmp7 = or i16 %tmp6, %tmp5
  %tmp8 = getelementptr inbounds i8, i8* %tmp, i32 2
  %tmp9 = load i8, i8* %tmp8, align 1
  %tmp10 = zext i8 %tmp9 to i16
  %tmp11 = getelementptr inbounds i8, i8* %tmp, i32 3
  %tmp12 = load i8, i8* %tmp11, align 1
  %tmp13 = zext i8 %tmp12 to i16
  %tmp14 = shl nuw nsw i16 %tmp10, 8
  %tmp15 = or i16 %tmp14, %tmp13
  %tmp16 = zext i16 %tmp7 to i32
  %tmp17 = zext i16 %tmp15 to i32
  %tmp18 = shl nuw nsw i32 %tmp16, 16
  %tmp19 = or i32 %tmp18, %tmp17
  ret i32 %tmp19
}

; i8* p;
; (i64) p[0] | ((i64) p[1] << 8) | ((i64) p[2] << 16) | ((i64) p[3] << 24) | ((i64) p[4] << 32) | ((i64) p[5] << 40) | ((i64) p[6] << 48) | ((i64) p[7] << 56)
define i64 @load_i64_by_i8(i64* %arg) {
; CHECK-LABEL: load_i64_by_i8:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl (%ecx), %eax
; CHECK-NEXT:    movl 4(%ecx), %edx
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: load_i64_by_i8:
; CHECK64:       # BB#0:
; CHECK64-NEXT:    movq (%rdi), %rax
; CHECK64-NEXT:    retq

  %tmp = bitcast i64* %arg to i8*
  %tmp1 = load i8, i8* %tmp, align 1
  %tmp2 = zext i8 %tmp1 to i64
  %tmp3 = getelementptr inbounds i8, i8* %tmp, i64 1
  %tmp4 = load i8, i8* %tmp3, align 1
  %tmp5 = zext i8 %tmp4 to i64
  %tmp6 = shl nuw nsw i64 %tmp5, 8
  %tmp7 = or i64 %tmp6, %tmp2
  %tmp8 = getelementptr inbounds i8, i8* %tmp, i64 2
  %tmp9 = load i8, i8* %tmp8, align 1
  %tmp10 = zext i8 %tmp9 to i64
  %tmp11 = shl nuw nsw i64 %tmp10, 16
  %tmp12 = or i64 %tmp7, %tmp11
  %tmp13 = getelementptr inbounds i8, i8* %tmp, i64 3
  %tmp14 = load i8, i8* %tmp13, align 1
  %tmp15 = zext i8 %tmp14 to i64
  %tmp16 = shl nuw nsw i64 %tmp15, 24
  %tmp17 = or i64 %tmp12, %tmp16
  %tmp18 = getelementptr inbounds i8, i8* %tmp, i64 4
  %tmp19 = load i8, i8* %tmp18, align 1
  %tmp20 = zext i8 %tmp19 to i64
  %tmp21 = shl nuw nsw i64 %tmp20, 32
  %tmp22 = or i64 %tmp17, %tmp21
  %tmp23 = getelementptr inbounds i8, i8* %tmp, i64 5
  %tmp24 = load i8, i8* %tmp23, align 1
  %tmp25 = zext i8 %tmp24 to i64
  %tmp26 = shl nuw nsw i64 %tmp25, 40
  %tmp27 = or i64 %tmp22, %tmp26
  %tmp28 = getelementptr inbounds i8, i8* %tmp, i64 6
  %tmp29 = load i8, i8* %tmp28, align 1
  %tmp30 = zext i8 %tmp29 to i64
  %tmp31 = shl nuw nsw i64 %tmp30, 48
  %tmp32 = or i64 %tmp27, %tmp31
  %tmp33 = getelementptr inbounds i8, i8* %tmp, i64 7
  %tmp34 = load i8, i8* %tmp33, align 1
  %tmp35 = zext i8 %tmp34 to i64
  %tmp36 = shl nuw i64 %tmp35, 56
  %tmp37 = or i64 %tmp32, %tmp36
  ret i64 %tmp37
}

; i8* p;
; ((i64) p[0] << 56) | ((i64) p[1] << 48) | ((i64) p[2] << 40) | ((i64) p[3] << 32) | ((i64) p[4] << 24) | ((i64) p[5] << 16) | ((i64) p[6] << 8) | (i64) p[7]
define i64 @load_i64_by_i8_bswap(i64* %arg) {
; CHECK-LABEL: load_i64_by_i8_bswap:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl (%eax), %edx
; CHECK-NEXT:    movl 4(%eax), %eax
; CHECK-NEXT:    bswapl %eax
; CHECK-NEXT:    bswapl %edx
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: load_i64_by_i8_bswap:
; CHECK64:       # BB#0:
; CHECK64-NEXT:    movq (%rdi), %rax
; CHECK64-NEXT:    bswapq %rax
; CHECK64-NEXT:    retq

  %tmp = bitcast i64* %arg to i8*
  %tmp1 = load i8, i8* %tmp, align 1
  %tmp2 = zext i8 %tmp1 to i64
  %tmp3 = shl nuw i64 %tmp2, 56
  %tmp4 = getelementptr inbounds i8, i8* %tmp, i64 1
  %tmp5 = load i8, i8* %tmp4, align 1
  %tmp6 = zext i8 %tmp5 to i64
  %tmp7 = shl nuw nsw i64 %tmp6, 48
  %tmp8 = or i64 %tmp7, %tmp3
  %tmp9 = getelementptr inbounds i8, i8* %tmp, i64 2
  %tmp10 = load i8, i8* %tmp9, align 1
  %tmp11 = zext i8 %tmp10 to i64
  %tmp12 = shl nuw nsw i64 %tmp11, 40
  %tmp13 = or i64 %tmp8, %tmp12
  %tmp14 = getelementptr inbounds i8, i8* %tmp, i64 3
  %tmp15 = load i8, i8* %tmp14, align 1
  %tmp16 = zext i8 %tmp15 to i64
  %tmp17 = shl nuw nsw i64 %tmp16, 32
  %tmp18 = or i64 %tmp13, %tmp17
  %tmp19 = getelementptr inbounds i8, i8* %tmp, i64 4
  %tmp20 = load i8, i8* %tmp19, align 1
  %tmp21 = zext i8 %tmp20 to i64
  %tmp22 = shl nuw nsw i64 %tmp21, 24
  %tmp23 = or i64 %tmp18, %tmp22
  %tmp24 = getelementptr inbounds i8, i8* %tmp, i64 5
  %tmp25 = load i8, i8* %tmp24, align 1
  %tmp26 = zext i8 %tmp25 to i64
  %tmp27 = shl nuw nsw i64 %tmp26, 16
  %tmp28 = or i64 %tmp23, %tmp27
  %tmp29 = getelementptr inbounds i8, i8* %tmp, i64 6
  %tmp30 = load i8, i8* %tmp29, align 1
  %tmp31 = zext i8 %tmp30 to i64
  %tmp32 = shl nuw nsw i64 %tmp31, 8
  %tmp33 = or i64 %tmp28, %tmp32
  %tmp34 = getelementptr inbounds i8, i8* %tmp, i64 7
  %tmp35 = load i8, i8* %tmp34, align 1
  %tmp36 = zext i8 %tmp35 to i64
  %tmp37 = or i64 %tmp33, %tmp36
  ret i64 %tmp37
}

; Part of the load by bytes pattern is used outside of the pattern
; i8* p;
; i32 x = (i32) p[1]
; res = ((i32) p[0] << 24) | (x << 16) | ((i32) p[2] << 8) | (i32) p[3]
; x | res
define i32 @load_i32_by_i8_bswap_uses(i32* %arg) {
; CHECK-LABEL: load_i32_by_i8_bswap_uses:
; CHECK:       # BB#0:
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:  .Lcfi0:
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .Lcfi1:
; CHECK-NEXT:    .cfi_offset %esi, -8
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movzbl (%eax), %ecx
; CHECK-NEXT:    shll $24, %ecx
; CHECK-NEXT:    movzbl 1(%eax), %edx
; CHECK-NEXT:    movl %edx, %esi
; CHECK-NEXT:    shll $16, %esi
; CHECK-NEXT:    orl %ecx, %esi
; CHECK-NEXT:    movzbl 2(%eax), %ecx
; CHECK-NEXT:    shll $8, %ecx
; CHECK-NEXT:    orl %esi, %ecx
; CHECK-NEXT:    movzbl 3(%eax), %eax
; CHECK-NEXT:    orl %ecx, %eax
; CHECK-NEXT:    orl %edx, %eax
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: load_i32_by_i8_bswap_uses:
; CHECK64:       # BB#0:
; CHECK64-NEXT:    movzbl (%rdi), %eax
; CHECK64-NEXT:    shll $24, %eax
; CHECK64-NEXT:    movzbl 1(%rdi), %ecx
; CHECK64-NEXT:    movl %ecx, %edx
; CHECK64-NEXT:    shll $16, %edx
; CHECK64-NEXT:    orl %eax, %edx
; CHECK64-NEXT:    movzbl 2(%rdi), %esi
; CHECK64-NEXT:    shll $8, %esi
; CHECK64-NEXT:    orl %edx, %esi
; CHECK64-NEXT:    movzbl 3(%rdi), %eax
; CHECK64-NEXT:    orl %esi, %eax
; CHECK64-NEXT:    orl %ecx, %eax
; CHECK64-NEXT:    retq

  %tmp = bitcast i32* %arg to i8*
  %tmp1 = load i8, i8* %tmp, align 1
  %tmp2 = zext i8 %tmp1 to i32
  %tmp3 = shl nuw nsw i32 %tmp2, 24
  %tmp4 = getelementptr inbounds i8, i8* %tmp, i32 1
  %tmp5 = load i8, i8* %tmp4, align 1
  %tmp6 = zext i8 %tmp5 to i32
  %tmp7 = shl nuw nsw i32 %tmp6, 16
  %tmp8 = or i32 %tmp7, %tmp3
  %tmp9 = getelementptr inbounds i8, i8* %tmp, i32 2
  %tmp10 = load i8, i8* %tmp9, align 1
  %tmp11 = zext i8 %tmp10 to i32
  %tmp12 = shl nuw nsw i32 %tmp11, 8
  %tmp13 = or i32 %tmp8, %tmp12
  %tmp14 = getelementptr inbounds i8, i8* %tmp, i32 3
  %tmp15 = load i8, i8* %tmp14, align 1
  %tmp16 = zext i8 %tmp15 to i32
  %tmp17 = or i32 %tmp13, %tmp16
  ; Use individual part of the pattern outside of the pattern
  %tmp18 = or i32 %tmp6, %tmp17
  ret i32 %tmp18
}

; One of the loads is volatile
; i8* p;
; p0 = volatile *p;
; ((i32) p0 << 24) | ((i32) p[1] << 16) | ((i32) p[2] << 8) | (i32) p[3]
define i32 @load_i32_by_i8_bswap_volatile(i32* %arg) {
; CHECK-LABEL: load_i32_by_i8_bswap_volatile:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movzbl (%eax), %ecx
; CHECK-NEXT:    shll $24, %ecx
; CHECK-NEXT:    movzbl 1(%eax), %edx
; CHECK-NEXT:    shll $16, %edx
; CHECK-NEXT:    orl %ecx, %edx
; CHECK-NEXT:    movzbl 2(%eax), %ecx
; CHECK-NEXT:    shll $8, %ecx
; CHECK-NEXT:    orl %edx, %ecx
; CHECK-NEXT:    movzbl 3(%eax), %eax
; CHECK-NEXT:    orl %ecx, %eax
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: load_i32_by_i8_bswap_volatile:
; CHECK64:       # BB#0:
; CHECK64-NEXT:    movzbl (%rdi), %eax
; CHECK64-NEXT:    shll $24, %eax
; CHECK64-NEXT:    movzbl 1(%rdi), %ecx
; CHECK64-NEXT:    shll $16, %ecx
; CHECK64-NEXT:    orl %eax, %ecx
; CHECK64-NEXT:    movzbl 2(%rdi), %edx
; CHECK64-NEXT:    shll $8, %edx
; CHECK64-NEXT:    orl %ecx, %edx
; CHECK64-NEXT:    movzbl 3(%rdi), %eax
; CHECK64-NEXT:    orl %edx, %eax
; CHECK64-NEXT:    retq

  %tmp = bitcast i32* %arg to i8*
  %tmp1 = load volatile i8, i8* %tmp, align 1
  %tmp2 = zext i8 %tmp1 to i32
  %tmp3 = shl nuw nsw i32 %tmp2, 24
  %tmp4 = getelementptr inbounds i8, i8* %tmp, i32 1
  %tmp5 = load i8, i8* %tmp4, align 1
  %tmp6 = zext i8 %tmp5 to i32
  %tmp7 = shl nuw nsw i32 %tmp6, 16
  %tmp8 = or i32 %tmp7, %tmp3
  %tmp9 = getelementptr inbounds i8, i8* %tmp, i32 2
  %tmp10 = load i8, i8* %tmp9, align 1
  %tmp11 = zext i8 %tmp10 to i32
  %tmp12 = shl nuw nsw i32 %tmp11, 8
  %tmp13 = or i32 %tmp8, %tmp12
  %tmp14 = getelementptr inbounds i8, i8* %tmp, i32 3
  %tmp15 = load i8, i8* %tmp14, align 1
  %tmp16 = zext i8 %tmp15 to i32
  %tmp17 = or i32 %tmp13, %tmp16
  ret i32 %tmp17
}

; There is a store in between individual loads
; i8* p, q;
; res1 = ((i32) p[0] << 24) | ((i32) p[1] << 16)
; *q = 0;
; res2 = ((i32) p[2] << 8) | (i32) p[3]
; res1 | res2
define i32 @load_i32_by_i8_bswap_store_in_between(i32* %arg, i32* %arg1) {
; CHECK-LABEL: load_i32_by_i8_bswap_store_in_between:
; CHECK:       # BB#0:
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:  .Lcfi2:
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .Lcfi3:
; CHECK-NEXT:    .cfi_offset %esi, -8
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movzbl (%ecx), %edx
; CHECK-NEXT:    shll $24, %edx
; CHECK-NEXT:    movzbl 1(%ecx), %esi
; CHECK-NEXT:    movl $0, (%eax)
; CHECK-NEXT:    shll $16, %esi
; CHECK-NEXT:    orl %edx, %esi
; CHECK-NEXT:    movzbl 2(%ecx), %edx
; CHECK-NEXT:    shll $8, %edx
; CHECK-NEXT:    orl %esi, %edx
; CHECK-NEXT:    movzbl 3(%ecx), %eax
; CHECK-NEXT:    orl %edx, %eax
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: load_i32_by_i8_bswap_store_in_between:
; CHECK64:       # BB#0:
; CHECK64-NEXT:    movzbl (%rdi), %eax
; CHECK64-NEXT:    shll $24, %eax
; CHECK64-NEXT:    movzbl 1(%rdi), %ecx
; CHECK64-NEXT:    movl $0, (%rsi)
; CHECK64-NEXT:    shll $16, %ecx
; CHECK64-NEXT:    orl %eax, %ecx
; CHECK64-NEXT:    movzbl 2(%rdi), %edx
; CHECK64-NEXT:    shll $8, %edx
; CHECK64-NEXT:    orl %ecx, %edx
; CHECK64-NEXT:    movzbl 3(%rdi), %eax
; CHECK64-NEXT:    orl %edx, %eax
; CHECK64-NEXT:    retq

  %tmp = bitcast i32* %arg to i8*
  %tmp2 = load i8, i8* %tmp, align 1
  %tmp3 = zext i8 %tmp2 to i32
  %tmp4 = shl nuw nsw i32 %tmp3, 24
  %tmp5 = getelementptr inbounds i8, i8* %tmp, i32 1
  %tmp6 = load i8, i8* %tmp5, align 1
  ; This store will prevent folding of the pattern
  store i32 0, i32* %arg1
  %tmp7 = zext i8 %tmp6 to i32
  %tmp8 = shl nuw nsw i32 %tmp7, 16
  %tmp9 = or i32 %tmp8, %tmp4
  %tmp10 = getelementptr inbounds i8, i8* %tmp, i32 2
  %tmp11 = load i8, i8* %tmp10, align 1
  %tmp12 = zext i8 %tmp11 to i32
  %tmp13 = shl nuw nsw i32 %tmp12, 8
  %tmp14 = or i32 %tmp9, %tmp13
  %tmp15 = getelementptr inbounds i8, i8* %tmp, i32 3
  %tmp16 = load i8, i8* %tmp15, align 1
  %tmp17 = zext i8 %tmp16 to i32
  %tmp18 = or i32 %tmp14, %tmp17
  ret i32 %tmp18
}

; One of the loads is from an unrelated location
; i8* p, q;
; ((i32) p[0] << 24) | ((i32) q[1] << 16) | ((i32) p[2] << 8) | (i32) p[3]
define i32 @load_i32_by_i8_bswap_unrelated_load(i32* %arg, i32* %arg1) {
; CHECK-LABEL: load_i32_by_i8_bswap_unrelated_load:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movzbl (%ecx), %edx
; CHECK-NEXT:    shll $24, %edx
; CHECK-NEXT:    movzbl 1(%eax), %eax
; CHECK-NEXT:    shll $16, %eax
; CHECK-NEXT:    orl %edx, %eax
; CHECK-NEXT:    movzbl 2(%ecx), %edx
; CHECK-NEXT:    shll $8, %edx
; CHECK-NEXT:    orl %eax, %edx
; CHECK-NEXT:    movzbl 3(%ecx), %eax
; CHECK-NEXT:    orl %edx, %eax
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: load_i32_by_i8_bswap_unrelated_load:
; CHECK64:       # BB#0:
; CHECK64-NEXT:    movzbl (%rdi), %eax
; CHECK64-NEXT:    shll $24, %eax
; CHECK64-NEXT:    movzbl 1(%rsi), %ecx
; CHECK64-NEXT:    shll $16, %ecx
; CHECK64-NEXT:    orl %eax, %ecx
; CHECK64-NEXT:    movzbl 2(%rdi), %edx
; CHECK64-NEXT:    shll $8, %edx
; CHECK64-NEXT:    orl %ecx, %edx
; CHECK64-NEXT:    movzbl 3(%rdi), %eax
; CHECK64-NEXT:    orl %edx, %eax
; CHECK64-NEXT:    retq

  %tmp = bitcast i32* %arg to i8*
  %tmp2 = bitcast i32* %arg1 to i8*
  %tmp3 = load i8, i8* %tmp, align 1
  %tmp4 = zext i8 %tmp3 to i32
  %tmp5 = shl nuw nsw i32 %tmp4, 24
  ; Load from an unrelated address
  %tmp6 = getelementptr inbounds i8, i8* %tmp2, i32 1
  %tmp7 = load i8, i8* %tmp6, align 1
  %tmp8 = zext i8 %tmp7 to i32
  %tmp9 = shl nuw nsw i32 %tmp8, 16
  %tmp10 = or i32 %tmp9, %tmp5
  %tmp11 = getelementptr inbounds i8, i8* %tmp, i32 2
  %tmp12 = load i8, i8* %tmp11, align 1
  %tmp13 = zext i8 %tmp12 to i32
  %tmp14 = shl nuw nsw i32 %tmp13, 8
  %tmp15 = or i32 %tmp10, %tmp14
  %tmp16 = getelementptr inbounds i8, i8* %tmp, i32 3
  %tmp17 = load i8, i8* %tmp16, align 1
  %tmp18 = zext i8 %tmp17 to i32
  %tmp19 = or i32 %tmp15, %tmp18
  ret i32 %tmp19
}

; Non-zero offsets are not supported for now
; i8* p;
; (i32) p[1] | ((i32) p[2] << 8) | ((i32) p[3] << 16) | ((i32) p[4] << 24)
define i32 @load_i32_by_i8_unsupported_offset(i32* %arg) {
; CHECK-LABEL: load_i32_by_i8_unsupported_offset:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movzbl 1(%eax), %ecx
; CHECK-NEXT:    movzbl 2(%eax), %edx
; CHECK-NEXT:    shll $8, %edx
; CHECK-NEXT:    orl %ecx, %edx
; CHECK-NEXT:    movzbl 3(%eax), %ecx
; CHECK-NEXT:    shll $16, %ecx
; CHECK-NEXT:    orl %edx, %ecx
; CHECK-NEXT:    movzbl 4(%eax), %eax
; CHECK-NEXT:    shll $24, %eax
; CHECK-NEXT:    orl %ecx, %eax
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: load_i32_by_i8_unsupported_offset:
; CHECK64:       # BB#0:
; CHECK64-NEXT:    movzbl 1(%rdi), %eax
; CHECK64-NEXT:    movzbl 2(%rdi), %ecx
; CHECK64-NEXT:    shll $8, %ecx
; CHECK64-NEXT:    orl %eax, %ecx
; CHECK64-NEXT:    movzbl 3(%rdi), %edx
; CHECK64-NEXT:    shll $16, %edx
; CHECK64-NEXT:    orl %ecx, %edx
; CHECK64-NEXT:    movzbl 4(%rdi), %eax
; CHECK64-NEXT:    shll $24, %eax
; CHECK64-NEXT:    orl %edx, %eax
; CHECK64-NEXT:    retq

  %tmp = bitcast i32* %arg to i8*
  %tmp1 = getelementptr inbounds i8, i8* %tmp, i32 1
  %tmp2 = load i8, i8* %tmp1, align 1
  %tmp3 = zext i8 %tmp2 to i32
  %tmp4 = getelementptr inbounds i8, i8* %tmp, i32 2
  %tmp5 = load i8, i8* %tmp4, align 1
  %tmp6 = zext i8 %tmp5 to i32
  %tmp7 = shl nuw nsw i32 %tmp6, 8
  %tmp8 = or i32 %tmp7, %tmp3
  %tmp9 = getelementptr inbounds i8, i8* %tmp, i32 3
  %tmp10 = load i8, i8* %tmp9, align 1
  %tmp11 = zext i8 %tmp10 to i32
  %tmp12 = shl nuw nsw i32 %tmp11, 16
  %tmp13 = or i32 %tmp8, %tmp12
  %tmp14 = getelementptr inbounds i8, i8* %tmp, i32 4
  %tmp15 = load i8, i8* %tmp14, align 1
  %tmp16 = zext i8 %tmp15 to i32
  %tmp17 = shl nuw nsw i32 %tmp16, 24
  %tmp18 = or i32 %tmp13, %tmp17
  ret i32 %tmp18
}

; i8* p; i32 i;
; ((i32) p[i] << 24) | ((i32) p[i + 1] << 16) | ((i32) p[i + 2] << 8) | (i32) p[i + 3]
define i32 @load_i32_by_i8_bswap_base_index_offset(i32* %arg, i32 %arg1) {
; CHECK-LABEL: load_i32_by_i8_bswap_base_index_offset:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl (%ecx,%eax), %eax
; CHECK-NEXT:    bswapl %eax
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: load_i32_by_i8_bswap_base_index_offset:
; CHECK64:       # BB#0:
; CHECK64-NEXT:    movslq %esi, %rax
; CHECK64-NEXT:    movzbl (%rdi,%rax), %ecx
; CHECK64-NEXT:    shll $24, %ecx
; CHECK64-NEXT:    movzbl 1(%rdi,%rax), %edx
; CHECK64-NEXT:    shll $16, %edx
; CHECK64-NEXT:    orl %ecx, %edx
; CHECK64-NEXT:    movzbl 2(%rdi,%rax), %ecx
; CHECK64-NEXT:    shll $8, %ecx
; CHECK64-NEXT:    orl %edx, %ecx
; CHECK64-NEXT:    movzbl 3(%rdi,%rax), %eax
; CHECK64-NEXT:    orl %ecx, %eax
; CHECK64-NEXT:    retq
; TODO: Currently we don't fold the pattern for x86-64 target because we don't
; see that the loads are adjacent. It happens because BaseIndexOffset doesn't
; look through zexts.

  %tmp = bitcast i32* %arg to i8*
  %tmp2 = getelementptr inbounds i8, i8* %tmp, i32 %arg1
  %tmp3 = load i8, i8* %tmp2, align 1
  %tmp4 = zext i8 %tmp3 to i32
  %tmp5 = shl nuw nsw i32 %tmp4, 24
  %tmp6 = add nuw nsw i32 %arg1, 1
  %tmp7 = getelementptr inbounds i8, i8* %tmp, i32 %tmp6
  %tmp8 = load i8, i8* %tmp7, align 1
  %tmp9 = zext i8 %tmp8 to i32
  %tmp10 = shl nuw nsw i32 %tmp9, 16
  %tmp11 = or i32 %tmp10, %tmp5
  %tmp12 = add nuw nsw i32 %arg1, 2
  %tmp13 = getelementptr inbounds i8, i8* %tmp, i32 %tmp12
  %tmp14 = load i8, i8* %tmp13, align 1
  %tmp15 = zext i8 %tmp14 to i32
  %tmp16 = shl nuw nsw i32 %tmp15, 8
  %tmp17 = or i32 %tmp11, %tmp16
  %tmp18 = add nuw nsw i32 %arg1, 3
  %tmp19 = getelementptr inbounds i8, i8* %tmp, i32 %tmp18
  %tmp20 = load i8, i8* %tmp19, align 1
  %tmp21 = zext i8 %tmp20 to i32
  %tmp22 = or i32 %tmp17, %tmp21
  ret i32 %tmp22
}

; Verify that we don't crash handling shl i32 %conv57, 32
define void @shift_i32_by_32(i8* %src1, i8* %src2, i64* %dst) {
; CHECK-LABEL: shift_i32_by_32:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl $-1, 4(%eax)
; CHECK-NEXT:    movl $-1, (%eax)
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: shift_i32_by_32:
; CHECK64:       # BB#0: # %entry
; CHECK64-NEXT:    movq $-1, (%rdx)
; CHECK64-NEXT:    retq
entry:
  %load1 = load i8, i8* %src1, align 1
  %conv46 = zext i8 %load1 to i32
  %shl47 = shl i32 %conv46, 56
  %or55 = or i32 %shl47, 0
  %load2 = load i8, i8* %src2, align 1
  %conv57 = zext i8 %load2 to i32
  %shl58 = shl i32 %conv57, 32
  %or59 = or i32 %or55, %shl58
  %or74 = or i32 %or59, 0
  %conv75 = sext i32 %or74 to i64
  store i64 %conv75, i64* %dst, align 8
  ret void
}
