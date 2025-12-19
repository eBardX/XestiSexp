// © 2025 John Gary Pusey (see LICENSE.md)

extension Sexp {

    // MARK: Internal Nested Types

    internal indirect enum Value {
        case boolean(Bool)
        case bytevector([UInt8])
        case character(Character)
        case null
        case number(Number)
        case pair(Sexp, Sexp)
        case string(String)
        case symbol(Symbol)
        case vector([Sexp])
    }
}

// MARK: - Sendable

extension Sexp.Value: Sendable {
}
