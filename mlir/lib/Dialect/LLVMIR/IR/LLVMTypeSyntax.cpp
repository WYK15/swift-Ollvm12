//===- LLVMTypeSyntax.cpp - Parsing/printing for MLIR LLVM Dialect types --===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/LLVMIR/LLVMTypes.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "llvm/ADT/ScopeExit.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace mlir;
using namespace mlir::LLVM;

//===----------------------------------------------------------------------===//
// Printing.
//===----------------------------------------------------------------------===//

/// If the given type is compatible with the LLVM dialect, prints it using
/// internal functions to avoid getting a verbose `!llvm` prefix. Otherwise
/// prints it as usual.
static void dispatchPrint(DialectAsmPrinter &printer, Type type) {
  if (isCompatibleType(type))
    return mlir::LLVM::detail::printType(type, printer);
  printer.printType(type);
}

/// Returns the keyword to use for the given type.
static StringRef getTypeKeyword(Type type) {
  return TypeSwitch<Type, StringRef>(type)
      .Case<LLVMVoidType>([&](Type) { return "void"; })
      .Case<LLVMHalfType>([&](Type) { return "half"; })
      .Case<LLVMBFloatType>([&](Type) { return "bfloat"; })
      .Case<LLVMFloatType>([&](Type) { return "float"; })
      .Case<LLVMDoubleType>([&](Type) { return "double"; })
      .Case<LLVMFP128Type>([&](Type) { return "fp128"; })
      .Case<LLVMX86FP80Type>([&](Type) { return "x86_fp80"; })
      .Case<LLVMPPCFP128Type>([&](Type) { return "ppc_fp128"; })
      .Case<LLVMX86MMXType>([&](Type) { return "x86_mmx"; })
      .Case<LLVMTokenType>([&](Type) { return "token"; })
      .Case<LLVMLabelType>([&](Type) { return "label"; })
      .Case<LLVMMetadataType>([&](Type) { return "metadata"; })
      .Case<LLVMFunctionType>([&](Type) { return "func"; })
      .Case<LLVMIntegerType>([&](Type) { return "i"; })
      .Case<LLVMPointerType>([&](Type) { return "ptr"; })
      .Case<LLVMVectorType>([&](Type) { return "vec"; })
      .Case<LLVMArrayType>([&](Type) { return "array"; })
      .Case<LLVMStructType>([&](Type) { return "struct"; })
      .Default([](Type) -> StringRef {
        llvm_unreachable("unexpected 'llvm' type kind");
      });
}

/// Prints a structure type. Keeps track of known struct names to handle self-
/// or mutually-referring structs without falling into infinite recursion.
static void printStructType(DialectAsmPrinter &printer, LLVMStructType type) {
  // This keeps track of the names of identified structure types that are
  // currently being printed. Since such types can refer themselves, this
  // tracking is necessary to stop the recursion: the current function may be
  // called recursively from DialectAsmPrinter::printType after the appropriate
  // dispatch. We maintain the invariant of this storage being modified
  // exclusively in this function, and at most one name being added per call.
  // TODO: consider having such functionality inside DialectAsmPrinter.
  thread_local llvm::SetVector<StringRef> knownStructNames;
  unsigned stackSize = knownStructNames.size();
  (void)stackSize;
  auto guard = llvm::make_scope_exit([&]() {
    assert(knownStructNames.size() == stackSize &&
           "malformed identified stack when printing recursive structs");
  });

  printer << "<";
  if (type.isIdentified()) {
    printer << '"' << type.getName() << '"';
    // If we are printing a reference to one of the enclosing structs, just
    // print the name and stop to avoid infinitely long output.
    if (knownStructNames.count(type.getName())) {
      printer << '>';
      return;
    }
    printer << ", ";
  }

  if (type.isIdentified() && type.isOpaque()) {
    printer << "opaque>";
    return;
  }

  if (type.isPacked())
    printer << "packed ";

  // Put the current type on stack to avoid infinite recursion.
  printer << '(';
  if (type.isIdentified())
    knownStructNames.insert(type.getName());
  llvm::interleaveComma(type.getBody(), printer.getStream(),
                        [&](Type subtype) { dispatchPrint(printer, subtype); });
  if (type.isIdentified())
    knownStructNames.pop_back();
  printer << ')';
  printer << '>';
}

