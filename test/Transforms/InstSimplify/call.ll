; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

declare {i8, i1} @llvm.uadd.with.overflow.i8(i8 %a, i8 %b)
declare {i8, i1} @llvm.sadd.with.overflow.i8(i8 %a, i8 %b)
declare {i8, i1} @llvm.usub.with.overflow.i8(i8 %a, i8 %b)
declare {i8, i1} @llvm.ssub.with.overflow.i8(i8 %a, i8 %b)
declare {i8, i1} @llvm.umul.with.overflow.i8(i8 %a, i8 %b)
declare {i8, i1} @llvm.smul.with.overflow.i8(i8 %a, i8 %b)

define i1 @test_uadd1() {
; CHECK-LABEL: @test_uadd1(
; CHECK-NEXT:    ret i1 true
;
  %x = call {i8, i1} @llvm.uadd.with.overflow.i8(i8 254, i8 3)
  %overflow = extractvalue {i8, i1} %x, 1
  ret i1 %overflow
}

define i8 @test_uadd2() {
; CHECK-LABEL: @test_uadd2(
; CHECK-NEXT:    ret i8 42
;
  %x = call {i8, i1} @llvm.uadd.with.overflow.i8(i8 254, i8 44)
  %result = extractvalue {i8, i1} %x, 0
  ret i8 %result
}

define {i8, i1} @test_uadd3(i8 %v) {
; CHECK-LABEL: @test_uadd3(
; CHECK-NEXT:    ret { i8, i1 } undef
;
  %result = call {i8, i1} @llvm.uadd.with.overflow.i8(i8 %v, i8 undef)
  ret {i8, i1} %result
}

define {i8, i1} @test_uadd4(i8 %v) {
; CHECK-LABEL: @test_uadd4(
; CHECK-NEXT:    ret { i8, i1 } undef
;
  %result = call {i8, i1} @llvm.uadd.with.overflow.i8(i8 undef, i8 %v)
  ret {i8, i1} %result
}

define i1 @test_sadd1() {
; CHECK-LABEL: @test_sadd1(
; CHECK-NEXT:    ret i1 true
;
  %x = call {i8, i1} @llvm.sadd.with.overflow.i8(i8 126, i8 3)
  %overflow = extractvalue {i8, i1} %x, 1
  ret i1 %overflow
}

define i8 @test_sadd2() {
; CHECK-LABEL: @test_sadd2(
; CHECK-NEXT:    ret i8 -86
;
  %x = call {i8, i1} @llvm.sadd.with.overflow.i8(i8 126, i8 44)
  %result = extractvalue {i8, i1} %x, 0
  ret i8 %result
}

define {i8, i1} @test_sadd3(i8 %v) {
; CHECK-LABEL: @test_sadd3(
; CHECK-NEXT:    ret { i8, i1 } undef
;
  %result = call {i8, i1} @llvm.sadd.with.overflow.i8(i8 %v, i8 undef)
  ret {i8, i1} %result
}

define {i8, i1} @test_sadd4(i8 %v) {
; CHECK-LABEL: @test_sadd4(
; CHECK-NEXT:    ret { i8, i1 } undef
;
  %result = call {i8, i1} @llvm.sadd.with.overflow.i8(i8 undef, i8 %v)
  ret {i8, i1} %result
}

define {i8, i1} @test_usub1(i8 %V) {
; CHECK-LABEL: @test_usub1(
; CHECK-NEXT:    ret { i8, i1 } zeroinitializer
;
  %x = call {i8, i1} @llvm.usub.with.overflow.i8(i8 %V, i8 %V)
  ret {i8, i1} %x
}

define {i8, i1} @test_usub2(i8 %V) {
; CHECK-LABEL: @test_usub2(
; CHECK-NEXT:    ret { i8, i1 } undef
;
  %x = call {i8, i1} @llvm.usub.with.overflow.i8(i8 %V, i8 undef)
  ret {i8, i1} %x
}

define {i8, i1} @test_usub3(i8 %V) {
; CHECK-LABEL: @test_usub3(
; CHECK-NEXT:    ret { i8, i1 } undef
;
  %x = call {i8, i1} @llvm.usub.with.overflow.i8(i8 undef, i8 %V)
  ret {i8, i1} %x
}

define {i8, i1} @test_ssub1(i8 %V) {
; CHECK-LABEL: @test_ssub1(
; CHECK-NEXT:    ret { i8, i1 } zeroinitializer
;
  %x = call {i8, i1} @llvm.ssub.with.overflow.i8(i8 %V, i8 %V)
  ret {i8, i1} %x
}

define {i8, i1} @test_ssub2(i8 %V) {
; CHECK-LABEL: @test_ssub2(
; CHECK-NEXT:    ret { i8, i1 } undef
;
  %x = call {i8, i1} @llvm.ssub.with.overflow.i8(i8 %V, i8 undef)
  ret {i8, i1} %x
}

define {i8, i1} @test_ssub3(i8 %V) {
; CHECK-LABEL: @test_ssub3(
; CHECK-NEXT:    ret { i8, i1 } undef
;
  %x = call {i8, i1} @llvm.ssub.with.overflow.i8(i8 undef, i8 %V)
  ret {i8, i1} %x
}

define {i8, i1} @test_umul1(i8 %V) {
; CHECK-LABEL: @test_umul1(
; CHECK-NEXT:    ret { i8, i1 } zeroinitializer
;
  %x = call {i8, i1} @llvm.umul.with.overflow.i8(i8 %V, i8 0)
  ret {i8, i1} %x
}

define {i8, i1} @test_umul2(i8 %V) {
; CHECK-LABEL: @test_umul2(
; CHECK-NEXT:    ret { i8, i1 } zeroinitializer
;
  %x = call {i8, i1} @llvm.umul.with.overflow.i8(i8 %V, i8 undef)
  ret {i8, i1} %x
}

define {i8, i1} @test_umul3(i8 %V) {
; CHECK-LABEL: @test_umul3(
; CHECK-NEXT:    ret { i8, i1 } zeroinitializer
;
  %x = call {i8, i1} @llvm.umul.with.overflow.i8(i8 0, i8 %V)
  ret {i8, i1} %x
}

define {i8, i1} @test_umul4(i8 %V) {
; CHECK-LABEL: @test_umul4(
; CHECK-NEXT:    ret { i8, i1 } zeroinitializer
;
  %x = call {i8, i1} @llvm.umul.with.overflow.i8(i8 undef, i8 %V)
  ret {i8, i1} %x
}

define {i8, i1} @test_smul1(i8 %V) {
; CHECK-LABEL: @test_smul1(
; CHECK-NEXT:    ret { i8, i1 } zeroinitializer
;
  %x = call {i8, i1} @llvm.smul.with.overflow.i8(i8 %V, i8 0)
  ret {i8, i1} %x
}

define {i8, i1} @test_smul2(i8 %V) {
; CHECK-LABEL: @test_smul2(
; CHECK-NEXT:    ret { i8, i1 } zeroinitializer
;
  %x = call {i8, i1} @llvm.smul.with.overflow.i8(i8 %V, i8 undef)
  ret {i8, i1} %x
}

define {i8, i1} @test_smul3(i8 %V) {
; CHECK-LABEL: @test_smul3(
; CHECK-NEXT:    ret { i8, i1 } zeroinitializer
;
  %x = call {i8, i1} @llvm.smul.with.overflow.i8(i8 0, i8 %V)
  ret {i8, i1} %x
}

define {i8, i1} @test_smul4(i8 %V) {
; CHECK-LABEL: @test_smul4(
; CHECK-NEXT:    ret { i8, i1 } zeroinitializer
;
  %x = call {i8, i1} @llvm.smul.with.overflow.i8(i8 undef, i8 %V)
  ret {i8, i1} %x
}

declare i256 @llvm.cttz.i256(i256 %src, i1 %is_zero_undef)

define i256 @test_cttz() {
; CHECK-LABEL: @test_cttz(
; CHECK-NEXT:    ret i256 1
;
  %x = call i256 @llvm.cttz.i256(i256 10, i1 false)
  ret i256 %x
}

declare <2 x i256> @llvm.cttz.v2i256(<2 x i256> %src, i1 %is_zero_undef)

define <2 x i256> @test_cttz_vec() {
; CHECK-LABEL: @test_cttz_vec(
; CHECK-NEXT:    ret <2 x i256> <i256 1, i256 1>
;
  %x = call <2 x i256> @llvm.cttz.v2i256(<2 x i256> <i256 10, i256 10>, i1 false)
  ret <2 x i256> %x
}

declare i256 @llvm.ctpop.i256(i256 %src)

define i256 @test_ctpop() {
; CHECK-LABEL: @test_ctpop(
; CHECK-NEXT:    ret i256 2
;
  %x = call i256 @llvm.ctpop.i256(i256 10)
  ret i256 %x
}

; Test a non-intrinsic that we know about as a library call.
declare float @fabs(float %x)

define float @test_fabs_libcall() {
; CHECK-LABEL: @test_fabs_libcall(
; CHECK-NEXT:    [[X:%.*]] = call float @fabs(float -4.200000e+01)
; CHECK-NEXT:    ret float 4.200000e+01
;

  %x = call float @fabs(float -42.0)
; This is still a real function call, so instsimplify won't nuke it -- other
; passes have to do that.

  ret float %x
}


declare float @llvm.fabs.f32(float) nounwind readnone
declare float @llvm.floor.f32(float) nounwind readnone
declare float @llvm.ceil.f32(float) nounwind readnone
declare float @llvm.trunc.f32(float) nounwind readnone
declare float @llvm.rint.f32(float) nounwind readnone
declare float @llvm.nearbyint.f32(float) nounwind readnone

; Test idempotent intrinsics
define float @test_idempotence(float %a) {
; CHECK-LABEL: @test_idempotence(
; CHECK-NEXT:    [[A0:%.*]] = call float @llvm.fabs.f32(float [[A:%.*]])
; CHECK-NEXT:    [[B0:%.*]] = call float @llvm.floor.f32(float [[A]])
; CHECK-NEXT:    [[C0:%.*]] = call float @llvm.ceil.f32(float [[A]])
; CHECK-NEXT:    [[D0:%.*]] = call float @llvm.trunc.f32(float [[A]])
; CHECK-NEXT:    [[E0:%.*]] = call float @llvm.rint.f32(float [[A]])
; CHECK-NEXT:    [[F0:%.*]] = call float @llvm.nearbyint.f32(float [[A]])
; CHECK-NEXT:    [[R0:%.*]] = fadd float [[A0]], [[B0]]
; CHECK-NEXT:    [[R1:%.*]] = fadd float [[R0]], [[C0]]
; CHECK-NEXT:    [[R2:%.*]] = fadd float [[R1]], [[D0]]
; CHECK-NEXT:    [[R3:%.*]] = fadd float [[R2]], [[E0]]
; CHECK-NEXT:    [[R4:%.*]] = fadd float [[R3]], [[F0]]
; CHECK-NEXT:    ret float [[R4]]
;

  %a0 = call float @llvm.fabs.f32(float %a)
  %a1 = call float @llvm.fabs.f32(float %a0)

  %b0 = call float @llvm.floor.f32(float %a)
  %b1 = call float @llvm.floor.f32(float %b0)

  %c0 = call float @llvm.ceil.f32(float %a)
  %c1 = call float @llvm.ceil.f32(float %c0)

  %d0 = call float @llvm.trunc.f32(float %a)
  %d1 = call float @llvm.trunc.f32(float %d0)

  %e0 = call float @llvm.rint.f32(float %a)
  %e1 = call float @llvm.rint.f32(float %e0)

  %f0 = call float @llvm.nearbyint.f32(float %a)
  %f1 = call float @llvm.nearbyint.f32(float %f0)

  %r0 = fadd float %a1, %b1
  %r1 = fadd float %r0, %c1
  %r2 = fadd float %r1, %d1
  %r3 = fadd float %r2, %e1
  %r4 = fadd float %r3, %f1

  ret float %r4
}

define i8* @operator_new() {
; CHECK-LABEL: @operator_new(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = tail call noalias i8* @_Znwm(i64 8)
; CHECK-NEXT:    br i1 false, label [[CAST_END:%.*]], label [[CAST_NOTNULL:%.*]]
; CHECK:       cast.notnull:
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i8, i8* [[CALL]], i64 4
; CHECK-NEXT:    br label [[CAST_END]]
; CHECK:       cast.end:
; CHECK-NEXT:    [[CAST_RESULT:%.*]] = phi i8* [ [[ADD_PTR]], [[CAST_NOTNULL]] ], [ null, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i8* [[CAST_RESULT]]
;
entry:
  %call = tail call noalias i8* @_Znwm(i64 8)
  %cmp = icmp eq i8* %call, null
  br i1 %cmp, label %cast.end, label %cast.notnull

cast.notnull:                                     ; preds = %entry
  %add.ptr = getelementptr inbounds i8, i8* %call, i64 4
  br label %cast.end

cast.end:                                         ; preds = %cast.notnull, %entry
  %cast.result = phi i8* [ %add.ptr, %cast.notnull ], [ null, %entry ]
  ret i8* %cast.result

}

declare nonnull noalias i8* @_Znwm(i64)

%"struct.std::nothrow_t" = type { i8 }
@_ZSt7nothrow = external global %"struct.std::nothrow_t"

define i8* @operator_new_nothrow_t() {
; CHECK-LABEL: @operator_new_nothrow_t(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = tail call noalias i8* @_ZnamRKSt9nothrow_t(i64 8, %"struct.std::nothrow_t"* @_ZSt7nothrow)
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8* [[CALL]], null
; CHECK-NEXT:    br i1 [[CMP]], label [[CAST_END:%.*]], label [[CAST_NOTNULL:%.*]]
; CHECK:       cast.notnull:
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i8, i8* [[CALL]], i64 4
; CHECK-NEXT:    br label [[CAST_END]]
; CHECK:       cast.end:
; CHECK-NEXT:    [[CAST_RESULT:%.*]] = phi i8* [ [[ADD_PTR]], [[CAST_NOTNULL]] ], [ null, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i8* [[CAST_RESULT]]
;
entry:
  %call = tail call noalias i8* @_ZnamRKSt9nothrow_t(i64 8, %"struct.std::nothrow_t"* @_ZSt7nothrow)
  %cmp = icmp eq i8* %call, null
  br i1 %cmp, label %cast.end, label %cast.notnull

cast.notnull:                                     ; preds = %entry
  %add.ptr = getelementptr inbounds i8, i8* %call, i64 4
  br label %cast.end

cast.end:                                         ; preds = %cast.notnull, %entry
  %cast.result = phi i8* [ %add.ptr, %cast.notnull ], [ null, %entry ]
  ret i8* %cast.result

}

declare i8* @_ZnamRKSt9nothrow_t(i64, %"struct.std::nothrow_t"*) nounwind

define i8* @malloc_can_return_null() {
; CHECK-LABEL: @malloc_can_return_null(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = tail call noalias i8* @malloc(i64 8)
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8* [[CALL]], null
; CHECK-NEXT:    br i1 [[CMP]], label [[CAST_END:%.*]], label [[CAST_NOTNULL:%.*]]
; CHECK:       cast.notnull:
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i8, i8* [[CALL]], i64 4
; CHECK-NEXT:    br label [[CAST_END]]
; CHECK:       cast.end:
; CHECK-NEXT:    [[CAST_RESULT:%.*]] = phi i8* [ [[ADD_PTR]], [[CAST_NOTNULL]] ], [ null, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i8* [[CAST_RESULT]]
;
entry:
  %call = tail call noalias i8* @malloc(i64 8)
  %cmp = icmp eq i8* %call, null
  br i1 %cmp, label %cast.end, label %cast.notnull

cast.notnull:                                     ; preds = %entry
  %add.ptr = getelementptr inbounds i8, i8* %call, i64 4
  br label %cast.end

cast.end:                                         ; preds = %cast.notnull, %entry
  %cast.result = phi i8* [ %add.ptr, %cast.notnull ], [ null, %entry ]
  ret i8* %cast.result

}

define i32 @call_null() {
; CHECK-LABEL: @call_null(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = call i32 null()
; CHECK-NEXT:    ret i32 undef
;
entry:
  %call = call i32 null()
  ret i32 %call
}

define i32 @call_undef() {
; CHECK-LABEL: @call_undef(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = call i32 undef()
; CHECK-NEXT:    ret i32 undef
;
entry:
  %call = call i32 undef()
  ret i32 %call
}

@GV = private constant [8 x i32] [i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49]

define <8 x i32> @partial_masked_load() {
; CHECK-LABEL: @partial_masked_load(
; CHECK-NEXT:    ret <8 x i32> <i32 undef, i32 undef, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
;
  %masked.load = call <8 x i32> @llvm.masked.load.v8i32.p0v8i32(<8 x i32>* bitcast (i32* getelementptr ([8 x i32], [8 x i32]* @GV, i64 0, i64 -2) to <8 x i32>*), i32 4, <8 x i1> <i1 false, i1 false, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i32> undef)
  ret <8 x i32> %masked.load
}

define <8 x i32> @masked_load_undef_mask(<8 x i32>* %V) {
; CHECK-LABEL: @masked_load_undef_mask(
; CHECK-NEXT:    ret <8 x i32> <i32 1, i32 0, i32 1, i32 0, i32 1, i32 0, i32 1, i32 0>
;
  %masked.load = call <8 x i32> @llvm.masked.load.v8i32.p0v8i32(<8 x i32>* %V, i32 4, <8 x i1> undef, <8 x i32> <i32 1, i32 0, i32 1, i32 0, i32 1, i32 0, i32 1, i32 0>)
  ret <8 x i32> %masked.load
}

declare noalias i8* @malloc(i64)

declare <8 x i32> @llvm.masked.load.v8i32.p0v8i32(<8 x i32>*, i32, <8 x i1>, <8 x i32>)

declare double @llvm.powi.f64(double, i32)
declare <2 x double> @llvm.powi.v2f64(<2 x double>, i32)

define double @constant_fold_powi() nounwind uwtable ssp {
; CHECK-LABEL: @constant_fold_powi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 9.000000e+00
;
entry:
  %0 = call double @llvm.powi.f64(double 3.00000e+00, i32 2)
  ret double %0
}

define <2 x double> @constant_fold_powi_vec() nounwind uwtable ssp {
; CHECK-LABEL: @constant_fold_powi_vec(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call <2 x double> @llvm.powi.v2f64(<2 x double> <double 3.000000e+00, double 5.000000e+00>, i32 2)
; CHECK-NEXT:    ret <2 x double> [[TMP0]]
;
entry:
  %0 = call <2 x double> @llvm.powi.v2f64(<2 x double> <double 3.00000e+00, double 5.00000e+00>, i32 2)
  ret <2 x double> %0
}
