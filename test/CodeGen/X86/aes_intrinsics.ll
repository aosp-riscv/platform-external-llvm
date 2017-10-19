; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown-unknown -mattr=+aes,-avx -show-mc-encoding | FileCheck %s --check-prefix=X86-SSE
; RUN: llc < %s -mtriple=i386-unknown-unknown -mattr=+aes,+avx -show-mc-encoding | FileCheck %s --check-prefix=X86-AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+aes,-avx -show-mc-encoding | FileCheck %s --check-prefix=X64-SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+aes,+avx -show-mc-encoding | FileCheck %s --check-prefix=X64-AVX

define <2 x i64> @test_x86_aesni_aesdec(<2 x i64> %a0, <2 x i64> %a1) {
; X86-SSE-LABEL: test_x86_aesni_aesdec:
; X86-SSE:       # BB#0:
; X86-SSE-NEXT:    aesdec %xmm1, %xmm0 # encoding: [0x66,0x0f,0x38,0xde,0xc1]
; X86-SSE-NEXT:    retl # encoding: [0xc3]
;
; X86-AVX-LABEL: test_x86_aesni_aesdec:
; X86-AVX:       # BB#0:
; X86-AVX-NEXT:    vaesdec %xmm1, %xmm0, %xmm0 # encoding: [0xc4,0xe2,0x79,0xde,0xc1]
; X86-AVX-NEXT:    retl # encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_aesni_aesdec:
; X64-SSE:       # BB#0:
; X64-SSE-NEXT:    aesdec %xmm1, %xmm0 # encoding: [0x66,0x0f,0x38,0xde,0xc1]
; X64-SSE-NEXT:    retq # encoding: [0xc3]
;
; X64-AVX-LABEL: test_x86_aesni_aesdec:
; X64-AVX:       # BB#0:
; X64-AVX-NEXT:    vaesdec %xmm1, %xmm0, %xmm0 # encoding: [0xc4,0xe2,0x79,0xde,0xc1]
; X64-AVX-NEXT:    retq # encoding: [0xc3]
  %res = call <2 x i64> @llvm.x86.aesni.aesdec(<2 x i64> %a0, <2 x i64> %a1) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.aesni.aesdec(<2 x i64>, <2 x i64>) nounwind readnone


define <2 x i64> @test_x86_aesni_aesdeclast(<2 x i64> %a0, <2 x i64> %a1) {
; X86-SSE-LABEL: test_x86_aesni_aesdeclast:
; X86-SSE:       # BB#0:
; X86-SSE-NEXT:    aesdeclast %xmm1, %xmm0 # encoding: [0x66,0x0f,0x38,0xdf,0xc1]
; X86-SSE-NEXT:    retl # encoding: [0xc3]
;
; X86-AVX-LABEL: test_x86_aesni_aesdeclast:
; X86-AVX:       # BB#0:
; X86-AVX-NEXT:    vaesdeclast %xmm1, %xmm0, %xmm0 # encoding: [0xc4,0xe2,0x79,0xdf,0xc1]
; X86-AVX-NEXT:    retl # encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_aesni_aesdeclast:
; X64-SSE:       # BB#0:
; X64-SSE-NEXT:    aesdeclast %xmm1, %xmm0 # encoding: [0x66,0x0f,0x38,0xdf,0xc1]
; X64-SSE-NEXT:    retq # encoding: [0xc3]
;
; X64-AVX-LABEL: test_x86_aesni_aesdeclast:
; X64-AVX:       # BB#0:
; X64-AVX-NEXT:    vaesdeclast %xmm1, %xmm0, %xmm0 # encoding: [0xc4,0xe2,0x79,0xdf,0xc1]
; X64-AVX-NEXT:    retq # encoding: [0xc3]
  %res = call <2 x i64> @llvm.x86.aesni.aesdeclast(<2 x i64> %a0, <2 x i64> %a1) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.aesni.aesdeclast(<2 x i64>, <2 x i64>) nounwind readnone


define <2 x i64> @test_x86_aesni_aesenc(<2 x i64> %a0, <2 x i64> %a1) {
; X86-SSE-LABEL: test_x86_aesni_aesenc:
; X86-SSE:       # BB#0:
; X86-SSE-NEXT:    aesenc %xmm1, %xmm0 # encoding: [0x66,0x0f,0x38,0xdc,0xc1]
; X86-SSE-NEXT:    retl # encoding: [0xc3]
;
; X86-AVX-LABEL: test_x86_aesni_aesenc:
; X86-AVX:       # BB#0:
; X86-AVX-NEXT:    vaesenc %xmm1, %xmm0, %xmm0 # encoding: [0xc4,0xe2,0x79,0xdc,0xc1]
; X86-AVX-NEXT:    retl # encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_aesni_aesenc:
; X64-SSE:       # BB#0:
; X64-SSE-NEXT:    aesenc %xmm1, %xmm0 # encoding: [0x66,0x0f,0x38,0xdc,0xc1]
; X64-SSE-NEXT:    retq # encoding: [0xc3]
;
; X64-AVX-LABEL: test_x86_aesni_aesenc:
; X64-AVX:       # BB#0:
; X64-AVX-NEXT:    vaesenc %xmm1, %xmm0, %xmm0 # encoding: [0xc4,0xe2,0x79,0xdc,0xc1]
; X64-AVX-NEXT:    retq # encoding: [0xc3]
  %res = call <2 x i64> @llvm.x86.aesni.aesenc(<2 x i64> %a0, <2 x i64> %a1) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.aesni.aesenc(<2 x i64>, <2 x i64>) nounwind readnone


define <2 x i64> @test_x86_aesni_aesenclast(<2 x i64> %a0, <2 x i64> %a1) {
; X86-SSE-LABEL: test_x86_aesni_aesenclast:
; X86-SSE:       # BB#0:
; X86-SSE-NEXT:    aesenclast %xmm1, %xmm0 # encoding: [0x66,0x0f,0x38,0xdd,0xc1]
; X86-SSE-NEXT:    retl # encoding: [0xc3]
;
; X86-AVX-LABEL: test_x86_aesni_aesenclast:
; X86-AVX:       # BB#0:
; X86-AVX-NEXT:    vaesenclast %xmm1, %xmm0, %xmm0 # encoding: [0xc4,0xe2,0x79,0xdd,0xc1]
; X86-AVX-NEXT:    retl # encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_aesni_aesenclast:
; X64-SSE:       # BB#0:
; X64-SSE-NEXT:    aesenclast %xmm1, %xmm0 # encoding: [0x66,0x0f,0x38,0xdd,0xc1]
; X64-SSE-NEXT:    retq # encoding: [0xc3]
;
; X64-AVX-LABEL: test_x86_aesni_aesenclast:
; X64-AVX:       # BB#0:
; X64-AVX-NEXT:    vaesenclast %xmm1, %xmm0, %xmm0 # encoding: [0xc4,0xe2,0x79,0xdd,0xc1]
; X64-AVX-NEXT:    retq # encoding: [0xc3]
  %res = call <2 x i64> @llvm.x86.aesni.aesenclast(<2 x i64> %a0, <2 x i64> %a1) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.aesni.aesenclast(<2 x i64>, <2 x i64>) nounwind readnone


define <2 x i64> @test_x86_aesni_aesimc(<2 x i64> %a0) {
; X86-SSE-LABEL: test_x86_aesni_aesimc:
; X86-SSE:       # BB#0:
; X86-SSE-NEXT:    aesimc %xmm0, %xmm0 # encoding: [0x66,0x0f,0x38,0xdb,0xc0]
; X86-SSE-NEXT:    retl # encoding: [0xc3]
;
; X86-AVX-LABEL: test_x86_aesni_aesimc:
; X86-AVX:       # BB#0:
; X86-AVX-NEXT:    vaesimc %xmm0, %xmm0 # encoding: [0xc4,0xe2,0x79,0xdb,0xc0]
; X86-AVX-NEXT:    retl # encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_aesni_aesimc:
; X64-SSE:       # BB#0:
; X64-SSE-NEXT:    aesimc %xmm0, %xmm0 # encoding: [0x66,0x0f,0x38,0xdb,0xc0]
; X64-SSE-NEXT:    retq # encoding: [0xc3]
;
; X64-AVX-LABEL: test_x86_aesni_aesimc:
; X64-AVX:       # BB#0:
; X64-AVX-NEXT:    vaesimc %xmm0, %xmm0 # encoding: [0xc4,0xe2,0x79,0xdb,0xc0]
; X64-AVX-NEXT:    retq # encoding: [0xc3]
  %res = call <2 x i64> @llvm.x86.aesni.aesimc(<2 x i64> %a0) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.aesni.aesimc(<2 x i64>) nounwind readnone


define <2 x i64> @test_x86_aesni_aeskeygenassist(<2 x i64> %a0) {
; X86-SSE-LABEL: test_x86_aesni_aeskeygenassist:
; X86-SSE:       # BB#0:
; X86-SSE-NEXT:    aeskeygenassist $7, %xmm0, %xmm0 # encoding: [0x66,0x0f,0x3a,0xdf,0xc0,0x07]
; X86-SSE-NEXT:    retl # encoding: [0xc3]
;
; X86-AVX-LABEL: test_x86_aesni_aeskeygenassist:
; X86-AVX:       # BB#0:
; X86-AVX-NEXT:    vaeskeygenassist $7, %xmm0, %xmm0 # encoding: [0xc4,0xe3,0x79,0xdf,0xc0,0x07]
; X86-AVX-NEXT:    retl # encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_aesni_aeskeygenassist:
; X64-SSE:       # BB#0:
; X64-SSE-NEXT:    aeskeygenassist $7, %xmm0, %xmm0 # encoding: [0x66,0x0f,0x3a,0xdf,0xc0,0x07]
; X64-SSE-NEXT:    retq # encoding: [0xc3]
;
; X64-AVX-LABEL: test_x86_aesni_aeskeygenassist:
; X64-AVX:       # BB#0:
; X64-AVX-NEXT:    vaeskeygenassist $7, %xmm0, %xmm0 # encoding: [0xc4,0xe3,0x79,0xdf,0xc0,0x07]
; X64-AVX-NEXT:    retq # encoding: [0xc3]
  %res = call <2 x i64> @llvm.x86.aesni.aeskeygenassist(<2 x i64> %a0, i8 7) ; <<2 x i64>> [#uses=1]
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.aesni.aeskeygenassist(<2 x i64>, i8) nounwind readnone
