# Instructions that are invalid
#
# RUN: not llvm-mc %s -triple=mips-unknown-linux -show-encoding -mcpu=mips3 \
# RUN:     2>%t1
# RUN: FileCheck %s < %t1

        .set noat

        sync 1                    # CHECK: :[[@LINE]]:{{[0-9]+}}: error: s-type must be zero or unspecified for pre-MIPS32 ISAs
