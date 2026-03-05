// © 2024–2026 John Gary Pusey (see LICENSE.md)

import XestiTools

extension Sexp {

    // MARK: Public Nested Types

    public enum Error {
        case formatFailed(any Sendable, Syntax)
        case invalidBoolean(Substring)
        case invalidBytevectorElement(Sexp.Number)
        case invalidCharacter(Substring)
        case invalidNumber(Substring)
        case invalidString(Substring)
        case invalidSymbol(Substring)
        case trailingGarbage
    }
}

// MARK: - EnhancedError

extension Sexp.Error: EnhancedError {
    public var message: String {
        switch self {
        case let .formatFailed(value, syntax):
            "Failed to format value in \(syntax) syntax: \(value)"

        case let .invalidBoolean(value):
            "Invalid boolean: \(value)"

        case let .invalidBytevectorElement(element):
            "Invalid bytevector element: \(element)"

        case let .invalidCharacter(value):
            "Invalid character: \(value)"

        case let .invalidNumber(value):
            "Invalid number: \(value)"

        case let .invalidString(value):
            "Invalid string: \(value)"

        case let .invalidSymbol(value):
            "Invalid symbol: \(value)"

        case .trailingGarbage:
            "Input contains trailing garbage"
        }
    }
}

// MARK: - Sendable

extension Sexp.Error: Sendable {
}
