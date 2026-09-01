import SwiftSyntax
import SwiftSyntaxMacros

enum BitRegisterMacroError: Error, CustomStringConvertible {
    case requiresStruct

    var description: String {
        switch self {
        case .requiresStruct:
            return "@BitRegister can only be applied to a struct"
        }
    }
}

/// Macro that expands a struct into a bit register type with `rawValue` and initializers.
public struct BitRegisterMacro: MemberMacro {
    /// Expands the `@BitRegister` macro to synthesize `rawValue` and initializers.
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext,
    ) throws -> [DeclSyntax] {
        guard declaration.is(StructDeclSyntax.self) else {
            throw BitRegisterMacroError.requiresStruct
        }

        var members: [DeclSyntax] = []

        let hasRawValue = declaration.memberBlock.members.contains { member in
            if let varDecl = member.decl.as(VariableDeclSyntax.self) {
                return varDecl.bindings.contains { binding in
                    binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text == "rawValue"
                }
            }
            return false
        }

        if !hasRawValue {
            members.append("var rawValue: UInt64")
        }

        members.append(
            """
            init(rawValue: UInt64 = 0) {
                self.rawValue = rawValue
            }
            """
        )

        members.append(
            """
            init(_ rawValue: UInt64) {
                self.rawValue = rawValue
            }
            """
        )

        return members
    }
}
