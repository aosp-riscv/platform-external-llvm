; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=mips-unknown-linux-gnu -mcpu=mips2 | FileCheck %s -check-prefix=GP32
; RUN: llc < %s -mtriple=mips-unknown-linux-gnu -mcpu=mips32 | FileCheck %s -check-prefix=GP32
; RUN: llc < %s -mtriple=mips-unknown-linux-gnu -mcpu=mips32r2 | FileCheck %s -check-prefix=GP32
; RUN: llc < %s -mtriple=mips-unknown-linux-gnu -mcpu=mips32r3 | FileCheck %s -check-prefix=GP32
; RUN: llc < %s -mtriple=mips-unknown-linux-gnu -mcpu=mips32r5 | FileCheck %s -check-prefix=GP32
; RUN: llc < %s -mtriple=mips-unknown-linux-gnu -mcpu=mips32r6 | FileCheck %s -check-prefix=GP32
; RUN: llc < %s -mtriple=mips64-unknown-linux-gnu -mcpu=mips3 | FileCheck %s -check-prefix=GP64
; RUN: llc < %s -mtriple=mips64-unknown-linux-gnu -mcpu=mips4 | FileCheck %s -check-prefix=GP64
; RUN: llc < %s -mtriple=mips64-unknown-linux-gnu -mcpu=mips64 | FileCheck %s -check-prefix=GP64
; RUN: llc < %s -mtriple=mips64-unknown-linux-gnu -mcpu=mips64r2 | FileCheck %s -check-prefix=GP64
; RUN: llc < %s -mtriple=mips64-unknown-linux-gnu -mcpu=mips64r3 | FileCheck %s -check-prefix=GP64
; RUN: llc < %s -mtriple=mips64-unknown-linux-gnu -mcpu=mips64r5 | FileCheck %s -check-prefix=GP64
; RUN: llc < %s -mtriple=mips64-unknown-linux-gnu -mcpu=mips64r6 | FileCheck %s -check-prefix=GP64
; RUN: llc < %s -mtriple=mips-unknown-linux-gnu -mcpu=mips32r3 -mattr=+micromips | FileCheck %s \
; RUN:    -check-prefix=MM32
; RUN: llc < %s -mtriple=mips-unknown-linux-gnu -mcpu=mips32r6 -mattr=+micromips | FileCheck %s \
; RUN:    -check-prefix=MM32R6

define signext i1 @or_i1(i1 signext %a, i1 signext %b) {
; GP32-LABEL: or_i1:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    or $2, $4, $5
;
; GP64-LABEL: or_i1:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    or $1, $4, $5
; GP64-NEXT:    jr $ra
; GP64-NEXT:    sll $2, $1, 0
;
; MM32-LABEL: or_i1:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    or16 $4, $5
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i1:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    or $2, $4, $5
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i1 %a, %b
  ret i1 %r
}

define signext i8 @or_i8(i8 signext %a, i8 signext %b) {
; GP32-LABEL: or_i8:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    or $2, $4, $5
;
; GP64-LABEL: or_i8:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    or $1, $4, $5
; GP64-NEXT:    jr $ra
; GP64-NEXT:    sll $2, $1, 0
;
; MM32-LABEL: or_i8:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    or16 $4, $5
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i8:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    or $2, $4, $5
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i8 %a, %b
  ret i8 %r
}

define signext i16 @or_i16(i16 signext %a, i16 signext %b) {
; GP32-LABEL: or_i16:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    or $2, $4, $5
;
; GP64-LABEL: or_i16:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    or $1, $4, $5
; GP64-NEXT:    jr $ra
; GP64-NEXT:    sll $2, $1, 0
;
; MM32-LABEL: or_i16:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    or16 $4, $5
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i16:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    or $2, $4, $5
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i16 %a, %b
  ret i16 %r
}

define signext i32 @or_i32(i32 signext %a, i32 signext %b) {
; GP32-LABEL: or_i32:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    or $2, $4, $5
;
; GP64-LABEL: or_i32:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    or $1, $4, $5
; GP64-NEXT:    jr $ra
; GP64-NEXT:    sll $2, $1, 0
;
; MM32-LABEL: or_i32:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    or16 $4, $5
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i32:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    or $2, $4, $5
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i32 %a, %b
  ret i32 %r
}

