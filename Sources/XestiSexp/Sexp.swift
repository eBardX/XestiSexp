// © 2024 John Gary Pusey (see LICENSE.md)

import XestiMath

public indirect enum Sexp {
    case boolean(Bool)
    case null
    case number(Real)
    case pair(Self, Self)
    case symbol(String)
}

// MARK: - CustomStringConvertible

extension Sexp: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .boolean(val):
            return "boolean(\(val))"

        case .null:
            return "null"

        case let .number(val):
            return "number(\(val))"

        case let .pair(val1, val2):
            return "pair(\(val1),\(val2))"

        case let .symbol(val):
            return "symbol(\(val))"
        }
    }
}

// MARK: - Equatable

extension Sexp: Equatable {
    public static func == (lhs: Self,
                           rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.boolean(lval), .boolean(rval)):
            return lval == rval

        case (.null, .null):
            return true

        case let (.number(lval), .number(rval)):
            return lval == rval

        case let (.pair(lval1, lval2), .pair(rval1, rval2)):
            return lval1 == rval1 && lval2 == rval2

        case let (.symbol(lval), .symbol(rval)):
            return lval == rval

        default:
            return false
        }
    }
}
