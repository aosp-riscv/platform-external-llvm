; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-apple-darwin10  -mattr=+avx,+fma,-fma4 -show-mc-encoding | FileCheck %s --check-prefix=FMA32
; RUN: llc < %s -mtriple=i386-apple-darwin10  -mattr=+avx,-fma,-fma4 -show-mc-encoding | FileCheck %s --check-prefix=FMACALL32
; RUN: llc < %s -mtriple=x86_64-apple-darwin10 -mattr=+fma,-fma4 -show-mc-encoding | FileCheck %s --check-prefix=FMA64
; RUN: llc < %s -mtriple=x86_64-apple-darwin10  -mattr=-fma,-fma4 -show-mc-encoding | FileCheck %s --check-prefix=FMACALL64
; RUN: llc < %s -mtriple=x86_64-apple-darwin10  -mattr=+avx512f,-fma4 -show-mc-encoding | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX51264
; RUN: llc < %s -mtriple=x86_64-apple-darwin10  -mattr=+avx512vl,-fma4 -show-mc-encoding | FileCheck %s --check-prefix=AVX512VL
; RUN: llc < %s -mtriple=i386-apple-darwin10 -mcpu=bdver2 -mattr=-fma4 -show-mc-encoding | FileCheck %s --check-prefix=FMA32
; RUN: llc < %s -mtriple=i386-apple-darwin10 -mcpu=bdver2 -mattr=-fma,-fma4 -show-mc-encoding | FileCheck %s --check-prefix=FMACALL32

define float @test_f32(float %a, float %b, float %c) #0 {
; FMA32-LABEL: test_f32:
; FMA32:       ## BB#0: ## %entry
; FMA32-NEXT:    pushl %eax ## encoding: [0x50]
; FMA32-NEXT:    vmovss {{[0-9]+}}(%esp), %xmm0 ## encoding: [0xc5,0xfa,0x10,0x44,0x24,0x08]
; FMA32-NEXT:    ## xmm0 = mem[0],zero,zero,zero
; FMA32-NEXT:    vmovss {{[0-9]+}}(%esp), %xmm1 ## encoding: [0xc5,0xfa,0x10,0x4c,0x24,0x0c]
; FMA32-NEXT:    ## xmm1 = mem[0],zero,zero,zero
; FMA32-NEXT:    vfmadd213ss {{[0-9]+}}(%esp), %xmm0, %xmm1 ## encoding: [0xc4,0xe2,0x79,0xa9,0x4c,0x24,0x10]
; FMA32-NEXT:    vmovss %xmm1, (%esp) ## encoding: [0xc5,0xfa,0x11,0x0c,0x24]
; FMA32-NEXT:    flds (%esp) ## encoding: [0xd9,0x04,0x24]
; FMA32-NEXT:    popl %eax ## encoding: [0x58]
; FMA32-NEXT:    retl ## encoding: [0xc3]
;
; FMACALL32-LABEL: test_f32:
; FMACALL32:       ## BB#0: ## %entry
; FMACALL32-NEXT:    jmp _fmaf ## TAILCALL
; FMACALL32-NEXT:    ## encoding: [0xeb,A]
; FMACALL32-NEXT:    ## fixup A - offset: 1, value: _fmaf-1, kind: FK_PCRel_1
;
; FMA64-LABEL: test_f32:
; FMA64:       ## BB#0: ## %entry
; FMA64-NEXT:    vfmadd213ss %xmm2, %xmm1, %xmm0 ## encoding: [0xc4,0xe2,0x71,0xa9,0xc2]
; FMA64-NEXT:    retq ## encoding: [0xc3]
;
; FMACALL64-LABEL: test_f32:
; FMACALL64:       ## BB#0: ## %entry
; FMACALL64-NEXT:    jmp _fmaf ## TAILCALL
; FMACALL64-NEXT:    ## encoding: [0xeb,A]
; FMACALL64-NEXT:    ## fixup A - offset: 1, value: _fmaf-1, kind: FK_PCRel_1
;
; AVX512-LABEL: test_f32:
; AVX512:       ## BB#0: ## %entry
; AVX512-NEXT:    vfmadd213ss %xmm2, %xmm1, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe2,0x71,0xa9,0xc2]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX512VL-LABEL: test_f32:
; AVX512VL:       ## BB#0: ## %entry
; AVX512VL-NEXT:    vfmadd213ss %xmm2, %xmm1, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe2,0x71,0xa9,0xc2]
; AVX512VL-NEXT:    retq ## encoding: [0xc3]
entry:
  %call = call float @llvm.fma.f32(float %a, float %b, float %c)
  ret float %call
}

