; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-unknown-linux-gnu < %s | FileCheck %s

; https://bugs.llvm.org/show_bug.cgi?id=38149

; We are truncating from wider width, and then sign-extending
; back to the original width. Then we inequality-comparing orig and src.
; If they don't match, then we had signed truncation during truncation.

; This can be expressed in a several ways in IR:
;   trunc + sext + icmp ne <- not canonical
;   shl   + ashr + icmp ne
;   add          + icmp ult
;   add          + icmp uge
; However only the simplest form (with two shifts) gets lowered best.

; ---------------------------------------------------------------------------- ;
; shl + ashr + icmp ne
; ---------------------------------------------------------------------------- ;

define i1 @shifts_necmp_i16_i8(i16 %x) nounwind {
; CHECK-LABEL: shifts_necmp_i16_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sxtb w8, w0
; CHECK-NEXT:    and w8, w8, #0xffff
; CHECK-NEXT:    cmp w8, w0, uxth
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %tmp0 = shl i16 %x, 8 ; 16-8
  %tmp1 = ashr exact i16 %tmp0, 8 ; 16-8
  %tmp2 = icmp ne i16 %tmp1, %x
  ret i1 %tmp2
}

define i1 @shifts_necmp_i32_i16(i32 %x) nounwind {
; CHECK-LABEL: shifts_necmp_i32_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sxth w8, w0
; CHECK-NEXT:    cmp w8, w0
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %tmp0 = shl i32 %x, 16 ; 32-16
  %tmp1 = ashr exact i32 %tmp0, 16 ; 32-16
  %tmp2 = icmp ne i32 %tmp1, %x
  ret i1 %tmp2
}

define i1 @shifts_necmp_i32_i8(i32 %x) nounwind {
; CHECK-LABEL: shifts_necmp_i32_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sxtb w8, w0
; CHECK-NEXT:    cmp w8, w0
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %tmp0 = shl i32 %x, 24 ; 32-8
  %tmp1 = ashr exact i32 %tmp0, 24 ; 32-8
  %tmp2 = icmp ne i32 %tmp1, %x
  ret i1 %tmp2
}

define i1 @shifts_necmp_i64_i32(i64 %x) nounwind {
; CHECK-LABEL: shifts_necmp_i64_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sxtw x8, w0
; CHECK-NEXT:    cmp x8, x0
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %tmp0 = shl i64 %x, 32 ; 64-32
  %tmp1 = ashr exact i64 %tmp0, 32 ; 64-32
  %tmp2 = icmp ne i64 %tmp1, %x
  ret i1 %tmp2
}

define i1 @shifts_necmp_i64_i16(i64 %x) nounwind {
; CHECK-LABEL: shifts_necmp_i64_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sxth x8, w0
; CHECK-NEXT:    cmp x8, x0
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %tmp0 = shl i64 %x, 48 ; 64-16
  %tmp1 = ashr exact i64 %tmp0, 48 ; 64-16
  %tmp2 = icmp ne i64 %tmp1, %x
  ret i1 %tmp2
}

define i1 @shifts_necmp_i64_i8(i64 %x) nounwind {
; CHECK-LABEL: shifts_necmp_i64_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sxtb x8, w0
; CHECK-NEXT:    cmp x8, x0
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %tmp0 = shl i64 %x, 56 ; 64-8
  %tmp1 = ashr exact i64 %tmp0, 56 ; 64-8
  %tmp2 = icmp ne i64 %tmp1, %x
  ret i1 %tmp2
}

; ---------------------------------------------------------------------------- ;
; add + icmp ult
; ---------------------------------------------------------------------------- ;

define i1 @add_ultcmp_i16_i8(i16 %x) nounwind {
; CHECK-LABEL: add_ultcmp_i16_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub w8, w0, #128 // =128
; CHECK-NEXT:    ubfx w8, w8, #8, #8
; CHECK-NEXT:    cmp w8, #255 // =255
; CHECK-NEXT:    cset w0, lo
; CHECK-NEXT:    ret
  %tmp0 = add i16 %x, -128 ; ~0U << (8-1)
  %tmp1 = icmp ult i16 %tmp0, -256 ; ~0U << 8
  ret i1 %tmp1
}

define i1 @add_ultcmp_i32_i16(i32 %x) nounwind {
; CHECK-LABEL: add_ultcmp_i32_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub w8, w0, #8, lsl #12 // =32768
; CHECK-NEXT:    cmn w8, #16, lsl #12 // =65536
; CHECK-NEXT:    cset w0, lo
; CHECK-NEXT:    ret
  %tmp0 = add i32 %x, -32768 ; ~0U << (16-1)
  %tmp1 = icmp ult i32 %tmp0, -65536 ; ~0U << 16
  ret i1 %tmp1
}

