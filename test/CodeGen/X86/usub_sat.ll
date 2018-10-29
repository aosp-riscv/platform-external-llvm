; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mcpu=generic -mtriple=x86_64-linux | FileCheck %s
; RUN: llc < %s -mcpu=generic -mtriple=i686 -mattr=cmov | FileCheck %s --check-prefix=CHECK32

declare  i4  @llvm.usub.sat.i4   (i4,  i4)
declare  i32 @llvm.usub.sat.i32  (i32, i32)
declare  i64 @llvm.usub.sat.i64  (i64, i64)
declare  <4 x i32> @llvm.usub.sat.v4i32(<4 x i32>, <4 x i32>)

define i32 @func(i32 %x, i32 %y) {
; CHECK-LABEL: func:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    subl %esi, %edi
; CHECK-NEXT:    cmovael %edi, %eax
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: func:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    xorl %ecx, %ecx
; CHECK32-NEXT:    subl {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    cmovbl %ecx, %eax
; CHECK32-NEXT:    retl
  %tmp = call i32 @llvm.usub.sat.i32(i32 %x, i32 %y);
  ret i32 %tmp;
}

define i64 @func2(i64 %x, i64 %y) {
; CHECK-LABEL: func2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    subq %rsi, %rdi
; CHECK-NEXT:    cmovaeq %rdi, %rax
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: func2:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK32-NEXT:    xorl %ecx, %ecx
; CHECK32-NEXT:    subl {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    sbbl {{[0-9]+}}(%esp), %edx
; CHECK32-NEXT:    cmovbl %ecx, %edx
; CHECK32-NEXT:    cmovbl %ecx, %eax
; CHECK32-NEXT:    retl
  %tmp = call i64 @llvm.usub.sat.i64(i64 %x, i64 %y);
  ret i64 %tmp;
}

define i4 @func3(i4 %x, i4 %y) {
; CHECK-LABEL: func3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    shlb $4, %sil
; CHECK-NEXT:    shlb $4, %al
; CHECK-NEXT:    subb %sil, %al
; CHECK-NEXT:    jae .LBB2_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:  .LBB2_2:
; CHECK-NEXT:    shrb $4, %al
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: func3:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    movb {{[0-9]+}}(%esp), %al
; CHECK32-NEXT:    movb {{[0-9]+}}(%esp), %cl
; CHECK32-NEXT:    shlb $4, %cl
; CHECK32-NEXT:    shlb $4, %al
; CHECK32-NEXT:    subb %cl, %al
; CHECK32-NEXT:    jae .LBB2_2
; CHECK32-NEXT:  # %bb.1:
; CHECK32-NEXT:    xorl %eax, %eax
; CHECK32-NEXT:  .LBB2_2:
; CHECK32-NEXT:    shrb $4, %al
; CHECK32-NEXT:    # kill: def $al killed $al killed $eax
; CHECK32-NEXT:    retl
  %tmp = call i4 @llvm.usub.sat.i4(i4 %x, i4 %y);
  ret i4 %tmp;
}

define <4 x i32> @vec(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vec:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[3,1,2,3]
; CHECK-NEXT:    movd %xmm2, %eax
; CHECK-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[3,1,2,3]
; CHECK-NEXT:    movd %xmm2, %ecx
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    subl %eax, %ecx
; CHECK-NEXT:    cmovbl %edx, %ecx
; CHECK-NEXT:    movd %ecx, %xmm2
; CHECK-NEXT:    pshufd {{.*#+}} xmm3 = xmm1[2,3,0,1]
; CHECK-NEXT:    movd %xmm3, %eax
; CHECK-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[2,3,0,1]
; CHECK-NEXT:    movd %xmm3, %ecx
; CHECK-NEXT:    subl %eax, %ecx
; CHECK-NEXT:    cmovbl %edx, %ecx
; CHECK-NEXT:    movd %ecx, %xmm3
; CHECK-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1]
; CHECK-NEXT:    movd %xmm1, %eax
; CHECK-NEXT:    movd %xmm0, %ecx
; CHECK-NEXT:    subl %eax, %ecx
; CHECK-NEXT:    cmovbl %edx, %ecx
; CHECK-NEXT:    movd %ecx, %xmm2
; CHECK-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,2,3]
; CHECK-NEXT:    movd %xmm1, %eax
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; CHECK-NEXT:    movd %xmm0, %ecx
; CHECK-NEXT:    subl %eax, %ecx
; CHECK-NEXT:    cmovbl %edx, %ecx
; CHECK-NEXT:    movd %ecx, %xmm0
; CHECK-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1]
; CHECK-NEXT:    punpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm3[0]
; CHECK-NEXT:    movdqa %xmm2, %xmm0
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: vec:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    pushl %ebx
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    pushl %edi
; CHECK32-NEXT:    .cfi_def_cfa_offset 12
; CHECK32-NEXT:    pushl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 16
; CHECK32-NEXT:    .cfi_offset %esi, -16
; CHECK32-NEXT:    .cfi_offset %edi, -12
; CHECK32-NEXT:    .cfi_offset %ebx, -8
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edi
; CHECK32-NEXT:    xorl %ebx, %ebx
; CHECK32-NEXT:    subl {{[0-9]+}}(%esp), %edi
; CHECK32-NEXT:    cmovbl %ebx, %edi
; CHECK32-NEXT:    subl {{[0-9]+}}(%esp), %esi
; CHECK32-NEXT:    cmovbl %ebx, %esi
; CHECK32-NEXT:    subl {{[0-9]+}}(%esp), %edx
; CHECK32-NEXT:    cmovbl %ebx, %edx
; CHECK32-NEXT:    subl {{[0-9]+}}(%esp), %ecx
; CHECK32-NEXT:    cmovbl %ebx, %ecx
; CHECK32-NEXT:    movl %ecx, 12(%eax)
; CHECK32-NEXT:    movl %edx, 8(%eax)
; CHECK32-NEXT:    movl %esi, 4(%eax)
; CHECK32-NEXT:    movl %edi, (%eax)
; CHECK32-NEXT:    popl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 12
; CHECK32-NEXT:    popl %edi
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    popl %ebx
; CHECK32-NEXT:    .cfi_def_cfa_offset 4
; CHECK32-NEXT:    retl $4
  %tmp = call <4 x i32> @llvm.usub.sat.v4i32(<4 x i32> %x, <4 x i32> %y);
  ret <4 x i32> %tmp;
}
