// © 2024 John Gary Pusey (see LICENSE.md)

import XestiMath

extension Sexp {

    // MARK: Internal Initializers

    internal init(_ value: [Self]) {
        var result: Self = .null

        for elt in value.reversed() {
            result = .pair(elt, result)
        }

        self = result
    }

    internal init(_ value: [String: Self],
                  _ keys: [String]) {
        var result: Self = .null

        for key in keys.reversed() {
            guard let val = value[key]
            else { continue }

            result = .pair(.pair(.symbol(key), .pair(val, .null)), result)
        }

        self = result
    }

    internal init(_ value: Bool) {
        self = .boolean(value)
    }

    internal init(_ value: Real) {
        self = .number(value)
    }

    internal init(_ value: String) {
        self = .symbol(value)
    }

    // MARK: Internal Instance Properties

    internal var arrayValue: [Self]? {
        var result: [Self] = []
        var sexp = self

        while true {
            switch sexp {
            case .null:
                return result

            case let .pair(hd, tl):
                result.append(hd)

                sexp = tl

            default:
                return nil
            }
        }
    }

    internal var boolValue: Bool? {
        guard case let .boolean(val) = self
        else { return nil }

        return val
    }

    internal var dictionaryValue: ([String: Sexp], [String])? {
        var dict: [String: Self] = [:]
        var keys: [String] = []
        var sexp = self

        while true {
            switch sexp {
            case .null:
                return (dict, keys)

            case let .pair(.pair(.symbol(key), .pair(val, .null)), rest):
                dict[key] = val

                keys.append(key)

                sexp = rest

            default:
                return nil
            }
        }
    }

    internal var realValue: Real? {
        guard case let .number(val) = self
        else { return nil }

        return val
    }

    internal var stringValue: String? {
        guard case let .symbol(val) = self
        else { return nil }

        return val
    }
}