define double @test_f64(double %a, double %b, double %c) #0 {
; FMA32-LABEL: test_f64:
; FMA32:       ## BB#0: ## %entry
; FMA32-NEXT:    subl $12, %esp ## encoding: [0x83,0xec,0x0c]
; FMA32-NEXT:    vmovsd {{[0-9]+}}(%esp), %xmm0 ## encoding: [0xc5,0xfb,0x10,0x44,0x24,0x10]
; FMA32-NEXT:    ## xmm0 = mem[0],zero
; FMA32-NEXT:    vmovsd {{[0-9]+}}(%esp), %xmm1 ## encoding: [0xc5,0xfb,0x10,0x4c,0x24,0x18]
; FMA32-NEXT:    ## xmm1 = mem[0],zero
; FMA32-NEXT:    vfmadd213sd {{[0-9]+}}(%esp), %xmm0, %xmm1 ## encoding: [0xc4,0xe2,0xf9,0xa9,0x4c,0x24,0x20]
; FMA32-NEXT:    vmovsd %xmm1, (%esp) ## encoding: [0xc5,0xfb,0x11,0x0c,0x24]
; FMA32-NEXT:    fldl (%esp) ## encoding: [0xdd,0x04,0x24]
; FMA32-NEXT:    addl $12, %esp ## encoding: [0x83,0xc4,0x0c]
; FMA32-NEXT:    retl ## encoding: [0xc3]
;
; FMACALL32-LABEL: test_f64:
; FMACALL32:       ## BB#0: ## %entry
; FMACALL32-NEXT:    jmp _fma ## TAILCALL
; FMACALL32-NEXT:    ## encoding: [0xeb,A]
; FMACALL32-NEXT:    ## fixup A - offset: 1, value: _fma-1, kind: FK_PCRel_1
;
; FMA64-LABEL: test_f64:
; FMA64:       ## BB#0: ## %entry
; FMA64-NEXT:    vfmadd213sd %xmm2, %xmm1, %xmm0 ## encoding: [0xc4,0xe2,0xf1,0xa9,0xc2]
; FMA64-NEXT:    retq ## encoding: [0xc3]
;
; FMACALL64-LABEL: test_f64:
; FMACALL64:       ## BB#0: ## %entry
; FMACALL64-NEXT:    jmp _fma ## TAILCALL
; FMACALL64-NEXT:    ## encoding: [0xeb,A]
; FMACALL64-NEXT:    ## fixup A - offset: 1, value: _fma-1, kind: FK_PCRel_1
;
; AVX512-LABEL: test_f64:
; AVX512:       ## BB#0: ## %entry
; AVX512-NEXT:    vfmadd213sd %xmm2, %xmm1, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe2,0xf1,0xa9,0xc2]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX512VL-LABEL: test_f64:
; AVX512VL:       ## BB#0: ## %entry
; AVX512VL-NEXT:    vfmadd213sd %xmm2, %xmm1, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe2,0xf1,0xa9,0xc2]
; AVX512VL-NEXT:    retq ## encoding: [0xc3]
entry:
  %call = call double @llvm.fma.f64(double %a, double %b, double %c)
  ret double %call
}

