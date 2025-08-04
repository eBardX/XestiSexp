// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

extension Sexp {

    // MARK: Public Nested Types

    public final class Symbol: StringRepresentable {

        // MARK: Public Initializers

        public init(_ stringValue: String) {
            self.isSpecial = _isSpecial(stringValue)
            self.stringValue = Self.requireValid(stringValue)
        }

        // MARK: Public Instance Properties

        public let isSpecial: Bool
        public let stringValue: String
    }
}

// MARK: - Hashable

extension Sexp.Symbol: Hashable {
    public func hash(into hasher: inout Hasher) {
        stringValue.hash(into: &hasher)
    }
}

// MARK: - Private Functions

private func _isSpecial(_ stringValue: String) -> Bool {
    guard stringValue.first?.isSexpSymbolHead ?? false // empty string is special
    else { return true }

    for chr in stringValue.dropFirst() where !chr.isSexpSymbolTail {
        return true
    }

    return false
}
