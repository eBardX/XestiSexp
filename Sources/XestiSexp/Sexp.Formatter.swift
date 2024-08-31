// © 2024 John Gary Pusey (see LICENSE.md)

import XestiMath

extension Sexp {

    // MARK: Internal Nested Types

    internal struct Formatter {

        // MARK: Private Instance Properties

        private let prettyPrint: Bool

        private var position: Int
        private var workBuffer: String
    }
}

// MARK: -

extension Sexp.Formatter {

    // MARK: Internal Type Methods

    internal static func format(_ sexp: Sexp,
                                prettyPrint: Bool) -> String {
        var formatter = Self(prettyPrint: prettyPrint)

        return formatter.format(sexp)
    }

    // MARK: Internal Initializers

    internal init(prettyPrint: Bool) {
        self.position = 0
        self.prettyPrint = prettyPrint
        self.workBuffer = ""
    }

    // MARK: Internal Instance Methods

    internal mutating func format(_ sexp: Sexp) -> String {
        position = 0
        workBuffer = ""

        if prettyPrint {
            _formatPretty(sexp)
        } else {
            _formatCompact(sexp)
        }

        return workBuffer
    }

    // MARK: Private Type Methods

    private static func _complexity(_ sexp: Sexp) -> Int {
        switch sexp {
        case .null:
            return 0

        case let .pair(hd, tl):
            return _complexity(hd) + _complexity(tl)

        default:
            return 1
        }
    }

    private static func _escapeString(_ value: String) -> String {
        var result = ""

        for ch in value {
            switch ch {
            case "\"":
                result += "\\\""

            case "\\":
                result += "\\\\"

            default:
                result.append(ch)
            }
        }

        return result
    }

    private static func _escapeSymbol(_ value: String) -> String {
        var result = ""

        for ch in value {
            switch ch {
            case "|":
                result += "\\|"

            case "\\":
                result += "\\\\"

            default:
                result.append(ch)
            }
        }

        return result
    }

    private static func _formatBoolean(_ value: Bool) -> String {
        value ? "#t" : "#f"
    }

    private static func _formatNull() -> String {
        "()"
    }

    private static func _formatNumber(_ value: Real) -> String {
        if value.isInfinite {
            return value.isNegative ? "-inf.0" : "+inf.0"
        }

        if value.isNaN {
            return "+nan.0"
        }

        return value.description
    }

    private static func _formatSymbol(_ value: String) -> String {
        guard !_isIdentifier(value)
        else { return value }

        return "|" + _escapeSymbol(value) + "|"
    }

    private static func _isIdentifier(_ value: String) -> Bool {
        guard value.first?.isSexpSymbolHead ?? false    // empty string is _not_ an identifier
        else { return false }

        for chr in value.dropFirst() where !chr.isSexpSymbolTail {
            return false
        }

        return true
    }

    // MARK: Private Instance Methods

    private mutating func _emit(_ string: String) {
        workBuffer.append(string)

        position += string.count
    }

    private mutating func _emitln(_ string: String? = nil) {
        if let string {
            workBuffer.append(string)
        }

        workBuffer.append("\n")

        position = 0
    }

    private mutating func _formatCompact(_ head: Sexp,
                                         _ tail: Sexp) {
        _emit("(")

        var head = head
        var tail = tail

        while true {
            _formatCompact(head)

            switch tail {
            case .null:
                _emit(")")
                return

            case let .pair(hd, tl):
                _emit(" ")

                head = hd
                tail = tl

            default:
                _emit(" . ")
                _formatCompact(tail)
                _emit(")")
                return
            }
        }
    }

    private mutating func _formatCompact(_ sexp: Sexp) {
        switch sexp {
        case let .boolean(val):
            _emit(Self._formatBoolean(val))

        case .null:
            _emit(Self._formatNull())

        case let .number(val):
            _emit(Self._formatNumber(val))

        case let .pair(hd, tl):
            _formatCompact(hd, tl)

        case let .symbol(val):
            _emit(Self._formatSymbol(val))
        }
    }

    private mutating func _formatPretty(_ head: Sexp,
                                        _ tail: Sexp,
                                        _ simple: Bool) {
        _emit("(")

        let pos = position

        var head = head
        var tail = tail

        while true {
            if !simple {
                _indent(to: pos)
            }

            _formatPretty(head)

            switch tail {
            case .null:
                _emit(")")
                return

            case let .pair(hd, tl):
                if simple {
                    _emit(" ")
                } else {
                    _emitln()
                }

                head = hd
                tail = tl

            default:
                _emit(" . ")
                _formatPretty(tail)
                _emit(")")
                return
            }
        }
    }

    private mutating func _formatPretty(_ sexp: Sexp) {
        switch sexp {
        case let .boolean(val):
            _emit(Self._formatBoolean(val))

        case .null:
            _emit(Self._formatNull())

        case let .number(val):
            _emit(Self._formatNumber(val))

        case let .pair(hd, tl):
            let hdc = Self._complexity(hd)
            let tdc = Self._complexity(tl)

            _formatPretty(hd,
                          tl,
                          (hdc + tdc) < 5)

        case let .symbol(val):
            _emit(Self._formatSymbol(val))
        }
    }

    private mutating func _indent(to pos: Int) {
        guard pos > position
        else { return }

        _emit(String(repeating: " " as Character,
                     count: pos - position))
    }
}
