import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

enum BitsMacroError: Error, CustomStringConvertible {
    case requiresVariable
    case invalidBitsArgument

    var description: String {
        switch self {
        case .requiresVariable:
            return "@Bits can only be applied to a variable property"
        case .invalidBitsArgument:
            return "@Bits argument must be a range (e.g., 0..<6) or bit index (e.g., 16)"
        }
    }
}

/// Macro that provides bitfield getters and setters for a register property.
public struct BitsMacro: AccessorMacro {
    /// Expands the `@Bits` macro to synthesize getter and setter accessors.
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext,
    ) throws -> [AccessorDeclSyntax] {
        guard let varDecl = declaration.as(VariableDeclSyntax.self),
            let typeSyntax = varDecl.bindings.first?.typeAnnotation?.type
        else {
            throw BitsMacroError.requiresVariable
        }

        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self),
            let firstExpr = arguments.first?.expression
        else {
            throw BitsMacroError.invalidBitsArgument
        }

        let (shift, width) = try parseBitsArgument(expr: firstExpr)

        let typeName = typeSyntax.description.trimmingCharacters(in: .whitespacesAndNewlines)
        let maskValue: UInt64 = width == 64 ? UInt64.max : ((UInt64(1) << width) - 1)
        let maskHexStr = "0x" + String(maskValue, radix: 16)

        if typeName == "Bool" {
            let getAccessor: AccessorDeclSyntax =
                """
                get {
                    rawValue >> \(raw: shift) & 1 != 0
                }
                """
            let setAccessor: AccessorDeclSyntax =
                """
                set {
                    rawValue = rawValue & ~(UInt64(1) << \(raw: shift)) | (newValue ? UInt64(1) << \(raw: shift) : 0)
                }
                """
            return [getAccessor, setAccessor]
        } else if isPrimitiveInteger(typeName) {
            let getAccessor: AccessorDeclSyntax =
                """
                get {
                    \(raw: typeName)(truncatingIfNeeded: rawValue >> \(raw: shift) & \(raw: maskHexStr))
                }
                """
            let setAccessor: AccessorDeclSyntax =
                """
                set {
                    rawValue = rawValue & ~(\(raw: maskHexStr) << \(raw: shift)) | (UInt64(truncatingIfNeeded: newValue) & \(raw: maskHexStr)) << \(raw: shift)
                }
                """
            return [getAccessor, setAccessor]
        } else {
            let getAccessor: AccessorDeclSyntax =
                """
                get {
                    \(raw: typeName)(rawValue: \(raw: typeName).RawValue(truncatingIfNeeded: rawValue >> \(raw: shift) & \(raw: maskHexStr)))!
                }
                """
            let setAccessor: AccessorDeclSyntax =
                """
                set {
                    rawValue = rawValue & ~(\(raw: maskHexStr) << \(raw: shift)) | (UInt64(truncatingIfNeeded: newValue.rawValue) & \(raw: maskHexStr)) << \(raw: shift)
                }
                """
            return [getAccessor, setAccessor]
        }
    }

    private static func parseBitsArgument(expr: ExprSyntax) throws -> (shift: Int, width: Int) {
        if let intExpr = expr.as(IntegerLiteralExprSyntax.self), let val = Int(intExpr.literal.text) {
            return (shift: val, width: 1)
        }

        if let seq = expr.as(SequenceExprSyntax.self) {
            let elements = Array(seq.elements)
            if elements.count >= 3,
                let leftInt = elements[0].as(IntegerLiteralExprSyntax.self),
                let leftVal = Int(leftInt.literal.text),
                let rightInt = elements[2].as(IntegerLiteralExprSyntax.self),
                let rightVal = Int(rightInt.literal.text)
            {
                let opText = elements[1].description.trimmingCharacters(in: .whitespacesAndNewlines)
                if opText == "..<" {
                    return (shift: leftVal, width: rightVal - leftVal)
                } else if opText == "..." {
                    return (shift: leftVal, width: rightVal - leftVal + 1)
                }
            }
        }

        if let infix = expr.as(InfixOperatorExprSyntax.self),
            let leftInt = infix.leftOperand.as(IntegerLiteralExprSyntax.self),
            let leftVal = Int(leftInt.literal.text),
            let rightInt = infix.rightOperand.as(IntegerLiteralExprSyntax.self),
            let rightVal = Int(rightInt.literal.text)
        {
            let opText = infix.operator.description.trimmingCharacters(in: .whitespacesAndNewlines)
            if opText == "..<" {
                return (shift: leftVal, width: rightVal - leftVal)
            } else if opText == "..." {
                return (shift: leftVal, width: rightVal - leftVal + 1)
            }
        }

        throw BitsMacroError.invalidBitsArgument
    }

    private static func isPrimitiveInteger(_ typeName: String) -> Bool {
        let integers: Set<String> = [
            "UInt8", "UInt16", "UInt32", "UInt64", "UInt",
            "Int8", "Int16", "Int32", "Int64", "Int",
        ]
        return integers.contains(typeName)
    }
}
