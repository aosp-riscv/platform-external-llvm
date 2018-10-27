# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -iterations=1000 -timeline < %s | FileCheck %s

add %eax, %ecx
add %esi, %eax
add %eax, %edx

# CHECK:      Iterations:        1000
# CHECK-NEXT: Instructions:      3000
# CHECK-NEXT: Total Cycles:      1004
# CHECK-NEXT: Total uOps:        3000

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    2.99
# CHECK-NEXT: IPC:               2.99
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.33                        addl	%eax, %ecx
# CHECK-NEXT:  1      1     0.33                        addl	%esi, %eax
# CHECK-NEXT:  1      1     0.33                        addl	%eax, %edx

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SBDivider
# CHECK-NEXT: [1]   - SBFPDivider
# CHECK-NEXT: [2]   - SBPort0
# CHECK-NEXT: [3]   - SBPort1
# CHECK-NEXT: [4]   - SBPort4
# CHECK-NEXT: [5]   - SBPort5
# CHECK-NEXT: [6.0] - SBPort23
# CHECK-NEXT: [6.1] - SBPort23

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]
# CHECK-NEXT:  -      -     1.00   1.00    -     1.00    -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]  Instructions:
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     addl	%eax, %ecx
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     addl	%esi, %eax
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     addl	%eax, %edx

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeER .    .  .   addl	%eax, %ecx
# CHECK-NEXT: [0,1]     DeER .    .  .   addl	%esi, %eax
# CHECK-NEXT: [0,2]     D=eER.    .  .   addl	%eax, %edx
# CHECK-NEXT: [1,0]     D=eER.    .  .   addl	%eax, %ecx
# CHECK-NEXT: [1,1]     .DeER.    .  .   addl	%esi, %eax
# CHECK-NEXT: [1,2]     .D=eER    .  .   addl	%eax, %edx
# CHECK-NEXT: [2,0]     .D=eER    .  .   addl	%eax, %ecx
# CHECK-NEXT: [2,1]     .D=eER    .  .   addl	%esi, %eax
# CHECK-NEXT: [2,2]     . D=eER   .  .   addl	%eax, %edx
# CHECK-NEXT: [3,0]     . D=eER   .  .   addl	%eax, %ecx
# CHECK-NEXT: [3,1]     . D=eER   .  .   addl	%esi, %eax
# CHECK-NEXT: [3,2]     . D==eER  .  .   addl	%eax, %edx
# CHECK-NEXT: [4,0]     .  D=eER  .  .   addl	%eax, %ecx
# CHECK-NEXT: [4,1]     .  D=eER  .  .   addl	%esi, %eax
# CHECK-NEXT: [4,2]     .  D==eER .  .   addl	%eax, %edx
# CHECK-NEXT: [5,0]     .  D==eER .  .   addl	%eax, %ecx
# CHECK-NEXT: [5,1]     .   D=eER .  .   addl	%esi, %eax
# CHECK-NEXT: [5,2]     .   D==eER.  .   addl	%eax, %edx
# CHECK-NEXT: [6,0]     .   D==eER.  .   addl	%eax, %ecx
# CHECK-NEXT: [6,1]     .   D==eER.  .   addl	%esi, %eax
# CHECK-NEXT: [6,2]     .    D==eER  .   addl	%eax, %edx
# CHECK-NEXT: [7,0]     .    D==eER  .   addl	%eax, %ecx
# CHECK-NEXT: [7,1]     .    D==eER  .   addl	%esi, %eax
# CHECK-NEXT: [7,2]     .    D===eER .   addl	%eax, %edx
# CHECK-NEXT: [8,0]     .    .D==eER .   addl	%eax, %ecx
# CHECK-NEXT: [8,1]     .    .D==eER .   addl	%esi, %eax
# CHECK-NEXT: [8,2]     .    .D===eER.   addl	%eax, %edx
# CHECK-NEXT: [9,0]     .    .D===eER.   addl	%eax, %ecx
# CHECK-NEXT: [9,1]     .    . D==eER.   addl	%esi, %eax
# CHECK-NEXT: [9,2]     .    . D===eER   addl	%eax, %edx

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     10    2.5    0.1    0.0       addl	%eax, %ecx
# CHECK-NEXT: 1.     10    2.2    0.1    0.0       addl	%esi, %eax
# CHECK-NEXT: 2.     10    3.0    0.0    0.0       addl	%eax, %edx
