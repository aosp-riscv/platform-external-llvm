//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===---------------------------------------------------------------------===//
//
// This implements methods defined in ResourceScriptStmt.h.
//
// Ref: msdn.microsoft.com/en-us/library/windows/desktop/aa380599(v=vs.85).aspx
//
//===---------------------------------------------------------------------===//

#include "ResourceScriptStmt.h"

namespace llvm {
namespace rc {

raw_ostream &operator<<(raw_ostream &OS, const IntOrString &Item) {
  if (Item.IsInt)
    return OS << Item.Data.Int;
  else
    return OS << Item.Data.String;
}

raw_ostream &OptionalStmtList::log(raw_ostream &OS) const {
  for (const auto &Stmt : Statements) {
    OS << "  Option: ";
    Stmt->log(OS);
  }
  return OS;
}

raw_ostream &LanguageResource::log(raw_ostream &OS) const {
  return OS << "Language: " << Lang << ", Sublanguage: " << SubLang << "\n";
}

StringRef AcceleratorsResource::Accelerator::OptionsStr
    [AcceleratorsResource::Accelerator::NumFlags] = {
        "ASCII", "VIRTKEY", "NOINVERT", "ALT", "SHIFT", "CONTROL"};

raw_ostream &AcceleratorsResource::log(raw_ostream &OS) const {
  OS << "Accelerators (" << ResName << "): \n";
  OptStatements.log(OS);
  for (const auto &Acc : Accelerators) {
    OS << "  Accelerator: " << Acc.Event << " " << Acc.Id;
    for (size_t i = 0; i < Accelerator::NumFlags; ++i)
      if (Acc.Flags & (1U << i))
        OS << " " << Accelerator::OptionsStr[i];
    OS << "\n";
  }
  return OS;
}

raw_ostream &CursorResource::log(raw_ostream &OS) const {
  return OS << "Cursor (" << ResName << "): " << CursorLoc << "\n";
}

raw_ostream &IconResource::log(raw_ostream &OS) const {
  return OS << "Icon (" << ResName << "): " << IconLoc << "\n";
}

raw_ostream &HTMLResource::log(raw_ostream &OS) const {
  return OS << "HTML (" << ResName << "): " << HTMLLoc << "\n";
}

StringRef MenuDefinition::OptionsStr[MenuDefinition::NumFlags] = {
    "CHECKED", "GRAYED", "HELP", "INACTIVE", "MENUBARBREAK", "MENUBREAK"};

raw_ostream &MenuDefinition::logFlags(raw_ostream &OS, uint8_t Flags) {
  for (size_t i = 0; i < NumFlags; ++i)
    if (Flags & (1U << i))
      OS << " " << OptionsStr[i];
  return OS;
}

raw_ostream &MenuDefinitionList::log(raw_ostream &OS) const {
  OS << "  Menu list starts\n";
  for (auto &Item : Definitions)
    Item->log(OS);
  return OS << "  Menu list ends\n";
}

raw_ostream &MenuItem::log(raw_ostream &OS) const {
  OS << "  MenuItem (" << Name << "), ID = " << Id;
  logFlags(OS, Flags);
  return OS << "\n";
}

raw_ostream &MenuSeparator::log(raw_ostream &OS) const {
  return OS << "  Menu separator\n";
}

raw_ostream &PopupItem::log(raw_ostream &OS) const {
  OS << "  Popup (" << Name << ")";
  logFlags(OS, Flags);
  OS << ":\n";
  return SubItems.log(OS);
}

raw_ostream &MenuResource::log(raw_ostream &OS) const {
  OS << "Menu (" << ResName << "):\n";
  OptStatements.log(OS);
  return Elements.log(OS);
}

raw_ostream &StringTableResource::log(raw_ostream &OS) const {
  OS << "StringTable:\n";
  OptStatements.log(OS);
  for (const auto &String : Table)
    OS << "  " << String.first << " => " << String.second << "\n";
  return OS;
}

const StringSet<> Control::SupportedCtls = {
    "LTEXT", "RTEXT", "CTEXT", "PUSHBUTTON", "DEFPUSHBUTTON", "EDITTEXT"};

const StringSet<> Control::CtlsWithTitle = {"LTEXT", "RTEXT", "CTEXT",
                                            "PUSHBUTTON", "DEFPUSHBUTTON"};

raw_ostream &Control::log(raw_ostream &OS) const {
  OS << "  Control (" << ID << "): " << Type << ", title: " << Title
     << ", loc: (" << X << ", " << Y << "), size: [" << Width << ", " << Height
     << "]";
  if (Style)
    OS << ", style: " << *Style;
  if (ExtStyle)
    OS << ", ext. style: " << *ExtStyle;
  if (HelpID)
    OS << ", help ID: " << *HelpID;
  return OS << "\n";
}

raw_ostream &DialogResource::log(raw_ostream &OS) const {
  OS << "Dialog" << (IsExtended ? "Ex" : "") << " (" << ResName << "): loc: ("
     << X << ", " << Y << "), size: [" << Width << ", " << Height
     << "], help ID: " << HelpID << "\n";
  OptStatements.log(OS);
  for (auto &Ctl : Controls)
    Ctl.log(OS);
  return OS;
}

raw_ostream &VersionInfoBlock::log(raw_ostream &OS) const {
  OS << "  Start of block (name: " << Name << ")\n";
  for (auto &Stmt : Stmts)
    Stmt->log(OS);
  return OS << "  End of block\n";
}

raw_ostream &VersionInfoValue::log(raw_ostream &OS) const {
  OS << "  " << Key << " =>";
  for (auto &Value : Values)
    OS << " " << Value;
  return OS << "\n";
}

using VersionInfoFixed = VersionInfoResource::VersionInfoFixed;
using VersionInfoFixedType = VersionInfoFixed::VersionInfoFixedType;

const StringRef
    VersionInfoFixed::FixedFieldsNames[VersionInfoFixed::FtNumTypes] = {
        "",          "FILEVERSION", "PRODUCTVERSION", "FILEFLAGSMASK",
        "FILEFLAGS", "FILEOS",      "FILETYPE",       "FILESUBTYPE"};

const StringMap<VersionInfoFixedType> VersionInfoFixed::FixedFieldsInfoMap = {
    {FixedFieldsNames[FtFileVersion], FtFileVersion},
    {FixedFieldsNames[FtProductVersion], FtProductVersion},
    {FixedFieldsNames[FtFileFlagsMask], FtFileFlagsMask},
    {FixedFieldsNames[FtFileFlags], FtFileFlags},
    {FixedFieldsNames[FtFileOS], FtFileOS},
    {FixedFieldsNames[FtFileType], FtFileType},
    {FixedFieldsNames[FtFileSubtype], FtFileSubtype}};

VersionInfoFixedType VersionInfoFixed::getFixedType(StringRef Type) {
  auto UpperType = Type.upper();
  auto Iter = FixedFieldsInfoMap.find(UpperType);
  if (Iter != FixedFieldsInfoMap.end())
    return Iter->getValue();
  return FtUnknown;
}

bool VersionInfoFixed::isTypeSupported(VersionInfoFixedType Type) {
  return FtUnknown < Type && Type < FtNumTypes;
}

bool VersionInfoFixed::isVersionType(VersionInfoFixedType Type) {
  switch (Type) {
  case FtFileVersion:
  case FtProductVersion:
    return true;

  default:
    return false;
  }
}

raw_ostream &VersionInfoFixed::log(raw_ostream &OS) const {
  for (int Type = FtUnknown; Type < FtNumTypes; ++Type) {
    if (!isTypeSupported((VersionInfoFixedType)Type))
      continue;
    OS << "  Fixed: " << FixedFieldsNames[Type] << ":";
    for (uint32_t Val : FixedInfo[Type])
      OS << " " << Val;
    OS << "\n";
  }
  return OS;
}

raw_ostream &VersionInfoResource::log(raw_ostream &OS) const {
  OS << "VersionInfo (" << ResName << "):\n";
  FixedData.log(OS);
  return MainBlock.log(OS);
}

raw_ostream &CharacteristicsStmt::log(raw_ostream &OS) const {
  return OS << "Characteristics: " << Value << "\n";
}

raw_ostream &VersionStmt::log(raw_ostream &OS) const {
  return OS << "Version: " << Value << "\n";
}

raw_ostream &CaptionStmt::log(raw_ostream &OS) const {
  return OS << "Caption: " << Value << "\n";
}

raw_ostream &FontStmt::log(raw_ostream &OS) const {
  return OS << "Font: size = " << Size << ", face = " << Typeface << "\n";
}

raw_ostream &StyleStmt::log(raw_ostream &OS) const {
  return OS << "Style: " << Value << "\n";
}

} // namespace rc
} // namespace llvm