/// Prints a type containing a fixed number of elements.
template <typename TypeTy>
static void printArrayOrVectorType(DialectAsmPrinter &printer, TypeTy type) {
  printer << '<' << type.getNumElements() << " x ";
  dispatchPrint(printer, type.getElementType());
  printer << '>';
}

/// Prints a function type.
static void printFunctionType(DialectAsmPrinter &printer,
                              LLVMFunctionType funcType) {
  printer << '<';
  dispatchPrint(printer, funcType.getReturnType());
  printer << " (";
  llvm::interleaveComma(
      funcType.getParams(), printer.getStream(),
      [&printer](Type subtype) { dispatchPrint(printer, subtype); });
  if (funcType.isVarArg()) {
    if (funcType.getNumParams() != 0)
      printer << ", ";
    printer << "...";
  }
  printer << ")>";
}

/// Prints the given LLVM dialect type recursively. This leverages closedness of
/// the LLVM dialect type system to avoid printing the dialect prefix
/// repeatedly. For recursive structures, only prints the name of the structure
/// when printing a self-reference. Note that this does not apply to sibling
/// references. For example,
///   struct<"a", (ptr<struct<"a">>)>
///   struct<"c", (ptr<struct<"b", (ptr<struct<"c">>)>>,
///                ptr<struct<"b", (ptr<struct<"c">>)>>)>
/// note that "b" is printed twice.
void mlir::LLVM::detail::printType(Type type, DialectAsmPrinter &printer) {
  if (!type) {
    printer << "<<NULL-TYPE>>";
    return;
  }

  printer << getTypeKeyword(type);

  if (auto intType = type.dyn_cast<LLVMIntegerType>()) {
    printer << intType.getBitWidth();
    return;
  }

  if (auto ptrType = type.dyn_cast<LLVMPointerType>()) {
    printer << '<';
    dispatchPrint(printer, ptrType.getElementType());
    if (ptrType.getAddressSpace() != 0)
      printer << ", " << ptrType.getAddressSpace();
    printer << '>';
    return;
  }

  if (auto arrayType = type.dyn_cast<LLVMArrayType>())
    return printArrayOrVectorType(printer, arrayType);
  if (auto vectorType = type.dyn_cast<LLVMFixedVectorType>())
    return printArrayOrVectorType(printer, vectorType);

  if (auto vectorType = type.dyn_cast<LLVMScalableVectorType>()) {
    printer << "<? x " << vectorType.getMinNumElements() << " x ";
    dispatchPrint(printer, vectorType.getElementType());
    printer << '>';
    return;
  }

  if (auto structType = type.dyn_cast<LLVMStructType>())
    return printStructType(printer, structType);

  if (auto funcType = type.dyn_cast<LLVMFunctionType>())
    return printFunctionType(printer, funcType);
}

//===----------------------------------------------------------------------===//
// Parsing.
//===----------------------------------------------------------------------===//

static ParseResult dispatchParse(DialectAsmParser &parser, Type &type);

