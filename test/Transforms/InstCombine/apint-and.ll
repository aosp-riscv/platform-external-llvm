; RUN: opt < %s -instcombine -S | FileCheck %s

; FIXME: Some of these tests belong in InstSimplify.

; Integer BitWidth <= 64 && BitWidth % 8 != 0.

define i39 @test0(i39 %A) {
; CHECK-LABEL: @test0(
; CHECK-NEXT:    ret i39 0
;
  %B = and i39 %A, 0 ; zero result
  ret i39 %B
}

define i15 @test2(i15 %x) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i15 %x
;
  %tmp.2 = and i15 %x, -1 ; noop
  ret i15 %tmp.2
}

define i23 @test3(i23 %x) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret i23 0
;
  %tmp.0 = and i23 %x, 127
  %tmp.2 = and i23 %tmp.0, 128
  ret i23 %tmp.2
}

define i1 @test4(i37 %x) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[B:%.*]] = icmp ugt i37 %x, 2147483647
; CHECK-NEXT:    ret i1 [[B]]
;
  %A = and i37 %x, -2147483648
  %B = icmp ne i37 %A, 0
  ret i1 %B
}

define i7 @test5(i7 %A, i7* %P) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[B:%.*]] = or i7 %A, 3
; CHECK-NEXT:    [[C:%.*]] = xor i7 [[B]], 12
; CHECK-NEXT:    store i7 [[C]], i7* %P, align 1
; CHECK-NEXT:    ret i7 3
;
  %B = or i7 %A, 3
  %C = xor i7 %B, 12
  store i7 %C, i7* %P
  %r = and i7 %C, 3
  ret i7 %r
}

define i47 @test7(i47 %A) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i47 %A, 39
; CHECK-NEXT:    ret i47 [[TMP1]]
;
  %X = ashr i47 %A, 39 ;; sign extend
  %C1 = and i47 %X, 255
  ret i47 %C1
}

; Integer BitWidth > 64 && BitWidth <= 1024.

define i999 @test8(i999 %A) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    ret i999 0
;
  %B = and i999 %A, 0 ; zero result
  ret i999 %B
}

define i1005 @test9(i1005 %x) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    ret i1005 %x
;
  %tmp.2 = and i1005 %x, -1 ; noop
  ret i1005 %tmp.2
}

define i123 @test10(i123 %x) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    ret i123 0
;
  %tmp.0 = and i123 %x, 127
  %tmp.2 = and i123 %tmp.0, 128
  ret i123 %tmp.2
}

define i1 @test11(i737 %x) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[B:%.*]] = icmp ugt i737 %x, 2147483647
; CHECK-NEXT:    ret i1 [[B]]
;
  %A = and i737 %x, -2147483648
  %B = icmp ne i737 %A, 0
  ret i1 %B
}

define i117 @test12(i117 %A, i117* %P) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[B:%.*]] = or i117 %A, 3
; CHECK-NEXT:    [[C:%.*]] = xor i117 [[B]], 12
; CHECK-NEXT:    store i117 [[C]], i117* %P, align 4
; CHECK-NEXT:    ret i117 3
;
  %B = or i117 %A, 3
  %C = xor i117 %B, 12
  store i117 %C, i117* %P
  %r = and i117 %C, 3
  ret i117 %r
}

define i1024 @test13(i1024 %A) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i1024 %A, 1016
; CHECK-NEXT:    ret i1024 [[TMP1]]
;
  %X = ashr i1024 %A, 1016 ;; sign extend
  %C1 = and i1024 %X, 255
  ret i1024 %C1
}

