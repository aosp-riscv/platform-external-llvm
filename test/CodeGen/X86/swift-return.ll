; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs < %s -mtriple=x86_64-unknown-unknown | FileCheck %s
; RUN: llc -verify-machineinstrs < %s -mtriple=x86_64-unknown-unknown -O0 | FileCheck --check-prefix=CHECK-O0 %s

@var = global i32 0

; Test how llvm handles return type of {i16, i8}. The return value will be
; passed in %eax and %dl.
define i16 @test(i32 %key) {
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movl %edi, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    callq gen
; CHECK-NEXT:    # kill: def $ax killed $ax def $eax
; CHECK-NEXT:    movsbl %dl, %ecx
; CHECK-NEXT:    addl %ecx, %eax
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    retq
;
; CHECK-O0-LABEL: test:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    pushq %rax
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 16
; CHECK-O0-NEXT:    movl %edi, {{[0-9]+}}(%rsp)
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%rsp), %edi
; CHECK-O0-NEXT:    callq gen
; CHECK-O0-NEXT:    movswl %ax, %edi
; CHECK-O0-NEXT:    movsbl %dl, %ecx
; CHECK-O0-NEXT:    addl %ecx, %edi
; CHECK-O0-NEXT:    movw %di, %ax
; CHECK-O0-NEXT:    popq %rcx
; CHECK-O0-NEXT:    retq
entry:
  %key.addr = alloca i32, align 4
  store i32 %key, i32* %key.addr, align 4
  %0 = load i32, i32* %key.addr, align 4
  %call = call swiftcc { i16, i8 } @gen(i32 %0)
  %v3 = extractvalue { i16, i8 } %call, 0
  %v1 = sext i16 %v3 to i32
  %v5 = extractvalue { i16, i8 } %call, 1
  %v2 = sext i8 %v5 to i32
  %add = add nsw i32 %v1, %v2
  %conv = trunc i32 %add to i16
  ret i16 %conv
}

declare swiftcc { i16, i8 } @gen(i32)

; If we can't pass every return value in register, we will pass everything
; in memroy. The caller provides space for the return value and passes
; the address in %rax. The first input argument will be in %rdi.
define i32 @test2(i32 %key) #0 {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    subq $24, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    movl %edi, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rsp, %rax
; CHECK-NEXT:    callq gen2
; CHECK-NEXT:    movl (%rsp), %eax
; CHECK-NEXT:    addl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addq $24, %rsp
; CHECK-NEXT:    retq
;
; CHECK-O0-LABEL: test2:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    subq $24, %rsp
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 32
; CHECK-O0-NEXT:    movl %edi, {{[0-9]+}}(%rsp)
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%rsp), %edi
; CHECK-O0-NEXT:    movq %rsp, %rax
; CHECK-O0-NEXT:    callq gen2
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%rsp), %edi
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%rsp), %ecx
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%rsp), %edx
; CHECK-O0-NEXT:    movl (%rsp), %esi
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%rsp), %r8d
; CHECK-O0-NEXT:    addl %r8d, %esi
; CHECK-O0-NEXT:    addl %edx, %esi
; CHECK-O0-NEXT:    addl %ecx, %esi
; CHECK-O0-NEXT:    addl %edi, %esi
; CHECK-O0-NEXT:    movl %esi, %eax
; CHECK-O0-NEXT:    addq $24, %rsp
; CHECK-O0-NEXT:    retq
entry:
  %key.addr = alloca i32, align 4
  store i32 %key, i32* %key.addr, align 4
  %0 = load i32, i32* %key.addr, align 4
  %call = call swiftcc { i32, i32, i32, i32, i32 } @gen2(i32 %0)

  %v3 = extractvalue { i32, i32, i32, i32, i32 } %call, 0
  %v5 = extractvalue { i32, i32, i32, i32, i32 } %call, 1
  %v6 = extractvalue { i32, i32, i32, i32, i32 } %call, 2
  %v7 = extractvalue { i32, i32, i32, i32, i32 } %call, 3
  %v8 = extractvalue { i32, i32, i32, i32, i32 } %call, 4

  %add = add nsw i32 %v3, %v5
  %add1 = add nsw i32 %add, %v6
  %add2 = add nsw i32 %add1, %v7
  %add3 = add nsw i32 %add2, %v8
  ret i32 %add3
}

