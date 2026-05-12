add_qtc_library(3rd_cplusplus OBJECT
  PUBLIC_DEPENDS Qt6::Core Utils
  SOURCES
    AST.cpp AST.h
    ASTClone.cpp
    ASTMatch0.cpp
    ASTMatcher.cpp ASTMatcher.h
    ASTPatternBuilder.h
    ASTVisit.cpp
    ASTVisitor.cpp ASTVisitor.h
    ASTfwd.h
    Bind.cpp Bind.h
    CPlusPlus.h
    CPlusPlusForwardDeclarations.h
    Control.cpp Control.h
    CoreTypes.cpp CoreTypes.h
    DiagnosticClient.cpp DiagnosticClient.h
    FullySpecifiedType.cpp FullySpecifiedType.h
    Keywords.cpp
    Lexer.cpp Lexer.h
    LiteralTable.h
    Literals.cpp Literals.h
    Matcher.cpp Matcher.h
    MemoryPool.cpp MemoryPool.h
    Name.cpp Name.h
    NameVisitor.cpp NameVisitor.h
    Names.cpp Names.h
    ObjectiveCAtKeywords.cpp
    ObjectiveCTypeQualifiers.cpp ObjectiveCTypeQualifiers.h
    Parser.cpp Parser.h
    QtContextKeywords.cpp QtContextKeywords.h
    SafeMatcher.cpp SafeMatcher.h
    Scope.cpp Scope.h
    Symbol.cpp Symbol.h
    SymbolVisitor.h
    Symbols.cpp Symbols.h
    Templates.cpp Templates.h
    Token.cpp Token.h
    TranslationUnit.cpp TranslationUnit.h
    Type.cpp Type.h
    TypeVisitor.cpp TypeVisitor.h
    cppassert.h
  SKIP_PCH
  PROPERTIES POSITION_INDEPENDENT_CODE ON
)

set(export_symbol_declaration DEFINES CPLUSPLUS_BUILD_LIB)
if (QTC_STATIC_BUILD)
  set(export_symbol_declaration PUBLIC_DEFINES CPLUSPLUS_BUILD_STATIC_LIB)
endif()
extend_qtc_target(3rd_cplusplus ${export_symbol_declaration})


