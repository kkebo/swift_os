import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct RegisterMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        BitRegisterMacro.self,
        BitsMacro.self,
        SystemRegisterMacro.self,
    ]
}
