; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -o - %s -mtriple=x86_64--unknown-linux-gnu | FileCheck %s

define void @foo(i32* %a, i32* %b, i32* noalias %c, i64 %s) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq $0, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    jmp .LBB0_1
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_2: # %body
; CHECK-NEXT:    # in Loop: Header=BB0_1 Depth=1
; CHECK-NEXT:    movl $1, (%rdx,%r9,4)
; CHECK-NEXT:    movzbl (%rdi,%r9,4), %r8d
; CHECK-NEXT:    movzbl (%rsi,%r9,4), %eax
; CHECK-NEXT:    andl %r8d, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    movl %eax, (%rdi,%r9,4)
; CHECK-NEXT:    incq %r9
; CHECK-NEXT:    movq %r9, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:  .LBB0_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movq -{{[0-9]+}}(%rsp), %r9
; CHECK-NEXT:    cmpq %rcx, %r9
; CHECK-NEXT:    jne .LBB0_2
; CHECK-NEXT:  # %bb.3: # %endloop
; CHECK-NEXT:    retq
%i = alloca i64
store i64 0, i64* %i
br label %loop

loop:
%ct = load i64, i64* %i
%comp = icmp eq i64 %ct, %s
br i1 %comp, label %endloop, label %body

body:
%var0 = getelementptr i32, i32* %c, i64 %ct
store i32 1, i32* %var0
%var1 = getelementptr i32, i32* %c, i64 %ct
%var2 = load i32, i32* %var1
%var3 = add i32 %var2, 1
%var4 = getelementptr i32, i32* %a, i64 %ct
%var5 = load i32, i32* %var4
%var6 = and i32 %var3, %var5
%var7 = add i32 %var6, 1
%var8 = getelementptr i32, i32* %a, i64 %ct
%var9 = load i32, i32* %var8
%var10 = and i32 %var7, %var9
%var11 = getelementptr i32, i32* %c, i64 %ct
%var12 = load i32, i32* %var11
%var13 = and i32 %var10, %var12
%var14 = getelementptr i32, i32* %b, i64 %ct
%var15 = load i32, i32* %var14
%var16 = and i32 %var15, 63
%var17 = and i32 %var13, %var16
%var18 = getelementptr i32, i32* %a, i64 %ct
store i32 %var17, i32* %var18
%z = add i64 1, %ct
store i64 %z, i64* %i
br label %loop

endloop:
ret void
}