define signext i64 @or_i64(i64 signext %a, i64 signext %b) {
; GP32-LABEL: or_i64:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    or $2, $4, $6
; GP32-NEXT:    jr $ra
; GP32-NEXT:    or $3, $5, $7
;
; GP64-LABEL: or_i64:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    or $2, $4, $5
;
; MM32-LABEL: or_i64:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    or16 $4, $6
; MM32-NEXT:    or16 $5, $7
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    move $3, $5
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i64:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    or $2, $4, $6
; MM32R6-NEXT:    or $3, $5, $7
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i64 %a, %b
  ret i64 %r
}

define signext i128 @or_i128(i128 signext %a, i128 signext %b) {
; GP32-LABEL: or_i128:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    lw $1, 20($sp)
; GP32-NEXT:    lw $2, 16($sp)
; GP32-NEXT:    or $2, $4, $2
; GP32-NEXT:    or $3, $5, $1
; GP32-NEXT:    lw $1, 24($sp)
; GP32-NEXT:    or $4, $6, $1
; GP32-NEXT:    lw $1, 28($sp)
; GP32-NEXT:    jr $ra
; GP32-NEXT:    or $5, $7, $1
;
; GP64-LABEL: or_i128:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    or $2, $4, $6
; GP64-NEXT:    jr $ra
; GP64-NEXT:    or $3, $5, $7
;
; MM32-LABEL: or_i128:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    lw $3, 20($sp)
; MM32-NEXT:    lw $2, 16($sp)
; MM32-NEXT:    or16 $2, $4
; MM32-NEXT:    or16 $3, $5
; MM32-NEXT:    lw $4, 24($sp)
; MM32-NEXT:    or16 $4, $6
; MM32-NEXT:    lw $5, 28($sp)
; MM32-NEXT:    or16 $5, $7
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i128:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    lw $1, 20($sp)
; MM32R6-NEXT:    lw $2, 16($sp)
; MM32R6-NEXT:    or $2, $4, $2
; MM32R6-NEXT:    or $3, $5, $1
; MM32R6-NEXT:    lw $1, 24($sp)
; MM32R6-NEXT:    or $4, $6, $1
; MM32R6-NEXT:    lw $1, 28($sp)
; MM32R6-NEXT:    or $5, $7, $1
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i128 %a, %b
  ret i128 %r
}

define signext i1 @or_i1_4(i1 signext %b) {
; GP32-LABEL: or_i1_4:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $2, $4
;
; GP64-LABEL: or_i1_4:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    move $2, $4
;
; MM32-LABEL: or_i1_4:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i1_4:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i1 4, %b
  ret i1 %r
}

define signext i8 @or_i8_4(i8 signext %b) {
; GP32-LABEL: or_i8_4:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    ori $2, $4, 4
;
; GP64-LABEL: or_i8_4:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 4
;
; MM32-LABEL: or_i8_4:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    jr $ra
; MM32-NEXT:    ori $2, $4, 4
;
; MM32R6-LABEL: or_i8_4:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $2, $4, 4
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i8 4, %b
  ret i8 %r
}

define signext i16 @or_i16_4(i16 signext %b) {
; GP32-LABEL: or_i16_4:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    ori $2, $4, 4
;
; GP64-LABEL: or_i16_4:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 4
;
; MM32-LABEL: or_i16_4:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    jr $ra
; MM32-NEXT:    ori $2, $4, 4
;
; MM32R6-LABEL: or_i16_4:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $2, $4, 4
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i16 4, %b
  ret i16 %r
}

define signext i32 @or_i32_4(i32 signext %b) {
; GP32-LABEL: or_i32_4:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    ori $2, $4, 4
;
; GP64-LABEL: or_i32_4:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 4
;
; MM32-LABEL: or_i32_4:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    jr $ra
; MM32-NEXT:    ori $2, $4, 4
;
; MM32R6-LABEL: or_i32_4:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $2, $4, 4
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i32 4, %b
  ret i32 %r
}