; The address of the return value is passed in %rax.
; On return, we don't keep the address in %rax.
define swiftcc { i32, i32, i32, i32, i32 } @gen2(i32 %key) {
; CHECK-LABEL: gen2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, 16(%rax)
; CHECK-NEXT:    movl %edi, 12(%rax)
; CHECK-NEXT:    movl %edi, 8(%rax)
; CHECK-NEXT:    movl %edi, 4(%rax)
; CHECK-NEXT:    movl %edi, (%rax)
; CHECK-NEXT:    retq
;
; CHECK-O0-LABEL: gen2:
; CHECK-O0:       # %bb.0:
; CHECK-O0-NEXT:    movl %edi, 16(%rax)
; CHECK-O0-NEXT:    movl %edi, 12(%rax)
; CHECK-O0-NEXT:    movl %edi, 8(%rax)
; CHECK-O0-NEXT:    movl %edi, 4(%rax)
; CHECK-O0-NEXT:    movl %edi, (%rax)
; CHECK-O0-NEXT:    retq
  %Y = insertvalue { i32, i32, i32, i32, i32 } undef, i32 %key, 0
  %Z = insertvalue { i32, i32, i32, i32, i32 } %Y, i32 %key, 1
  %Z2 = insertvalue { i32, i32, i32, i32, i32 } %Z, i32 %key, 2
  %Z3 = insertvalue { i32, i32, i32, i32, i32 } %Z2, i32 %key, 3
  %Z4 = insertvalue { i32, i32, i32, i32, i32 } %Z3, i32 %key, 4
  ret { i32, i32, i32, i32, i32 } %Z4
}

; The return value {i32, i32, i32, i32} will be returned via registers %eax,
; %edx, %ecx, %r8d.
define i32 @test3(i32 %key) #0 {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movl %edi, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    callq gen3
; CHECK-NEXT:    addl %edx, %eax
; CHECK-NEXT:    addl %ecx, %eax
; CHECK-NEXT:    addl %r8d, %eax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    retq
;
; CHECK-O0-LABEL: test3:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    pushq %rax
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 16
; CHECK-O0-NEXT:    movl %edi, {{[0-9]+}}(%rsp)
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%rsp), %edi
; CHECK-O0-NEXT:    callq gen3
; CHECK-O0-NEXT:    addl %edx, %eax
; CHECK-O0-NEXT:    addl %ecx, %eax
; CHECK-O0-NEXT:    addl %r8d, %eax
; CHECK-O0-NEXT:    popq %rcx
; CHECK-O0-NEXT:    retq
entry:
  %key.addr = alloca i32, align 4
  store i32 %key, i32* %key.addr, align 4
  %0 = load i32, i32* %key.addr, align 4
  %call = call swiftcc { i32, i32, i32, i32 } @gen3(i32 %0)

  %v3 = extractvalue { i32, i32, i32, i32 } %call, 0
  %v5 = extractvalue { i32, i32, i32, i32 } %call, 1
  %v6 = extractvalue { i32, i32, i32, i32 } %call, 2
  %v7 = extractvalue { i32, i32, i32, i32 } %call, 3

  %add = add nsw i32 %v3, %v5
  %add1 = add nsw i32 %add, %v6
  %add2 = add nsw i32 %add1, %v7
  ret i32 %add2
}

declare swiftcc { i32, i32, i32, i32 } @gen3(i32 %key)

; The return value {float, float, float, float} will be returned via registers
; %xmm0, %xmm1, %xmm2, %xmm3.
define float @test4(float %key) #0 {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movss %xmm0, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    callq gen4
; CHECK-NEXT:    addss %xmm1, %xmm0
; CHECK-NEXT:    addss %xmm2, %xmm0
; CHECK-NEXT:    addss %xmm3, %xmm0
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; CHECK-O0-LABEL: test4:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    pushq %rax
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 16
; CHECK-O0-NEXT:    movss %xmm0, {{[0-9]+}}(%rsp)
; CHECK-O0-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-O0-NEXT:    callq gen4
; CHECK-O0-NEXT:    addss %xmm1, %xmm0
; CHECK-O0-NEXT:    addss %xmm2, %xmm0
; CHECK-O0-NEXT:    addss %xmm3, %xmm0
; CHECK-O0-NEXT:    popq %rax
; CHECK-O0-NEXT:    retq
entry:
  %key.addr = alloca float, align 4
  store float %key, float* %key.addr, align 4
  %0 = load float, float* %key.addr, align 4
  %call = call swiftcc { float, float, float, float } @gen4(float %0)

  %v3 = extractvalue { float, float, float, float } %call, 0
  %v5 = extractvalue { float, float, float, float } %call, 1
  %v6 = extractvalue { float, float, float, float } %call, 2
  %v7 = extractvalue { float, float, float, float } %call, 3

  %add = fadd float %v3, %v5
  %add1 = fadd float %add, %v6
  %add2 = fadd float %add1, %v7
  ret float %add2
}

