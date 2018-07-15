; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

define <2 x float> @fsub_negzero_vec_undef_elts(<2 x float> %x) {
; CHECK-LABEL: @fsub_negzero_vec_undef_elts(
; CHECK-NEXT:    ret <2 x float> [[X:%.*]]
;
  %r = fsub nsz <2 x float> %x, <float undef, float -0.0>
  ret <2 x float> %r
}

; fsub -0.0, (fsub -0.0, X) ==> X
define float @fsub_-0_-0_x(float %a) {
; CHECK-LABEL: @fsub_-0_-0_x(
; CHECK-NEXT:    ret float [[A:%.*]]
;
  %t1 = fsub float -0.0, %a
  %ret = fsub float -0.0, %t1
  ret float %ret
}

define <2 x float> @fsub_-0_-0_x_vec(<2 x float> %a) {
; CHECK-LABEL: @fsub_-0_-0_x_vec(
; CHECK-NEXT:    ret <2 x float> [[A:%.*]]
;
  %t1 = fsub <2 x float> <float -0.0, float -0.0>, %a
  %ret = fsub <2 x float> <float -0.0, float -0.0>, %t1
  ret <2 x float> %ret
}

define <2 x float> @fsub_-0_-0_x_vec_undef_elts(<2 x float> %a) {
; CHECK-LABEL: @fsub_-0_-0_x_vec_undef_elts(
; CHECK-NEXT:    ret <2 x float> [[A:%.*]]
;
  %t1 = fsub <2 x float> <float undef, float -0.0>, %a
  %ret = fsub <2 x float> <float -0.0, float undef>, %t1
  ret <2 x float> %ret
}

; fsub 0.0, (fsub -0.0, X) != X
define float @fsub_0_-0_x(float %a) {
; CHECK-LABEL: @fsub_0_-0_x(
; CHECK-NEXT:    [[T1:%.*]] = fsub float 0.000000e+00, [[A:%.*]]
; CHECK-NEXT:    [[RET:%.*]] = fsub float -0.000000e+00, [[T1]]
; CHECK-NEXT:    ret float [[RET]]
;
  %t1 = fsub float 0.0, %a
  %ret = fsub float -0.0, %t1
  ret float %ret
}

; fsub -0.0, (fsub 0.0, X) != X
define float @fsub_-0_0_x(float %a) {
; CHECK-LABEL: @fsub_-0_0_x(
; CHECK-NEXT:    [[T1:%.*]] = fsub float -0.000000e+00, [[A:%.*]]
; CHECK-NEXT:    [[RET:%.*]] = fsub float 0.000000e+00, [[T1]]
; CHECK-NEXT:    ret float [[RET]]
;
  %t1 = fsub float -0.0, %a
  %ret = fsub float 0.0, %t1
  ret float %ret
}

; fsub X, 0 ==> X
define float @fsub_x_0(float %x) {
; CHECK-LABEL: @fsub_x_0(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %r = fsub float %x, 0.0
  ret float %r
}

define <2 x float> @fsub_x_0_vec_undef(<2 x float> %x) {
; CHECK-LABEL: @fsub_x_0_vec_undef(
; CHECK-NEXT:    ret <2 x float> [[X:%.*]]
;
  %r = fsub <2 x float> %x, <float undef, float 0.0>
  ret <2 x float> %r
}

; fadd X, -0 ==> X
define float @fadd_x_n0(float %a) {
; CHECK-LABEL: @fadd_x_n0(
; CHECK-NEXT:    ret float [[A:%.*]]
;
  %ret = fadd float %a, -0.0
  ret float %ret
}

define <2 x float> @fadd_x_n0_vec_undef_elt(<2 x float> %a) {
; CHECK-LABEL: @fadd_x_n0_vec_undef_elt(
; CHECK-NEXT:    ret <2 x float> [[A:%.*]]
;
  %ret = fadd <2 x float> %a, <float -0.0, float undef>
  ret <2 x float> %ret
}

; fmul X, 1.0 ==> X
define double @fmul_X_1(double %a) {
; CHECK-LABEL: @fmul_X_1(
; CHECK-NEXT:    ret double [[A:%.*]]
;
  %b = fmul double 1.0, %a
  ret double %b
}

; PR2642
define <4 x float> @fmul_X_1_vec(<4 x float> %x) {
; CHECK-LABEL: @fmul_X_1_vec(
; CHECK-NEXT:    ret <4 x float> [[X:%.*]]
;
  %m = fmul <4 x float> %x, <float 1.0, float 1.0, float 1.0, float 1.0>
  ret <4 x float> %m
}

; fdiv X, 1.0 ==> X
define float @fdiv_x_1(float %a) {
; CHECK-LABEL: @fdiv_x_1(
; CHECK-NEXT:    ret float [[A:%.*]]
;
  %ret = fdiv float %a, 1.0
  ret float %ret
}

; We can't optimize away the fadd in this test because the input
; value to the function and subsequently to the fadd may be -0.0.
; In that one special case, the result of the fadd should be +0.0
; rather than the first parameter of the fadd.

; Fragile test warning: We need 6 sqrt calls to trigger the bug
; because the internal logic has a magic recursion limit of 6.
; This is presented without any explanation or ability to customize.

declare float @sqrtf(float)

define float @PR22688(float %x) {
; CHECK-LABEL: @PR22688(
; CHECK-NEXT:    [[TMP1:%.*]] = call float @sqrtf(float [[X:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call float @sqrtf(float [[TMP1]])
; CHECK-NEXT:    [[TMP3:%.*]] = call float @sqrtf(float [[TMP2]])
; CHECK-NEXT:    [[TMP4:%.*]] = call float @sqrtf(float [[TMP3]])
; CHECK-NEXT:    [[TMP5:%.*]] = call float @sqrtf(float [[TMP4]])
; CHECK-NEXT:    [[TMP6:%.*]] = call float @sqrtf(float [[TMP5]])
; CHECK-NEXT:    [[TMP7:%.*]] = fadd float [[TMP6]], 0.000000e+00
; CHECK-NEXT:    ret float [[TMP7]]
;
  %1 = call float @sqrtf(float %x)
  %2 = call float @sqrtf(float %1)
  %3 = call float @sqrtf(float %2)
  %4 = call float @sqrtf(float %3)
  %5 = call float @sqrtf(float %4)
  %6 = call float @sqrtf(float %5)
  %7 = fadd float %6, 0.0
  ret float %7
}

declare float @llvm.fabs.f32(float)
declare <2 x float> @llvm.fabs.v2f32(<2 x float>)
declare float @llvm.sqrt.f32(float)

define float @fabs_select_positive_constants(i32 %c) {
; CHECK-LABEL: @fabs_select_positive_constants(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], float 1.000000e+00, float 2.000000e+00
; CHECK-NEXT:    ret float [[SELECT]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, float 1.0, float 2.0
  %fabs = call float @llvm.fabs.f32(float %select)
  ret float %fabs
}

define <2 x float> @fabs_select_positive_constants_vector(i32 %c) {
; CHECK-LABEL: @fabs_select_positive_constants_vector(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], <2 x float> <float 1.000000e+00, float 1.000000e+00>, <2 x float> <float 2.000000e+00, float 2.000000e+00>
; CHECK-NEXT:    ret <2 x float> [[SELECT]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, <2 x float> <float 1.0, float 1.0>, <2 x float> <float 2.0, float 2.0>
  %fabs = call <2 x float> @llvm.fabs.v2f32(<2 x float> %select)
  ret <2 x float> %fabs
}

define float @fabs_select_constant_variable(i32 %c, float %x) {
; CHECK-LABEL: @fabs_select_constant_variable(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], float 1.000000e+00, float [[X:%.*]]
; CHECK-NEXT:    [[FABS:%.*]] = call float @llvm.fabs.f32(float [[SELECT]])
; CHECK-NEXT:    ret float [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, float 1.0, float %x
  %fabs = call float @llvm.fabs.f32(float %select)
  ret float %fabs
}

define <2 x float> @fabs_select_constant_variable_vector(i32 %c, <2 x float> %x) {
; CHECK-LABEL: @fabs_select_constant_variable_vector(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], <2 x float> <float 1.000000e+00, float 1.000000e+00>, <2 x float> [[X:%.*]]
; CHECK-NEXT:    [[FABS:%.*]] = call <2 x float> @llvm.fabs.v2f32(<2 x float> [[SELECT]])
; CHECK-NEXT:    ret <2 x float> [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, <2 x float> <float 1.0, float 1.0>, <2 x float> %x
  %fabs = call <2 x float> @llvm.fabs.v2f32(<2 x float> %select)
  ret <2 x float> %fabs
}

define float @fabs_select_neg0_pos0(i32 %c) {
; CHECK-LABEL: @fabs_select_neg0_pos0(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], float -0.000000e+00, float 0.000000e+00
; CHECK-NEXT:    [[FABS:%.*]] = call float @llvm.fabs.f32(float [[SELECT]])
; CHECK-NEXT:    ret float [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, float -0.0, float 0.0
  %fabs = call float @llvm.fabs.f32(float %select)
  ret float %fabs
}

define <2 x float> @fabs_select_neg0_pos0_vector(i32 %c) {
; CHECK-LABEL: @fabs_select_neg0_pos0_vector(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], <2 x float> <float -0.000000e+00, float -0.000000e+00>, <2 x float> zeroinitializer
; CHECK-NEXT:    [[FABS:%.*]] = call <2 x float> @llvm.fabs.v2f32(<2 x float> [[SELECT]])
; CHECK-NEXT:    ret <2 x float> [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, <2 x float> <float -0.0, float -0.0>, <2 x float> <float 0.0, float 0.0>
  %fabs = call <2 x float> @llvm.fabs.v2f32(<2 x float> %select)
  ret <2 x float> %fabs
}

define float @fabs_select_neg0_neg1(i32 %c) {
; CHECK-LABEL: @fabs_select_neg0_neg1(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], float -0.000000e+00, float -1.000000e+00
; CHECK-NEXT:    [[FABS:%.*]] = call float @llvm.fabs.f32(float [[SELECT]])
; CHECK-NEXT:    ret float [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, float -0.0, float -1.0
  %fabs = call float @llvm.fabs.f32(float %select)
  ret float %fabs
}

define <2 x float> @fabs_select_neg0_neg1_vector(i32 %c) {
; CHECK-LABEL: @fabs_select_neg0_neg1_vector(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], <2 x float> <float -0.000000e+00, float -0.000000e+00>, <2 x float> <float -1.000000e+00, float -1.000000e+00>
; CHECK-NEXT:    [[FABS:%.*]] = call <2 x float> @llvm.fabs.v2f32(<2 x float> [[SELECT]])
; CHECK-NEXT:    ret <2 x float> [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, <2 x float> <float -0.0, float -0.0>, <2 x float> <float -1.0, float -1.0>
  %fabs = call <2 x float> @llvm.fabs.v2f32(<2 x float> %select)
  ret <2 x float> %fabs
}

define float @fabs_select_nan_nan(i32 %c) {
; CHECK-LABEL: @fabs_select_nan_nan(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], float 0x7FF8000000000000, float 0x7FF8000100000000
; CHECK-NEXT:    ret float [[SELECT]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, float 0x7FF8000000000000, float 0x7FF8000100000000
  %fabs = call float @llvm.fabs.f32(float %select)
  ret float %fabs
}

define <2 x float> @fabs_select_nan_nan_vector(i32 %c) {
; CHECK-LABEL: @fabs_select_nan_nan_vector(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], <2 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000>, <2 x float> <float 0x7FF8000100000000, float 0x7FF8000100000000>
; CHECK-NEXT:    ret <2 x float> [[SELECT]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, <2 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000>, <2 x float> <float 0x7FF8000100000000, float 0x7FF8000100000000>
  %fabs = call <2 x float> @llvm.fabs.v2f32(<2 x float> %select)
  ret <2 x float> %fabs
}

define float @fabs_select_negnan_nan(i32 %c) {
; CHECK-LABEL: @fabs_select_negnan_nan(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], float 0xFFF8000000000000, float 0x7FF8000000000000
; CHECK-NEXT:    [[FABS:%.*]] = call float @llvm.fabs.f32(float [[SELECT]])
; CHECK-NEXT:    ret float [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, float 0xFFF8000000000000, float 0x7FF8000000000000
  %fabs = call float @llvm.fabs.f32(float %select)
  ret float %fabs
}

define <2 x float> @fabs_select_negnan_nan_vector(i32 %c) {
; CHECK-LABEL: @fabs_select_negnan_nan_vector(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], <2 x float> <float 0xFFF8000000000000, float 0xFFF8000000000000>, <2 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000>
; CHECK-NEXT:    [[FABS:%.*]] = call <2 x float> @llvm.fabs.v2f32(<2 x float> [[SELECT]])
; CHECK-NEXT:    ret <2 x float> [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, <2 x float> <float 0xFFF8000000000000, float 0xFFF8000000000000>, <2 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000>
  %fabs = call <2 x float> @llvm.fabs.v2f32(<2 x float> %select)
  ret <2 x float> %fabs
}

define float @fabs_select_negnan_negnan(i32 %c) {
; CHECK-LABEL: @fabs_select_negnan_negnan(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], float 0xFFF8000000000000, float 0x7FF8000100000000
; CHECK-NEXT:    [[FABS:%.*]] = call float @llvm.fabs.f32(float [[SELECT]])
; CHECK-NEXT:    ret float [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, float 0xFFF8000000000000, float 0x7FF8000100000000
  %fabs = call float @llvm.fabs.f32(float %select)
  ret float %fabs
}

define <2 x float> @fabs_select_negnan_negnan_vector(i32 %c) {
; CHECK-LABEL: @fabs_select_negnan_negnan_vector(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], <2 x float> <float 0xFFF8000000000000, float 0xFFF8000000000000>, <2 x float> <float 0x7FF8000100000000, float 0x7FF8000100000000>
; CHECK-NEXT:    [[FABS:%.*]] = call <2 x float> @llvm.fabs.v2f32(<2 x float> [[SELECT]])
; CHECK-NEXT:    ret <2 x float> [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, <2 x float> <float 0xFFF8000000000000, float 0xFFF8000000000000>, <2 x float> <float 0x7FF8000100000000, float 0x7FF8000100000000>
  %fabs = call <2 x float> @llvm.fabs.v2f32(<2 x float> %select)
  ret <2 x float> %fabs
}

define float @fabs_select_negnan_negzero(i32 %c) {
; CHECK-LABEL: @fabs_select_negnan_negzero(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], float 0xFFF8000000000000, float -0.000000e+00
; CHECK-NEXT:    [[FABS:%.*]] = call float @llvm.fabs.f32(float [[SELECT]])
; CHECK-NEXT:    ret float [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, float 0xFFF8000000000000, float -0.0
  %fabs = call float @llvm.fabs.f32(float %select)
  ret float %fabs
}

define <2 x float> @fabs_select_negnan_negzero_vector(i32 %c) {
; CHECK-LABEL: @fabs_select_negnan_negzero_vector(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], <2 x float> <float 0xFFF8000000000000, float 0xFFF8000000000000>, <2 x float> <float -0.000000e+00, float -0.000000e+00>
; CHECK-NEXT:    [[FABS:%.*]] = call <2 x float> @llvm.fabs.v2f32(<2 x float> [[SELECT]])
; CHECK-NEXT:    ret <2 x float> [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, <2 x float> <float 0xFFF8000000000000, float 0xFFF8000000000000>, <2 x float> <float -0.0, float -0.0>
  %fabs = call <2 x float> @llvm.fabs.v2f32(<2 x float> %select)
  ret <2 x float> %fabs
}

define float @fabs_select_negnan_zero(i32 %c) {
; CHECK-LABEL: @fabs_select_negnan_zero(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], float 0xFFF8000000000000, float 0.000000e+00
; CHECK-NEXT:    [[FABS:%.*]] = call float @llvm.fabs.f32(float [[SELECT]])
; CHECK-NEXT:    ret float [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, float 0xFFF8000000000000, float 0.0
  %fabs = call float @llvm.fabs.f32(float %select)
  ret float %fabs
}

define <2 x float> @fabs_select_negnan_zero_vector(i32 %c) {
; CHECK-LABEL: @fabs_select_negnan_zero_vector(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], <2 x float> <float 0xFFF8000000000000, float 0xFFF8000000000000>, <2 x float> zeroinitializer
; CHECK-NEXT:    [[FABS:%.*]] = call <2 x float> @llvm.fabs.v2f32(<2 x float> [[SELECT]])
; CHECK-NEXT:    ret <2 x float> [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, <2 x float> <float 0xFFF8000000000000, float 0xFFF8000000000000>, <2 x float> <float 0.0, float 0.0>
  %fabs = call <2 x float> @llvm.fabs.v2f32(<2 x float> %select)
  ret <2 x float> %fabs
}

; The fabs can't be eliminated because llvm.sqrt.f32 may return -0 or NaN with
; an arbitrary sign bit.
define float @fabs_sqrt(float %a) {
; CHECK-LABEL: @fabs_sqrt(
; CHECK-NEXT:    [[SQRT:%.*]] = call float @llvm.sqrt.f32(float [[A:%.*]])
; CHECK-NEXT:    [[FABS:%.*]] = call float @llvm.fabs.f32(float [[SQRT]])
; CHECK-NEXT:    ret float [[FABS]]
;
  %sqrt = call float @llvm.sqrt.f32(float %a)
  %fabs = call float @llvm.fabs.f32(float %sqrt)
  ret float %fabs
}

; The fabs can't be eliminated because the nnan sqrt may still return -0.
define float @fabs_sqrt_nnan(float %a) {
; CHECK-LABEL: @fabs_sqrt_nnan(
; CHECK-NEXT:    [[SQRT:%.*]] = call nnan float @llvm.sqrt.f32(float [[A:%.*]])
; CHECK-NEXT:    [[FABS:%.*]] = call float @llvm.fabs.f32(float [[SQRT]])
; CHECK-NEXT:    ret float [[FABS]]
;
  %sqrt = call nnan float @llvm.sqrt.f32(float %a)
  %fabs = call float @llvm.fabs.f32(float %sqrt)
  ret float %fabs
}

; The fabs can't be eliminated because the nsz sqrt may still return NaN.
define float @fabs_sqrt_nsz(float %a) {
; CHECK-LABEL: @fabs_sqrt_nsz(
; CHECK-NEXT:    [[SQRT:%.*]] = call nsz float @llvm.sqrt.f32(float [[A:%.*]])
; CHECK-NEXT:    [[FABS:%.*]] = call float @llvm.fabs.f32(float [[SQRT]])
; CHECK-NEXT:    ret float [[FABS]]
;
  %sqrt = call nsz float @llvm.sqrt.f32(float %a)
  %fabs = call float @llvm.fabs.f32(float %sqrt)
  ret float %fabs
}

; The fabs can be eliminated because we're nsz and nnan.
define float @fabs_sqrt_nnan_nsz(float %a) {
; CHECK-LABEL: @fabs_sqrt_nnan_nsz(
; CHECK-NEXT:    [[SQRT:%.*]] = call nnan nsz float @llvm.sqrt.f32(float [[A:%.*]])
; CHECK-NEXT:    ret float [[SQRT]]
;
  %sqrt = call nnan nsz float @llvm.sqrt.f32(float %a)
  %fabs = call float @llvm.fabs.f32(float %sqrt)
  ret float %fabs
}

; The second fabs can be eliminated because the operand to sqrt cannot be -0.
define float @fabs_sqrt_nnan_fabs(float %a) {
; CHECK-LABEL: @fabs_sqrt_nnan_fabs(
; CHECK-NEXT:    [[B:%.*]] = call float @llvm.fabs.f32(float [[A:%.*]])
; CHECK-NEXT:    [[SQRT:%.*]] = call nnan float @llvm.sqrt.f32(float [[B]])
; CHECK-NEXT:    ret float [[SQRT]]
;
  %b = call float @llvm.fabs.f32(float %a)
  %sqrt = call nnan float @llvm.sqrt.f32(float %b)
  %fabs = call float @llvm.fabs.f32(float %sqrt)
  ret float %fabs
}

define float @fabs_select_positive_constants_vector_extract(i32 %c) {
; CHECK-LABEL: @fabs_select_positive_constants_vector_extract(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], <2 x float> <float 1.000000e+00, float 1.000000e+00>, <2 x float> <float 2.000000e+00, float 2.000000e+00>
; CHECK-NEXT:    [[EXTRACT:%.*]] = extractelement <2 x float> [[SELECT]], i32 0
; CHECK-NEXT:    ret float [[EXTRACT]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, <2 x float> <float 1.0, float 1.0>, <2 x float> <float 2.0, float 2.0>
  %extract = extractelement <2 x float> %select, i32 0
  %fabs = call float @llvm.fabs.f32(float %extract)
  ret float %fabs
}

declare double @llvm.minnum.f64(double, double)
declare double @llvm.maxnum.f64(double, double)
declare <2 x double> @llvm.minnum.v2f64(<2 x double>, <2 x double>)
declare <2 x double> @llvm.maxnum.v2f64(<2 x double>, <2 x double>)

; From the LangRef for minnum/maxnum:
; "follows the IEEE-754 semantics for maxNum, which also match for libm’s fmax.
; If either operand is a NaN, returns the other non-NaN operand."

define double @maxnum_nan_op0(double %x) {
; CHECK-LABEL: @maxnum_nan_op0(
; CHECK-NEXT:    [[R:%.*]] = call double @llvm.maxnum.f64(double 0x7FF8000000000000, double [[X:%.*]])
; CHECK-NEXT:    ret double [[R]]
;
  %r = call double @llvm.maxnum.f64(double 0x7ff8000000000000, double %x)
  ret double %r
}

define double @maxnum_nan_op1(double %x) {
; CHECK-LABEL: @maxnum_nan_op1(
; CHECK-NEXT:    [[R:%.*]] = call double @llvm.maxnum.f64(double [[X:%.*]], double 0x7FF800000000DEAD)
; CHECK-NEXT:    ret double [[R]]
;
  %r = call double @llvm.maxnum.f64(double %x, double 0x7ff800000000dead)
  ret double %r
}

define double @minnum_nan_op0(double %x) {
; CHECK-LABEL: @minnum_nan_op0(
; CHECK-NEXT:    [[R:%.*]] = call double @llvm.minnum.f64(double 0x7FF8000DEAD00000, double [[X:%.*]])
; CHECK-NEXT:    ret double [[R]]
;
  %r = call double @llvm.minnum.f64(double 0x7ff8000dead00000, double %x)
  ret double %r
}

define double @minnum_nan_op1(double %x) {
; CHECK-LABEL: @minnum_nan_op1(
; CHECK-NEXT:    [[R:%.*]] = call double @llvm.minnum.f64(double [[X:%.*]], double 0x7FF800DEAD00DEAD)
; CHECK-NEXT:    ret double [[R]]
;
  %r = call double @llvm.minnum.f64(double %x, double 0x7ff800dead00dead)
  ret double %r
}

define <2 x double> @maxnum_nan_op0_vec(<2 x double> %x) {
; CHECK-LABEL: @maxnum_nan_op0_vec(
; CHECK-NEXT:    [[R:%.*]] = call <2 x double> @llvm.maxnum.v2f64(<2 x double> <double 0x7FF8000000000000, double undef>, <2 x double> [[X:%.*]])
; CHECK-NEXT:    ret <2 x double> [[R]]
;
  %r = call <2 x double> @llvm.maxnum.v2f64(<2 x double> <double 0x7ff8000000000000, double undef>, <2 x double> %x)
  ret <2 x double> %r
}

define <2 x double> @maxnum_nan_op1_vec(<2 x double> %x) {
; CHECK-LABEL: @maxnum_nan_op1_vec(
; CHECK-NEXT:    [[R:%.*]] = call <2 x double> @llvm.maxnum.v2f64(<2 x double> [[X:%.*]], <2 x double> <double 0x7FF800000000DEAD, double 0x7FF8FFFFFFFFFFFF>)
; CHECK-NEXT:    ret <2 x double> [[R]]
;
  %r = call <2 x double> @llvm.maxnum.v2f64(<2 x double> %x, <2 x double> <double 0x7ff800000000dead, double 0x7ff8ffffffffffff>)
  ret <2 x double> %r
}

define <2 x double> @minnum_nan_op0_vec(<2 x double> %x) {
; CHECK-LABEL: @minnum_nan_op0_vec(
; CHECK-NEXT:    [[R:%.*]] = call <2 x double> @llvm.minnum.v2f64(<2 x double> <double undef, double 0x7FF8000DEAD00000>, <2 x double> [[X:%.*]])
; CHECK-NEXT:    ret <2 x double> [[R]]
;
  %r = call <2 x double> @llvm.minnum.v2f64(<2 x double> <double undef, double 0x7ff8000dead00000>, <2 x double> %x)
  ret <2 x double> %r
}

define <2 x double> @minnum_nan_op1_vec(<2 x double> %x) {
; CHECK-LABEL: @minnum_nan_op1_vec(
; CHECK-NEXT:    [[R:%.*]] = call <2 x double> @llvm.minnum.v2f64(<2 x double> [[X:%.*]], <2 x double> <double 0x7FF800DEAD00DEAD, double 0x7FF800DEAD00DEAD>)
; CHECK-NEXT:    ret <2 x double> [[R]]
;
  %r = call <2 x double> @llvm.minnum.v2f64(<2 x double> %x, <2 x double> <double 0x7ff800dead00dead, double 0x7ff800dead00dead>)
  ret <2 x double> %r
}