define x86_fp80 @test_f80(x86_fp80 %a, x86_fp80 %b, x86_fp80 %c) #0 {
; FMA32-LABEL: test_f80:
; FMA32:       ## BB#0: ## %entry
; FMA32-NEXT:    subl $60, %esp ## encoding: [0x83,0xec,0x3c]
; FMA32-NEXT:    fldt {{[0-9]+}}(%esp) ## encoding: [0xdb,0x6c,0x24,0x40]
; FMA32-NEXT:    fldt {{[0-9]+}}(%esp) ## encoding: [0xdb,0x6c,0x24,0x50]
; FMA32-NEXT:    fldt {{[0-9]+}}(%esp) ## encoding: [0xdb,0x6c,0x24,0x60]
; FMA32-NEXT:    fstpt {{[0-9]+}}(%esp) ## encoding: [0xdb,0x7c,0x24,0x20]
; FMA32-NEXT:    fstpt {{[0-9]+}}(%esp) ## encoding: [0xdb,0x7c,0x24,0x10]
; FMA32-NEXT:    fstpt (%esp) ## encoding: [0xdb,0x3c,0x24]
; FMA32-NEXT:    calll _fmal ## encoding: [0xe8,A,A,A,A]
; FMA32-NEXT:    ## fixup A - offset: 1, value: _fmal-4, kind: FK_PCRel_4
; FMA32-NEXT:    addl $60, %esp ## encoding: [0x83,0xc4,0x3c]
; FMA32-NEXT:    retl ## encoding: [0xc3]
;
; FMACALL32-LABEL: test_f80:
; FMACALL32:       ## BB#0: ## %entry
; FMACALL32-NEXT:    subl $60, %esp ## encoding: [0x83,0xec,0x3c]
; FMACALL32-NEXT:    fldt {{[0-9]+}}(%esp) ## encoding: [0xdb,0x6c,0x24,0x40]
; FMACALL32-NEXT:    fldt {{[0-9]+}}(%esp) ## encoding: [0xdb,0x6c,0x24,0x50]
; FMACALL32-NEXT:    fldt {{[0-9]+}}(%esp) ## encoding: [0xdb,0x6c,0x24,0x60]
; FMACALL32-NEXT:    fstpt {{[0-9]+}}(%esp) ## encoding: [0xdb,0x7c,0x24,0x20]
; FMACALL32-NEXT:    fstpt {{[0-9]+}}(%esp) ## encoding: [0xdb,0x7c,0x24,0x10]
; FMACALL32-NEXT:    fstpt (%esp) ## encoding: [0xdb,0x3c,0x24]
; FMACALL32-NEXT:    calll _fmal ## encoding: [0xe8,A,A,A,A]
; FMACALL32-NEXT:    ## fixup A - offset: 1, value: _fmal-4, kind: FK_PCRel_4
; FMACALL32-NEXT:    addl $60, %esp ## encoding: [0x83,0xc4,0x3c]
; FMACALL32-NEXT:    retl ## encoding: [0xc3]
;
; FMA64-LABEL: test_f80:
; FMA64:       ## BB#0: ## %entry
; FMA64-NEXT:    subq $56, %rsp ## encoding: [0x48,0x83,0xec,0x38]
; FMA64-NEXT:    fldt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x6c,0x24,0x40]
; FMA64-NEXT:    fldt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x6c,0x24,0x50]
; FMA64-NEXT:    fldt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x6c,0x24,0x60]
; FMA64-NEXT:    fstpt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x7c,0x24,0x20]
; FMA64-NEXT:    fstpt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x7c,0x24,0x10]
; FMA64-NEXT:    fstpt (%rsp) ## encoding: [0xdb,0x3c,0x24]
; FMA64-NEXT:    callq _fmal ## encoding: [0xe8,A,A,A,A]
; FMA64-NEXT:    ## fixup A - offset: 1, value: _fmal-4, kind: FK_PCRel_4
; FMA64-NEXT:    addq $56, %rsp ## encoding: [0x48,0x83,0xc4,0x38]
; FMA64-NEXT:    retq ## encoding: [0xc3]
;
; FMACALL64-LABEL: test_f80:
; FMACALL64:       ## BB#0: ## %entry
; FMACALL64-NEXT:    subq $56, %rsp ## encoding: [0x48,0x83,0xec,0x38]
; FMACALL64-NEXT:    fldt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x6c,0x24,0x40]
; FMACALL64-NEXT:    fldt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x6c,0x24,0x50]
; FMACALL64-NEXT:    fldt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x6c,0x24,0x60]
; FMACALL64-NEXT:    fstpt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x7c,0x24,0x20]
; FMACALL64-NEXT:    fstpt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x7c,0x24,0x10]
; FMACALL64-NEXT:    fstpt (%rsp) ## encoding: [0xdb,0x3c,0x24]
; FMACALL64-NEXT:    callq _fmal ## encoding: [0xe8,A,A,A,A]
; FMACALL64-NEXT:    ## fixup A - offset: 1, value: _fmal-4, kind: FK_PCRel_4
; FMACALL64-NEXT:    addq $56, %rsp ## encoding: [0x48,0x83,0xc4,0x38]
; FMACALL64-NEXT:    retq ## encoding: [0xc3]
;
; AVX512-LABEL: test_f80:
; AVX512:       ## BB#0: ## %entry
; AVX512-NEXT:    subq $56, %rsp ## encoding: [0x48,0x83,0xec,0x38]
; AVX512-NEXT:    fldt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x6c,0x24,0x40]
; AVX512-NEXT:    fldt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x6c,0x24,0x50]
; AVX512-NEXT:    fldt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x6c,0x24,0x60]
; AVX512-NEXT:    fstpt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x7c,0x24,0x20]
; AVX512-NEXT:    fstpt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x7c,0x24,0x10]
; AVX512-NEXT:    fstpt (%rsp) ## encoding: [0xdb,0x3c,0x24]
; AVX512-NEXT:    callq _fmal ## encoding: [0xe8,A,A,A,A]
; AVX512-NEXT:    ## fixup A - offset: 1, value: _fmal-4, kind: FK_PCRel_4
; AVX512-NEXT:    addq $56, %rsp ## encoding: [0x48,0x83,0xc4,0x38]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX512VL-LABEL: test_f80:
; AVX512VL:       ## BB#0: ## %entry
; AVX512VL-NEXT:    subq $56, %rsp ## encoding: [0x48,0x83,0xec,0x38]
; AVX512VL-NEXT:    fldt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x6c,0x24,0x40]
; AVX512VL-NEXT:    fldt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x6c,0x24,0x50]
; AVX512VL-NEXT:    fldt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x6c,0x24,0x60]
; AVX512VL-NEXT:    fstpt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x7c,0x24,0x20]
; AVX512VL-NEXT:    fstpt {{[0-9]+}}(%rsp) ## encoding: [0xdb,0x7c,0x24,0x10]
; AVX512VL-NEXT:    fstpt (%rsp) ## encoding: [0xdb,0x3c,0x24]
; AVX512VL-NEXT:    callq _fmal ## encoding: [0xe8,A,A,A,A]
; AVX512VL-NEXT:    ## fixup A - offset: 1, value: _fmal-4, kind: FK_PCRel_4
; AVX512VL-NEXT:    addq $56, %rsp ## encoding: [0x48,0x83,0xc4,0x38]
; AVX512VL-NEXT:    retq ## encoding: [0xc3]
entry:
  %call = call x86_fp80 @llvm.fma.f80(x86_fp80 %a, x86_fp80 %b, x86_fp80 %c)
  ret x86_fp80 %call
}