define signext i64 @or_i64_4(i64 signext %b) {
; GP32-LABEL: or_i64_4:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    ori $3, $5, 4
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $2, $4
;
; GP64-LABEL: or_i64_4:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 4
;
; MM32-LABEL: or_i64_4:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    ori $3, $5, 4
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i64_4:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $3, $5, 4
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i64 4, %b
  ret i64 %r
}

define signext i128 @or_i128_4(i128 signext %b) {
; GP32-LABEL: or_i128_4:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    ori $1, $7, 4
; GP32-NEXT:    move $2, $4
; GP32-NEXT:    move $3, $5
; GP32-NEXT:    move $4, $6
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $5, $1
;
; GP64-LABEL: or_i128_4:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    ori $3, $5, 4
; GP64-NEXT:    jr $ra
; GP64-NEXT:    move $2, $4
;
; MM32-LABEL: or_i128_4:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    ori $1, $7, 4
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    move $3, $5
; MM32-NEXT:    move $4, $6
; MM32-NEXT:    move $5, $1
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i128_4:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $1, $7, 4
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    move $3, $5
; MM32R6-NEXT:    move $4, $6
; MM32R6-NEXT:    move $5, $1
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i128 4, %b
  ret i128 %r
}

define signext i1 @or_i1_31(i1 signext %b) {
; GP32-LABEL: or_i1_31:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    addiu $2, $zero, -1
;
; GP64-LABEL: or_i1_31:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    addiu $2, $zero, -1
;
; MM32-LABEL: or_i1_31:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    li16 $2, -1
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i1_31:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    li16 $2, -1
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i1 31, %b
  ret i1 %r
}

define signext i8 @or_i8_31(i8 signext %b) {
; GP32-LABEL: or_i8_31:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    ori $2, $4, 31
;
; GP64-LABEL: or_i8_31:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 31
;
; MM32-LABEL: or_i8_31:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    jr $ra
; MM32-NEXT:    ori $2, $4, 31
;
; MM32R6-LABEL: or_i8_31:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $2, $4, 31
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i8 31, %b
  ret i8 %r
}

define signext i16 @or_i16_31(i16 signext %b) {
; GP32-LABEL: or_i16_31:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    ori $2, $4, 31
;
; GP64-LABEL: or_i16_31:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 31
;
; MM32-LABEL: or_i16_31:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    jr $ra
; MM32-NEXT:    ori $2, $4, 31
;
; MM32R6-LABEL: or_i16_31:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $2, $4, 31
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i16 31, %b
  ret i16 %r
}

define signext i32 @or_i32_31(i32 signext %b) {
; GP32-LABEL: or_i32_31:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    ori $2, $4, 31
;
; GP64-LABEL: or_i32_31:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 31
;
; MM32-LABEL: or_i32_31:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    jr $ra
; MM32-NEXT:    ori $2, $4, 31
;
; MM32R6-LABEL: or_i32_31:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $2, $4, 31
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i32 31, %b
  ret i32 %r
}

define signext i64 @or_i64_31(i64 signext %b) {
; GP32-LABEL: or_i64_31:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    ori $3, $5, 31
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $2, $4
;
; GP64-LABEL: or_i64_31:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 31
;
; MM32-LABEL: or_i64_31:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    ori $3, $5, 31
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i64_31:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $3, $5, 31
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i64 31, %b
  ret i64 %r
}

define signext i128 @or_i128_31(i128 signext %b) {
; GP32-LABEL: or_i128_31:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    ori $1, $7, 31
; GP32-NEXT:    move $2, $4
; GP32-NEXT:    move $3, $5
; GP32-NEXT:    move $4, $6
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $5, $1
;
; GP64-LABEL: or_i128_31:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    ori $3, $5, 31
; GP64-NEXT:    jr $ra
; GP64-NEXT:    move $2, $4
;
; MM32-LABEL: or_i128_31:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    ori $1, $7, 31
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    move $3, $5
; MM32-NEXT:    move $4, $6
; MM32-NEXT:    move $5, $1
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i128_31:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $1, $7, 31
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    move $3, $5
; MM32R6-NEXT:    move $4, $6
; MM32R6-NEXT:    move $5, $1
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i128 31, %b
  ret i128 %r
}

