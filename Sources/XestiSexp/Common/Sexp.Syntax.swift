// © 2025 John Gary Pusey (see LICENSE.md)

extension Sexp {

    // MARK: Public Nested Types

    public enum Syntax {
        case r5rs
        case r7rsPartial
    }
}

// MARK: - Sendable

extension Sexp.Syntax: Sendable {
}