define float @test_f32_cst() #0 {
; FMA32-LABEL: test_f32_cst:
; FMA32:       ## BB#0: ## %entry
; FMA32-NEXT:    flds LCPI3_0 ## encoding: [0xd9,0x05,A,A,A,A]
; FMA32-NEXT:    ## fixup A - offset: 2, value: LCPI3_0, kind: FK_Data_4
; FMA32-NEXT:    retl ## encoding: [0xc3]
;
; FMACALL32-LABEL: test_f32_cst:
; FMACALL32:       ## BB#0: ## %entry
; FMACALL32-NEXT:    flds LCPI3_0 ## encoding: [0xd9,0x05,A,A,A,A]
; FMACALL32-NEXT:    ## fixup A - offset: 2, value: LCPI3_0, kind: FK_Data_4
; FMACALL32-NEXT:    retl ## encoding: [0xc3]
;
; FMA64-LABEL: test_f32_cst:
; FMA64:       ## BB#0: ## %entry
; FMA64-NEXT:    vmovss {{.*}}(%rip), %xmm0 ## encoding: [0xc5,0xfa,0x10,0x05,A,A,A,A]
; FMA64-NEXT:    ## fixup A - offset: 4, value: LCPI3_0-4, kind: reloc_riprel_4byte
; FMA64-NEXT:    ## xmm0 = mem[0],zero,zero,zero
; FMA64-NEXT:    retq ## encoding: [0xc3]
;
; FMACALL64-LABEL: test_f32_cst:
; FMACALL64:       ## BB#0: ## %entry
; FMACALL64-NEXT:    movss {{.*}}(%rip), %xmm0 ## encoding: [0xf3,0x0f,0x10,0x05,A,A,A,A]
; FMACALL64-NEXT:    ## fixup A - offset: 4, value: LCPI3_0-4, kind: reloc_riprel_4byte
; FMACALL64-NEXT:    ## xmm0 = mem[0],zero,zero,zero
; FMACALL64-NEXT:    retq ## encoding: [0xc3]
;
; AVX512-LABEL: test_f32_cst:
; AVX512:       ## BB#0: ## %entry
; AVX512-NEXT:    vmovss {{.*}}(%rip), %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfa,0x10,0x05,A,A,A,A]
; AVX512-NEXT:    ## fixup A - offset: 4, value: LCPI3_0-4, kind: reloc_riprel_4byte
; AVX512-NEXT:    ## xmm0 = mem[0],zero,zero,zero
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX512VL-LABEL: test_f32_cst:
; AVX512VL:       ## BB#0: ## %entry
; AVX512VL-NEXT:    vmovss {{.*}}(%rip), %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfa,0x10,0x05,A,A,A,A]
; AVX512VL-NEXT:    ## fixup A - offset: 4, value: LCPI3_0-4, kind: reloc_riprel_4byte
; AVX512VL-NEXT:    ## xmm0 = mem[0],zero,zero,zero
; AVX512VL-NEXT:    retq ## encoding: [0xc3]
entry:
  %call = call float @llvm.fma.f32(float 3.0, float 3.0, float 3.0)
  ret float %call
}

