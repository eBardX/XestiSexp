// © 2025—2026 John Gary Pusey (see LICENSE.md)

import XestiTools

extension Sexp {

    // MARK: Public Nested Types

    public struct Symbol: StringRepresentable {

        // MARK: Public Initializers

        public init(_ stringValue: String) {
            self.init(stringValue,
                      Self.isSpecial(stringValue))
        }

        // MARK: Public Instance Properties

        public let isSpecial: Bool
        public let stringValue: String

        // MARK: Internal Initializers

        internal init(_ stringValue: String,
                      _ isSpecial: Bool) {
            self.isSpecial = isSpecial
            self.stringValue = Self.requireValid(stringValue)
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
