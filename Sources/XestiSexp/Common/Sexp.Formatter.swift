// © 2024–2025 John Gary Pusey (see LICENSE.md)

extension Sexp {

    // MARK: Public Nested Types

    public struct Formatter {

        // MARK: Public Type Methods

        public static func format(_ sexp: Sexp,
                                  prettyPrint: Bool) -> String {
            var formatter = Self(prettyPrint: prettyPrint)

            formatter._formatDatum(sexp)

            return formatter.workBuffer
        }

        // MARK: Private Initializers

        private init(prettyPrint: Bool) {
            self.position = 0
            self.prettyPrint = prettyPrint
            self.workBuffer = ""
        }

        // MARK: Private Instance Properties

        private let prettyPrint: Bool

        private var position: Int
        private var workBuffer: String
    }
}

// MARK: -

extension Sexp.Formatter {

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

    private mutating func _formatBoolean(_ value: Bool) {
        _emit(value ? "#t" : "#f")
    }

    private mutating func _formatBytevector(_ value: [UInt8]) {
        _emit("#u8(")

        var firstDone = false

        for byte in value {
            if firstDone {
                _emit(" ")
            } else {
                firstDone = true
            }

            _emit(byte.description)
        }

        _emit(")")
    }

    private mutating func _formatCharacter(_ value: Character) {
        if ("!"..."~").contains(value) {
            _emit("#\\")
            _emit(String(value))
        } else if let name = value.sexpName {
            _emit("#\\")
            _emit(name)
        } else if let hex = value.sexpHexScalarValues.first {
            _emit("#\\x")
            _emit(hex)
        } else {
            fatalError("Internal formatter inconsistency")
        }
    }

    private mutating func _formatDatum(_ sexp: Sexp) {
        let isSimple = prettyPrint ? _complexity(sexp) < 5 : true

        switch sexp.value {
        case let .boolean(value):
            _formatBoolean(value)

        case let .bytevector(value):
            _formatBytevector(value)

        case let .character(value):
            _formatCharacter(value)

        case .null:
            _formatNull()

        case let .number(value):
            _formatNumber(value)

        case let .pair(hvalue, tvalue):
            _formatPair(hvalue, tvalue, isSimple)

        case let .string(value):
            _formatString(value)

        case let .symbol(value):
            _formatSymbol(value)

        case let .vector(value):
            _formatVector(value, isSimple)
        }
    }

    private mutating func _formatNull() {
        _emit("()")
    }

    private mutating func _formatNumber(_ value: Sexp.Number) {
        if value.isInfinite {
            _emit(value.isNegative ? "-inf.0" : "+inf.0")
        } else if value.isNaN {
            _emit("+nan.0")
        } else {
            _emit(value.description)
        }
    }

    private mutating func _formatPair(_ hvalue: Sexp,
                                      _ tvalue: Sexp,
                                      _ isSimple: Bool) {
        _emit("(")

        let pos = position

        var head = hvalue
        var tail = tvalue

        while true {
            if !isSimple {
                _indent(to: pos)
            }

            _formatDatum(head)

            switch tail.value {
            case .null:
                _emit(")")

            case let .pair(hd, tl):
                if isSimple {
                    _emit(" ")
                } else {
                    _emitln()
                }

                head = hd
                tail = tl

                continue

            default:
                _emit(" . ")
                _formatDatum(tail)
                _emit(")")
            }

            break
        }
    }

    private mutating func _formatString(_ value: String) {
        _emit("\"")

        for chr in value {
            _formatStringElement(chr)
        }

        _emit("\"")
    }

    private mutating func _formatStringElement(_ value: Character) {
        switch value {
        case "\"":
            _emit("\\\"")

        case "\\":
            _emit("\\\\")

        case " "..."~":
            _emit(String(value))

        default:
            _emit(_escape(value))
        }
    }

    private mutating func _formatSymbol(_ value: Sexp.Symbol) {
        if value.isSpecial {
            _emit("|")

            for chr in value.stringValue {
                _formatSymbolElement(chr)
            }

            _emit("|")
        } else {
            _emit(value.stringValue)
        }
    }

    private mutating func _formatSymbolElement(_ value: Character) {
        switch value {
        case "|":
            _emit("\\|")

        case "\\":
            _emit("\\\\")

        case " "..."~":
            _emit(String(value))

        default:
            _emit(_escape(value))
        }
    }

    private mutating func _formatVector(_ value: [Sexp],
                                        _ isSimple: Bool) {
        _emit("#(")

        let pos = position

        var firstDone = false

        for sexp in value {
            if !isSimple {
                _indent(to: pos)
            } else if firstDone {
                _emit(" ")
            }

            _formatDatum(sexp)

            if !isSimple {
                _emitln()
            }

            firstDone = true
        }

        _emit(")")
    }

    private mutating func _indent(to pos: Int) {
        guard pos > position
        else { return }

        _emit(String(repeating: " " as Character,
                     count: pos - position))
    }
}

// MARK: - Private Functions

private func _complexity(_ sexp: Sexp) -> Int {
    switch sexp.value {
    case .null:
        0

    case let .pair(hvalue, tvalue):
        _complexity(hvalue) + _complexity(tvalue)

    case let .vector(value):
        value.reduce(0) { $0 + _complexity($1) }

    default:
        1
    }
}

private func _escape(_ chr: Character) -> String {
    chr.sexpMnemonicEscape ?? chr.sexpHexScalarValues.map { "\\x\($0);" }.joined()
}