define <4 x float> @test_v4f32(<4 x float> %a, <4 x float> %b, <4 x float> %c) #0 {
; FMA32-LABEL: test_v4f32:
; FMA32:       ## BB#0: ## %entry
; FMA32-NEXT:    vfmadd213ps %xmm2, %xmm1, %xmm0 ## encoding: [0xc4,0xe2,0x71,0xa8,0xc2]
; FMA32-NEXT:    retl ## encoding: [0xc3]
;
; FMA64-LABEL: test_v4f32:
; FMA64:       ## BB#0: ## %entry
; FMA64-NEXT:    vfmadd213ps %xmm2, %xmm1, %xmm0 ## encoding: [0xc4,0xe2,0x71,0xa8,0xc2]
; FMA64-NEXT:    retq ## encoding: [0xc3]
;
; AVX512-LABEL: test_v4f32:
; AVX512:       ## BB#0: ## %entry
; AVX512-NEXT:    vfmadd213ps %xmm2, %xmm1, %xmm0 ## encoding: [0xc4,0xe2,0x71,0xa8,0xc2]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX512VL-LABEL: test_v4f32:
; AVX512VL:       ## BB#0: ## %entry
; AVX512VL-NEXT:    vfmadd213ps %xmm2, %xmm1, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe2,0x71,0xa8,0xc2]
; AVX512VL-NEXT:    retq ## encoding: [0xc3]
entry:
  %call = call <4 x float> @llvm.fma.v4f32(<4 x float> %a, <4 x float> %b, <4 x float> %c)
  ret <4 x float> %call
}

