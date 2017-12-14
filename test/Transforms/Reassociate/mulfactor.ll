; RUN: opt < %s -reassociate -S | FileCheck %s

define i32 @test1(i32 %a, i32 %b) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[T2:%.*]] = mul i32 %a, %a
; CHECK-NEXT:    [[T6:%.*]] = mul i32 %a, 2
; CHECK-NEXT:    [[REASS_ADD:%.*]] = add i32 [[T6]], %b
; CHECK-NEXT:    [[REASS_MUL:%.*]] = mul i32 [[REASS_ADD]], %b
; CHECK-NEXT:    [[T11:%.*]] = add i32 [[REASS_MUL]], [[T2]]
; CHECK-NEXT:    ret i32 [[T11]]
;
  %t2 = mul i32 %a, %a
  %t5 = shl i32 %a, 1
  %t6 = mul i32 %t5, %b
  %t8 = mul i32 %b, %b
  %t7 = add i32 %t6, %t2
  %t11 = add i32 %t7, %t8
  ret i32 %t11
}

define i32 @test2(i32 %t) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[REASS_MUL:%.*]] = mul i32 %t, 42
; CHECK-NEXT:    [[D:%.*]] = add i32 [[REASS_MUL]], 15
; CHECK-NEXT:    ret i32 [[D]]
;
  %a = mul i32 %t, 6
  %b = mul i32 %t, 36
  %c = add i32 %b, 15
  %d = add i32 %c, %a
  ret i32 %d
}

; (x^8)
define i32 @test3(i32 %x) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 %x, %x
; CHECK-NEXT:    [[TMP2:%.*]] = mul i32 [[TMP1]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = mul i32 [[TMP2]], [[TMP2]]
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %a = mul i32 %x, %x
  %b = mul i32 %a, %x
  %c = mul i32 %b, %x
  %d = mul i32 %c, %x
  %e = mul i32 %d, %x
  %f = mul i32 %e, %x
  %g = mul i32 %f, %x
  ret i32 %g
}

; (x^7)
define i32 @test4(i32 %x) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 %x, %x
; CHECK-NEXT:    [[TMP2:%.*]] = mul i32 [[TMP1]], %x
; CHECK-NEXT:    [[TMP3:%.*]] = mul i32 [[TMP2]], %x
; CHECK-NEXT:    [[F:%.*]] = mul i32 [[TMP3]], [[TMP2]]
; CHECK-NEXT:    ret i32 [[F]]
;
  %a = mul i32 %x, %x
  %b = mul i32 %a, %x
  %c = mul i32 %b, %x
  %d = mul i32 %c, %x
  %e = mul i32 %d, %x
  %f = mul i32 %e, %x
  ret i32 %f
}

; (x^4) * (y^2)
define i32 @test5(i32 %x, i32 %y) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 %x, %x
; CHECK-NEXT:    [[TMP2:%.*]] = mul i32 [[TMP1]], %y
; CHECK-NEXT:    [[TMP3:%.*]] = mul i32 [[TMP2]], [[TMP2]]
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %a = mul i32 %x, %y
  %b = mul i32 %a, %y
  %c = mul i32 %b, %x
  %d = mul i32 %c, %x
  %e = mul i32 %d, %x
  ret i32 %e
}

; (x^5) * (y^3) * z
define i32 @test6(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 %x, %x
; CHECK-NEXT:    [[TMP2:%.*]] = mul i32 [[TMP1]], %y
; CHECK-NEXT:    [[F:%.*]] = mul i32 %y, %x
; CHECK-NEXT:    [[G:%.*]] = mul i32 [[F]], [[TMP2]]
; CHECK-NEXT:    [[TMP3:%.*]] = mul i32 [[G]], [[TMP2]]
; CHECK-NEXT:    [[H:%.*]] = mul i32 [[TMP3]], %z
; CHECK-NEXT:    ret i32 [[H]]
;
  %a = mul i32 %x, %y
  %b = mul i32 %a, %x
  %c = mul i32 %b, %y
  %d = mul i32 %c, %x
  %e = mul i32 %d, %y
  %f = mul i32 %e, %x
  %g = mul i32 %f, %z
  %h = mul i32 %g, %x
  ret i32 %h
}

; (x^4) * (y^3) * (z^2)
define i32 @test7(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 %x, %x
; CHECK-NEXT:    [[TMP2:%.*]] = mul i32 [[TMP1]], %y
; CHECK-NEXT:    [[TMP3:%.*]] = mul i32 [[TMP2]], %z
; CHECK-NEXT:    [[TMP4:%.*]] = mul i32 [[TMP3]], %y
; CHECK-NEXT:    [[H:%.*]] = mul i32 [[TMP4]], [[TMP3]]
; CHECK-NEXT:    ret i32 [[H]]
;
  %a = mul i32 %y, %x
  %b = mul i32 %a, %z
  %c = mul i32 %b, %z
  %d = mul i32 %c, %x
  %e = mul i32 %d, %y
  %f = mul i32 %e, %y
  %g = mul i32 %f, %x
  %h = mul i32 %g, %x
  ret i32 %h
}

