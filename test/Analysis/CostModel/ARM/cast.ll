; RUN: opt < %s  -cost-model -analyze -mtriple=thumbv7-apple-ios6.0.0 -mcpu=cortex-a8 | FileCheck %s
target datalayout = "e-p:32:32:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:32:64-v128:32:128-a0:0:32-n32-S32"
target triple = "thumbv7-apple-ios6.0.0"

define i32 @casts() {

    ; -- scalars --
  ; CHECK: Found an estimated cost of 1 for instruction:   %r0 = sext i1 undef to i8
  %r0 = sext i1 undef to i8
  ; CHECK: Found an estimated cost of 1 for instruction:   %r1 = zext i1 undef to i8
  %r1 = zext i1 undef to i8
  ; CHECK: Found an estimated cost of 1 for instruction:   %r2 = sext i1 undef to i16
  %r2 = sext i1 undef to i16
  ; CHECK: Found an estimated cost of 1 for instruction:   %r3 = zext i1 undef to i16
  %r3 = zext i1 undef to i16
  ; CHECK: Found an estimated cost of 1 for instruction:   %r4 = sext i1 undef to i32
  %r4 = sext i1 undef to i32
  ; CHECK: Found an estimated cost of 1 for instruction:   %r5 = zext i1 undef to i32
  %r5 = zext i1 undef to i32
  ; CHECK: Found an estimated cost of 1 for instruction:   %r6 = sext i1 undef to i64
  %r6 = sext i1 undef to i64
  ; CHECK: Found an estimated cost of 1 for instruction:   %r7 = zext i1 undef to i64
  %r7 = zext i1 undef to i64
  ; CHECK: Found an estimated cost of 0 for instruction:   %r8 = trunc i8 undef to i1
  %r8 = trunc i8 undef to i1
  ; CHECK: Found an estimated cost of 1 for instruction:   %r9 = sext i8 undef to i16
  %r9 = sext i8 undef to i16
  ; CHECK: Found an estimated cost of 1 for instruction:   %r10 = zext i8 undef to i16
  %r10 = zext i8 undef to i16
  ; CHECK: Found an estimated cost of 1 for instruction:   %r11 = sext i8 undef to i32
  %r11 = sext i8 undef to i32
  ; CHECK: Found an estimated cost of 1 for instruction:   %r12 = zext i8 undef to i32
  %r12 = zext i8 undef to i32
  ; CHECK: Found an estimated cost of 1 for instruction:   %r13 = sext i8 undef to i64
  %r13 = sext i8 undef to i64
  ; CHECK: Found an estimated cost of 1 for instruction:   %r14 = zext i8 undef to i64
  %r14 = zext i8 undef to i64
  ; CHECK: Found an estimated cost of 0 for instruction:   %r15 = trunc i16 undef to i1
  %r15 = trunc i16 undef to i1
  ; CHECK: Found an estimated cost of 0 for instruction:   %r16 = trunc i16 undef to i8
  %r16 = trunc i16 undef to i8
  ; CHECK: Found an estimated cost of 1 for instruction:   %r17 = sext i16 undef to i32
  %r17 = sext i16 undef to i32
  ; CHECK: Found an estimated cost of 1 for instruction:   %r18 = zext i16 undef to i32
  %r18 = zext i16 undef to i32
  ; CHECK: Found an estimated cost of 2 for instruction:   %r19 = sext i16 undef to i64
  %r19 = sext i16 undef to i64
  ; CHECK: Found an estimated cost of 1 for instruction:   %r20 = zext i16 undef to i64
  %r20 = zext i16 undef to i64
  ; CHECK: Found an estimated cost of 0 for instruction:   %r21 = trunc i32 undef to i1
  %r21 = trunc i32 undef to i1
  ; CHECK: Found an estimated cost of 0 for instruction:   %r22 = trunc i32 undef to i8
  %r22 = trunc i32 undef to i8
  ; CHECK: Found an estimated cost of 0 for instruction:   %r23 = trunc i32 undef to i16
  %r23 = trunc i32 undef to i16
  ; CHECK: Found an estimated cost of 1 for instruction:   %r24 = sext i32 undef to i64
  %r24 = sext i32 undef to i64
  ; CHECK: Found an estimated cost of 1 for instruction:   %r25 = zext i32 undef to i64
  %r25 = zext i32 undef to i64
  ; CHECK: Found an estimated cost of 0 for instruction:   %r26 = trunc i64 undef to i1
  %r26 = trunc i64 undef to i1
  ; CHECK: Found an estimated cost of 0 for instruction:   %r27 = trunc i64 undef to i8
  %r27 = trunc i64 undef to i8
  ; CHECK: Found an estimated cost of 0 for instruction:   %r28 = trunc i64 undef to i16
  %r28 = trunc i64 undef to i16
  ; CHECK: Found an estimated cost of 0 for instruction:   %r29 = trunc i64 undef to i32
  %r29 = trunc i64 undef to i32

    ; -- floating point conversions --
  ; Moves between scalar and NEON registers.
  ; CHECK: Found an estimated cost of 2 for instruction:   %r30 = fptoui float undef to i1
  %r30 = fptoui float undef to i1
  ; CHECK: Found an estimated cost of 2 for instruction:   %r31 = fptosi float undef to i1
  %r31 = fptosi float undef to i1
  ; CHECK: Found an estimated cost of 2 for instruction:   %r32 = fptoui float undef to i8
  %r32 = fptoui float undef to i8
  ; CHECK: Found an estimated cost of 2 for instruction:   %r33 = fptosi float undef to i8
  %r33 = fptosi float undef to i8
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r34 = fptoui float undef to i16
  %r34 = fptoui float undef to i16
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r35 = fptosi float undef to i16
  %r35 = fptosi float undef to i16
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r36 = fptoui float undef to i32
  %r36 = fptoui float undef to i32
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r37 = fptosi float undef to i32
  %r37 = fptosi float undef to i32
  ; CHECK:  Found an estimated cost of 10 for instruction:   %r38 = fptoui float undef to i64
  %r38 = fptoui float undef to i64
  ; CHECK:  Found an estimated cost of 10 for instruction:   %r39 = fptosi float undef to i64
  %r39 = fptosi float undef to i64
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r40 = fptoui double undef to i1
  %r40 = fptoui double undef to i1
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r41 = fptosi double undef to i1
  %r41 = fptosi double undef to i1
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r42 = fptoui double undef to i8
  %r42 = fptoui double undef to i8
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r43 = fptosi double undef to i8
  %r43 = fptosi double undef to i8
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r44 = fptoui double undef to i16
  %r44 = fptoui double undef to i16
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r45 = fptosi double undef to i16
  %r45 = fptosi double undef to i16
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r46 = fptoui double undef to i32
  %r46 = fptoui double undef to i32
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r47 = fptosi double undef to i32
  %r47 = fptosi double undef to i32
  ; Function call
  ; CHECK:  Found an estimated cost of 10 for instruction:   %r48 = fptoui double undef to i64
  %r48 = fptoui double undef to i64
  ; CHECK:  Found an estimated cost of 10 for instruction:   %r49 = fptosi double undef to i64
  %r49 = fptosi double undef to i64

  ; CHECK:  Found an estimated cost of 2 for instruction:   %r50 = sitofp i1 undef to float
  %r50 = sitofp i1 undef to float
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r51 = uitofp i1 undef to float
  %r51 = uitofp i1 undef to float
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r52 = sitofp i1 undef to double
  %r52 = sitofp i1 undef to double
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r53 = uitofp i1 undef to double
  %r53 = uitofp i1 undef to double
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r54 = sitofp i8 undef to float
  %r54 = sitofp i8 undef to float
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r55 = uitofp i8 undef to float
  %r55 = uitofp i8 undef to float
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r56 = sitofp i8 undef to double
  %r56 = sitofp i8 undef to double
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r57 = uitofp i8 undef to double
  %r57 = uitofp i8 undef to double
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r58 = sitofp i16 undef to float
  %r58 = sitofp i16 undef to float
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r59 = uitofp i16 undef to float
  %r59 = uitofp i16 undef to float
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r60 = sitofp i16 undef to double
  %r60 = sitofp i16 undef to double
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r61 = uitofp i16 undef to double
  %r61 = uitofp i16 undef to double
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r62 = sitofp i32 undef to float
  %r62 = sitofp i32 undef to float
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r63 = uitofp i32 undef to float
  %r63 = uitofp i32 undef to float
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r64 = sitofp i32 undef to double
  %r64 = sitofp i32 undef to double
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r65 = uitofp i32 undef to double
  %r65 = uitofp i32 undef to double
  ; Function call
  ; CHECK:  Found an estimated cost of 10 for instruction:   %r66 = sitofp i64 undef to float
  %r66 = sitofp i64 undef to float
  ; CHECK:  Found an estimated cost of 10 for instruction:   %r67 = uitofp i64 undef to float
  %r67 = uitofp i64 undef to float
  ; CHECK:  Found an estimated cost of 10 for instruction:   %r68 = sitofp i64 undef to double
  %r68 = sitofp i64 undef to double
  ; CHECK:  Found an estimated cost of 10 for instruction:   %r69 = uitofp i64 undef to double
  %r69 = uitofp i64 undef to double

  ; CHECK:  Found an estimated cost of 3 for instruction:   %r70 = sext <8 x i8> undef to <8 x i32>
  %r70 = sext <8 x i8> undef to <8 x i32>
  ; CHECK:  Found an estimated cost of 6 for instruction:   %r71 = sext <16 x i8> undef to <16 x i32>
  %r71 = sext <16 x i8> undef to <16 x i32>
  ; CHECK:  Found an estimated cost of 3 for instruction:   %r72 = zext <8 x i8> undef to <8 x i32>
  %r72 = zext <8 x i8> undef to <8 x i32>
  ; CHECK:  Found an estimated cost of 6 for instruction:   %r73 = zext <16 x i8> undef to <16 x i32>
  %r73 = zext <16 x i8> undef to <16 x i32>

  ; CHECK:  Found an estimated cost of 7 for instruction:   %rext_0 = sext <8 x i8> undef to <8 x i64>
  %rext_0 = sext <8 x i8> undef to <8 x i64>
  ; CHECK:  Found an estimated cost of 7 for instruction:   %rext_1 = zext <8 x i8> undef to <8 x i64>
  %rext_1 = zext <8 x i8> undef to <8 x i64>
  ; CHECK:  Found an estimated cost of 6 for instruction:   %rext_2 = sext <8 x i16> undef to <8 x i64>
  %rext_2 = sext <8 x i16> undef to <8 x i64>
  ; CHECK:  Found an estimated cost of 6 for instruction:   %rext_3 = zext <8 x i16> undef to <8 x i64>
  %rext_3 = zext <8 x i16> undef to <8 x i64>
  ; CHECK:  Found an estimated cost of 3 for instruction:   %rext_4 = sext <4 x i16> undef to <4 x i64>
  %rext_4 = sext <4 x i16> undef to <4 x i64>
  ; CHECK:  Found an estimated cost of 3 for instruction:   %rext_5 = zext <4 x i16> undef to <4 x i64>
  %rext_5 = zext <4 x i16> undef to <4 x i64>

  ; Vector cast cost of instructions lowering the cast to the stack.
  ; CHECK:  Found an estimated cost of 3 for instruction:   %r74 = trunc <8 x i32> undef to <8 x i8>
  %r74 = trunc <8 x i32> undef to <8 x i8>
  ; CHECK:  Found an estimated cost of 6 for instruction:   %r75 = trunc <16 x i32> undef to <16 x i8>
  %r75 = trunc <16 x i32> undef to <16 x i8>

  ; Floating point truncation costs.
  ; CHECK:  Found an estimated cost of 1 for instruction:   %r80 = fptrunc double undef to float
  %r80 = fptrunc double undef to float
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r81 = fptrunc <2 x double> undef to <2 x float>
  %r81 = fptrunc <2 x double> undef to <2 x float>
  ; CHECK:  Found an estimated cost of 4 for instruction:   %r82 = fptrunc <4 x double> undef to <4 x float>
  %r82 = fptrunc <4 x double> undef to <4 x float>
  ; CHECK:  Found an estimated cost of 8 for instruction:   %r83 = fptrunc <8 x double> undef to <8 x float>
  %r83 = fptrunc <8 x double> undef to <8 x float>
  ; CHECK:  Found an estimated cost of 16 for instruction:   %r84 = fptrunc <16 x double> undef to <16 x float>
  %r84 = fptrunc <16 x double> undef to <16 x float>

  ; Floating point extension costs.
  ; CHECK:  Found an estimated cost of 1 for instruction:   %r85 = fpext float undef to double
  %r85 = fpext float undef to double
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r86 = fpext <2 x float> undef to <2 x double>
  %r86 = fpext <2 x float> undef to <2 x double>
  ; CHECK:  Found an estimated cost of 4 for instruction:   %r87 = fpext <4 x float> undef to <4 x double>
  %r87 = fpext <4 x float> undef to <4 x double>
  ; CHECK:  Found an estimated cost of 8 for instruction:   %r88 = fpext <8 x float> undef to <8 x double>
  %r88 = fpext <8 x float> undef to <8 x double>
  ; CHECK:  Found an estimated cost of 16 for instruction:   %r89 = fpext <16 x float> undef to <16 x double>
  %r89 = fpext <16 x float> undef to <16 x double>

  ;; Floating point to integer vector casts.
  ; CHECK:  Found an estimated cost of 1 for instruction:   %r90 = fptoui <2 x float> undef to <2 x i1>
  %r90 = fptoui <2 x float> undef to <2 x i1>
  ; CHECK:  Found an estimated cost of 1 for instruction:   %r91 = fptosi <2 x float> undef to <2 x i1>
  %r91 = fptosi <2 x float> undef to <2 x i1>
  ; CHECK:  Found an estimated cost of 1 for instruction:   %r92 = fptoui <2 x float> undef to <2 x i8>
  %r92 = fptoui <2 x float> undef to <2 x i8>
  ; CHECK:  Found an estimated cost of 1 for instruction:   %r93 = fptosi <2 x float> undef to <2 x i8>
  %r93 = fptosi <2 x float> undef to <2 x i8>
  ; CHECK:  Found an estimated cost of 1 for instruction:   %r94 = fptoui <2 x float> undef to <2 x i16>
  %r94 = fptoui <2 x float> undef to <2 x i16>
  ; CHECK:  Found an estimated cost of 1 for instruction:   %r95 = fptosi <2 x float> undef to <2 x i16>
  %r95 = fptosi <2 x float> undef to <2 x i16>
  ; CHECK:  Found an estimated cost of 1 for instruction:   %r96 = fptoui <2 x float> undef to <2 x i32>
  %r96 = fptoui <2 x float> undef to <2 x i32>
  ; CHECK:  Found an estimated cost of 1 for instruction:   %r97 = fptosi <2 x float> undef to <2 x i32>
  %r97 = fptosi <2 x float> undef to <2 x i32>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r98 = fptoui <2 x float> undef to <2 x i64>
  %r98 = fptoui <2 x float> undef to <2 x i64>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r99 = fptosi <2 x float> undef to <2 x i64>
  %r99 = fptosi <2 x float> undef to <2 x i64>

  ; CHECK:  Found an estimated cost of 16 for instruction:   %r100 = fptoui <2 x double> undef to <2 x i1>
  %r100 = fptoui <2 x double> undef to <2 x i1>
  ; CHECK:  Found an estimated cost of 16 for instruction:   %r101 = fptosi <2 x double> undef to <2 x i1>
  %r101 = fptosi <2 x double> undef to <2 x i1>
  ; CHECK:  Found an estimated cost of 16 for instruction:   %r102 = fptoui <2 x double> undef to <2 x i8>
  %r102 = fptoui <2 x double> undef to <2 x i8>
  ; CHECK:  Found an estimated cost of 16 for instruction:   %r103 = fptosi <2 x double> undef to <2 x i8>
  %r103 = fptosi <2 x double> undef to <2 x i8>
  ; CHECK:  Found an estimated cost of 16 for instruction:   %r104 = fptoui <2 x double> undef to <2 x i16>
  %r104 = fptoui <2 x double> undef to <2 x i16>
  ; CHECK:  Found an estimated cost of 16 for instruction:   %r105 = fptosi <2 x double> undef to <2 x i16>
  %r105 = fptosi <2 x double> undef to <2 x i16>
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r106 = fptoui <2 x double> undef to <2 x i32>
  %r106 = fptoui <2 x double> undef to <2 x i32>
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r107 = fptosi <2 x double> undef to <2 x i32>
  %r107 = fptosi <2 x double> undef to <2 x i32>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r108 = fptoui <2 x double> undef to <2 x i64>
  %r108 = fptoui <2 x double> undef to <2 x i64>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r109 = fptosi <2 x double> undef to <2 x i64>
  %r109 = fptosi <2 x double> undef to <2 x i64>

  ; CHECK:  Found an estimated cost of 32 for instruction:   %r110 = fptoui <4 x float> undef to <4 x i1>
  %r110 = fptoui <4 x float> undef to <4 x i1>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r111 = fptosi <4 x float> undef to <4 x i1>
  %r111 = fptosi <4 x float> undef to <4 x i1>
  ; CHECK:  Found an estimated cost of 3 for instruction:   %r112 = fptoui <4 x float> undef to <4 x i8>
  %r112 = fptoui <4 x float> undef to <4 x i8>
  ; CHECK:  Found an estimated cost of 3 for instruction:   %r113 = fptosi <4 x float> undef to <4 x i8>
  %r113 = fptosi <4 x float> undef to <4 x i8>

  ; CHECK:  Found an estimated cost of 2 for instruction:   %r114 = fptoui <4 x float> undef to <4 x i16>
  %r114 = fptoui <4 x float> undef to <4 x i16>
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r115 = fptosi <4 x float> undef to <4 x i16>
  %r115 = fptosi <4 x float> undef to <4 x i16>
  ; CHECK:  Found an estimated cost of 1 for instruction:   %r116 = fptoui <4 x float> undef to <4 x i32>
  %r116 = fptoui <4 x float> undef to <4 x i32>
  ; CHECK:  Found an estimated cost of 1 for instruction:   %r117 = fptosi <4 x float> undef to <4 x i32>
  %r117 = fptosi <4 x float> undef to <4 x i32>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r118 = fptoui <4 x float> undef to <4 x i64>
  %r118 = fptoui <4 x float> undef to <4 x i64>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r119 = fptosi <4 x float> undef to <4 x i64>
  %r119 = fptosi <4 x float> undef to <4 x i64>

  ; CHECK:  Found an estimated cost of 32 for instruction:   %r120 = fptoui <4 x double> undef to <4 x i1>
  %r120 = fptoui <4 x double> undef to <4 x i1>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r121 = fptosi <4 x double> undef to <4 x i1>
  %r121 = fptosi <4 x double> undef to <4 x i1>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r122 = fptoui <4 x double> undef to <4 x i8>
  %r122 = fptoui <4 x double> undef to <4 x i8>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r123 = fptosi <4 x double> undef to <4 x i8>
  %r123 = fptosi <4 x double> undef to <4 x i8>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r124 = fptoui <4 x double> undef to <4 x i16>
  %r124 = fptoui <4 x double> undef to <4 x i16>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r125 = fptosi <4 x double> undef to <4 x i16>
  %r125 = fptosi <4 x double> undef to <4 x i16>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r126 = fptoui <4 x double> undef to <4 x i32>
  %r126 = fptoui <4 x double> undef to <4 x i32>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r127 = fptosi <4 x double> undef to <4 x i32>
  %r127 = fptosi <4 x double> undef to <4 x i32>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r128 = fptoui <4 x double> undef to <4 x i64>
  %r128 = fptoui <4 x double> undef to <4 x i64>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r129 = fptosi <4 x double> undef to <4 x i64>
  %r129 = fptosi <4 x double> undef to <4 x i64>

  ; CHECK:  Found an estimated cost of 64 for instruction:   %r130 = fptoui <8 x float> undef to <8 x i1>
  %r130 = fptoui <8 x float> undef to <8 x i1>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r131 = fptosi <8 x float> undef to <8 x i1>
  %r131 = fptosi <8 x float> undef to <8 x i1>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r132 = fptoui <8 x float> undef to <8 x i8>
  %r132 = fptoui <8 x float> undef to <8 x i8>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r133 = fptosi <8 x float> undef to <8 x i8>
  %r133 = fptosi <8 x float> undef to <8 x i8>
  ; CHECK:  Found an estimated cost of 4 for instruction:   %r134 = fptoui <8 x float> undef to <8 x i16>
  %r134 = fptoui <8 x float> undef to <8 x i16>
  ; CHECK:  Found an estimated cost of 4 for instruction:   %r135 = fptosi <8 x float> undef to <8 x i16>
  %r135 = fptosi <8 x float> undef to <8 x i16>
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r136 = fptoui <8 x float> undef to <8 x i32>
  %r136 = fptoui <8 x float> undef to <8 x i32>
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r137 = fptosi <8 x float> undef to <8 x i32>
  %r137 = fptosi <8 x float> undef to <8 x i32>
  ; CHECK:  Found an estimated cost of 128 for instruction:   %r138 = fptoui <8 x float> undef to <8 x i64>
  %r138 = fptoui <8 x float> undef to <8 x i64>
  ; CHECK:  Found an estimated cost of 128 for instruction:   %r139 = fptosi <8 x float> undef to <8 x i64>
  %r139 = fptosi <8 x float> undef to <8 x i64>

  ; CHECK:  Found an estimated cost of 64 for instruction:   %r140 = fptoui <8 x double> undef to <8 x i1>
  %r140 = fptoui <8 x double> undef to <8 x i1>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r141 = fptosi <8 x double> undef to <8 x i1>
  %r141 = fptosi <8 x double> undef to <8 x i1>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r142 = fptoui <8 x double> undef to <8 x i8>
  %r142 = fptoui <8 x double> undef to <8 x i8>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r143 = fptosi <8 x double> undef to <8 x i8>
  %r143 = fptosi <8 x double> undef to <8 x i8>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r144 = fptoui <8 x double> undef to <8 x i16>
  %r144 = fptoui <8 x double> undef to <8 x i16>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r145 = fptosi <8 x double> undef to <8 x i16>
  %r145 = fptosi <8 x double> undef to <8 x i16>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r146 = fptoui <8 x double> undef to <8 x i32>
  %r146 = fptoui <8 x double> undef to <8 x i32>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r147 = fptosi <8 x double> undef to <8 x i32>
  %r147 = fptosi <8 x double> undef to <8 x i32>
  ; CHECK:  Found an estimated cost of 128 for instruction:   %r148 = fptoui <8 x double> undef to <8 x i64>
  %r148 = fptoui <8 x double> undef to <8 x i64>
  ; CHECK:  Found an estimated cost of 128 for instruction:   %r149 = fptosi <8 x double> undef to <8 x i64>
  %r149 = fptosi <8 x double> undef to <8 x i64>

  ; CHECK:  Found an estimated cost of 128 for instruction:   %r150 = fptoui <16 x float> undef to <16 x i1>
  %r150 = fptoui <16 x float> undef to <16 x i1>
  ; CHECK:  Found an estimated cost of 128 for instruction:   %r151 = fptosi <16 x float> undef to <16 x i1>
  %r151 = fptosi <16 x float> undef to <16 x i1>
 ; CHECK:  Found an estimated cost of 128 for instruction:   %r152 = fptoui <16 x float> undef to <16 x i8>
  %r152 = fptoui <16 x float> undef to <16 x i8>
  ; CHECK:  Found an estimated cost of 128 for instruction:   %r153 = fptosi <16 x float> undef to <16 x i8>
  %r153 = fptosi <16 x float> undef to <16 x i8>
  ; CHECK:  Found an estimated cost of 8 for instruction:   %r154 = fptoui <16 x float> undef to <16 x i16>
  %r154 = fptoui <16 x float> undef to <16 x i16>
  ; CHECK:  Found an estimated cost of 8 for instruction:   %r155 = fptosi <16 x float> undef to <16 x i16>
  %r155 = fptosi <16 x float> undef to <16 x i16>
  ; CHECK:  Found an estimated cost of 4 for instruction:   %r156 = fptoui <16 x float> undef to <16 x i32>
  %r156 = fptoui <16 x float> undef to <16 x i32>
  ; CHECK:  Found an estimated cost of 4 for instruction:   %r157 = fptosi <16 x float> undef to <16 x i32>
  %r157 = fptosi <16 x float> undef to <16 x i32>
  ; CHECK:  Found an estimated cost of 256 for instruction:   %r158 = fptoui <16 x float> undef to <16 x i64>
  %r158 = fptoui <16 x float> undef to <16 x i64>
  ; CHECK:  Found an estimated cost of 256 for instruction:   %r159 = fptosi <16 x float> undef to <16 x i64>
  %r159 = fptosi <16 x float> undef to <16 x i64>

  ; CHECK:  Found an estimated cost of 128 for instruction:   %r160 = fptoui <16 x double> undef to <16 x i1>
  %r160 = fptoui <16 x double> undef to <16 x i1>
  ; CHECK:  Found an estimated cost of 128 for instruction:   %r161 = fptosi <16 x double> undef to <16 x i1>
  %r161 = fptosi <16 x double> undef to <16 x i1>
  ; CHECK:  Found an estimated cost of 128 for instruction:   %r162 = fptoui <16 x double> undef to <16 x i8>
  %r162 = fptoui <16 x double> undef to <16 x i8>
  ; CHECK:  Found an estimated cost of 128 for instruction:   %r163 = fptosi <16 x double> undef to <16 x i8>
  %r163 = fptosi <16 x double> undef to <16 x i8>
  ; CHECK:  Found an estimated cost of 128 for instruction:   %r164 = fptoui <16 x double> undef to <16 x i16>
  %r164 = fptoui <16 x double> undef to <16 x i16>
  ; CHECK:  Found an estimated cost of 128 for instruction:   %r165 = fptosi <16 x double> undef to <16 x i16>
  %r165 = fptosi <16 x double> undef to <16 x i16>
  ; CHECK:  Found an estimated cost of 128 for instruction:   %r166 = fptoui <16 x double> undef to <16 x i32>
  %r166 = fptoui <16 x double> undef to <16 x i32>
  ; CHECK:  Found an estimated cost of 128 for instruction:   %r167 = fptosi <16 x double> undef to <16 x i32>
  %r167 = fptosi <16 x double> undef to <16 x i32>
  ; CHECK:  Found an estimated cost of 256 for instruction:   %r168 = fptoui <16 x double> undef to <16 x i64>
  %r168 = fptoui <16 x double> undef to <16 x i64>
  ; CHECK:  Found an estimated cost of 256 for instruction:   %r169 = fptosi <16 x double> undef to <16 x i64>
  %r169 = fptosi <16 x double> undef to <16 x i64>

  ; CHECK:  Found an estimated cost of 12 for instruction:   %r170 = uitofp <2 x i1> undef to <2 x float>
  %r170 = uitofp <2 x i1> undef to <2 x float>
  ; CHECK:  Found an estimated cost of 12 for instruction:   %r171 = sitofp <2 x i1> undef to <2 x float>
  %r171 = sitofp <2 x i1> undef to <2 x float>
  ; CHECK:  Found an estimated cost of 3 for instruction:   %r172 = uitofp <2 x i8> undef to <2 x float>
  %r172 = uitofp <2 x i8> undef to <2 x float>
  ; CHECK:  Found an estimated cost of 3 for instruction:   %r173 = sitofp <2 x i8> undef to <2 x float>
  %r173 = sitofp <2 x i8> undef to <2 x float>
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r174 = uitofp <2 x i16> undef to <2 x float>
  %r174 = uitofp <2 x i16> undef to <2 x float>
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r175 = sitofp <2 x i16> undef to <2 x float>
  %r175 = sitofp <2 x i16> undef to <2 x float>
  ; CHECK:  Found an estimated cost of 1 for instruction:   %r176 = uitofp <2 x i32> undef to <2 x float>
  %r176 = uitofp <2 x i32> undef to <2 x float>
  ; CHECK:  Found an estimated cost of 1 for instruction:   %r177 = sitofp <2 x i32> undef to <2 x float>
  %r177 = sitofp <2 x i32> undef to <2 x float>
  ; CHECK:  Found an estimated cost of 28 for instruction:   %r178 = uitofp <2 x i64> undef to <2 x float>
  %r178 = uitofp <2 x i64> undef to <2 x float>
  ; CHECK:  Found an estimated cost of 28 for instruction:   %r179 = sitofp <2 x i64> undef to <2 x float>
  %r179 = sitofp <2 x i64> undef to <2 x float>

  ; CHECK:  Found an estimated cost of 8 for instruction:   %r180 = uitofp <2 x i1> undef to <2 x double>
  %r180 = uitofp <2 x i1> undef to <2 x double>
  ; CHECK:  Found an estimated cost of 8 for instruction:   %r181 = sitofp <2 x i1> undef to <2 x double>
  %r181 = sitofp <2 x i1> undef to <2 x double>
  ; CHECK:  Found an estimated cost of 4 for instruction:   %r182 = uitofp <2 x i8> undef to <2 x double>
  %r182 = uitofp <2 x i8> undef to <2 x double>
  ; CHECK:  Found an estimated cost of 4 for instruction:   %r183 = sitofp <2 x i8> undef to <2 x double>
  %r183 = sitofp <2 x i8> undef to <2 x double>
  ; CHECK:  Found an estimated cost of 3 for instruction:   %r184 = uitofp <2 x i16> undef to <2 x double>
  %r184 = uitofp <2 x i16> undef to <2 x double>
  ; CHECK:  Found an estimated cost of 3 for instruction:   %r185 = sitofp <2 x i16> undef to <2 x double>
  %r185 = sitofp <2 x i16> undef to <2 x double>
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r186 = uitofp <2 x i32> undef to <2 x double>
  %r186 = uitofp <2 x i32> undef to <2 x double>
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r187 = sitofp <2 x i32> undef to <2 x double>
  %r187 = sitofp <2 x i32> undef to <2 x double>
  ; CHECK:  Found an estimated cost of 24 for instruction:   %r188 = uitofp <2 x i64> undef to <2 x double>
  %r188 = uitofp <2 x i64> undef to <2 x double>
  ; CHECK:  Found an estimated cost of 24 for instruction:   %r189 = sitofp <2 x i64> undef to <2 x double>
  %r189 = sitofp <2 x i64> undef to <2 x double>

  ; CHECK:  Found an estimated cost of 3 for instruction:   %r190 = uitofp <4 x i1> undef to <4 x float>
  %r190 = uitofp <4 x i1> undef to <4 x float>
  ; CHECK:  Found an estimated cost of 3 for instruction:   %r191 = sitofp <4 x i1> undef to <4 x float>
  %r191 = sitofp <4 x i1> undef to <4 x float>
  ; CHECK:  Found an estimated cost of 3 for instruction:   %r192 = uitofp <4 x i8> undef to <4 x float>
  %r192 = uitofp <4 x i8> undef to <4 x float>
  ; CHECK:  Found an estimated cost of 3 for instruction:   %r193 = sitofp <4 x i8> undef to <4 x float>
  %r193 = sitofp <4 x i8> undef to <4 x float>
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r194 = uitofp <4 x i16> undef to <4 x float>
  %r194 = uitofp <4 x i16> undef to <4 x float>
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r195 = sitofp <4 x i16> undef to <4 x float>
  %r195 = sitofp <4 x i16> undef to <4 x float>
  ; CHECK:  Found an estimated cost of 1 for instruction:   %r196 = uitofp <4 x i32> undef to <4 x float>
  %r196 = uitofp <4 x i32> undef to <4 x float>
  ; CHECK:  Found an estimated cost of 1 for instruction:   %r197 = sitofp <4 x i32> undef to <4 x float>
  %r197 = sitofp <4 x i32> undef to <4 x float>
  ; CHECK:  Found an estimated cost of 56 for instruction:   %r198 = uitofp <4 x i64> undef to <4 x float>
  %r198 = uitofp <4 x i64> undef to <4 x float>
  ; CHECK:  Found an estimated cost of 56 for instruction:   %r199 = sitofp <4 x i64> undef to <4 x float>
  %r199 = sitofp <4 x i64> undef to <4 x float>

  ; CHECK:  Found an estimated cost of 16 for instruction:   %r200 = uitofp <4 x i1> undef to <4 x double>
  %r200 = uitofp <4 x i1> undef to <4 x double>
  ; CHECK:  Found an estimated cost of 16 for instruction:   %r201 = sitofp <4 x i1> undef to <4 x double>
  %r201 = sitofp <4 x i1> undef to <4 x double>
  ; CHECK:  Found an estimated cost of 16 for instruction:   %r202 = uitofp <4 x i8> undef to <4 x double>
  %r202 = uitofp <4 x i8> undef to <4 x double>
  ; CHECK:  Found an estimated cost of 16 for instruction:   %r203 = sitofp <4 x i8> undef to <4 x double>
  %r203 = sitofp <4 x i8> undef to <4 x double>
  ; CHECK:  Found an estimated cost of 16 for instruction:   %r204 = uitofp <4 x i16> undef to <4 x double>
  %r204 = uitofp <4 x i16> undef to <4 x double>
  ; CHECK:  Found an estimated cost of 16 for instruction:   %r205 = sitofp <4 x i16> undef to <4 x double>
  %r205 = sitofp <4 x i16> undef to <4 x double>
  ; CHECK:  Found an estimated cost of 16 for instruction:   %r206 = uitofp <4 x i32> undef to <4 x double>
  %r206 = uitofp <4 x i32> undef to <4 x double>
  ; CHECK:  Found an estimated cost of 16 for instruction:   %r207 = sitofp <4 x i32> undef to <4 x double>
  %r207 = sitofp <4 x i32> undef to <4 x double>
  ; CHECK:  Found an estimated cost of 48 for instruction:   %r208 = uitofp <4 x i64> undef to <4 x double>
  %r208 = uitofp <4 x i64> undef to <4 x double>
  ; CHECK:  Found an estimated cost of 48 for instruction:   %r209 = sitofp <4 x i64> undef to <4 x double>
  %r209 = sitofp <4 x i64> undef to <4 x double>

  ; CHECK:  Found an estimated cost of 48 for instruction:   %r210 = uitofp <8 x i1> undef to <8 x float>
  %r210 = uitofp <8 x i1> undef to <8 x float>
  ; CHECK:  Found an estimated cost of 48 for instruction:   %r211 = sitofp <8 x i1> undef to <8 x float>
  %r211 = sitofp <8 x i1> undef to <8 x float>
  ; CHECK:  Found an estimated cost of 48 for instruction:   %r212 = uitofp <8 x i8> undef to <8 x float>
  %r212 = uitofp <8 x i8> undef to <8 x float>
  ; CHECK:  Found an estimated cost of 48 for instruction:   %r213 = sitofp <8 x i8> undef to <8 x float>
  %r213 = sitofp <8 x i8> undef to <8 x float>
  ; CHECK:  Found an estimated cost of 4 for instruction:   %r214 = uitofp <8 x i16> undef to <8 x float>
  %r214 = uitofp <8 x i16> undef to <8 x float>
  ; CHECK:  Found an estimated cost of 4 for instruction:   %r215 = sitofp <8 x i16> undef to <8 x float>
  %r215 = sitofp <8 x i16> undef to <8 x float>
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r216 = uitofp <8 x i32> undef to <8 x float>
  %r216 = uitofp <8 x i32> undef to <8 x float>
  ; CHECK:  Found an estimated cost of 2 for instruction:   %r217 = sitofp <8 x i32> undef to <8 x float>
  %r217 = sitofp <8 x i32> undef to <8 x float>
  ; CHECK:  Found an estimated cost of 112 for instruction:   %r218 = uitofp <8 x i64> undef to <8 x float>
  %r218 = uitofp <8 x i64> undef to <8 x float>
  ; CHECK:  Found an estimated cost of 112 for instruction:   %r219 = sitofp <8 x i64> undef to <8 x float>
  %r219 = sitofp <8 x i64> undef to <8 x float>

  ; CHECK:  Found an estimated cost of 32 for instruction:   %r220 = uitofp <8 x i1> undef to <8 x double>
  %r220 = uitofp <8 x i1> undef to <8 x double>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r221 = sitofp <8 x i1> undef to <8 x double>
  %r221 = sitofp <8 x i1> undef to <8 x double>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r222 = uitofp <8 x i8> undef to <8 x double>
  %r222 = uitofp <8 x i8> undef to <8 x double>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r223 = sitofp <8 x i8> undef to <8 x double>
  %r223 = sitofp <8 x i8> undef to <8 x double>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r224 = uitofp <8 x i16> undef to <8 x double>
  %r224 = uitofp <8 x i16> undef to <8 x double>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r225 = sitofp <8 x i16> undef to <8 x double>
  %r225 = sitofp <8 x i16> undef to <8 x double>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r226 = uitofp <8 x i16> undef to <8 x double>
  %r226 = uitofp <8 x i16> undef to <8 x double>
  ; CHECK:  Found an estimated cost of 32 for instruction:   %r227 = sitofp <8 x i16> undef to <8 x double>
  %r227 = sitofp <8 x i16> undef to <8 x double>
  ; CHECK:  Found an estimated cost of 96 for instruction:   %r228 = uitofp <8 x i64> undef to <8 x double>
  %r228 = uitofp <8 x i64> undef to <8 x double>
  ; CHECK:  Found an estimated cost of 96 for instruction:   %r229 = sitofp <8 x i64> undef to <8 x double>
  %r229 = sitofp <8 x i64> undef to <8 x double>

  ; CHECK:  Found an estimated cost of 96 for instruction:   %r230 = uitofp <16 x i1> undef to <16 x float>
  %r230 = uitofp <16 x i1> undef to <16 x float>
  ; CHECK:  Found an estimated cost of 96 for instruction:   %r231 = sitofp <16 x i1> undef to <16 x float>
  %r231 = sitofp <16 x i1> undef to <16 x float>
  ; CHECK:  Found an estimated cost of 96 for instruction:   %r232 = uitofp <16 x i8> undef to <16 x float>
  %r232 = uitofp <16 x i8> undef to <16 x float>
  ; CHECK:  Found an estimated cost of 96 for instruction:   %r233 = sitofp <16 x i8> undef to <16 x float>
  %r233 = sitofp <16 x i8> undef to <16 x float>
  ; CHECK:  Found an estimated cost of 8 for instruction:   %r234 = uitofp <16 x i16> undef to <16 x float>
  %r234 = uitofp <16 x i16> undef to <16 x float>
  ; CHECK:  Found an estimated cost of 8 for instruction:   %r235 = sitofp <16 x i16> undef to <16 x float>
  %r235 = sitofp <16 x i16> undef to <16 x float>
  ; CHECK:  Found an estimated cost of 4 for instruction:   %r236 = uitofp <16 x i32> undef to <16 x float>
  %r236 = uitofp <16 x i32> undef to <16 x float>
  ; CHECK:  Found an estimated cost of 4 for instruction:   %r237 = sitofp <16 x i32> undef to <16 x float>
  %r237 = sitofp <16 x i32> undef to <16 x float>
  ; CHECK:  Found an estimated cost of 224 for instruction:   %r238 = uitofp <16 x i64> undef to <16 x float>
  %r238 = uitofp <16 x i64> undef to <16 x float>
  ; CHECK:  Found an estimated cost of 224 for instruction:   %r239 = sitofp <16 x i64> undef to <16 x float>
  %r239 = sitofp <16 x i64> undef to <16 x float>

  ; CHECK:  Found an estimated cost of 64 for instruction:   %r240 = uitofp <16 x i1> undef to <16 x double>
  %r240 = uitofp <16 x i1> undef to <16 x double>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r241 = sitofp <16 x i1> undef to <16 x double>
  %r241 = sitofp <16 x i1> undef to <16 x double>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r242 = uitofp <16 x i8> undef to <16 x double>
  %r242 = uitofp <16 x i8> undef to <16 x double>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r243 = sitofp <16 x i8> undef to <16 x double>
  %r243 = sitofp <16 x i8> undef to <16 x double>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r244 = uitofp <16 x i16> undef to <16 x double>
  %r244 = uitofp <16 x i16> undef to <16 x double>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r245 = sitofp <16 x i16> undef to <16 x double>
  %r245 = sitofp <16 x i16> undef to <16 x double>
  ; CHECK:  Found an estimated cost of 64 for instruction:   %r246 = uitofp <16 x i16> undef to <16 x double>
  %r246 = uitofp <16 x i16> undef to <16 x double>
  ;  CHECK:  Found an estimated cost of 64 for instruction:   %r247 = sitofp <16 x i16> undef to <16 x double>
  %r247 = sitofp <16 x i16> undef to <16 x double>
  ; CHECK:   Found an estimated cost of 192 for instruction:   %r248 = uitofp <16 x i64> undef to <16 x double>
  %r248 = uitofp <16 x i64> undef to <16 x double>
  ; CHECK:   Found an estimated cost of 192 for instruction:   %r249 = sitofp <16 x i64> undef to <16 x double>
  %r249 = sitofp <16 x i64> undef to <16 x double>

  ; CHECK:   Found an estimated cost of 0 for instruction:   ret i32 undef
  ret i32 undef
}