define <8 x float> @test_v8f32(<8 x float> %a, <8 x float> %b, <8 x float> %c) #0 {
; FMA32-LABEL: test_v8f32:
; FMA32:       ## BB#0: ## %entry
; FMA32-NEXT:    vfmadd213ps %ymm2, %ymm1, %ymm0 ## encoding: [0xc4,0xe2,0x75,0xa8,0xc2]
; FMA32-NEXT:    retl ## encoding: [0xc3]
;
; FMA64-LABEL: test_v8f32:
; FMA64:       ## BB#0: ## %entry
; FMA64-NEXT:    vfmadd213ps %ymm2, %ymm1, %ymm0 ## encoding: [0xc4,0xe2,0x75,0xa8,0xc2]
; FMA64-NEXT:    retq ## encoding: [0xc3]
;
; AVX512-LABEL: test_v8f32:
; AVX512:       ## BB#0: ## %entry
; AVX512-NEXT:    vfmadd213ps %ymm2, %ymm1, %ymm0 ## encoding: [0xc4,0xe2,0x75,0xa8,0xc2]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX512VL-LABEL: test_v8f32:
; AVX512VL:       ## BB#0: ## %entry
; AVX512VL-NEXT:    vfmadd213ps %ymm2, %ymm1, %ymm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe2,0x75,0xa8,0xc2]
; AVX512VL-NEXT:    retq ## encoding: [0xc3]
entry:
  %call = call <8 x float> @llvm.fma.v8f32(<8 x float> %a, <8 x float> %b, <8 x float> %c)
  ret <8 x float> %call
}

define <16 x float> @test_v16f32(<16 x float> %a, <16 x float> %b, <16 x float> %c) #0 {
; FMA32-LABEL: test_v16f32:
; FMA32:       ## BB#0: ## %entry
; FMA32-NEXT:    pushl %ebp ## encoding: [0x55]
; FMA32-NEXT:    movl %esp, %ebp ## encoding: [0x89,0xe5]
; FMA32-NEXT:    andl $-32, %esp ## encoding: [0x83,0xe4,0xe0]
; FMA32-NEXT:    subl $32, %esp ## encoding: [0x83,0xec,0x20]
; FMA32-NEXT:    vfmadd213ps 8(%ebp), %ymm2, %ymm0 ## encoding: [0xc4,0xe2,0x6d,0xa8,0x45,0x08]
; FMA32-NEXT:    vfmadd213ps 40(%ebp), %ymm3, %ymm1 ## encoding: [0xc4,0xe2,0x65,0xa8,0x4d,0x28]
; FMA32-NEXT:    movl %ebp, %esp ## encoding: [0x89,0xec]
; FMA32-NEXT:    popl %ebp ## encoding: [0x5d]
; FMA32-NEXT:    retl ## encoding: [0xc3]
;
; FMA64-LABEL: test_v16f32:
; FMA64:       ## BB#0: ## %entry
; FMA64-NEXT:    vfmadd213ps %ymm4, %ymm2, %ymm0 ## encoding: [0xc4,0xe2,0x6d,0xa8,0xc4]
; FMA64-NEXT:    vfmadd213ps %ymm5, %ymm3, %ymm1 ## encoding: [0xc4,0xe2,0x65,0xa8,0xcd]
; FMA64-NEXT:    retq ## encoding: [0xc3]
;
; AVX512-LABEL: test_v16f32:
; AVX512:       ## BB#0: ## %entry
; AVX512-NEXT:    vfmadd213ps %zmm2, %zmm1, %zmm0 ## encoding: [0x62,0xf2,0x75,0x48,0xa8,0xc2]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX512VL-LABEL: test_v16f32:
; AVX512VL:       ## BB#0: ## %entry
; AVX512VL-NEXT:    vfmadd213ps %zmm2, %zmm1, %zmm0 ## encoding: [0x62,0xf2,0x75,0x48,0xa8,0xc2]
; AVX512VL-NEXT:    retq ## encoding: [0xc3]
entry:
  %call = call <16 x float> @llvm.fma.v16f32(<16 x float> %a, <16 x float> %b, <16 x float> %c)
  ret <16 x float> %call
}