declare swiftcc { float, float, float, float } @gen4(float %key)

define void @consume_i1_ret() {
; CHECK-LABEL: consume_i1_ret:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq produce_i1_ret
; CHECK-NEXT:    andb $1, %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    movl %eax, {{.*}}(%rip)
; CHECK-NEXT:    andb $1, %dl
; CHECK-NEXT:    movzbl %dl, %eax
; CHECK-NEXT:    movl %eax, {{.*}}(%rip)
; CHECK-NEXT:    andb $1, %cl
; CHECK-NEXT:    movzbl %cl, %eax
; CHECK-NEXT:    movl %eax, {{.*}}(%rip)
; CHECK-NEXT:    andb $1, %r8b
; CHECK-NEXT:    movzbl %r8b, %eax
; CHECK-NEXT:    movl %eax, {{.*}}(%rip)
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; CHECK-O0-LABEL: consume_i1_ret:
; CHECK-O0:       # %bb.0:
; CHECK-O0-NEXT:    pushq %rax
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 16
; CHECK-O0-NEXT:    callq produce_i1_ret
; CHECK-O0-NEXT:    andb $1, %al
; CHECK-O0-NEXT:    movzbl %al, %esi
; CHECK-O0-NEXT:    movl %esi, var
; CHECK-O0-NEXT:    andb $1, %dl
; CHECK-O0-NEXT:    movzbl %dl, %esi
; CHECK-O0-NEXT:    movl %esi, var
; CHECK-O0-NEXT:    andb $1, %cl
; CHECK-O0-NEXT:    movzbl %cl, %esi
; CHECK-O0-NEXT:    movl %esi, var
; CHECK-O0-NEXT:    andb $1, %r8b
; CHECK-O0-NEXT:    movzbl %r8b, %esi
; CHECK-O0-NEXT:    movl %esi, var
; CHECK-O0-NEXT:    popq %rax
; CHECK-O0-NEXT:    retq
  %call = call swiftcc { i1, i1, i1, i1 } @produce_i1_ret()
  %v3 = extractvalue { i1, i1, i1, i1 } %call, 0
  %v5 = extractvalue { i1, i1, i1, i1 } %call, 1
  %v6 = extractvalue { i1, i1, i1, i1 } %call, 2
  %v7 = extractvalue { i1, i1, i1, i1 } %call, 3
  %val = zext i1 %v3 to i32
  store volatile i32 %val, i32* @var
  %val2 = zext i1 %v5 to i32
  store volatile i32 %val2, i32* @var
  %val3 = zext i1 %v6 to i32
  store volatile i32 %val3, i32* @var
  %val4 = zext i1 %v7 to i32
  store i32 %val4, i32* @var
  ret void
}

declare swiftcc { i1, i1, i1, i1 } @produce_i1_ret()

define swiftcc void @foo(i64* sret %agg.result, i64 %val) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, (%rax)
; CHECK-NEXT:    retq
;
; CHECK-O0-LABEL: foo:
; CHECK-O0:       # %bb.0:
; CHECK-O0-NEXT:    movq %rdi, (%rax)
; CHECK-O0-NEXT:    retq
  store i64 %val, i64* %agg.result
  ret void
}

define swiftcc double @test5() #0 {
; CHECK-LABEL: test5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq gen5
; CHECK-NEXT:    addsd %xmm1, %xmm0
; CHECK-NEXT:    addsd %xmm2, %xmm0
; CHECK-NEXT:    addsd %xmm3, %xmm0
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; CHECK-O0-LABEL: test5:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    pushq %rax
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 16
; CHECK-O0-NEXT:    callq gen5
; CHECK-O0-NEXT:    addsd %xmm1, %xmm0
; CHECK-O0-NEXT:    addsd %xmm2, %xmm0
; CHECK-O0-NEXT:    addsd %xmm3, %xmm0
; CHECK-O0-NEXT:    popq %rax
; CHECK-O0-NEXT:    retq
entry:
  %call = call swiftcc { double, double, double, double } @gen5()

  %v3 = extractvalue { double, double, double, double } %call, 0
  %v5 = extractvalue { double, double, double, double } %call, 1
  %v6 = extractvalue { double, double, double, double } %call, 2
  %v7 = extractvalue { double, double, double, double } %call, 3

  %add = fadd double %v3, %v5
  %add1 = fadd double %add, %v6
  %add2 = fadd double %add1, %v7
  ret double %add2
}