/// Parses an LLVM dialect function type.
///   llvm-type :: = `func<` llvm-type `(` llvm-type-list `...`? `)>`
static LLVMFunctionType parseFunctionType(DialectAsmParser &parser) {
  Location loc = parser.getEncodedSourceLoc(parser.getCurrentLocation());
  Type returnType;
  if (parser.parseLess() || dispatchParse(parser, returnType) ||
      parser.parseLParen())
    return LLVMFunctionType();

  // Function type without arguments.
  if (succeeded(parser.parseOptionalRParen())) {
    if (succeeded(parser.parseGreater()))
      return LLVMFunctionType::getChecked(loc, returnType, {},
                                          /*isVarArg=*/false);
    return LLVMFunctionType();
  }

  // Parse arguments.
  SmallVector<Type, 8> argTypes;
  do {
    if (succeeded(parser.parseOptionalEllipsis())) {
      if (parser.parseOptionalRParen() || parser.parseOptionalGreater())
        return LLVMFunctionType();
      return LLVMFunctionType::getChecked(loc, returnType, argTypes,
                                          /*isVarArg=*/true);
    }

    Type arg;
    if (dispatchParse(parser, arg))
      return LLVMFunctionType();
    argTypes.push_back(arg);
  } while (succeeded(parser.parseOptionalComma()));

  if (parser.parseOptionalRParen() || parser.parseOptionalGreater())
    return LLVMFunctionType();
  return LLVMFunctionType::getChecked(loc, returnType, argTypes,
                                      /*isVarArg=*/false);
}

/// Parses an LLVM dialect pointer type.
///   llvm-type ::= `ptr<` llvm-type (`,` integer)? `>`
static LLVMPointerType parsePointerType(DialectAsmParser &parser) {
  Location loc = parser.getEncodedSourceLoc(parser.getCurrentLocation());
  Type elementType;
  if (parser.parseLess() || dispatchParse(parser, elementType))
    return LLVMPointerType();

  unsigned addressSpace = 0;
  if (succeeded(parser.parseOptionalComma()) &&
      failed(parser.parseInteger(addressSpace)))
    return LLVMPointerType();
  if (failed(parser.parseGreater()))
    return LLVMPointerType();
  return LLVMPointerType::getChecked(loc, elementType, addressSpace);
}

/// Parses an LLVM dialect vector type.
///   llvm-type ::= `vec<` `? x`? integer `x` llvm-type `>`
/// Supports both fixed and scalable vectors.
static LLVMVectorType parseVectorType(DialectAsmParser &parser) {
  SmallVector<int64_t, 2> dims;
  llvm::SMLoc dimPos;
  Type elementType;
  Location loc = parser.getEncodedSourceLoc(parser.getCurrentLocation());
  if (parser.parseLess() || parser.getCurrentLocation(&dimPos) ||
      parser.parseDimensionList(dims, /*allowDynamic=*/true) ||
      dispatchParse(parser, elementType) || parser.parseGreater())
    return LLVMVectorType();

  // We parsed a generic dimension list, but vectors only support two forms:
  //  - single non-dynamic entry in the list (fixed vector);
  //  - two elements, the first dynamic (indicated by -1) and the second
  //    non-dynamic (scalable vector).
  if (dims.empty() || dims.size() > 2 ||
      ((dims.size() == 2) ^ (dims[0] == -1)) ||
      (dims.size() == 2 && dims[1] == -1)) {
    parser.emitError(dimPos)
        << "expected '? x <integer> x <type>' or '<integer> x <type>'";
    return LLVMVectorType();
  }

  bool isScalable = dims.size() == 2;
  if (isScalable)
    return LLVMScalableVectorType::getChecked(loc, elementType, dims[1]);
  return LLVMFixedVectorType::getChecked(loc, elementType, dims[0]);
}

/// Parses an LLVM dialect array type.
///   llvm-type ::= `array<` integer `x` llvm-type `>`
static LLVMArrayType parseArrayType(DialectAsmParser &parser) {
  SmallVector<int64_t, 1> dims;
  llvm::SMLoc sizePos;
  Type elementType;
  Location loc = parser.getEncodedSourceLoc(parser.getCurrentLocation());
  if (parser.parseLess() || parser.getCurrentLocation(&sizePos) ||
      parser.parseDimensionList(dims, /*allowDynamic=*/false) ||
      dispatchParse(parser, elementType) || parser.parseGreater())
    return LLVMArrayType();

  if (dims.size() != 1) {
    parser.emitError(sizePos) << "expected ? x <type>";
    return LLVMArrayType();
  }

  return LLVMArrayType::getChecked(loc, elementType, dims[0]);
}

