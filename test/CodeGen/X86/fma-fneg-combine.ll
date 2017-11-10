; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+avx512bw -mattr=+avx512vl -mattr=+avx512dq  | FileCheck %s  --check-prefix=CHECK --check-prefix=SKX
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+avx512f -mattr=+fma | FileCheck %s --check-prefix=CHECK --check-prefix=KNL

; This test checks combinations of FNEG and FMA intrinsics on AVX-512 target
; PR28892

define <16 x float> @test1(<16 x float> %a, <16 x float> %b, <16 x float> %c)  {
; CHECK-LABEL: test1:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    vfmsub213ps %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    retq
entry:
  %sub.i = fsub <16 x float> <float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00>, %c
  %0 = tail call <16 x float> @llvm.x86.avx512.mask.vfmadd.ps.512(<16 x float> %a, <16 x float> %b, <16 x float> %sub.i, i16 -1, i32 4) #2
  ret <16 x float> %0
}

declare <16 x float> @llvm.x86.avx512.mask.vfmadd.ps.512(<16 x float>, <16 x float>, <16 x float>, i16, i32)
declare <16 x float> @llvm.x86.avx512.mask.vfnmadd.ps.512(<16 x float>, <16 x float>, <16 x float>, i16, i32)
declare <16 x float> @llvm.x86.avx512.mask.vfnmsub.ps.512(<16 x float>, <16 x float>, <16 x float>, i16, i32)


define <16 x float> @test2(<16 x float> %a, <16 x float> %b, <16 x float> %c) {
; CHECK-LABEL: test2:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    vfnmsub213ps %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    retq
entry:
  %0 = tail call <16 x float> @llvm.x86.avx512.mask.vfmadd.ps.512(<16 x float> %a, <16 x float> %b, <16 x float> %c, i16 -1, i32 4) #2
  %sub.i = fsub <16 x float> <float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00>, %0
  ret <16 x float> %sub.i
}

define <16 x float> @test3(<16 x float> %a, <16 x float> %b, <16 x float> %c)  {
; CHECK-LABEL: test3:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    vfmsub213ps %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    retq
entry:
  %0 = tail call <16 x float> @llvm.x86.avx512.mask.vfnmadd.ps.512(<16 x float> %a, <16 x float> %b, <16 x float> %c, i16 -1, i32 4) #2
  %sub.i = fsub <16 x float> <float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00>, %0
  ret <16 x float> %sub.i
}

define <16 x float> @test4(<16 x float> %a, <16 x float> %b, <16 x float> %c) {
; CHECK-LABEL: test4:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    vfmadd213ps %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    retq
entry:
  %0 = tail call <16 x float> @llvm.x86.avx512.mask.vfnmsub.ps.512(<16 x float> %a, <16 x float> %b, <16 x float> %c, i16 -1, i32 4) #2
  %sub.i = fsub <16 x float> <float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00>, %0
  ret <16 x float> %sub.i
}

define <16 x float> @test5(<16 x float> %a, <16 x float> %b, <16 x float> %c) {
; CHECK-LABEL: test5:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    vfmsub213ps {ru-sae}, %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    retq
entry:
  %sub.i = fsub <16 x float> <float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00>, %c
  %0 = tail call <16 x float> @llvm.x86.avx512.mask.vfmadd.ps.512(<16 x float> %a, <16 x float> %b, <16 x float> %sub.i, i16 -1, i32 2) #2
  ret <16 x float> %0
}

define <16 x float> @test6(<16 x float> %a, <16 x float> %b, <16 x float> %c) {
; CHECK-LABEL: test6:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    vfmadd213ps {ru-sae}, %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    retq
entry:
  %0 = tail call <16 x float> @llvm.x86.avx512.mask.vfnmsub.ps.512(<16 x float> %a, <16 x float> %b, <16 x float> %c, i16 -1, i32 2) #2
  %sub.i = fsub <16 x float> <float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00>, %0
  ret <16 x float> %sub.i
}


