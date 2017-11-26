; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-apple-darwin -mattr=+gfni,+avx -show-mc-encoding | FileCheck %s

declare <16 x i8> @llvm.x86.vgf2p8affineinvqb.128(<16 x i8>, <16 x i8>, i8)
define <16 x i8> @test_vgf2p8affineinvqb_128(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: test_vgf2p8affineinvqb_128:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vgf2p8affineinvqb $11, %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0xf9,0xcf,0xc1,0x0b]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = call <16 x i8> @llvm.x86.vgf2p8affineinvqb.128(<16 x i8> %src1, <16 x i8> %src2, i8 11)
  ret <16 x i8> %1
}

declare <32 x i8> @llvm.x86.vgf2p8affineinvqb.256(<32 x i8>, <32 x i8>, i8)
define <32 x i8> @test_vgf2p8affineinvqb_256(<32 x i8> %src1, <32 x i8> %src2) {
; CHECK-LABEL: test_vgf2p8affineinvqb_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vgf2p8affineinvqb $11, %ymm1, %ymm0, %ymm0 ## encoding: [0xc4,0xe3,0xfd,0xcf,0xc1,0x0b]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = call <32 x i8> @llvm.x86.vgf2p8affineinvqb.256(<32 x i8> %src1, <32 x i8> %src2, i8 11)
  ret <32 x i8> %1
}

declare <16 x i8> @llvm.x86.vgf2p8affineqb.128(<16 x i8>, <16 x i8>, i8)
define <16 x i8> @test_vgf2p8affineqb(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: test_vgf2p8affineqb:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vgf2p8affineqb $11, %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0xf9,0xce,0xc1,0x0b]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = call <16 x i8> @llvm.x86.vgf2p8affineqb.128(<16 x i8> %src1, <16 x i8> %src2, i8 11)
  ret <16 x i8> %1
}

declare <32 x i8> @llvm.x86.vgf2p8affineqb.256(<32 x i8>, <32 x i8>, i8)
define <32 x i8> @test_vgf2p8affineqb_256(<32 x i8> %src1, <32 x i8> %src2) {
; CHECK-LABEL: test_vgf2p8affineqb_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vgf2p8affineqb $11, %ymm1, %ymm0, %ymm0 ## encoding: [0xc4,0xe3,0xfd,0xce,0xc1,0x0b]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = call <32 x i8> @llvm.x86.vgf2p8affineqb.256(<32 x i8> %src1, <32 x i8> %src2, i8 11)
  ret <32 x i8> %1
}

declare <16 x i8> @llvm.x86.vgf2p8mulb.128(<16 x i8>, <16 x i8>)
define <16 x i8> @test_vgf2p8mulb_128(<16 x i8> %src1, <16 x i8> %src2) {
; CHECK-LABEL: test_vgf2p8mulb_128:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vgf2p8mulb %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0xcf,0xc1]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = call <16 x i8> @llvm.x86.vgf2p8mulb.128(<16 x i8> %src1, <16 x i8> %src2)
  ret <16 x i8> %1
}

declare <32 x i8> @llvm.x86.vgf2p8mulb.256(<32 x i8>, <32 x i8>)
define <32 x i8> @test_vgf2p8mulb_256(<32 x i8> %src1, <32 x i8> %src2) {
; CHECK-LABEL: test_vgf2p8mulb_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vgf2p8mulb %ymm1, %ymm0, %ymm0 ## encoding: [0xc4,0xe2,0x7d,0xcf,0xc1]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = call <32 x i8> @llvm.x86.vgf2p8mulb.256(<32 x i8> %src1, <32 x i8> %src2)
  ret <32 x i8> %1
}