define i1 @add_ultcmp_i32_i8(i32 %x) nounwind {
; CHECK-LABEL: add_ultcmp_i32_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub w8, w0, #128 // =128
; CHECK-NEXT:    cmn w8, #256 // =256
; CHECK-NEXT:    cset w0, lo
; CHECK-NEXT:    ret
  %tmp0 = add i32 %x, -128 ; ~0U << (8-1)
  %tmp1 = icmp ult i32 %tmp0, -256 ; ~0U << 8
  ret i1 %tmp1
}

define i1 @add_ultcmp_i64_i32(i64 %x) nounwind {
; CHECK-LABEL: add_ultcmp_i64_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #-2147483648
; CHECK-NEXT:    add x8, x0, x8
; CHECK-NEXT:    mov x9, #-4294967296
; CHECK-NEXT:    cmp x8, x9
; CHECK-NEXT:    cset w0, lo
; CHECK-NEXT:    ret
  %tmp0 = add i64 %x, -2147483648 ; ~0U << (32-1)
  %tmp1 = icmp ult i64 %tmp0, -4294967296 ; ~0U << 32
  ret i1 %tmp1
}

define i1 @add_ultcmp_i64_i16(i64 %x) nounwind {
; CHECK-LABEL: add_ultcmp_i64_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub x8, x0, #8, lsl #12 // =32768
; CHECK-NEXT:    cmn x8, #16, lsl #12 // =65536
; CHECK-NEXT:    cset w0, lo
; CHECK-NEXT:    ret
  %tmp0 = add i64 %x, -32768 ; ~0U << (16-1)
  %tmp1 = icmp ult i64 %tmp0, -65536 ; ~0U << 16
  ret i1 %tmp1
}

define i1 @add_ultcmp_i64_i8(i64 %x) nounwind {
; CHECK-LABEL: add_ultcmp_i64_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub x8, x0, #128 // =128
; CHECK-NEXT:    cmn x8, #256 // =256
; CHECK-NEXT:    cset w0, lo
; CHECK-NEXT:    ret
  %tmp0 = add i64 %x, -128 ; ~0U << (8-1)
  %tmp1 = icmp ult i64 %tmp0, -256 ; ~0U << 8
  ret i1 %tmp1
}

; ---------------------------------------------------------------------------- ;
; add + icmp uge
; ---------------------------------------------------------------------------- ;

define i1 @add_ugecmp_i16_i8(i16 %x) nounwind {
; CHECK-LABEL: add_ugecmp_i16_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w0, #128 // =128
; CHECK-NEXT:    and w8, w8, #0xffff
; CHECK-NEXT:    cmp w8, #255 // =255
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
  %tmp0 = add i16 %x, 128 ; 1U << (8-1)
  %tmp1 = icmp uge i16 %tmp0, 256 ; 1U << 8
  ret i1 %tmp1
}

define i1 @add_ugecmp_i32_i16(i32 %x) nounwind {
; CHECK-LABEL: add_ugecmp_i32_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w0, #8, lsl #12 // =32768
; CHECK-NEXT:    lsr w8, w8, #16
; CHECK-NEXT:    cmp w8, #0 // =0
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %tmp0 = add i32 %x, 32768 ; 1U << (16-1)
  %tmp1 = icmp uge i32 %tmp0, 65536 ; 1U << 16
  ret i1 %tmp1
}

define i1 @add_ugecmp_i32_i8(i32 %x) nounwind {
; CHECK-LABEL: add_ugecmp_i32_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w0, #128 // =128
; CHECK-NEXT:    cmp w8, #255 // =255
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
  %tmp0 = add i32 %x, 128 ; 1U << (8-1)
  %tmp1 = icmp uge i32 %tmp0, 256 ; 1U << 8
  ret i1 %tmp1
}

define i1 @add_ugecmp_i64_i32(i64 %x) nounwind {
; CHECK-LABEL: add_ugecmp_i64_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w8, wzr, #0x80000000
; CHECK-NEXT:    add x8, x0, x8
; CHECK-NEXT:    lsr x8, x8, #32
; CHECK-NEXT:    cmp x8, #0 // =0
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %tmp0 = add i64 %x, 2147483648 ; 1U << (32-1)
  %tmp1 = icmp uge i64 %tmp0, 4294967296 ; 1U << 32
  ret i1 %tmp1
}

define i1 @add_ugecmp_i64_i16(i64 %x) nounwind {
; CHECK-LABEL: add_ugecmp_i64_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add x8, x0, #8, lsl #12 // =32768
; CHECK-NEXT:    lsr x8, x8, #16
; CHECK-NEXT:    cmp x8, #0 // =0
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %tmp0 = add i64 %x, 32768 ; 1U << (16-1)
  %tmp1 = icmp uge i64 %tmp0, 65536 ; 1U << 16
  ret i1 %tmp1
}

