# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=sandybridge -iterations=1 -timeline -instruction-info=false -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=SANDY

# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=ivybridge -iterations=1 -timeline -instruction-info=false -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=IVY

# RUN: llvm-mca -mtriple=x86_64-unknown-unknown  -mcpu=haswell -iterations=1 -timeline -instruction-info=false -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=HASWELL

# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=broadwell -iterations=1 -timeline -instruction-info=false -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=BDWELL

# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=skylake -iterations=1 -timeline -instruction-info=false -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=SKYLAKE

# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -iterations=1 -timeline -instruction-info=false -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=BTVER2

# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver1 -iterations=1 -timeline -instruction-info=false -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=ZNVER1

vaddps %xmm0, %xmm0, %xmm1
vblendvps %xmm1, (%rdi), %xmm2, %xmm3

# ALL:          Iterations:        1
# ALL-NEXT:     Instructions:      2

# BDWELL-NEXT:  Total Cycles:      10
# BDWELL-NEXT:  Total uOps:        4

# BTVER2-NEXT:  Total Cycles:      11
# BTVER2-NEXT:  Total uOps:        4

# HASWELL-NEXT: Total Cycles:      11
# HASWELL-NEXT: Total uOps:        4

# IVY-NEXT:     Total Cycles:      11
# IVY-NEXT:     Total uOps:        4

# SANDY-NEXT:   Total Cycles:      11
# SANDY-NEXT:   Total uOps:        4

# SKYLAKE-NEXT: Total Cycles:      11
# SKYLAKE-NEXT: Total uOps:        4

# ZNVER1-NEXT:  Total Cycles:      11
# ZNVER1-NEXT:  Total uOps:        2

# BDWELL:       Dispatch Width:    4
# BDWELL-NEXT:  uOps Per Cycle:    0.40
# BDWELL-NEXT:  IPC:               0.20
# BDWELL-NEXT:  Block RThroughput: 2.0

# BTVER2:       Dispatch Width:    2
# BTVER2-NEXT:  uOps Per Cycle:    0.36
# BTVER2-NEXT:  IPC:               0.18
# BTVER2-NEXT:  Block RThroughput: 2.0

# HASWELL:      Dispatch Width:    4
# HASWELL-NEXT: uOps Per Cycle:    0.36
# HASWELL-NEXT: IPC:               0.18
# HASWELL-NEXT: Block RThroughput: 2.0

# IVY:          Dispatch Width:    4
# IVY-NEXT:     uOps Per Cycle:    0.36
# IVY-NEXT:     IPC:               0.18
# IVY-NEXT:     Block RThroughput: 1.0

# SANDY:        Dispatch Width:    4
# SANDY-NEXT:   uOps Per Cycle:    0.36
# SANDY-NEXT:   IPC:               0.18
# SANDY-NEXT:   Block RThroughput: 1.0

# SKYLAKE:      Dispatch Width:    6
# SKYLAKE-NEXT: uOps Per Cycle:    0.36
# SKYLAKE-NEXT: IPC:               0.18
# SKYLAKE-NEXT: Block RThroughput: 0.7

# ZNVER1:       Dispatch Width:    4
# ZNVER1-NEXT:  uOps Per Cycle:    0.18
# ZNVER1-NEXT:  IPC:               0.18
# ZNVER1-NEXT:  Block RThroughput: 1.0

# BDWELL:       Timeline view:
# BDWELL-NEXT:  Index     0123456789

# BTVER2:       Timeline view:
# BTVER2-NEXT:                      0
# BTVER2-NEXT:  Index     0123456789

# HASWELL:      Timeline view:
# HASWELL-NEXT:                     0
# HASWELL-NEXT: Index     0123456789

# IVY:          Timeline view:
# IVY-NEXT:                         0
# IVY-NEXT:     Index     0123456789

# SANDY:        Timeline view:
# SANDY-NEXT:                       0
# SANDY-NEXT:   Index     0123456789

# SKYLAKE:      Timeline view:
# SKYLAKE-NEXT:                     0
# SKYLAKE-NEXT: Index     0123456789

# ZNVER1:       Timeline view:
# ZNVER1-NEXT:                      0
# ZNVER1-NEXT:  Index     0123456789

# BDWELL:       [0,0]     DeeeER   .   vaddps	%xmm0, %xmm0, %xmm1
# BDWELL-NEXT:  [0,1]     DeeeeeeeER   vblendvps	%xmm1, (%rdi), %xmm2, %xmm3

# BTVER2:       [0,0]     DeeeER    .   vaddps	%xmm0, %xmm0, %xmm1
# BTVER2-NEXT:  [0,1]     .DeeeeeeeER   vblendvps	%xmm1, (%rdi), %xmm2, %xmm3

# HASWELL:      [0,0]     DeeeER    .   vaddps	%xmm0, %xmm0, %xmm1
# HASWELL-NEXT: [0,1]     DeeeeeeeeER   vblendvps	%xmm1, (%rdi), %xmm2, %xmm3

# IVY:          [0,0]     DeeeER    .   vaddps	%xmm0, %xmm0, %xmm1
# IVY-NEXT:     [0,1]     DeeeeeeeeER   vblendvps	%xmm1, (%rdi), %xmm2, %xmm3

# SANDY:        [0,0]     DeeeER    .   vaddps	%xmm0, %xmm0, %xmm1
# SANDY-NEXT:   [0,1]     DeeeeeeeeER   vblendvps	%xmm1, (%rdi), %xmm2, %xmm3

# SKYLAKE:      [0,0]     DeeeeER   .   vaddps	%xmm0, %xmm0, %xmm1
# SKYLAKE-NEXT: [0,1]     DeeeeeeeeER   vblendvps	%xmm1, (%rdi), %xmm2, %xmm3

# ZNVER1:       [0,0]     DeeeER    .   vaddps	%xmm0, %xmm0, %xmm1
# ZNVER1-NEXT:  [0,1]     DeeeeeeeeER   vblendvps	%xmm1, (%rdi), %xmm2, %xmm3

# ALL:          Average Wait times (based on the timeline view):
# ALL-NEXT:     [0]: Executions
# ALL-NEXT:     [1]: Average time spent waiting in a scheduler's queue
# ALL-NEXT:     [2]: Average time spent waiting in a scheduler's queue while ready
# ALL-NEXT:     [3]: Average time elapsed from WB until retire stage

# ALL:                [0]    [1]    [2]    [3]
# ALL-NEXT:     0.     1     1.0    1.0    0.0       vaddps	%xmm0, %xmm0, %xmm1

# BDWELL-NEXT:  1.     1     1.0    0.0    0.0       vblendvps	%xmm1, (%rdi), %xmm2, %xmm3
# BTVER2-NEXT:  1.     1     1.0    1.0    0.0       vblendvps	%xmm1, (%rdi), %xmm2, %xmm3
# HASWELL-NEXT: 1.     1     1.0    0.0    0.0       vblendvps	%xmm1, (%rdi), %xmm2, %xmm3
# IVY-NEXT:     1.     1     1.0    0.0    0.0       vblendvps	%xmm1, (%rdi), %xmm2, %xmm3
# SANDY-NEXT:   1.     1     1.0    0.0    0.0       vblendvps	%xmm1, (%rdi), %xmm2, %xmm3
# SKYLAKE-NEXT: 1.     1     1.0    0.0    0.0       vblendvps	%xmm1, (%rdi), %xmm2, %xmm3
# ZNVER1-NEXT:  1.     1     1.0    0.0    0.0       vblendvps	%xmm1, (%rdi), %xmm2, %xmm3