define signext i1 @or_i1_255(i1 signext %b) {
; GP32-LABEL: or_i1_255:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    addiu $2, $zero, -1
;
; GP64-LABEL: or_i1_255:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    addiu $2, $zero, -1
;
; MM32-LABEL: or_i1_255:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    li16 $2, -1
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i1_255:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    li16 $2, -1
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i1 255, %b
  ret i1 %r
}

define signext i8 @or_i8_255(i8 signext %b) {
; GP32-LABEL: or_i8_255:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    addiu $2, $zero, -1
;
; GP64-LABEL: or_i8_255:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    addiu $2, $zero, -1
;
; MM32-LABEL: or_i8_255:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    li16 $2, -1
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i8_255:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    li16 $2, -1
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i8 255, %b
  ret i8 %r
}

define signext i16 @or_i16_255(i16 signext %b) {
; GP32-LABEL: or_i16_255:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    ori $2, $4, 255
;
; GP64-LABEL: or_i16_255:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 255
;
; MM32-LABEL: or_i16_255:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    jr $ra
; MM32-NEXT:    ori $2, $4, 255
;
; MM32R6-LABEL: or_i16_255:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $2, $4, 255
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i16 255, %b
  ret i16 %r
}

define signext i32 @or_i32_255(i32 signext %b) {
; GP32-LABEL: or_i32_255:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    ori $2, $4, 255
;
; GP64-LABEL: or_i32_255:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 255
;
; MM32-LABEL: or_i32_255:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    jr $ra
; MM32-NEXT:    ori $2, $4, 255
;
; MM32R6-LABEL: or_i32_255:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $2, $4, 255
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i32 255, %b
  ret i32 %r
}

define signext i64 @or_i64_255(i64 signext %b) {
; GP32-LABEL: or_i64_255:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    ori $3, $5, 255
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $2, $4
;
; GP64-LABEL: or_i64_255:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 255
;
; MM32-LABEL: or_i64_255:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    ori $3, $5, 255
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i64_255:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $3, $5, 255
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i64 255, %b
  ret i64 %r
}

define signext i128 @or_i128_255(i128 signext %b) {
; GP32-LABEL: or_i128_255:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    ori $1, $7, 255
; GP32-NEXT:    move $2, $4
; GP32-NEXT:    move $3, $5
; GP32-NEXT:    move $4, $6
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $5, $1
;
; GP64-LABEL: or_i128_255:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    ori $3, $5, 255
; GP64-NEXT:    jr $ra
; GP64-NEXT:    move $2, $4
;
; MM32-LABEL: or_i128_255:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    ori $1, $7, 255
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    move $3, $5
; MM32-NEXT:    move $4, $6
; MM32-NEXT:    move $5, $1
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i128_255:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $1, $7, 255
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    move $3, $5
; MM32R6-NEXT:    move $4, $6
; MM32R6-NEXT:    move $5, $1
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i128 255, %b
  ret i128 %r
}

define signext i1 @or_i1_32768(i1 signext %b) {
; GP32-LABEL: or_i1_32768:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $2, $4
;
; GP64-LABEL: or_i1_32768:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    move $2, $4
;
; MM32-LABEL: or_i1_32768:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i1_32768:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i1 32768, %b
  ret i1 %r
}

define signext i8 @or_i8_32768(i8 signext %b) {
; GP32-LABEL: or_i8_32768:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $2, $4
;
; GP64-LABEL: or_i8_32768:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    move $2, $4
;
; MM32-LABEL: or_i8_32768:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i8_32768:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i8 32768, %b
  ret i8 %r
}

define signext i16 @or_i16_32768(i16 signext %b) {
; GP32-LABEL: or_i16_32768:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    addiu $1, $zero, -32768
; GP32-NEXT:    jr $ra
; GP32-NEXT:    or $2, $4, $1
;
; GP64-LABEL: or_i16_32768:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    addiu $1, $zero, -32768
; GP64-NEXT:    jr $ra
; GP64-NEXT:    or $2, $4, $1
;
; MM32-LABEL: or_i16_32768:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    addiu $2, $zero, -32768
; MM32-NEXT:    or16 $2, $4
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i16_32768:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    addiu $1, $zero, -32768
; MM32R6-NEXT:    or $2, $4, $1
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i16 32768, %b
  ret i16 %r
}

