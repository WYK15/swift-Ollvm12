add_llvm_component_library(LLVMObfuscation
  CryptoUtils.cpp
  Utils.cpp
  ObfuscationPassManager.cpp
  ObfuscationOptions.cpp
  IPObfuscationContext.cpp
  IndirectBranch.cpp
  IndirectCall.cpp
  IndirectGlobalVariable.cpp
  Flattening.cpp
  StringEncryption.cpp
  LegacyLowerSwitch.cpp

  ADDITIONAL_HEADER_DIRS
  ${LLVM_MAIN_INCLUDE_DIR}/llvm/Transforms

  DEPENDS
  LLVMObfuscation
  intrinsics_gen
  LLVMLinker

  COMPONENT_NAME
  Obfuscation

  LINK_COMPONENTS
  AggressiveInstCombine
  Analysis
  BitReader
  )