define <2 x double> @test_v2f64(<2 x double> %a, <2 x double> %b, <2 x double> %c) #0 {
; FMA32-LABEL: test_v2f64:
; FMA32:       ## BB#0: ## %entry
; FMA32-NEXT:    vfmadd213pd %xmm2, %xmm1, %xmm0 ## encoding: [0xc4,0xe2,0xf1,0xa8,0xc2]
; FMA32-NEXT:    retl ## encoding: [0xc3]
;
; FMA64-LABEL: test_v2f64:
; FMA64:       ## BB#0: ## %entry
; FMA64-NEXT:    vfmadd213pd %xmm2, %xmm1, %xmm0 ## encoding: [0xc4,0xe2,0xf1,0xa8,0xc2]
; FMA64-NEXT:    retq ## encoding: [0xc3]
;
; AVX512-LABEL: test_v2f64:
; AVX512:       ## BB#0: ## %entry
; AVX512-NEXT:    vfmadd213pd %xmm2, %xmm1, %xmm0 ## encoding: [0xc4,0xe2,0xf1,0xa8,0xc2]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX512VL-LABEL: test_v2f64:
; AVX512VL:       ## BB#0: ## %entry
; AVX512VL-NEXT:    vfmadd213pd %xmm2, %xmm1, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe2,0xf1,0xa8,0xc2]
; AVX512VL-NEXT:    retq ## encoding: [0xc3]
entry:
  %call = call <2 x double> @llvm.fma.v2f64(<2 x double> %a, <2 x double> %b, <2 x double> %c)
  ret <2 x double> %call
}

define <4 x double> @test_v4f64(<4 x double> %a, <4 x double> %b, <4 x double> %c) #0 {
; FMA32-LABEL: test_v4f64:
; FMA32:       ## BB#0: ## %entry
; FMA32-NEXT:    vfmadd213pd %ymm2, %ymm1, %ymm0 ## encoding: [0xc4,0xe2,0xf5,0xa8,0xc2]
; FMA32-NEXT:    retl ## encoding: [0xc3]
;
; FMA64-LABEL: test_v4f64:
; FMA64:       ## BB#0: ## %entry
; FMA64-NEXT:    vfmadd213pd %ymm2, %ymm1, %ymm0 ## encoding: [0xc4,0xe2,0xf5,0xa8,0xc2]
; FMA64-NEXT:    retq ## encoding: [0xc3]
;
; AVX512-LABEL: test_v4f64:
; AVX512:       ## BB#0: ## %entry
; AVX512-NEXT:    vfmadd213pd %ymm2, %ymm1, %ymm0 ## encoding: [0xc4,0xe2,0xf5,0xa8,0xc2]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX512VL-LABEL: test_v4f64:
; AVX512VL:       ## BB#0: ## %entry
; AVX512VL-NEXT:    vfmadd213pd %ymm2, %ymm1, %ymm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe2,0xf5,0xa8,0xc2]
; AVX512VL-NEXT:    retq ## encoding: [0xc3]
entry:
  %call = call <4 x double> @llvm.fma.v4f64(<4 x double> %a, <4 x double> %b, <4 x double> %c)
  ret <4 x double> %call
}

