; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -newgvn -S | FileCheck %s
;; Test that we do not infinite loop on this testcase, and that we do not try
;; to replace the phi node argument with the result of the phi node.
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

define internal i32 @pr31491() {
; CHECK-LABEL: @pr31491(
; CHECK-NEXT:  bb5:
; CHECK-NEXT:    br label %bb7
; CHECK:       bb7:
; CHECK-NEXT:    [[TMP:%.*]] = phi i8* [ [[TMP:%.*]]11, %bb10 ], [ undef, %bb5 ]
; CHECK-NEXT:    br label %bb10
; CHECK:       bb10:
; CHECK-NEXT:    [[TMP11:%.*]] = tail call i8* @patatino(i8* [[TMP]])
; CHECK-NEXT:    br label %bb7
;
bb5:
  br label %bb7

bb7:                                              ; preds = %bb10, %bb5
  %tmp = phi i8* [ %tmp11, %bb10 ], [ undef, %bb5 ]
  br label %bb10

bb10:                                             ; preds = %bb7
  %tmp11 = tail call i8* @patatino(i8* %tmp)
  br label %bb7
}

declare i8* @patatino(i8*)
