import SwiftSyntax
private import SwiftSyntaxBuilder
import SwiftSyntaxMacros

#if canImport(SwiftCompilerPlugin)
    private import SwiftCompilerPlugin
#endif

struct VectorTableMacro {}

extension VectorTableMacro: DeclarationMacro {
    static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext,
    ) throws(MacroError) -> [DeclSyntax] {
        let arguments = node.arguments
        guard arguments.count == 16 else {
            throw MacroError.invalidArgumentCount
        }

        let entries = arguments.lazy
            .map(\.expression.trimmed.description)
            .map { "(0x5800_0050, 0xd61f_0200, \($0), [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])" }

        return [
            """
            private typealias VectorEntry = (
                UInt32,  // ldr x16, #8
                UInt32,  // br x16
                @convention(c) () -> Void,  // handler
                [14 of UInt64]  // padding
            )
            """,
            """
            @section(".vectors")
            @used
            nonisolated(unsafe) private var vectorTable: [16 of VectorEntry] = [
                \(raw: entries.joined(separator: ",\n    "))
            ]
            """,
        ]
    }
}

enum MacroError: Error {
    case invalidArgumentCount
}

extension MacroError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidArgumentCount: "#vectorTable requires exactly 16 exception handlers"
        }
    }
}

#if canImport(SwiftCompilerPlugin)
    @main
    struct KernelMacrosPlugin {}

    extension KernelMacrosPlugin: CompilerPlugin {
        var providingMacros: [any Macro.Type] { [VectorTableMacro.self] }
    }
#endif
