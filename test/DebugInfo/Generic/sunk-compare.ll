; RUN: opt -S -codegenprepare < %s | FileCheck %s
;
; This test case has been generated by hand but is inspired by the
; observation that compares that are sunk into the basic blocks where
; their results are used did not retain their debug locs. This caused
; sample profiling to attribute code to the wrong source lines. 
;
; We check that the compare instruction retains its debug loc after 
; it is sunk into other.bb by the codegen prepare pass.
; 
; CHECK:       entry:
; CHECK-NEXT:  icmp{{.*}}%x, 0, !dbg ![[MDHANDLE:[0-9]*]]
; CHECK:       ![[MDHANDLE]] = !DILocation(line: 2
;
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define i32 @_Z3fooii(i32 %x, i32 %y) !dbg !5 {
entry:
  %cmp17 = icmp sgt i32 %x, 0, !dbg !6
  br label %other.bb, !dbg !6

other.bb:
  br i1 %cmp17, label %exit1.bb, label %exit2.bb, !dbg !7

exit1.bb:
  %0 = add i32 %y, 42, !dbg !8
  ret i32 %0, !dbg !8

exit2.bb:
  ret i32 44, !dbg !9

}

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4}

!0 = distinct !DICompileUnit(language: DW_LANG_C, file: !1, producer: "clang", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, globals: !2)
!1 = !DIFile(filename: "test.cpp", directory: "/debuginfo/bug/cgp")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = distinct !DISubprogram(name: "foo", linkageName: "foo", scope: !1, file: !1, line: 1, isLocal: false, isDefinition: true, scopeLine: 1, flags: DIFlagPrototyped, isOptimized: false, unit: !0, retainedNodes: !2)
!6 = !DILocation(line: 2, column: 0, scope: !5)
!7 = !DILocation(line: 3, column: 0, scope: !5)
!8 = !DILocation(line: 4, column: 0, scope: !5)
!9 = !DILocation(line: 5, column: 0, scope: !5)
