; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

define i32 @test1(i32 %x) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i32 %x
;
  %and = and i32 %x, 1
  %cmp = icmp eq i32 %and, 0
  %and1 = and i32 %x, -2
  %and1.x = select i1 %cmp, i32 %and1, i32 %x
  ret i32 %and1.x
}

define i32 @test2(i32 %x) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i32 %x
;
  %and = and i32 %x, 1
  %cmp = icmp ne i32 %and, 0
  %and1 = and i32 %x, -2
  %and1.x = select i1 %cmp, i32 %x, i32 %and1
  ret i32 %and1.x
}

define i32 @test3(i32 %x) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[AND1:%.*]] = and i32 %x, -2
; CHECK-NEXT:    ret i32 [[AND1]]
;
  %and = and i32 %x, 1
  %cmp = icmp ne i32 %and, 0
  %and1 = and i32 %x, -2
  %and1.x = select i1 %cmp, i32 %and1, i32 %x
  ret i32 %and1.x
}

define i32 @test4(i32 %X) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[OR:%.*]] = or i32 %X, -2147483648
; CHECK-NEXT:    ret i32 [[OR]]
;
  %cmp = icmp slt i32 %X, 0
  %or = or i32 %X, -2147483648
  %cond = select i1 %cmp, i32 %X, i32 %or
  ret i32 %cond
}

; Same as above, but the compare isn't canonical
; TODO: we should be able to simplify this
define i32 @test4noncanon(i32 %X) {
; CHECK-LABEL: @test4noncanon(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i32 [[X:%.*]], -1
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[X]], -2147483648
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP]], i32 [[X]], i32 [[OR]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp sle i32 %X, -1
  %or = or i32 %X, -2147483648
  %cond = select i1 %cmp, i32 %X, i32 %or
  ret i32 %cond
}

define i32 @test5(i32 %X) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    ret i32 %X
;
  %cmp = icmp slt i32 %X, 0
  %or = or i32 %X, -2147483648
  %cond = select i1 %cmp, i32 %or, i32 %X
  ret i32 %cond
}

define i32 @test6(i32 %X) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[AND:%.*]] = and i32 %X, 2147483647
; CHECK-NEXT:    ret i32 [[AND]]
;
  %cmp = icmp slt i32 %X, 0
  %and = and i32 %X, 2147483647
  %cond = select i1 %cmp, i32 %and, i32 %X
  ret i32 %cond
}

define i32 @test7(i32 %X) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    ret i32 %X
;
  %cmp = icmp slt i32 %X, 0
  %and = and i32 %X, 2147483647
  %cond = select i1 %cmp, i32 %X, i32 %and
  ret i32 %cond
}

define i32 @test8(i32 %X) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    ret i32 %X
;
  %cmp = icmp sgt i32 %X, -1
  %or = or i32 %X, -2147483648
  %cond = select i1 %cmp, i32 %X, i32 %or
  ret i32 %cond
}

define i32 @test9(i32 %X) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[OR:%.*]] = or i32 %X, -2147483648
; CHECK-NEXT:    ret i32 [[OR]]
;
  %cmp = icmp sgt i32 %X, -1
  %or = or i32 %X, -2147483648
  %cond = select i1 %cmp, i32 %or, i32 %X
  ret i32 %cond
}

; Same as above, but the compare isn't canonical
; TODO: we should be able to simplify this
define i32 @test9noncanon(i32 %X) {
; CHECK-LABEL: @test9noncanon(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sge i32 [[X:%.*]], 0
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[X]], -2147483648
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP]], i32 [[OR]], i32 [[X]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp sge i32 %X, 0
  %or = or i32 %X, -2147483648
  %cond = select i1 %cmp, i32 %or, i32 %X
  ret i32 %cond
}

define i32 @test10(i32 %X) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    ret i32 %X
;
  %cmp = icmp sgt i32 %X, -1
  %and = and i32 %X, 2147483647
  %cond = select i1 %cmp, i32 %and, i32 %X
  ret i32 %cond
}

define i32 @test11(i32 %X) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[AND:%.*]] = and i32 %X, 2147483647
; CHECK-NEXT:    ret i32 [[AND]]
;
  %cmp = icmp sgt i32 %X, -1
  %and = and i32 %X, 2147483647
  %cond = select i1 %cmp, i32 %X, i32 %and
  ret i32 %cond
}

define <2 x i8> @test11vec(<2 x i8> %X) {
; CHECK-LABEL: @test11vec(
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i8> %X, <i8 127, i8 127>
; CHECK-NEXT:    ret <2 x i8> [[AND]]
;
  %cmp = icmp sgt <2 x i8> %X, <i8 -1, i8 -1>
  %and = and <2 x i8> %X, <i8 127, i8 127>
  %sel = select <2 x i1> %cmp, <2 x i8> %X, <2 x i8> %and
  ret <2 x i8> %sel
}

; TODO: we should be able to simplify this
define i32 @test12(i32 %X) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[X:%.*]], 4
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X]], 3
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP]], i32 [[X]], i32 [[AND]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp ult i32 %X, 4
  %and = and i32 %X, 3
  %cond = select i1 %cmp, i32 %X, i32 %and
  ret i32 %cond
}