define signext i32 @or_i32_32768(i32 signext %b) {
; GP32-LABEL: or_i32_32768:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    ori $2, $4, 32768
;
; GP64-LABEL: or_i32_32768:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 32768
;
; MM32-LABEL: or_i32_32768:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    jr $ra
; MM32-NEXT:    ori $2, $4, 32768
;
; MM32R6-LABEL: or_i32_32768:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $2, $4, 32768
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i32 32768, %b
  ret i32 %r
}

define signext i64 @or_i64_32768(i64 signext %b) {
; GP32-LABEL: or_i64_32768:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    ori $3, $5, 32768
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $2, $4
;
; GP64-LABEL: or_i64_32768:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 32768
;
; MM32-LABEL: or_i64_32768:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    ori $3, $5, 32768
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i64_32768:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $3, $5, 32768
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i64 32768, %b
  ret i64 %r
}

define signext i128 @or_i128_32768(i128 signext %b) {
; GP32-LABEL: or_i128_32768:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    ori $1, $7, 32768
; GP32-NEXT:    move $2, $4
; GP32-NEXT:    move $3, $5
; GP32-NEXT:    move $4, $6
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $5, $1
;
; GP64-LABEL: or_i128_32768:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    ori $3, $5, 32768
; GP64-NEXT:    jr $ra
; GP64-NEXT:    move $2, $4
;
; MM32-LABEL: or_i128_32768:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    ori $1, $7, 32768
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    move $3, $5
; MM32-NEXT:    move $4, $6
; MM32-NEXT:    move $5, $1
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i128_32768:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $1, $7, 32768
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    move $3, $5
; MM32R6-NEXT:    move $4, $6
; MM32R6-NEXT:    move $5, $1
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i128 32768, %b
  ret i128 %r
}

define signext i1 @or_i1_65(i1 signext %b) {
; GP32-LABEL: or_i1_65:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    addiu $2, $zero, -1
;
; GP64-LABEL: or_i1_65:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    addiu $2, $zero, -1
;
; MM32-LABEL: or_i1_65:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    li16 $2, -1
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i1_65:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    li16 $2, -1
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i1 65, %b
  ret i1 %r
}

define signext i8 @or_i8_65(i8 signext %b) {
; GP32-LABEL: or_i8_65:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    ori $2, $4, 65
;
; GP64-LABEL: or_i8_65:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 65
;
; MM32-LABEL: or_i8_65:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    jr $ra
; MM32-NEXT:    ori $2, $4, 65
;
; MM32R6-LABEL: or_i8_65:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $2, $4, 65
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i8 65, %b
  ret i8 %r
}

define signext i16 @or_i16_65(i16 signext %b) {
; GP32-LABEL: or_i16_65:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    ori $2, $4, 65
;
; GP64-LABEL: or_i16_65:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 65
;
; MM32-LABEL: or_i16_65:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    jr $ra
; MM32-NEXT:    ori $2, $4, 65
;
; MM32R6-LABEL: or_i16_65:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $2, $4, 65
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i16 65, %b
  ret i16 %r
}

define signext i32 @or_i32_65(i32 signext %b) {
; GP32-LABEL: or_i32_65:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    ori $2, $4, 65
;
; GP64-LABEL: or_i32_65:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 65
;
; MM32-LABEL: or_i32_65:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    jr $ra
; MM32-NEXT:    ori $2, $4, 65
;
; MM32R6-LABEL: or_i32_65:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $2, $4, 65
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i32 65, %b
  ret i32 %r
}

define signext i64 @or_i64_65(i64 signext %b) {
; GP32-LABEL: or_i64_65:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    ori $3, $5, 65
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $2, $4
;
; GP64-LABEL: or_i64_65:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 65
;
; MM32-LABEL: or_i64_65:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    ori $3, $5, 65
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i64_65:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $3, $5, 65
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i64 65, %b
  ret i64 %r
}

