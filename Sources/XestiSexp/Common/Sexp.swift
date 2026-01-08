// © 2024–2026 John Gary Pusey (see LICENSE.md)

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

    internal init(array: [Self]) {
        var list = Self()

        for element in array.reversed() {
            list = Self(head: element,
                        tail: list)
        }

        self = list
    }

    internal init(dictionary: [String: Self],
                  orderedKeys: [String]) {
        let pairs = orderedKeys.compactMap {
            if let sexpValue = dictionary[$0] {
                if Symbol.isSpecial($0) {
                    Self(head: Self(string: $0),
                         tail: Self(head: sexpValue))
                } else {
                    Self(head: Self(symbol: Symbol($0, false)),
                         tail: Self(head: sexpValue))
                }
            } else {
                nil
            }
        }

        self = Self(array: pairs)
    }

    // MARK: Internal Instance Properties

    internal let value: Value

    internal var arrayValue: [Self]? {
        var array: [Self] = []

        var sexp = self

    loop:
        while true {
            switch sexp.value {
            case .null:
                break loop

            case let .pair(head, tail):
                array.append(head)

                sexp = tail

            default:
                return nil
            }
        }

        return array
    }

    internal var dictionaryValue: ([String: Self], [String])? {
        var dict: [String: Self] = [:]
        var keys: [String] = []

        guard let pairs = arrayValue
        else { return nil }

        for pair in pairs {
            guard let (key, value) = Self._extractKeyValue(pair)
            else { return nil }

            dict[key] = value

            keys.append(key)
        }

        return (dict, keys)
    }

    // MARK: Private Instance Methods

    private static func _extractKeyValue(_ sexp: Self) -> (String, Self)? {
        switch sexp.value {
        case let .pair(head, tail):
            guard let key = _extractKey(head),
                  let value = _extractValue(tail)
            else { return nil }

            return (key, value)

        default:
            return nil
        }
    }

    private static func _extractKey(_ sexp: Self) -> String? {
        switch sexp.value {
        case let .string(key):
            key

        case let .symbol(key):
            key.stringValue

        default:
            nil
        }
    }

    private static func _extractValue(_ sexp: Self) -> Self? {
        switch sexp.value {
        case let .pair(head, tail) where tail.isNullValue:
            head

        default:
            nil
        }
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

// MARK: - Sendable

extension Sexp: Sendable {
}