; Same as above, but the compare isn't canonical
; TODO: we should be able to simplify this
define i32 @test12noncanon(i32 %X) {
; CHECK-LABEL: @test12noncanon(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i32 [[X:%.*]], 3
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X]], 3
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP]], i32 [[X]], i32 [[AND]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp ule i32 %X, 3
  %and = and i32 %X, 3
  %cond = select i1 %cmp, i32 %X, i32 %and
  ret i32 %cond
}

; TODO: we should be able to simplify this
define i32 @test13(i32 %X) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i32 [[X:%.*]], 3
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X]], 3
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP]], i32 [[AND]], i32 [[X]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp ugt i32 %X, 3
  %and = and i32 %X, 3
  %cond = select i1 %cmp, i32 %and, i32 %X
  ret i32 %cond
}

; Same as above, but the compare isn't canonical
; TODO: we should be able to simplify this
define i32 @test13noncanon(i32 %X) {
; CHECK-LABEL: @test13noncanon(
; CHECK-NEXT:    [[CMP:%.*]] = icmp uge i32 [[X:%.*]], 4
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X]], 3
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[CMP]], i32 [[AND]], i32 [[X]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %cmp = icmp uge i32 %X, 4
  %and = and i32 %X, 3
  %cond = select i1 %cmp, i32 %and, i32 %X
  ret i32 %cond
}

