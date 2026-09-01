import SwiftSyntax
import SwiftSyntaxMacros

enum SystemRegisterMacroError: Error, CustomStringConvertible {
    case requiresStruct
    case invalidRegisterName

    var description: String {
        switch self {
        case .requiresStruct:
            return "@SystemRegister can only be applied to a struct"
        case .invalidRegisterName:
            return "@SystemRegister requires a register name string, e.g., @SystemRegister(\"TCR_EL1\")"
        }
    }
}

/// Macro that expands system register read and write methods for a register struct.
public struct SystemRegisterMacro: MemberMacro {
    /// Expands the `@SystemRegister` macro to synthesize `read()` and `write()` methods.
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext,
    ) throws -> [DeclSyntax] {
        guard declaration.is(StructDeclSyntax.self) else {
            throw SystemRegisterMacroError.requiresStruct
        }

        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self),
            let firstArg = arguments.first?.expression.as(StringLiteralExprSyntax.self),
            let segment = firstArg.segments.first?.as(StringSegmentSyntax.self)
        else {
            throw SystemRegisterMacroError.invalidRegisterName
        }

        let regName = segment.content.text

        let readFuncName = "swift_os_sysreg_read_\(regName)"
        let writeFuncName = "swift_os_sysreg_write_\(regName)"

        return [
            """
            @_silgen_name("\(raw: readFuncName)")
            private static func _sysreg_read() -> UInt64
            """,
            """
            @_silgen_name("\(raw: writeFuncName)")
            private static func _sysreg_write(_ val: UInt64)
            """,
            """
            static func read() -> Self {
                #if arch(aarch64)
                return Self(rawValue: _sysreg_read())
                #else
                return Self(rawValue: 0)
                #endif
            }
            """,
            """
            static func write(_ value: Self) {
                #if arch(aarch64)
                _sysreg_write(value.rawValue)
                #endif
            }
            """,
            """
            func write() {
                Self.write(self)
            }
            """,
        ]
    }
}