declare swiftcc { double, double, double, double } @gen5()


define swiftcc { double, i64 } @test6() #0 {
; CHECK-LABEL: test6:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq gen6
; CHECK-NEXT:    addsd %xmm1, %xmm0
; CHECK-NEXT:    addsd %xmm2, %xmm0
; CHECK-NEXT:    addsd %xmm3, %xmm0
; CHECK-NEXT:    addq %rdx, %rax
; CHECK-NEXT:    addq %rcx, %rax
; CHECK-NEXT:    addq %r8, %rax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    retq
;
; CHECK-O0-LABEL: test6:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    pushq %rax
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 16
; CHECK-O0-NEXT:    callq gen6
; CHECK-O0-NEXT:    addsd %xmm1, %xmm0
; CHECK-O0-NEXT:    addsd %xmm2, %xmm0
; CHECK-O0-NEXT:    addsd %xmm3, %xmm0
; CHECK-O0-NEXT:    addq %rdx, %rax
; CHECK-O0-NEXT:    addq %rcx, %rax
; CHECK-O0-NEXT:    addq %r8, %rax
; CHECK-O0-NEXT:    popq %rcx
; CHECK-O0-NEXT:    retq
entry:
  %call = call swiftcc { double, double, double, double, i64, i64, i64, i64 } @gen6()

  %v3 = extractvalue { double, double, double, double, i64, i64, i64, i64 } %call, 0
  %v5 = extractvalue { double, double, double, double, i64, i64, i64, i64 } %call, 1
  %v6 = extractvalue { double, double, double, double, i64, i64, i64, i64 } %call, 2
  %v7 = extractvalue { double, double, double, double, i64, i64, i64, i64 } %call, 3
  %v3.i = extractvalue { double, double, double, double, i64, i64, i64, i64 } %call, 4
  %v5.i = extractvalue { double, double, double, double, i64, i64, i64, i64 } %call, 5
  %v6.i = extractvalue { double, double, double, double, i64, i64, i64, i64 } %call, 6
  %v7.i = extractvalue { double, double, double, double, i64, i64, i64, i64 } %call, 7

  %add = fadd double %v3, %v5
  %add1 = fadd double %add, %v6
  %add2 = fadd double %add1, %v7

  %add.i = add nsw i64 %v3.i, %v5.i
  %add1.i = add nsw i64 %add.i, %v6.i
  %add2.i = add nsw i64 %add1.i, %v7.i

  %Y = insertvalue { double, i64 } undef, double %add2, 0
  %Z = insertvalue { double, i64 } %Y, i64 %add2.i, 1
  ret { double, i64} %Z
}

declare swiftcc { double, double, double, double, i64, i64, i64, i64 } @gen6()

define swiftcc { i32, i32, i32, i32 } @gen7(i32 %key) {
; CHECK-LABEL: gen7:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    movl %edi, %edx
; CHECK-NEXT:    movl %edi, %ecx
; CHECK-NEXT:    movl %edi, %r8d
; CHECK-NEXT:    retq
;
; CHECK-O0-LABEL: gen7:
; CHECK-O0:       # %bb.0:
; CHECK-O0-NEXT:    movl %edi, %eax
; CHECK-O0-NEXT:    movl %edi, %edx
; CHECK-O0-NEXT:    movl %edi, %ecx
; CHECK-O0-NEXT:    movl %edi, %r8d
; CHECK-O0-NEXT:    retq
  %v0 = insertvalue { i32, i32, i32, i32 } undef, i32 %key, 0
  %v1 = insertvalue { i32, i32, i32, i32 } %v0, i32 %key, 1
  %v2 = insertvalue { i32, i32, i32, i32 } %v1, i32 %key, 2
  %v3 = insertvalue { i32, i32, i32, i32 } %v2, i32 %key, 3
  ret { i32, i32, i32, i32 } %v3
}

