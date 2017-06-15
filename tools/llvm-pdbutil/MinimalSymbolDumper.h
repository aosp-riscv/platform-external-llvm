//===- MinimalSymbolDumper.h ---------------------------------- *- C++ --*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TOOLS_LLVMPDBUTIL_MINIMAL_SYMBOL_DUMPER_H
#define LLVM_TOOLS_LLVMPDBUTIL_MINIMAL_SYMBOL_DUMPER_H

#include "llvm/DebugInfo/CodeView/SymbolVisitorCallbacks.h"

namespace llvm {
namespace codeview {
class LazyRandomTypeCollection;
}

namespace pdb {
class LinePrinter;

class MinimalSymbolDumper : public codeview::SymbolVisitorCallbacks {
public:
  MinimalSymbolDumper(LinePrinter &P, bool RecordBytes,
                      codeview::LazyRandomTypeCollection &Types)
      : P(P), RecordBytes(RecordBytes), Types(Types) {}

  virtual Error visitSymbolBegin(codeview::CVSymbol &Record);
  virtual Error visitSymbolEnd(codeview::CVSymbol &Record);

#define SYMBOL_RECORD(EnumName, EnumVal, Name)                                 \
  virtual Error visitKnownRecord(codeview::CVSymbol &CVR,                      \
                                 codeview::Name &Record) override;
#define SYMBOL_RECORD_ALIAS(EnumName, EnumVal, Name, AliasName)
#include "llvm/DebugInfo/CodeView/CodeViewSymbols.def"

private:
  std::string typeIndex(codeview::TypeIndex TI) const;

  LinePrinter &P;
  bool RecordBytes = false;
  codeview::LazyRandomTypeCollection &Types;
};
} // namespace pdb
} // namespace llvm

#endif