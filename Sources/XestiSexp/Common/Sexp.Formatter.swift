// © 2024–2026 John Gary Pusey (see LICENSE.md)

import XestiTools

extension Sexp {

    // MARK: Public Nested Types

    public struct Formatter {

        // MARK: Public Initializers

        public init(prettyPrint: Bool,
                    syntax: Syntax,
                    tracing: Verbosity) {
            self.prettyPrint = prettyPrint
            self.syntax = syntax
            self.tracing = tracing
        }

        // MARK: Public Instance Properties

        public let prettyPrint: Bool
        public let syntax: Syntax
        public let tracing: Verbosity

        // MARK: Public Instance Methods

        public func format(_ sexp: Sexp) throws -> String {
            var context = Self.Context()

            try _formatDatum(sexp, &context)

            return context.workBuffer
        }
    }
}

// MARK: -

extension Sexp.Formatter {

    // MARK: Private Instance Methods

    private func _formatBoolean(_ value: Bool,
                                _ context: inout Context) throws {
        context.emit(value ? "#t" : "#f")
    }

    private func _formatBytevector(_ value: [UInt8],
                                   _ context: inout Context) throws {
        guard syntax == .r7rsPartial
        else { throw Sexp.Error.formatFailed(value, syntax) }

        context.emit("#u8(")

        var firstDone = false

        for byte in value {
            if firstDone {
                context.emit(" ")
            } else {
                firstDone = true
            }

            context.emit(byte.description)
        }

        context.emit(")")
    }

    private func _formatCharacter(_ value: Character,
                                  _ context: inout Context) throws {
        switch syntax {
        case .r7rsPartial:
            if let name = value.sexpNameR7RS {
                context.emit("#\\")
                context.emit(name)
            } else if value.isSexpVisible {
                context.emit("#\\")
                context.emit(String(value))
            } else if let hex = value.sexpHexScalarValues.first {
                context.emit("#\\x")
                context.emit(hex)
            } else {
                throw Sexp.Error.formatFailed(value, syntax)
            }

        default:
            if let name = value.sexpNameR5RS {
                context.emit("#\\")
                context.emit(name)
            } else {
                guard value.isSexpVisible
                else { throw Sexp.Error.formatFailed(value, syntax) }

                context.emit("#\\")
                context.emit(String(value))
            }
        }
    }

    private func _formatDatum(_ sexp: Sexp,
                              _ context: inout Context) throws {
        let isSimple = prettyPrint ? _complexity(sexp) < 5 : true

        switch sexp.value {
        case let .boolean(value):
            try _formatBoolean(value, &context)

        case let .bytevector(value):
            try _formatBytevector(value, &context)

        case let .character(value):
            try _formatCharacter(value, &context)

        case .null:
            try _formatNull(&context)

        case let .number(value):
            try _formatNumber(value, &context)

        case let .pair(hvalue, tvalue):
            try _formatPair(hvalue, tvalue, isSimple, &context)

        case let .string(value):
            try _formatString(value, &context)

        case let .symbol(value):
            try _formatSymbol(value, &context)

        case let .vector(value):
            try _formatVector(value, isSimple, &context)
        }
    }

    private func _formatNull(_ context: inout Context) throws {
        context.emit("()")
    }

    private func _formatNumber(_ value: Sexp.Number,
                               _ context: inout Context) throws {
        switch syntax {
        case .r7rsPartial:
            if value.isInfinite {
                context.emit(value.isNegative ? "-inf.0" : "+inf.0")
            } else if value.isNaN {
                context.emit("+nan.0")
            } else {
                context.emit(value.description)
            }

        default:
            guard !value.isInfinite,
                  !value.isNaN
            else { throw Sexp.Error.formatFailed(value, syntax) }

            context.emit(value.description)
        }
    }

    private func _formatPair(_ hvalue: Sexp,
                             _ tvalue: Sexp,
                             _ isSimple: Bool,
                             _ context: inout Context) throws {
        context.emit("(")

        let pos = context.position

        var head = hvalue
        var tail = tvalue

        while true {
            if !isSimple {
                context.indent(to: pos)
            }

            try _formatDatum(head, &context)

            switch tail.value {
            case .null:
                context.emit(")")

            case let .pair(hd, tl):
                if isSimple {
                    context.emit(" ")
                } else {
                    context.emitln()
                }

                head = hd
                tail = tl

                continue

            default:
                context.emit(" . ")
                try _formatDatum(tail, &context)
                context.emit(")")
            }

            break
        }
    }

    private func _formatString(_ value: String,
                               _ context: inout Context) throws {
        context.emit("\"")

        for chr in value {
            try _formatStringElement(chr, &context)
        }

        context.emit("\"")
    }

    private func _formatStringElement(_ value: Character,
                                      _ context: inout Context) throws {
        switch value {
        case "\"":
            context.emit("\\\"")

        case "\\":
            context.emit("\\\\")

        default:
            switch syntax {
            case .r7rsPartial:
                if value.isSexpVisible {
                    context.emit(String(value))
                } else {
                    context.emit(_escape(value))
                }

            default:
                context.emit(String(value))
            }
        }
    }

    private func _formatSymbol(_ value: Sexp.Symbol,
                               _ context: inout Context) throws {
        if value.isSpecial {
            guard syntax == .r7rsPartial
            else { throw Sexp.Error.formatFailed(value, syntax) }

            context.emit("|")

            for chr in value.stringValue {
                try _formatSymbolElement(chr, &context)
            }

            context.emit("|")
        } else {
            context.emit(value.stringValue)
        }
    }

    private func _formatSymbolElement(_ value: Character,
                                      _ context: inout Context) throws {
        switch value {
        case "|":
            context.emit("\\|")

        case "\\":
            context.emit("\\\\")

        default:
            if value.isSexpVisible {
                context.emit(String(value))
            } else {
                context.emit(_escape(value))
            }
        }
    }

    private func _formatVector(_ value: [Sexp],
                               _ isSimple: Bool,
                               _ context: inout Context) throws {
        context.emit("#(")

        let pos = context.position

        var firstDone = false

        for sexp in value {
            if !isSimple {
                context.indent(to: pos)
            } else if firstDone {
                context.emit(" ")
            }

            try _formatDatum(sexp, &context)

            if !isSimple {
                context.emitln()
            }

            firstDone = true
        }

        context.emit(")")
    }
}

// MARK: - Sendable

extension Sexp.Formatter: Sendable {
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