define swiftcc { i64, i64, i64, i64 } @gen8(i64 %key) {
; CHECK-LABEL: gen8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    movq %rdi, %rdx
; CHECK-NEXT:    movq %rdi, %rcx
; CHECK-NEXT:    movq %rdi, %r8
; CHECK-NEXT:    retq
;
; CHECK-O0-LABEL: gen8:
; CHECK-O0:       # %bb.0:
; CHECK-O0-NEXT:    movq %rdi, %rax
; CHECK-O0-NEXT:    movq %rdi, %rdx
; CHECK-O0-NEXT:    movq %rdi, %rcx
; CHECK-O0-NEXT:    movq %rdi, %r8
; CHECK-O0-NEXT:    retq
  %v0 = insertvalue { i64, i64, i64, i64 } undef, i64 %key, 0
  %v1 = insertvalue { i64, i64, i64, i64 } %v0, i64 %key, 1
  %v2 = insertvalue { i64, i64, i64, i64 } %v1, i64 %key, 2
  %v3 = insertvalue { i64, i64, i64, i64 } %v2, i64 %key, 3
  ret { i64, i64, i64, i64 } %v3
}

define swiftcc { i8, i8, i8, i8 } @gen9(i8 %key) {
; CHECK-LABEL: gen9:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    movl %edi, %edx
; CHECK-NEXT:    movl %edi, %ecx
; CHECK-NEXT:    movl %edi, %r8d
; CHECK-NEXT:    retq
;
; CHECK-O0-LABEL: gen9:
; CHECK-O0:       # %bb.0:
; CHECK-O0-NEXT:    movb %dil, %al
; CHECK-O0-NEXT:    movb %al, -{{[0-9]+}}(%rsp) # 1-byte Spill
; CHECK-O0-NEXT:    movb -{{[0-9]+}}(%rsp), %dl # 1-byte Reload
; CHECK-O0-NEXT:    movb -{{[0-9]+}}(%rsp), %cl # 1-byte Reload
; CHECK-O0-NEXT:    movb -{{[0-9]+}}(%rsp), %r8b # 1-byte Reload
; CHECK-O0-NEXT:    retq
  %v0 = insertvalue { i8, i8, i8, i8 } undef, i8 %key, 0
  %v1 = insertvalue { i8, i8, i8, i8 } %v0, i8 %key, 1
  %v2 = insertvalue { i8, i8, i8, i8 } %v1, i8 %key, 2
  %v3 = insertvalue { i8, i8, i8, i8 } %v2, i8 %key, 3
  ret { i8, i8, i8, i8 } %v3
}
define swiftcc { double, double, double, double, i64, i64, i64, i64 } @gen10(double %keyd, i64 %keyi) {
; CHECK-LABEL: gen10:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps %xmm0, %xmm1
; CHECK-NEXT:    movaps %xmm0, %xmm2
; CHECK-NEXT:    movaps %xmm0, %xmm3
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    movq %rdi, %rdx
; CHECK-NEXT:    movq %rdi, %rcx
; CHECK-NEXT:    movq %rdi, %r8
; CHECK-NEXT:    retq
;
; CHECK-O0-LABEL: gen10:
; CHECK-O0:       # %bb.0:
; CHECK-O0-NEXT:    movsd %xmm0, -{{[0-9]+}}(%rsp) # 8-byte Spill
; CHECK-O0-NEXT:    movsd -{{[0-9]+}}(%rsp), %xmm1 # 8-byte Reload
; CHECK-O0-NEXT:    # xmm1 = mem[0],zero
; CHECK-O0-NEXT:    movsd -{{[0-9]+}}(%rsp), %xmm2 # 8-byte Reload
; CHECK-O0-NEXT:    # xmm2 = mem[0],zero
; CHECK-O0-NEXT:    movsd -{{[0-9]+}}(%rsp), %xmm3 # 8-byte Reload
; CHECK-O0-NEXT:    # xmm3 = mem[0],zero
; CHECK-O0-NEXT:    movq %rdi, %rax
; CHECK-O0-NEXT:    movq %rdi, %rdx
; CHECK-O0-NEXT:    movq %rdi, %rcx
; CHECK-O0-NEXT:    movq %rdi, %r8
; CHECK-O0-NEXT:    retq
  %v0 = insertvalue { double, double, double, double, i64, i64, i64, i64 } undef, double %keyd, 0
  %v1 = insertvalue { double, double, double, double, i64, i64, i64, i64 } %v0, double %keyd, 1
  %v2 = insertvalue { double, double, double, double, i64, i64, i64, i64 } %v1, double %keyd, 2
  %v3 = insertvalue { double, double, double, double, i64, i64, i64, i64 } %v2, double %keyd, 3
  %v4 = insertvalue { double, double, double, double, i64, i64, i64, i64 } %v3, i64 %keyi, 4
  %v5 = insertvalue { double, double, double, double, i64, i64, i64, i64 } %v4, i64 %keyi, 5
  %v6 = insertvalue { double, double, double, double, i64, i64, i64, i64 } %v5, i64 %keyi, 6
  %v7 = insertvalue { double, double, double, double, i64, i64, i64, i64 } %v6, i64 %keyi, 7
  ret { double, double, double, double, i64, i64, i64, i64 } %v7
}