define <8 x double> @test_v8f64(<8 x double> %a, <8 x double> %b, <8 x double> %c) #0 {
; FMA32-LABEL: test_v8f64:
; FMA32:       ## BB#0: ## %entry
; FMA32-NEXT:    pushl %ebp ## encoding: [0x55]
; FMA32-NEXT:    movl %esp, %ebp ## encoding: [0x89,0xe5]
; FMA32-NEXT:    andl $-32, %esp ## encoding: [0x83,0xe4,0xe0]
; FMA32-NEXT:    subl $32, %esp ## encoding: [0x83,0xec,0x20]
; FMA32-NEXT:    vfmadd213pd 8(%ebp), %ymm2, %ymm0 ## encoding: [0xc4,0xe2,0xed,0xa8,0x45,0x08]
; FMA32-NEXT:    vfmadd213pd 40(%ebp), %ymm3, %ymm1 ## encoding: [0xc4,0xe2,0xe5,0xa8,0x4d,0x28]
; FMA32-NEXT:    movl %ebp, %esp ## encoding: [0x89,0xec]
; FMA32-NEXT:    popl %ebp ## encoding: [0x5d]
; FMA32-NEXT:    retl ## encoding: [0xc3]
;
; FMA64-LABEL: test_v8f64:
; FMA64:       ## BB#0: ## %entry
; FMA64-NEXT:    vfmadd213pd %ymm4, %ymm2, %ymm0 ## encoding: [0xc4,0xe2,0xed,0xa8,0xc4]
; FMA64-NEXT:    vfmadd213pd %ymm5, %ymm3, %ymm1 ## encoding: [0xc4,0xe2,0xe5,0xa8,0xcd]
; FMA64-NEXT:    retq ## encoding: [0xc3]
;
; AVX512-LABEL: test_v8f64:
; AVX512:       ## BB#0: ## %entry
; AVX512-NEXT:    vfmadd213pd %zmm2, %zmm1, %zmm0 ## encoding: [0x62,0xf2,0xf5,0x48,0xa8,0xc2]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX512VL-LABEL: test_v8f64:
; AVX512VL:       ## BB#0: ## %entry
; AVX512VL-NEXT:    vfmadd213pd %zmm2, %zmm1, %zmm0 ## encoding: [0x62,0xf2,0xf5,0x48,0xa8,0xc2]
; AVX512VL-NEXT:    retq ## encoding: [0xc3]
entry:
  %call = call <8 x double> @llvm.fma.v8f64(<8 x double> %a, <8 x double> %b, <8 x double> %c)
  ret <8 x double> %call
}

declare float @llvm.fma.f32(float, float, float)
declare double @llvm.fma.f64(double, double, double)
declare x86_fp80 @llvm.fma.f80(x86_fp80, x86_fp80, x86_fp80)

declare <4 x float> @llvm.fma.v4f32(<4 x float>, <4 x float>, <4 x float>)
declare <8 x float> @llvm.fma.v8f32(<8 x float>, <8 x float>, <8 x float>)
declare <16 x float> @llvm.fma.v16f32(<16 x float>, <16 x float>, <16 x float>)

declare <2 x double> @llvm.fma.v2f64(<2 x double>, <2 x double>, <2 x double>)
declare <4 x double> @llvm.fma.v4f64(<4 x double>, <4 x double>, <4 x double>)
declare <8 x double> @llvm.fma.v8f64(<8 x double>, <8 x double>, <8 x double>)

attributes #0 = { nounwind }
