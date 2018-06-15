# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=btver2 -iterations=1 -all-stats=false -all-views=false -scheduler-stats < %s | FileCheck --check-prefixes=ALL,BTVER2 %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=znver1 -iterations=1 -all-stats=false -all-views=false -scheduler-stats < %s | FileCheck --check-prefixes=ALL,ZNVER1 %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=sandybridge -iterations=1 -all-stats=false -all-views=false -scheduler-stats < %s | FileCheck --check-prefixes=ALL,SNB %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=ivybridge -iterations=1 -all-stats=false -all-views=false -scheduler-stats < %s | FileCheck --check-prefixes=ALL,IVB %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=haswell -iterations=1 -all-stats=false -all-views=false -scheduler-stats < %s | FileCheck --check-prefixes=ALL,HSW %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=broadwell -iterations=1 -all-stats=false -all-views=false -scheduler-stats < %s | FileCheck --check-prefixes=ALL,BDW %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=knl -iterations=1 -all-stats=false -all-views=false -scheduler-stats < %s | FileCheck --check-prefixes=ALL,KNL %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=skylake -iterations=1 -all-stats=false -all-views=false -scheduler-stats < %s | FileCheck --check-prefixes=ALL,SKX %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=skylake-avx512 -iterations=1 -all-stats=false -all-views=false -scheduler-stats < %s | FileCheck --check-prefixes=ALL,SKX-AVX512 %s
# RUN: llvm-mca %s -mtriple=x86_64-unknown-unknown -mcpu=slm -iterations=1 -all-stats=false -all-views=false -scheduler-stats < %s | FileCheck --check-prefixes=ALL,SLM %s

xor %eax, %ebx

# ALL:             Iterations:        1
# ALL-NEXT:        Instructions:      1
# ALL-NEXT:        Total Cycles:      4

# BDW-NEXT:        Dispatch Width:    4
# BTVER2-NEXT:     Dispatch Width:    2
# HSW-NEXT:        Dispatch Width:    4
# IVB-NEXT:        Dispatch Width:    4
# KNL-NEXT:        Dispatch Width:    4
# SKX-NEXT:        Dispatch Width:    6
# SKX-AVX512-NEXT: Dispatch Width:    6
# SLM-NEXT:        Dispatch Width:    2
# SNB-NEXT:        Dispatch Width:    4
# ZNVER1-NEXT:     Dispatch Width:    4

# ALL-NEXT:        IPC:               0.25

# BDW-NEXT:        Block RThroughput: 0.3
# BTVER2-NEXT:     Block RThroughput: 0.5
# HSW-NEXT:        Block RThroughput: 0.3
# IVB-NEXT:        Block RThroughput: 0.3
# KNL-NEXT:        Block RThroughput: 0.3
# SKX-NEXT:        Block RThroughput: 0.3
# SKX-AVX512-NEXT: Block RThroughput: 0.3
# SLM-NEXT:        Block RThroughput: 0.5
# SNB-NEXT:        Block RThroughput: 0.3
# ZNVER1-NEXT:     Block RThroughput: 0.3

# ALL:             Schedulers - number of cycles where we saw N instructions issued:
# ALL-NEXT:        [# issued], [# cycles]
# ALL-NEXT:         0,          3  (75.0%)
# ALL-NEXT:         1,          1  (25.0%)

# BDW:             Scheduler's queue usage:
# BDW-NEXT:        BWPortAny,  1/60

# HSW:             Scheduler's queue usage:
# HSW-NEXT:        HWPortAny,  1/60

# KNL:             Scheduler's queue usage:
# KNL-NEXT:        HWPortAny,  1/60

# BTVER2:          Scheduler's queue usage:
# BTVER2-NEXT:     JALU01,  1/20
# BTVER2-NEXT:     JFPU01,  0/18
# BTVER2-NEXT:     JLSAGU,  0/12

# SLM:             Scheduler's queue usage:
# SLM-NEXT:        No scheduler resources used.

# IVB:             Scheduler's queue usage:
# IVB-NEXT:        SBPortAny,  1/54

# SNB:             Scheduler's queue usage:
# SNB-NEXT:        SBPortAny,  1/54

# SKX:             Scheduler's queue usage:
# SKX-NEXT:        SKLPortAny,  1/60

# SKX-AVX512:      Scheduler's queue usage:
# SKX-AVX512-NEXT: SKXPortAny,  1/60

# ZNVER1:          Scheduler's queue usage:
# ZNVER1-NEXT:     ZnAGU,  0/28
# ZNVER1-NEXT:     ZnALU,  1/56
