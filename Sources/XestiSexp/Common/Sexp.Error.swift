// © 2024–2026 John Gary Pusey (see LICENSE.md)

import XestiTools

extension Sexp {

    // MARK: Public Nested Types

    /// An error that occurs while parsing or formatting an S-expression.
    public enum Error {
        /// A value that is not representable in the requested syntax standard
        /// was encountered while formatting an S-expression.
        ///
        /// As associated values, this case contains the unrepresentable value,
        /// as well as the syntax standard.
        ///
        /// For example, in the ``Sexp/Syntax/r7rsPartial`` syntax standard, a
        /// bytevector can be formatted  as `#u8(…)`. However, in the
        /// ``Sexp/Syntax/r5rs`` syntax standard, bytevectors are not supported
        /// and therefore cannot be successfully formatted.
        case formatFailed(any Sendable, Syntax)

        /// An invalid boolean was encountered while parsing an S-expression.
        ///
        /// As an associated value, this case contains the substring comprising
        /// the invalid boolean.
        case invalidBoolean(Substring)

        /// An invalid bytevector element was encountered while parsing an
        /// S-expression.
        ///
        /// As an associated value, this case contains the substring comprising
        /// the invalid bytevector element.
        case invalidBytevectorElement(Sexp.Number)

        /// An invalid character was encountered while parsing an S-expression.
        ///
        /// As an associated value, this case contains the substring comprising
        /// the invalid character.
        case invalidCharacter(Substring)

        /// An invalid number was encountered while parsing an S-expression.
        ///
        /// As an associated value, this case contains the substring comprising
        /// the invalid numbe.
        case invalidNumber(Substring)

        /// An invalid string was encountered while parsing an S-expression.
        ///
        /// As an associated value, this case contains the substring comprising
        /// the invalid string.
        case invalidString(Substring)

        /// An invalid symbol was encountered while parsing an S-expression.
        ///
        /// As an associated value, this case contains the substring comprising
        /// the invalid symbol.
        case invalidSymbol(Substring)

        /// Trailing garbage was encountered while parsing an S-expression.
        ///
        /// Any text following a valid S-expression that is not whitespace and
        /// is not a comment is considered to be “trailing garbage” by the
        /// parser.
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