define i32 @select_icmp_and_8_eq_0_or_8(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_eq_0_or_8(
; CHECK-NEXT:    [[OR:%.*]] = or i32 %x, 8
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %or = or i32 %x, 8
  %sel = select i1 %cmp, i32 %or, i32 %x
  ret i32 %sel
}

define i32 @select_icmp_and_8_eq_0_or_8_alt(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_eq_0_or_8_alt(
; CHECK-NEXT:    [[OR:%.*]] = or i32 %x, 8
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %x, 8
  %cmp = icmp ne i32 %and, 0
  %or = or i32 %x, 8
  %sel = select i1 %cmp, i32 %x, i32 %or
  ret i32 %sel
}

define i32 @select_icmp_and_8_ne_0_or_8(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_ne_0_or_8(
; CHECK-NEXT:    ret i32 %x
;
  %and = and i32 %x, 8
  %cmp = icmp ne i32 %and, 0
  %or = or i32 %x, 8
  %sel = select i1 %cmp, i32 %or, i32 %x
  ret i32 %sel
}

define i32 @select_icmp_and_8_ne_0_or_8_alt(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_ne_0_or_8_alt(
; CHECK-NEXT:    ret i32 %x
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %or = or i32 %x, 8
  %sel = select i1 %cmp, i32 %x, i32 %or
  ret i32 %sel
}

define i32 @select_icmp_and_8_eq_0_and_not_8(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_eq_0_and_not_8(
; CHECK-NEXT:    [[AND1:%.*]] = and i32 %x, -9
; CHECK-NEXT:    ret i32 [[AND1]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %and1 = and i32 %x, -9
  %sel = select i1 %cmp, i32 %x, i32 %and1
  ret i32 %sel
}

define i32 @select_icmp_and_8_eq_0_and_not_8_alt(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_eq_0_and_not_8_alt(
; CHECK-NEXT:    [[AND1:%.*]] = and i32 %x, -9
; CHECK-NEXT:    ret i32 [[AND1]]
;
  %and = and i32 %x, 8
  %cmp = icmp ne i32 %and, 0
  %and1 = and i32 %x, -9
  %sel = select i1 %cmp, i32 %and1, i32 %x
  ret i32 %sel
}

define i32 @select_icmp_and_8_ne_0_and_not_8(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_ne_0_and_not_8(
; CHECK-NEXT:    ret i32 %x
;
  %and = and i32 %x, 8
  %cmp = icmp ne i32 %and, 0
  %and1 = and i32 %x, -9
  %sel = select i1 %cmp, i32 %x, i32 %and1
  ret i32 %sel
}

define i32 @select_icmp_and_8_ne_0_and_not_8_alt(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_ne_0_and_not_8_alt(
; CHECK-NEXT:    ret i32 %x
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %and1 = and i32 %x, -9
  %sel = select i1 %cmp, i32 %and1, i32 %x
  ret i32 %sel
}

; PR28466: https://llvm.org/bugs/show_bug.cgi?id=28466
; Each of the previous 8 patterns has a variant that replaces the
; 'and' with a 'trunc' and the icmp eq/ne with icmp slt/sgt.

define i32 @select_icmp_trunc_8_ne_0_or_128(i32 %x) {
; CHECK-LABEL: @select_icmp_trunc_8_ne_0_or_128(
; CHECK-NEXT:    [[OR:%.*]] = or i32 %x, 128
; CHECK-NEXT:    ret i32 [[OR]]
;
  %trunc = trunc i32 %x to i8
  %cmp = icmp sgt i8 %trunc, -1
  %or = or i32 %x, 128
  %sel = select i1 %cmp, i32 %or, i32 %x
  ret i32 %sel
}

define i32 @select_icmp_trunc_8_ne_0_or_128_alt(i32 %x) {
; CHECK-LABEL: @select_icmp_trunc_8_ne_0_or_128_alt(
; CHECK-NEXT:    [[OR:%.*]] = or i32 %x, 128
; CHECK-NEXT:    ret i32 [[OR]]
;
  %trunc = trunc i32 %x to i8
  %cmp = icmp slt i8 %trunc, 0
  %or = or i32 %x, 128
  %sel = select i1 %cmp, i32 %x, i32 %or
  ret i32 %sel
}

define i32 @select_icmp_trunc_8_eq_0_or_128(i32 %x) {
; CHECK-LABEL: @select_icmp_trunc_8_eq_0_or_128(
; CHECK-NEXT:    ret i32 %x
;
  %trunc = trunc i32 %x to i8
  %cmp = icmp slt i8 %trunc, 0
  %or = or i32 %x, 128
  %sel = select i1 %cmp, i32 %or, i32 %x
  ret i32 %sel
}

define i32 @select_icmp_trunc_8_eq_0_or_128_alt(i32 %x) {
; CHECK-LABEL: @select_icmp_trunc_8_eq_0_or_128_alt(
; CHECK-NEXT:    ret i32 %x
;
  %trunc = trunc i32 %x to i8
  %cmp = icmp sgt i8 %trunc, -1
  %or = or i32 %x, 128
  %sel = select i1 %cmp, i32 %x, i32 %or
  ret i32 %sel
}

define i32 @select_icmp_trunc_8_eq_0_and_not_8(i32 %x) {
; CHECK-LABEL: @select_icmp_trunc_8_eq_0_and_not_8(
; CHECK-NEXT:    [[AND:%.*]] = and i32 %x, -9
; CHECK-NEXT:    ret i32 [[AND]]
;
  %trunc = trunc i32 %x to i4
  %cmp = icmp sgt i4 %trunc, -1
  %and = and i32 %x, -9
  %sel = select i1 %cmp, i32 %x, i32 %and
  ret i32 %sel
}

define i32 @select_icmp_trunc_8_eq_0_and_not_8_alt(i32 %x) {
; CHECK-LABEL: @select_icmp_trunc_8_eq_0_and_not_8_alt(
; CHECK-NEXT:    [[AND:%.*]] = and i32 %x, -9
; CHECK-NEXT:    ret i32 [[AND]]
;
  %trunc = trunc i32 %x to i4
  %cmp = icmp slt i4 %trunc, 0
  %and = and i32 %x, -9
  %sel = select i1 %cmp, i32 %and, i32 %x
  ret i32 %sel
}

define i32 @select_icmp_trunc_8_ne_0_and_not_8(i32 %x) {
; CHECK-LABEL: @select_icmp_trunc_8_ne_0_and_not_8(
; CHECK-NEXT:    ret i32 %x
;
  %trunc = trunc i32 %x to i4
  %cmp = icmp slt i4 %trunc, 0
  %and = and i32 %x, -9
  %sel = select i1 %cmp, i32 %x, i32 %and
  ret i32 %sel
}

define i32 @select_icmp_trunc_8_ne_0_and_not_8_alt(i32 %x) {
; CHECK-LABEL: @select_icmp_trunc_8_ne_0_and_not_8_alt(
; CHECK-NEXT:    ret i32 %x
;
  %trunc = trunc i32 %x to i4
  %cmp = icmp sgt i4 %trunc, -1
  %and = and i32 %x, -9
  %sel = select i1 %cmp, i32 %and, i32 %x
  ret i32 %sel
}

; Make sure that at least a few of the same patterns are repeated with vector types.

define <2 x i32> @select_icmp_and_8_ne_0_and_not_8_vec(<2 x i32> %x) {
; CHECK-LABEL: @select_icmp_and_8_ne_0_and_not_8_vec(
; CHECK-NEXT:    ret <2 x i32> %x
;
  %and = and <2 x i32> %x, <i32 8, i32 8>
  %cmp = icmp ne <2 x i32> %and, zeroinitializer
  %and1 = and <2 x i32> %x, <i32 -9, i32 -9>
  %sel = select <2 x i1> %cmp, <2 x i32> %x, <2 x i32> %and1
  ret <2 x i32> %sel
}

define <2 x i32> @select_icmp_trunc_8_ne_0_and_not_8_alt_vec(<2 x i32> %x) {
; CHECK-LABEL: @select_icmp_trunc_8_ne_0_and_not_8_alt_vec(
; CHECK-NEXT:    ret <2 x i32> %x
;
  %trunc = trunc <2 x i32> %x to <2 x i4>
  %cmp = icmp sgt <2 x i4> %trunc, <i4 -1, i4 -1>
  %and = and <2 x i32> %x, <i32 -9, i32 -9>
  %sel = select <2 x i1> %cmp, <2 x i32> %and, <2 x i32> %x
  ret <2 x i32> %sel
}

; Insert a bit from x into y? This should be possible in InstCombine, but not InstSimplify?

define i32 @select_icmp_x_and_8_eq_0_y_and_not_8(i32 %x, i32 %y) {
; CHECK-LABEL: @select_icmp_x_and_8_eq_0_y_and_not_8(
; CHECK-NEXT:    [[AND:%.*]] = and i32 %x, 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[AND1:%.*]] = and i32 %y, -9
; CHECK-NEXT:    [[Y_AND1:%.*]] = select i1 [[CMP]], i32 %y, i32 [[AND1]]
; CHECK-NEXT:    ret i32 [[Y_AND1]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %and1 = and i32 %y, -9
  %y.and1 = select i1 %cmp, i32 %y, i32 %and1
  ret i32 %y.and1
}

define i64 @select_icmp_x_and_8_eq_0_y64_and_not_8(i32 %x, i64 %y) {
; CHECK-LABEL: @select_icmp_x_and_8_eq_0_y64_and_not_8(
; CHECK-NEXT:    [[AND:%.*]] = and i32 %x, 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[AND1:%.*]] = and i64 %y, -9
; CHECK-NEXT:    [[Y_AND1:%.*]] = select i1 [[CMP]], i64 %y, i64 [[AND1]]
; CHECK-NEXT:    ret i64 [[Y_AND1]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %and1 = and i64 %y, -9
  %y.and1 = select i1 %cmp, i64 %y, i64 %and1
  ret i64 %y.and1
}

define i64 @select_icmp_x_and_8_ne_0_y64_and_not_8(i32 %x, i64 %y) {
; CHECK-LABEL: @select_icmp_x_and_8_ne_0_y64_and_not_8(
; CHECK-NEXT:    [[AND:%.*]] = and i32 %x, 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[AND1:%.*]] = and i64 %y, -9
; CHECK-NEXT:    [[AND1_Y:%.*]] = select i1 [[CMP]], i64 [[AND1]], i64 %y
; CHECK-NEXT:    ret i64 [[AND1_Y]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %and1 = and i64 %y, -9
  %and1.y = select i1 %cmp, i64 %and1, i64 %y
  ret i64 %and1.y
}

; Don't crash on a pointer or aggregate type.

define i32* @select_icmp_pointers(i32* %x, i32* %y) {
; CHECK-LABEL: @select_icmp_pointers(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32* %x, null
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[CMP]], i32* %x, i32* %y
; CHECK-NEXT:    ret i32* [[SEL]]
;
  %cmp = icmp slt i32* %x, null
  %sel = select i1 %cmp, i32* %x, i32* %y
  ret i32* %sel
}

; If the condition is known, we don't need to select, but we're not
; doing this fold here to avoid compile-time cost.

declare void @llvm.assume(i1)

define i8 @assume_sel_cond(i1 %cond, i8 %x, i8 %y) {
; CHECK-LABEL: @assume_sel_cond(
; CHECK-NEXT:    call void @llvm.assume(i1 %cond)
; CHECK-NEXT:    [[SEL:%.*]] = select i1 %cond, i8 %x, i8 %y
; CHECK-NEXT:    ret i8 [[SEL]]
;
  call void @llvm.assume(i1 %cond)
  %sel = select i1 %cond, i8 %x, i8 %y
  ret i8 %sel
}

define i8 @do_not_assume_sel_cond(i1 %cond, i8 %x, i8 %y) {
; CHECK-LABEL: @do_not_assume_sel_cond(
; CHECK-NEXT:    [[NOTCOND:%.*]] = icmp eq i1 %cond, false
; CHECK-NEXT:    call void @llvm.assume(i1 [[NOTCOND]])
; CHECK-NEXT:    [[SEL:%.*]] = select i1 %cond, i8 %x, i8 %y
; CHECK-NEXT:    ret i8 [[SEL]]
;
  %notcond = icmp eq i1 %cond, false
  call void @llvm.assume(i1 %notcond)
  %sel = select i1 %cond, i8 %x, i8 %y
  ret i8 %sel
}