/// Attempts to set the body of an identified structure type. Reports a parsing
/// error at `subtypesLoc` in case of failure.
static LLVMStructType trySetStructBody(LLVMStructType type,
                                       ArrayRef<Type> subtypes, bool isPacked,
                                       DialectAsmParser &parser,
                                       llvm::SMLoc subtypesLoc) {
  for (Type t : subtypes) {
    if (!LLVMStructType::isValidElementType(t)) {
      parser.emitError(subtypesLoc)
          << "invalid LLVM structure element type: " << t;
      return LLVMStructType();
    }
  }

  if (succeeded(type.setBody(subtypes, isPacked)))
    return type;

  parser.emitError(subtypesLoc)
      << "identified type already used with a different body";
  return LLVMStructType();
}

/// Parses an LLVM dialect structure type.
///   llvm-type ::= `struct<` (string-literal `,`)? `packed`?
///                 `(` llvm-type-list `)` `>`
///               | `struct<` string-literal `>`
///               | `struct<` string-literal `, opaque>`
static LLVMStructType parseStructType(DialectAsmParser &parser) {
  // This keeps track of the names of identified structure types that are
  // currently being parsed. Since such types can refer themselves, this
  // tracking is necessary to stop the recursion: the current function may be
  // called recursively from DialectAsmParser::parseType after the appropriate
  // dispatch. We maintain the invariant of this storage being modified
  // exclusively in this function, and at most one name being added per call.
  // TODO: consider having such functionality inside DialectAsmParser.
  thread_local llvm::SetVector<StringRef> knownStructNames;
  unsigned stackSize = knownStructNames.size();
  (void)stackSize;
  auto guard = llvm::make_scope_exit([&]() {
    assert(knownStructNames.size() == stackSize &&
           "malformed identified stack when parsing recursive structs");
  });

  Location loc = parser.getEncodedSourceLoc(parser.getCurrentLocation());

  if (failed(parser.parseLess()))
    return LLVMStructType();

  // If we are parsing a self-reference to a recursive struct, i.e. the parsing
  // stack already contains a struct with the same identifier, bail out after
  // the name.
  StringRef name;
  bool isIdentified = succeeded(parser.parseOptionalString(&name));
  if (isIdentified) {
    if (knownStructNames.count(name)) {
      if (failed(parser.parseGreater()))
        return LLVMStructType();
      return LLVMStructType::getIdentifiedChecked(loc, name);
    }
    if (failed(parser.parseComma()))
      return LLVMStructType();
  }

  // Handle intentionally opaque structs.
  llvm::SMLoc kwLoc = parser.getCurrentLocation();
  if (succeeded(parser.parseOptionalKeyword("opaque"))) {
    if (!isIdentified)
      return parser.emitError(kwLoc, "only identified structs can be opaque"),
             LLVMStructType();
    if (failed(parser.parseGreater()))
      return LLVMStructType();
    auto type = LLVMStructType::getOpaqueChecked(loc, name);
    if (!type.isOpaque()) {
      parser.emitError(kwLoc, "redeclaring defined struct as opaque");
      return LLVMStructType();
    }
    return type;
  }

  // Check for packedness.
  bool isPacked = succeeded(parser.parseOptionalKeyword("packed"));
  if (failed(parser.parseLParen()))
    return LLVMStructType();

  // Fast pass for structs with zero subtypes.
  if (succeeded(parser.parseOptionalRParen())) {
    if (failed(parser.parseGreater()))
      return LLVMStructType();
    if (!isIdentified)
      return LLVMStructType::getLiteralChecked(loc, {}, isPacked);
    auto type = LLVMStructType::getIdentifiedChecked(loc, name);
    return trySetStructBody(type, {}, isPacked, parser, kwLoc);
  }

  // Parse subtypes. For identified structs, put the identifier of the struct on
  // the stack to support self-references in the recursive calls.
  SmallVector<Type, 4> subtypes;
  llvm::SMLoc subtypesLoc = parser.getCurrentLocation();
  do {
    if (isIdentified)
      knownStructNames.insert(name);
    Type type;
    if (dispatchParse(parser, type))
      return LLVMStructType();
    subtypes.push_back(type);
    if (isIdentified)
      knownStructNames.pop_back();
  } while (succeeded(parser.parseOptionalComma()));

  if (parser.parseRParen() || parser.parseGreater())
    return LLVMStructType();

  // Construct the struct with body.
  if (!isIdentified)
    return LLVMStructType::getLiteralChecked(loc, subtypes, isPacked);
  auto type = LLVMStructType::getIdentifiedChecked(loc, name);
  return trySetStructBody(type, subtypes, isPacked, parser, subtypesLoc);
}