define <8 x float> @test7(<8 x float> %a, <8 x float> %b, <8 x float> %c) {
; CHECK-LABEL: test7:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    vfnmadd213ps %ymm2, %ymm1, %ymm0
; CHECK-NEXT:    retq
entry:
  %0 = tail call <8 x float> @llvm.x86.fma.vfmsub.ps.256(<8 x float> %a, <8 x float> %b, <8 x float> %c) #2
  %sub.i = fsub <8 x float> <float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00>, %0
  ret <8 x float> %sub.i
}

define <8 x float> @test8(<8 x float> %a, <8 x float> %b, <8 x float> %c) {
; SKX-LABEL: test8:
; SKX:       # BB#0: # %entry
; SKX-NEXT:    vxorps {{.*}}(%rip){1to8}, %ymm2, %ymm2
; SKX-NEXT:    vfmsub213ps %ymm2, %ymm1, %ymm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test8:
; KNL:       # BB#0: # %entry
; KNL-NEXT:    vbroadcastss {{.*#+}} ymm3 = [-0,-0,-0,-0,-0,-0,-0,-0]
; KNL-NEXT:    vxorps %ymm3, %ymm2, %ymm2
; KNL-NEXT:    vfmsub213ps %ymm2, %ymm1, %ymm0
; KNL-NEXT:    retq
entry:
  %sub.c = fsub <8 x float> <float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00>, %c
  %0 = tail call <8 x float> @llvm.x86.fma.vfmsub.ps.256(<8 x float> %a, <8 x float> %b, <8 x float> %sub.c) #2
  ret <8 x float> %0
}

declare <8 x float> @llvm.x86.fma.vfmsub.ps.256(<8 x float>, <8 x float>, <8 x float>)


define <8 x double> @test9(<8 x double> %a, <8 x double> %b, <8 x double> %c) {
; CHECK-LABEL: test9:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    vfnmsub213pd %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    retq
entry:
  %0 = tail call <8 x double> @llvm.x86.avx512.mask.vfmadd.pd.512(<8 x double> %a, <8 x double> %b, <8 x double> %c, i8 -1, i32 4) #2
  %sub.i = fsub <8 x double> <double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00>, %0
  ret <8 x double> %sub.i
}

declare <8 x double> @llvm.x86.avx512.mask.vfmadd.pd.512(<8 x double> %a, <8 x double> %b, <8 x double> %c, i8, i32)

define <2 x double> @test10(<2 x double> %a, <2 x double> %b, <2 x double> %c) {
; CHECK-LABEL: test10:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    vfmadd213sd %xmm2, %xmm1, %xmm0
; CHECK-NEXT:    vxorpd {{.*}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    retq
entry:
  %0 = tail call <2 x double> @llvm.x86.avx512.mask.vfmadd.sd(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8 -1, i32 4) #2
  %sub.i = fsub <2 x double> <double -0.000000e+00, double -0.000000e+00>, %0
  ret <2 x double> %sub.i
}

declare <2 x double> @llvm.x86.avx512.mask.vfmadd.sd(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8, i32)

define <4 x float> @test11(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 zeroext %mask) local_unnamed_addr #0 {
; SKX-LABEL: test11:
; SKX:       # BB#0: # %entry
; SKX-NEXT:    vxorps {{.*}}(%rip){1to4}, %xmm2, %xmm0
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfmadd231ss %xmm1, %xmm1, %xmm0 {%k1}
; SKX-NEXT:    retq
;
; KNL-LABEL: test11:
; KNL:       # BB#0: # %entry
; KNL-NEXT:    vbroadcastss {{.*#+}} xmm0 = [-0,-0,-0,-0]
; KNL-NEXT:    vxorps %xmm0, %xmm2, %xmm0
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfmadd231ss %xmm1, %xmm1, %xmm0 {%k1}
; KNL-NEXT:    retq
entry:
  %sub.i = fsub <4 x float> <float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00>, %c
  %0 = tail call <4 x float> @llvm.x86.avx512.mask3.vfmadd.ss(<4 x float> %b, <4 x float> %b, <4 x float> %sub.i, i8 %mask, i32 4) #10
  ret <4 x float> %0
}

declare <4 x float> @llvm.x86.avx512.mask3.vfmadd.ss(<4 x float>, <4 x float>, <4 x float>, i8, i32)

define <4 x float> @test11b(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 zeroext %mask) local_unnamed_addr #0 {
; SKX-LABEL: test11b:
; SKX:       # BB#0: # %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfmsub213ss %xmm2, %xmm1, %xmm1 {%k1}
; SKX-NEXT:    vmovaps %xmm1, %xmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test11b:
; KNL:       # BB#0: # %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfmsub213ss %xmm2, %xmm1, %xmm1 {%k1}
; KNL-NEXT:    vmovaps %xmm1, %xmm0
; KNL-NEXT:    retq
entry:
  %sub.i = fsub <4 x float> <float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00>, %c
  %0 = tail call <4 x float> @llvm.x86.avx512.mask.vfmadd.ss(<4 x float> %b, <4 x float> %b, <4 x float> %sub.i, i8 %mask, i32 4) #10
  ret <4 x float> %0
}

declare <4 x float> @llvm.x86.avx512.mask.vfmadd.ss(<4 x float>, <4 x float>, <4 x float>, i8, i32)

define <8 x double> @test12(<8 x double> %a, <8 x double> %b, <8 x double> %c, i8 %mask) {
; SKX-LABEL: test12:
; SKX:       # BB#0: # %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfmadd132pd %zmm1, %zmm2, %zmm0 {%k1}
; SKX-NEXT:    vxorpd {{.*}}(%rip){1to8}, %zmm0, %zmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test12:
; KNL:       # BB#0: # %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfmadd132pd %zmm1, %zmm2, %zmm0 {%k1}
; KNL-NEXT:    vpxorq {{.*}}(%rip){1to8}, %zmm0, %zmm0
; KNL-NEXT:    retq
entry:
  %0 = tail call <8 x double> @llvm.x86.avx512.mask.vfmadd.pd.512(<8 x double> %a, <8 x double> %b, <8 x double> %c, i8 %mask, i32 4) #2
  %sub.i = fsub <8 x double> <double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00>, %0
  ret <8 x double> %sub.i
}

define <2 x double> @test13(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8 %mask) {
; SKX-LABEL: test13:
; SKX:       # BB#0: # %entry
; SKX-NEXT:    vxorpd {{.*}}(%rip), %xmm0, %xmm0
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfmadd213sd %xmm2, %xmm1, %xmm0 {%k1}
; SKX-NEXT:    retq
;
; KNL-LABEL: test13:
; KNL:       # BB#0: # %entry
; KNL-NEXT:    vxorpd {{.*}}(%rip), %xmm0, %xmm0
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfmadd213sd %xmm2, %xmm1, %xmm0 {%k1}
; KNL-NEXT:    retq

entry:
  %sub.i = fsub <2 x double> <double -0.000000e+00, double -0.000000e+00>, %a
  %0 = tail call <2 x double> @llvm.x86.avx512.mask.vfmadd.sd(<2 x double> %sub.i, <2 x double> %b, <2 x double> %c, i8 %mask, i32 4)
  ret <2 x double> %0
}

define <16 x float> @test14(<16 x float> %a, <16 x float> %b, <16 x float> %c, i16 %mask) {
; SKX-LABEL: test14:
; SKX:       # BB#0: # %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfnmsub132ps {ru-sae}, %zmm1, %zmm2, %zmm0 {%k1}
; SKX-NEXT:    vxorps {{.*}}(%rip){1to16}, %zmm0, %zmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test14:
; KNL:       # BB#0: # %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfnmsub132ps {ru-sae}, %zmm1, %zmm2, %zmm0 {%k1}
; KNL-NEXT:    vpxord {{.*}}(%rip){1to16}, %zmm0, %zmm0
; KNL-NEXT:    retq
entry:
  %0 = tail call <16 x float> @llvm.x86.avx512.mask.vfnmsub.ps.512(<16 x float> %a, <16 x float> %b, <16 x float> %c, i16 %mask, i32 2) #2
  %sub.i = fsub <16 x float> <float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00>, %0
  ret <16 x float> %sub.i
}

define <16 x float> @test15(<16 x float> %a, <16 x float> %b, <16 x float> %c, i16 %mask)  {
; SKX-LABEL: test15:
; SKX:       # BB#0: # %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vxorps {{.*}}(%rip){1to16}, %zmm0, %zmm3
; SKX-NEXT:    vfnmadd213ps {ru-sae}, %zmm2, %zmm0, %zmm1
; SKX-NEXT:    vmovaps %zmm1, %zmm3 {%k1}
; SKX-NEXT:    vfnmadd132ps {rd-sae}, %zmm0, %zmm2, %zmm3 {%k1}
; SKX-NEXT:    vmovaps %zmm3, %zmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test15:
; KNL:       # BB#0: # %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpxord {{.*}}(%rip){1to16}, %zmm0, %zmm3
; KNL-NEXT:    vfnmadd213ps {ru-sae}, %zmm2, %zmm0, %zmm1
; KNL-NEXT:    vmovaps %zmm1, %zmm3 {%k1}
; KNL-NEXT:    vfnmadd132ps {rd-sae}, %zmm0, %zmm2, %zmm3 {%k1}
; KNL-NEXT:    vmovaps %zmm3, %zmm0
; KNL-NEXT:    retq
entry:
  %sub.i = fsub <16 x float> <float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00>, %a
  %0 = tail call <16 x float> @llvm.x86.avx512.mask.vfmadd.ps.512(<16 x float> %sub.i, <16 x float> %b, <16 x float> %c, i16 %mask, i32 2)
  %1 = tail call <16 x float> @llvm.x86.avx512.mask.vfmadd.ps.512(<16 x float> %0, <16 x float> %sub.i, <16 x float> %c, i16 %mask, i32 1)
  ret <16 x float> %1
}

define <16 x float> @test16(<16 x float> %a, <16 x float> %b, <16 x float> %c, i16 %mask) {
; SKX-LABEL: test16:
; SKX:       # BB#0:
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfmsubadd132ps {rd-sae}, %zmm1, %zmm2, %zmm0 {%k1}
; SKX-NEXT:    retq
;
; KNL-LABEL: test16:
; KNL:       # BB#0:
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfmsubadd132ps {rd-sae}, %zmm1, %zmm2, %zmm0 {%k1}
; KNL-NEXT:    retq
  %sub.i = fsub <16 x float> <float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00, float -0.000000e+00>, %c
  %res = call <16 x float> @llvm.x86.avx512.mask.vfmaddsub.ps.512(<16 x float> %a, <16 x float> %b, <16 x float> %sub.i, i16 %mask, i32 1)
  ret <16 x float> %res
}
declare <16 x float> @llvm.x86.avx512.mask.vfmaddsub.ps.512(<16 x float>, <16 x float>, <16 x float>, i16, i32)

define <8 x double> @test17(<8 x double> %a, <8 x double> %b, <8 x double> %c, i8 %mask) {
; SKX-LABEL: test17:
; SKX:       # BB#0:
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfmsubadd132pd %zmm1, %zmm2, %zmm0 {%k1}
; SKX-NEXT:    retq
;
; KNL-LABEL: test17:
; KNL:       # BB#0:
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfmsubadd132pd %zmm1, %zmm2, %zmm0 {%k1}
; KNL-NEXT:    retq
  %sub.i = fsub <8 x double> <double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00, double -0.000000e+00>, %c
  %res = call <8 x double> @llvm.x86.avx512.mask.vfmaddsub.pd.512(<8 x double> %a, <8 x double> %b, <8 x double> %sub.i, i8 %mask, i32 4)
  ret <8 x double> %res
}
declare <8 x double> @llvm.x86.avx512.mask.vfmaddsub.pd.512(<8 x double>, <8 x double>, <8 x double>, i8, i32)
