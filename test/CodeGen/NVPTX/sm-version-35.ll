; RUN: llc < %s -march=nvptx -mcpu=sm_35 | FileCheck %s
; RUN: llc < %s -march=nvptx64 -mcpu=sm_35 | FileCheck %s


; CHECK: .version 3.2
; CHECK: .target sm_35

