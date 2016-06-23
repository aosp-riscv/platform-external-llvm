; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=X64

; tests variable insert and extract of a 4 x i32

define <4 x i32> @var_insert(<4 x i32> %x, i32 %val, i32 %idx) nounwind {
; X32-LABEL: var_insert:
; X32:       # BB#0: # %entry
; X32-NEXT:    pushl %ebp
; X32-NEXT:    movl %esp, %ebp
; X32-NEXT:    andl $-16, %esp
; X32-NEXT:    subl $32, %esp
; X32-NEXT:    movl 8(%ebp), %eax
; X32-NEXT:    movl 12(%ebp), %ecx
; X32-NEXT:    movaps %xmm0, (%esp)
; X32-NEXT:    movl %eax, (%esp,%ecx,4)
; X32-NEXT:    movaps (%esp), %xmm0
; X32-NEXT:    movl %ebp, %esp
; X32-NEXT:    popl %ebp
; X32-NEXT:    retl
;
; X64-LABEL: var_insert:
; X64:       # BB#0: # %entry
; X64-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; X64-NEXT:    movslq %esi, %rax
; X64-NEXT:    movl %edi, -24(%rsp,%rax,4)
; X64-NEXT:    movaps -{{[0-9]+}}(%rsp), %xmm0
; X64-NEXT:    retq
entry:
  %tmp3 = insertelement <4 x i32> %x, i32 %val, i32 %idx
  ret <4 x i32> %tmp3
}

define i32 @var_extract(<4 x i32> %x, i32 %idx) nounwind {
; X32-LABEL: var_extract:
; X32:       # BB#0: # %entry
; X32-NEXT:    pushl %ebp
; X32-NEXT:    movl %esp, %ebp
; X32-NEXT:    andl $-16, %esp
; X32-NEXT:    subl $32, %esp
; X32-NEXT:    movl 8(%ebp), %eax
; X32-NEXT:    movaps %xmm0, (%esp)
; X32-NEXT:    movl (%esp,%eax,4), %eax
; X32-NEXT:    movl %ebp, %esp
; X32-NEXT:    popl %ebp
; X32-NEXT:    retl
;
; X64-LABEL: var_extract:
; X64:       # BB#0: # %entry
; X64-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; X64-NEXT:    movslq %edi, %rax
; X64-NEXT:    movl -24(%rsp,%rax,4), %eax
; X64-NEXT:    retq
entry:
  %tmp3 = extractelement <4 x i32> %x, i32 %idx
  ret i32 %tmp3
}
