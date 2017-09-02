; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i1 @oeq_self(double %arg) {
; CHECK-LABEL: @oeq_self(
; CHECK-NEXT:    [[TMP:%.*]] = fcmp ord double %arg, 0.000000e+00
; CHECK-NEXT:    ret i1 [[TMP]]
;
  %tmp = fcmp oeq double %arg, %arg
  ret i1 %tmp
}

; PR1111 - https://bugs.llvm.org/show_bug.cgi?id=1111

define i1 @une_self(double %x) {
; CHECK-LABEL: @une_self(
; CHECK-NEXT:    [[TMP:%.*]] = fcmp uno double %x, 0.000000e+00
; CHECK-NEXT:    ret i1 [[TMP]]
;
  %tmp = fcmp une double %x, %x
  ret i1 %tmp
}