/// Parses a type appearing inside another LLVM dialect-compatible type. This
/// will try to parse any type in full form (including types with the `!llvm`
/// prefix), and on failure fall back to parsing the short-hand version of the
/// LLVM dialect types without the `!llvm` prefix.
static Type dispatchParse(DialectAsmParser &parser) {
  Type type;
  llvm::SMLoc keyLoc = parser.getCurrentLocation();
  Location loc = parser.getEncodedSourceLoc(keyLoc);
  OptionalParseResult parseResult = parser.parseOptionalType(type);
  if (parseResult.hasValue()) {
    if (failed(*parseResult))
      return Type();

    // Special case for integers (i[1-9][0-9]*) that are literals rather than
    // keywords for the parser, so they are not caught by the main dispatch
    // below. Try parsing it a built-in integer type instead.
    auto intType = type.dyn_cast<IntegerType>();
    if (!intType || !intType.isSignless())
      return type;

    return LLVMIntegerType::getChecked(loc, intType.getWidth());
  }

  // Dispatch to concrete functions.
  StringRef key;
  if (failed(parser.parseKeyword(&key)))
    return Type();

  MLIRContext *ctx = parser.getBuilder().getContext();
  return StringSwitch<function_ref<Type()>>(key)
      .Case("void", [&] { return LLVMVoidType::get(ctx); })
      .Case("half", [&] { return LLVMHalfType::get(ctx); })
      .Case("bfloat", [&] { return LLVMBFloatType::get(ctx); })
      .Case("float", [&] { return LLVMFloatType::get(ctx); })
      .Case("double", [&] { return LLVMDoubleType::get(ctx); })
      .Case("fp128", [&] { return LLVMFP128Type::get(ctx); })
      .Case("x86_fp80", [&] { return LLVMX86FP80Type::get(ctx); })
      .Case("ppc_fp128", [&] { return LLVMPPCFP128Type::get(ctx); })
      .Case("x86_mmx", [&] { return LLVMX86MMXType::get(ctx); })
      .Case("token", [&] { return LLVMTokenType::get(ctx); })
      .Case("label", [&] { return LLVMLabelType::get(ctx); })
      .Case("metadata", [&] { return LLVMMetadataType::get(ctx); })
      .Case("func", [&] { return parseFunctionType(parser); })
      .Case("ptr", [&] { return parsePointerType(parser); })
      .Case("vec", [&] { return parseVectorType(parser); })
      .Case("array", [&] { return parseArrayType(parser); })
      .Case("struct", [&] { return parseStructType(parser); })
      .Default([&] {
        parser.emitError(keyLoc) << "unknown LLVM type: " << key;
        return Type();
      })();
}

/// Helper to use in parse lists.
static ParseResult dispatchParse(DialectAsmParser &parser, Type &type) {
  type = dispatchParse(parser);
  return success(type != nullptr);
}

/// Parses one of the LLVM dialect types.
Type mlir::LLVM::detail::parseType(DialectAsmParser &parser) {
  llvm::SMLoc loc = parser.getCurrentLocation();
  Type type = dispatchParse(parser);
  if (!type)
    return type;
  if (!isCompatibleType(type)) {
    parser.emitError(loc) << "unexpected type, expected i* or keyword";
    return nullptr;
  }
  return type;
}
