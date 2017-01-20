; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -mtriple=x86_64-unknown -mattr=+avx -slp-vectorizer | FileCheck %s



define i32 @jumbled-load(i32* noalias nocapture %in, i32* noalias nocapture %inn, i32* noalias nocapture %out) {
; CHECK-LABEL: @jumbled-load(
; CHECK-NEXT:    [[IN_ADDR:%.*]] = getelementptr inbounds i32, i32* [[IN:%.*]], i64 0
; CHECK-NEXT:    [[LOAD_1:%.*]] = load i32, i32* [[IN_ADDR]], align 4
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr inbounds i32, i32* [[IN_ADDR]], i64 1
; CHECK-NEXT:    [[LOAD_2:%.*]] = load i32, i32* [[GEP_1]], align 4
; CHECK-NEXT:    [[GEP_2:%.*]] = getelementptr inbounds i32, i32* [[IN_ADDR]], i64 2
; CHECK-NEXT:    [[LOAD_3:%.*]] = load i32, i32* [[GEP_2]], align 4
; CHECK-NEXT:    [[GEP_3:%.*]] = getelementptr inbounds i32, i32* [[IN_ADDR]], i64 3
; CHECK-NEXT:    [[LOAD_4:%.*]] = load i32, i32* [[GEP_3]], align 4
; CHECK-NEXT:    [[INN_ADDR:%.*]] = getelementptr inbounds i32, i32* [[INN:%.*]], i64 0
; CHECK-NEXT:    [[LOAD_5:%.*]] = load i32, i32* [[INN_ADDR]], align 4
; CHECK-NEXT:    [[GEP_4:%.*]] = getelementptr inbounds i32, i32* [[INN_ADDR]], i64 1
; CHECK-NEXT:    [[LOAD_6:%.*]] = load i32, i32* [[GEP_4]], align 4
; CHECK-NEXT:    [[GEP_5:%.*]] = getelementptr inbounds i32, i32* [[INN_ADDR]], i64 2
; CHECK-NEXT:    [[LOAD_7:%.*]] = load i32, i32* [[GEP_5]], align 4
; CHECK-NEXT:    [[GEP_6:%.*]] = getelementptr inbounds i32, i32* [[INN_ADDR]], i64 3
; CHECK-NEXT:    [[LOAD_8:%.*]] = load i32, i32* [[GEP_6]], align 4
; CHECK-NEXT:    [[MUL_1:%.*]] = mul i32 [[LOAD_1]], [[LOAD_5]]
; CHECK-NEXT:    [[MUL_2:%.*]] = mul i32 [[LOAD_2]], [[LOAD_6]]
; CHECK-NEXT:    [[MUL_3:%.*]] = mul i32 [[LOAD_3]], [[LOAD_7]]
; CHECK-NEXT:    [[MUL_4:%.*]] = mul i32 [[LOAD_4]], [[LOAD_8]]
; CHECK-NEXT:    [[GEP_7:%.*]] = getelementptr inbounds i32, i32* [[OUT:%.*]], i64 0
; CHECK-NEXT:    [[GEP_8:%.*]] = getelementptr inbounds i32, i32* [[OUT]], i64 1
; CHECK-NEXT:    [[GEP_9:%.*]] = getelementptr inbounds i32, i32* [[OUT]], i64 2
; CHECK-NEXT:    [[GEP_10:%.*]] = getelementptr inbounds i32, i32* [[OUT]], i64 3
; CHECK-NEXT:    store i32 [[MUL_1]], i32* [[GEP_9]], align 4
; CHECK-NEXT:    store i32 [[MUL_2]], i32* [[GEP_7]], align 4
; CHECK-NEXT:    store i32 [[MUL_3]], i32* [[GEP_10]], align 4
; CHECK-NEXT:    store i32 [[MUL_4]], i32* [[GEP_8]], align 4
; CHECK-NEXT:    ret i32 undef
;
  %in.addr = getelementptr inbounds i32, i32* %in, i64 0
  %load.1 = load i32, i32* %in.addr, align 4
  %gep.1 = getelementptr inbounds i32, i32* %in.addr, i64 1
  %load.2 = load i32, i32* %gep.1, align 4
  %gep.2 = getelementptr inbounds i32, i32* %in.addr, i64 2
  %load.3 = load i32, i32* %gep.2, align 4
  %gep.3 = getelementptr inbounds i32, i32* %in.addr, i64 3
  %load.4 = load i32, i32* %gep.3, align 4
  %inn.addr = getelementptr inbounds i32, i32* %inn, i64 0
  %load.5 = load i32, i32* %inn.addr, align 4
  %gep.4 = getelementptr inbounds i32, i32* %inn.addr, i64 1
  %load.6 = load i32, i32* %gep.4, align 4
  %gep.5 = getelementptr inbounds i32, i32* %inn.addr, i64 2
  %load.7 = load i32, i32* %gep.5, align 4
  %gep.6 = getelementptr inbounds i32, i32* %inn.addr, i64 3
  %load.8 = load i32, i32* %gep.6, align 4
  %mul.1 = mul i32 %load.1, %load.5
  %mul.2 = mul i32 %load.2, %load.6
  %mul.3 = mul i32 %load.3, %load.7
  %mul.4 = mul i32 %load.4, %load.8
  %gep.7 = getelementptr inbounds i32, i32* %out, i64 0
  %gep.8 = getelementptr inbounds i32, i32* %out, i64 1
  %gep.9 = getelementptr inbounds i32, i32* %out, i64 2
  %gep.10 = getelementptr inbounds i32, i32* %out, i64 3
  store i32 %mul.1, i32* %gep.9, align 4
  store i32 %mul.2, i32* %gep.7, align 4
  store i32 %mul.3, i32* %gep.10, align 4
  store i32 %mul.4, i32* %gep.8, align 4

  ret i32 undef
}