define i1 @add_ugecmp_i64_i8(i64 %x) nounwind {
; CHECK-LABEL: add_ugecmp_i64_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add x8, x0, #128 // =128
; CHECK-NEXT:    cmp x8, #255 // =255
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
  %tmp0 = add i64 %x, 128 ; 1U << (8-1)
  %tmp1 = icmp uge i64 %tmp0, 256 ; 1U << 8
  ret i1 %tmp1
}

; Negative tests
; ---------------------------------------------------------------------------- ;

; Adding not a constant
define i1 @add_ugecmp_bad_i16_i8_add(i16 %x, i16 %y) nounwind {
; CHECK-LABEL: add_ugecmp_bad_i16_i8_add:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w0, w1
; CHECK-NEXT:    and w8, w8, #0xffff
; CHECK-NEXT:    cmp w8, #255 // =255
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
  %tmp0 = add i16 %x, %y
  %tmp1 = icmp uge i16 %tmp0, 256 ; 1U << 8
  ret i1 %tmp1
}

; Comparing not with a constant
define i1 @add_ugecmp_bad_i16_i8_cmp(i16 %x, i16 %y) nounwind {
; CHECK-LABEL: add_ugecmp_bad_i16_i8_cmp:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w0, #128 // =128
; CHECK-NEXT:    and w8, w8, #0xffff
; CHECK-NEXT:    cmp w8, w1, uxth
; CHECK-NEXT:    cset w0, hs
; CHECK-NEXT:    ret
  %tmp0 = add i16 %x, 128 ; 1U << (8-1)
  %tmp1 = icmp uge i16 %tmp0, %y
  ret i1 %tmp1
}

; Second constant is not larger than the first one
define i1 @add_ugecmp_bad_i8_i16(i16 %x) nounwind {
; CHECK-LABEL: add_ugecmp_bad_i8_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w0, #128 // =128
; CHECK-NEXT:    and w8, w8, #0xffff
; CHECK-NEXT:    cmp w8, #127 // =127
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
  %tmp0 = add i16 %x, 128 ; 1U << (8-1)
  %tmp1 = icmp uge i16 %tmp0, 128 ; 1U << (8-1)
  ret i1 %tmp1
}

; First constant is not power of two
define i1 @add_ugecmp_bad_i16_i8_c0notpoweroftwo(i16 %x) nounwind {
; CHECK-LABEL: add_ugecmp_bad_i16_i8_c0notpoweroftwo:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w0, #192 // =192
; CHECK-NEXT:    and w8, w8, #0xffff
; CHECK-NEXT:    cmp w8, #255 // =255
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
  %tmp0 = add i16 %x, 192 ; (1U << (8-1)) + (1U << (8-1-1))
  %tmp1 = icmp uge i16 %tmp0, 256 ; 1U << 8
  ret i1 %tmp1
}

; Second constant is not power of two
define i1 @add_ugecmp_bad_i16_i8_c1notpoweroftwo(i16 %x) nounwind {
; CHECK-LABEL: add_ugecmp_bad_i16_i8_c1notpoweroftwo:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w0, #128 // =128
; CHECK-NEXT:    and w8, w8, #0xffff
; CHECK-NEXT:    cmp w8, #767 // =767
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
  %tmp0 = add i16 %x, 128 ; 1U << (8-1)
  %tmp1 = icmp uge i16 %tmp0, 768 ; (1U << 8)) + (1U << (8+1))
  ret i1 %tmp1
}

; Magic check fails, 64 << 1 != 256
define i1 @add_ugecmp_bad_i16_i8_magic(i16 %x) nounwind {
; CHECK-LABEL: add_ugecmp_bad_i16_i8_magic:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w0, #64 // =64
; CHECK-NEXT:    and w8, w8, #0xffff
; CHECK-NEXT:    cmp w8, #255 // =255
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
  %tmp0 = add i16 %x, 64 ; 1U << (8-1-1)
  %tmp1 = icmp uge i16 %tmp0, 256 ; 1U << 8
  ret i1 %tmp1
}

; Bad 'destination type'
define i1 @add_ugecmp_bad_i16_i4(i16 %x) nounwind {
; CHECK-LABEL: add_ugecmp_bad_i16_i4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w0, #8 // =8
; CHECK-NEXT:    and w8, w8, #0xffff
; CHECK-NEXT:    cmp w8, #15 // =15
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
  %tmp0 = add i16 %x, 8 ; 1U << (4-1)
  %tmp1 = icmp uge i16 %tmp0, 16 ; 1U << 4
  ret i1 %tmp1
}

; Bad storage type
define i1 @add_ugecmp_bad_i24_i8(i24 %x) nounwind {
; CHECK-LABEL: add_ugecmp_bad_i24_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w0, #128 // =128
; CHECK-NEXT:    and w8, w8, #0xffffff
; CHECK-NEXT:    cmp w8, #255 // =255
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
  %tmp0 = add i24 %x, 128 ; 1U << (8-1)
  %tmp1 = icmp uge i24 %tmp0, 256 ; 1U << 8
  ret i1 %tmp1
}
