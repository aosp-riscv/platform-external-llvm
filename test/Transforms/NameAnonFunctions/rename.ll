; RUN: opt -S -name-anon-functions < %s | FileCheck %s


; foo contribute to the unique hash for the module
define void @foo() {
    ret void
}

; bar is internal, and does not contribute to the unique hash for the module
define internal void @bar() {
    ret void
}

; CHECK: @anon.acbd18db4cc2f85cedef654fccc4a4d8.3 = global i8 0
; CHECK: @anon.acbd18db4cc2f85cedef654fccc4a4d8.4 = alias i8, i8* @anon.acbd18db4cc2f85cedef654fccc4a4d8.3
; CHECK: define void @anon.acbd18db4cc2f85cedef654fccc4a4d8.0()
; CHECK: define void @anon.acbd18db4cc2f85cedef654fccc4a4d8.1()
; CHECK: define void @anon.acbd18db4cc2f85cedef654fccc4a4d8.2()

define void @0() {
    ret void
}
define void @1() {
    ret void
}
define void @2() {
    ret void
}


@3 = global i8 0

@4 = alias i8, i8 *@3
