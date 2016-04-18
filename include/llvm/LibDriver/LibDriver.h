//===- llvm/LibDriver/LibDriver.h - lib.exe-compatible driver ---*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Defines an interface to a lib.exe-compatible driver that also understands
// bitcode files. Used by llvm-lib and lld-link /lib.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIBDRIVER_LIBDRIVER_H
#define LLVM_LIBDRIVER_LIBDRIVER_H

namespace llvm {
template <typename T> class ArrayRef;

int libDriverMain(ArrayRef<const char *> ARgs);
}

#endif