define swiftcc <4 x float> @test11() #0 {
; CHECK-LABEL: test11:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq gen11
; CHECK-NEXT:    addps %xmm1, %xmm0
; CHECK-NEXT:    addps %xmm2, %xmm0
; CHECK-NEXT:    addps %xmm3, %xmm0
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; CHECK-O0-LABEL: test11:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    pushq %rax
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 16
; CHECK-O0-NEXT:    callq gen11
; CHECK-O0-NEXT:    addps %xmm1, %xmm0
; CHECK-O0-NEXT:    addps %xmm2, %xmm0
; CHECK-O0-NEXT:    addps %xmm3, %xmm0
; CHECK-O0-NEXT:    popq %rax
; CHECK-O0-NEXT:    retq
entry:
  %call = call swiftcc { <4 x float>, <4 x float>, <4 x float>, <4 x float> } @gen11()

  %v3 = extractvalue { <4 x float>, <4 x float>, <4 x float>, <4 x float> } %call, 0
  %v5 = extractvalue { <4 x float>, <4 x float>, <4 x float>, <4 x float> } %call, 1
  %v6 = extractvalue { <4 x float>, <4 x float>, <4 x float>, <4 x float> } %call, 2
  %v7 = extractvalue { <4 x float>, <4 x float>, <4 x float>, <4 x float> } %call, 3

  %add = fadd <4 x float> %v3, %v5
  %add1 = fadd <4 x float> %add, %v6
  %add2 = fadd <4 x float> %add1, %v7
  ret <4 x float> %add2
}

declare swiftcc { <4 x float>, <4 x float>, <4 x float>, <4 x float> } @gen11()

define swiftcc { <4 x float>, float } @test12() #0 {
; CHECK-LABEL: test12:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq gen12
; CHECK-NEXT:    addps %xmm1, %xmm0
; CHECK-NEXT:    addps %xmm2, %xmm0
; CHECK-NEXT:    movaps %xmm3, %xmm1
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; CHECK-O0-LABEL: test12:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    pushq %rax
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 16
; CHECK-O0-NEXT:    callq gen12
; CHECK-O0-NEXT:    addps %xmm1, %xmm0
; CHECK-O0-NEXT:    addps %xmm2, %xmm0
; CHECK-O0-NEXT:    movaps %xmm3, %xmm1
; CHECK-O0-NEXT:    popq %rax
; CHECK-O0-NEXT:    retq
entry:
  %call = call swiftcc { <4 x float>, <4 x float>, <4 x float>, float } @gen12()

  %v3 = extractvalue { <4 x float>, <4 x float>, <4 x float>, float } %call, 0
  %v5 = extractvalue { <4 x float>, <4 x float>, <4 x float>, float } %call, 1
  %v6 = extractvalue { <4 x float>, <4 x float>, <4 x float>, float } %call, 2
  %v8 = extractvalue { <4 x float>, <4 x float>, <4 x float>, float } %call, 3

  %add = fadd <4 x float> %v3, %v5
  %add1 = fadd <4 x float> %add, %v6
  %res.0 = insertvalue { <4 x float>, float } undef, <4 x float> %add1, 0
  %res = insertvalue { <4 x float>, float } %res.0, float %v8, 1
  ret { <4 x float>, float } %res
}

declare swiftcc { <4 x float>, <4 x float>, <4 x float>, float } @gen12()
