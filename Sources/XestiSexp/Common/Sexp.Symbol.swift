// © 2025—2026 John Gary Pusey (see LICENSE.md)

import XestiTools

extension Sexp {

    // MARK: Public Nested Types

    /// An S-expression symbol value.
    public struct Symbol: StringRepresentable {

        // MARK: Public Type Methods

        /// Determines if the provided string value is a valid representation
        /// for a symbol value.
        ///
        /// - Parameter stringValue:    The string value to check for validity.
        ///
        /// - Returns:  `true` when the provided string value is a valid
        ///             representation for a symbol value; `false` otherwise.
        public static func isValid(_ stringValue: String) -> Bool {
            true
        }

        // MARK: Public Initializers

        /// Creates a new symbol value with the provided string value.
        ///
        /// If the provided string value is determined to be invalid, this
        /// initializer returns `nil`.
        ///
        /// - Parameter stringValue:    The string value to use for the new
        ///                             symbol value.
        public init?(stringValue: String) {
            guard Self.isValid(stringValue)
            else { return nil }

            self.init(stringValue,
                      Self.isSpecial(stringValue))
        }

        // MARK: Public Instance Properties

        /// A Boolean value indicating whether this symbol value contains any
        /// special characters in its string value.
        public let isSpecial: Bool

        /// The string value that represents this symbol value.
        public let stringValue: String

        // MARK: Internal Initializers

        internal init(_ stringValue: String,
                      _ isSpecial: Bool) {
            self.isSpecial = isSpecial
            self.stringValue = stringValue
        }
    }
}

// MARK: -

extension Sexp.Symbol {

    // MARK: Internal Type Methods

    internal static func isSpecial(_ stringValue: String) -> Bool {
        guard stringValue.first?.isSexpSymbolHead ?? false // empty string is special
        else { return true }

        for chr in stringValue.dropFirst() where !chr.isSexpSymbolTail {
            return true
        }

        return false
    }
}

// MARK: - Hashable

extension Sexp.Symbol: Hashable {
    public func hash(into hasher: inout Hasher) {
        stringValue.hash(into: &hasher)
    }
}

// MARK: - Sendable

extension Sexp.Symbol: Sendable {
}
