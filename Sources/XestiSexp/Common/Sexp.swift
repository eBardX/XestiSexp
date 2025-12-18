// © 2024–2025 John Gary Pusey (see LICENSE.md)

public struct Sexp {

    // MARK: Public Initializers

    public init() {
        self.value = .null
    }

    public init(boolean value: Bool) {
        self.value = .boolean(value)
    }

    public init(bytevector value: [UInt8]) {
        self.value = .bytevector(value)
    }

    public init(character value: Character) {
        self.value = .character(value)
    }

    public init(head hdValue: Self,
                tail tlValue: Self? = nil) {
        self.value = .pair(hdValue,
                           tlValue ?? Self())
    }

    public init(number value: Number) {
        self.value = .number(value)
    }

    public init(string value: String) {
        self.value = .string(value)
    }

    public init(symbol value: Symbol) {
        self.value = .symbol(value)
    }

    public init(vector value: [Self]) {
        self.value = .vector(value)
    }

    // MARK: Public Instance Properties

    public var booleanValue: Bool? {
        guard case let .boolean(rawValue) = value
        else { return nil }

        return rawValue
    }

    public var bytevectorValue: [UInt8]? {
        guard case let .bytevector(rawValue) = value
        else { return nil }

        return rawValue
    }

    public var characterValue: Character? {
        guard case let .character(rawValue) = value
        else { return nil }

        return rawValue
    }

    public var isNullValue: Bool {
        switch value {
        case .null:
            true

        default:
            false
        }
    }

    public var numberValue: Number? {
        guard case let .number(rawValue) = value
        else { return nil }

        return rawValue
    }

    public var pairValue: (Self, Self?)? {
        guard case let .pair(hdValue, tlValue) = value
        else { return nil }

        return (hdValue,
                tlValue.isNullValue ? nil : tlValue)
    }

    public var stringValue: String? {
        guard case let .string(rawValue) = value
        else { return nil }

        return rawValue
    }

    public var symbolValue: Symbol? {
        guard case let .symbol(rawValue) = value
        else { return nil }

        return rawValue
    }

    public var vectorValue: [Self]? {
        guard case let .vector(rawValue) = value
        else { return nil }

        return rawValue
    }

    // MARK: Internal Initializers

    internal init(dictionaryValue: [String: Self],
                  dictionaryKeys: [String]) {
        self.value = .vector(dictionaryKeys.compactMap {
            if let sexpValue = dictionaryValue[$0] {
                return Self(head: Self(symbol: Symbol($0)),
                            tail: sexpValue)
            } else {
                return nil
            }
        })
    }

    // MARK: Internal Instance Properties

    internal let value: Value

    internal var dictionaryValue: ([String: Self], [String])? {
        var dict: [String: Self] = [:]
        var keys: [String] = []

        guard case let .vector(sexpValues) = value
        else { return nil }

        for sexpValue in sexpValues {
            switch sexpValue.value {
            case let .pair(sexpKey, value):
                switch sexpKey.value {
                case let .symbol(key):
                    dict[key.stringValue] = value

                    keys.append(key.stringValue)

                default:
                    return nil
                }

            default:
                return nil
            }
        }

        return (dict, keys)
    }
}

// MARK: - CustomStringConvertible

extension Sexp: CustomStringConvertible {
    public var description: String {
        switch value {
        case let .boolean(value):
            "boolean(\(value))"

        case let .bytevector(value):
            "bytevector(\(value))"

        case let .character(value):
            "character(\(value))"

        case .null:
            "null"

        case let .number(value):
            "number(\(value))"

        case let .pair(hval, tval):
            "pair(\(hval),\(tval))"

        case let .string(value):
            "string(\(value))"

        case let .symbol(value):
            "symbol(\(value))"

        case let .vector(value):
            "vector(\(value))"
        }
    }
}

// MARK: - Equatable

extension Sexp: Equatable {
    public static func == (lhs: Self,
                           rhs: Self) -> Bool {
        switch (lhs.value, rhs.value) {
        case let (.boolean(lvalue), .boolean(rvalue)):
            lvalue == rvalue

        case let (.bytevector(lvalue), .bytevector(rvalue)):
            lvalue == rvalue

        case let (.character(lvalue), .character(rvalue)):
            lvalue == rvalue

        case (.null, .null):
            true

        case let (.number(lvalue), .number(rvalue)):
            lvalue.isNaN == rvalue.isNaN || lvalue == rvalue

        case let (.pair(lhval, ltval), .pair(rhval, rtval)):
            lhval == rhval && ltval == rtval

        case let (.string(lvalue), .string(rvalue)):
            lvalue == rvalue

        case let (.symbol(lvalue), .symbol(rvalue)):
            lvalue == rvalue

        case let (.vector(lvalue), .vector(rvalue)):
            lvalue == rvalue

        default:
            false
        }
    }
}