define signext i128 @or_i128_65(i128 signext %b) {
; GP32-LABEL: or_i128_65:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    ori $1, $7, 65
; GP32-NEXT:    move $2, $4
; GP32-NEXT:    move $3, $5
; GP32-NEXT:    move $4, $6
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $5, $1
;
; GP64-LABEL: or_i128_65:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    ori $3, $5, 65
; GP64-NEXT:    jr $ra
; GP64-NEXT:    move $2, $4
;
; MM32-LABEL: or_i128_65:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    ori $1, $7, 65
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    move $3, $5
; MM32-NEXT:    move $4, $6
; MM32-NEXT:    move $5, $1
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i128_65:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $1, $7, 65
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    move $3, $5
; MM32R6-NEXT:    move $4, $6
; MM32R6-NEXT:    move $5, $1
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i128 65, %b
  ret i128 %r
}

define signext i1 @or_i1_256(i1 signext %b) {
; GP32-LABEL: or_i1_256:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $2, $4
;
; GP64-LABEL: or_i1_256:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    move $2, $4
;
; MM32-LABEL: or_i1_256:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i1_256:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i1 256, %b
  ret i1 %r
}

define signext i8 @or_i8_256(i8 signext %b) {
; GP32-LABEL: or_i8_256:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $2, $4
;
; GP64-LABEL: or_i8_256:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    move $2, $4
;
; MM32-LABEL: or_i8_256:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i8_256:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i8 256, %b
  ret i8 %r
}

define signext i16 @or_i16_256(i16 signext %b) {
; GP32-LABEL: or_i16_256:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    ori $2, $4, 256
;
; GP64-LABEL: or_i16_256:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 256
;
; MM32-LABEL: or_i16_256:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    jr $ra
; MM32-NEXT:    ori $2, $4, 256
;
; MM32R6-LABEL: or_i16_256:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $2, $4, 256
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i16 256, %b
  ret i16 %r
}

define signext i32 @or_i32_256(i32 signext %b) {
; GP32-LABEL: or_i32_256:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    jr $ra
; GP32-NEXT:    ori $2, $4, 256
;
; GP64-LABEL: or_i32_256:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 256
;
; MM32-LABEL: or_i32_256:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    jr $ra
; MM32-NEXT:    ori $2, $4, 256
;
; MM32R6-LABEL: or_i32_256:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $2, $4, 256
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i32 256, %b
  ret i32 %r
}

define signext i64 @or_i64_256(i64 signext %b) {
; GP32-LABEL: or_i64_256:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    ori $3, $5, 256
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $2, $4
;
; GP64-LABEL: or_i64_256:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    jr $ra
; GP64-NEXT:    ori $2, $4, 256
;
; MM32-LABEL: or_i64_256:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    ori $3, $5, 256
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i64_256:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $3, $5, 256
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i64 256, %b
  ret i64 %r
}

define signext i128 @or_i128_256(i128 signext %b) {
; GP32-LABEL: or_i128_256:
; GP32:       # %bb.0: # %entry
; GP32-NEXT:    ori $1, $7, 256
; GP32-NEXT:    move $2, $4
; GP32-NEXT:    move $3, $5
; GP32-NEXT:    move $4, $6
; GP32-NEXT:    jr $ra
; GP32-NEXT:    move $5, $1
;
; GP64-LABEL: or_i128_256:
; GP64:       # %bb.0: # %entry
; GP64-NEXT:    ori $3, $5, 256
; GP64-NEXT:    jr $ra
; GP64-NEXT:    move $2, $4
;
; MM32-LABEL: or_i128_256:
; MM32:       # %bb.0: # %entry
; MM32-NEXT:    ori $1, $7, 256
; MM32-NEXT:    move $2, $4
; MM32-NEXT:    move $3, $5
; MM32-NEXT:    move $4, $6
; MM32-NEXT:    move $5, $1
; MM32-NEXT:    jrc $ra
;
; MM32R6-LABEL: or_i128_256:
; MM32R6:       # %bb.0: # %entry
; MM32R6-NEXT:    ori $1, $7, 256
; MM32R6-NEXT:    move $2, $4
; MM32R6-NEXT:    move $3, $5
; MM32R6-NEXT:    move $4, $6
; MM32R6-NEXT:    move $5, $1
; MM32R6-NEXT:    jrc $ra
entry:
  %r = or i128 256, %b
  ret i128 %r
}
