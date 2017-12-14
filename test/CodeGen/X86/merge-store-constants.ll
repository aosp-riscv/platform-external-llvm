; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown   -mattr=avx | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx | FileCheck %s --check-prefix=X64

define void @big_nonzero_16_bytes(i32* nocapture %a) {
; X32-LABEL: big_nonzero_16_bytes:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vmovaps {{.*#+}} xmm0 = [1,2,3,4]
; X32-NEXT:    vmovups %xmm0, (%eax)
; X32-NEXT:    retl
;
; X64-LABEL: big_nonzero_16_bytes:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps {{.*#+}} xmm0 = [1,2,3,4]
; X64-NEXT:    vmovups %xmm0, (%rdi)
; X64-NEXT:    retq
  %arrayidx1 = getelementptr inbounds i32, i32* %a, i64 1
  %arrayidx2 = getelementptr inbounds i32, i32* %a, i64 2
  %arrayidx3 = getelementptr inbounds i32, i32* %a, i64 3

  store i32 1, i32* %a, align 4
  store i32 2, i32* %arrayidx1, align 4
  store i32 3, i32* %arrayidx2, align 4
  store i32 4, i32* %arrayidx3, align 4
  ret void
}

; TODO: We assumed that two 64-bit stores were better than 1 vector load and 1 vector store.
; But if the 64-bit constants can't be represented as sign-extended 32-bit constants, then
; it takes extra instructions to do this in scalar.

define void @big_nonzero_16_bytes_big64bit_constants(i64* nocapture %a) {
; X32-LABEL: big_nonzero_16_bytes_big64bit_constants:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vmovaps {{.*#+}} xmm0 = [1,1,1,3]
; X32-NEXT:    vmovups %xmm0, (%eax)
; X32-NEXT:    retl
;
; X64-LABEL: big_nonzero_16_bytes_big64bit_constants:
; X64:       # %bb.0:
; X64-NEXT:    movabsq $4294967297, %rax # imm = 0x100000001
; X64-NEXT:    movq %rax, (%rdi)
; X64-NEXT:    movabsq $12884901889, %rax # imm = 0x300000001
; X64-NEXT:    movq %rax, 8(%rdi)
; X64-NEXT:    retq
  %arrayidx1 = getelementptr inbounds i64, i64* %a, i64 1

  store i64 4294967297, i64* %a
  store i64 12884901889, i64* %arrayidx1
  ret void
}

; Splats may be an opportunity to use a broadcast op.

define void @big_nonzero_32_bytes_splat(i32* nocapture %a) {
; X32-LABEL: big_nonzero_32_bytes_splat:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vmovaps {{.*#+}} ymm0 = [42,42,42,42,42,42,42,42]
; X32-NEXT:    vmovups %ymm0, (%eax)
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: big_nonzero_32_bytes_splat:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps {{.*#+}} ymm0 = [42,42,42,42,42,42,42,42]
; X64-NEXT:    vmovups %ymm0, (%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %arrayidx1 = getelementptr inbounds i32, i32* %a, i64 1
  %arrayidx2 = getelementptr inbounds i32, i32* %a, i64 2
  %arrayidx3 = getelementptr inbounds i32, i32* %a, i64 3
  %arrayidx4 = getelementptr inbounds i32, i32* %a, i64 4
  %arrayidx5 = getelementptr inbounds i32, i32* %a, i64 5
  %arrayidx6 = getelementptr inbounds i32, i32* %a, i64 6
  %arrayidx7 = getelementptr inbounds i32, i32* %a, i64 7

  store i32 42, i32* %a, align 4
  store i32 42, i32* %arrayidx1, align 4
  store i32 42, i32* %arrayidx2, align 4
  store i32 42, i32* %arrayidx3, align 4
  store i32 42, i32* %arrayidx4, align 4
  store i32 42, i32* %arrayidx5, align 4
  store i32 42, i32* %arrayidx6, align 4
  store i32 42, i32* %arrayidx7, align 4
  ret void
}

; Verify that we choose the best-sized store(s) for each chunk.

define void @big_nonzero_63_bytes(i8* nocapture %a) {
; X32-LABEL: big_nonzero_63_bytes:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vmovaps {{.*#+}} ymm0 = [1,0,2,0,3,0,4,0]
; X32-NEXT:    vmovups %ymm0, (%eax)
; X32-NEXT:    vmovaps {{.*#+}} xmm0 = [5,0,6,0]
; X32-NEXT:    vmovups %xmm0, 32(%eax)
; X32-NEXT:    movl $0, 52(%eax)
; X32-NEXT:    movl $7, 48(%eax)
; X32-NEXT:    movl $8, 56(%eax)
; X32-NEXT:    movw $9, 60(%eax)
; X32-NEXT:    movb $10, 62(%eax)
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: big_nonzero_63_bytes:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps {{.*#+}} ymm0 = [1,2,3,4]
; X64-NEXT:    vmovups %ymm0, (%rdi)
; X64-NEXT:    movq $5, 32(%rdi)
; X64-NEXT:    movq $6, 40(%rdi)
; X64-NEXT:    movq $7, 48(%rdi)
; X64-NEXT:    movl $8, 56(%rdi)
; X64-NEXT:    movw $9, 60(%rdi)
; X64-NEXT:    movb $10, 62(%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %a8 = bitcast i8* %a to i64*
  %arrayidx8 = getelementptr inbounds i64, i64* %a8, i64 1
  %arrayidx16 = getelementptr inbounds i64, i64* %a8, i64 2
  %arrayidx24 = getelementptr inbounds i64, i64* %a8, i64 3
  %arrayidx32 = getelementptr inbounds i64, i64* %a8, i64 4
  %arrayidx40 = getelementptr inbounds i64, i64* %a8, i64 5
  %arrayidx48 = getelementptr inbounds i64, i64* %a8, i64 6
  %a4 = bitcast i8* %a to i32*
  %arrayidx56 = getelementptr inbounds i32, i32* %a4, i64 14
  %a2 = bitcast i8* %a to i16*
  %arrayidx60 = getelementptr inbounds i16, i16* %a2, i64 30
  %arrayidx62 = getelementptr inbounds i8, i8* %a, i64 62

  store i64 1, i64* %a8
  store i64 2, i64* %arrayidx8
  store i64 3, i64* %arrayidx16
  store i64 4, i64* %arrayidx24
  store i64 5, i64* %arrayidx32
  store i64 6, i64* %arrayidx40
  store i64 7, i64* %arrayidx48
  store i32 8, i32* %arrayidx56
  store i16 9, i16* %arrayidx60
  store i8 10, i8* %arrayidx62
  ret void
}

