// © 2024 John Gary Pusey (see LICENSE.md)

import XestiMath
import XestiTools

extension Sexp {

    // MARK: Internal Nested Types

    internal struct Parser {

        // MARK: Private Instance Properties

        private var reader: StringReader
    }
}

// MARK: -

extension Sexp.Parser {

    // MARK: Internal Type Methods

    internal static func parse(_ string: String) throws -> Sexp {
        var parser = Self(string)

        return try parser.parse()
    }

    // MARK: Internal Initializers

    internal init(_ string: String) {
        self.reader = .init(string)
    }

    // MARK: Internal Instance Methods

    internal mutating func parse() throws -> Sexp {
        _skipWhitespace()

        let sexp = try _parseExpression()

        _skipWhitespace()

        guard !reader.hasMore
        else { throw Sexp.Error.badExpression }

        return sexp
    }

    // MARK: Private Instance Methods

    private mutating func _parseExpression() throws -> Sexp {
        guard let chr = reader.peek()
        else { throw Sexp.Error.endOfString }

        switch chr {
        case "(":
            return try _parseList()

        case "#":
            return try _parseSpecial()

        case "|":
            return try _parseSymbolQuoted()

        default:
            if chr.isSexpNumberHead {
                return try _parseNumber()
            }

            if chr.isSexpSymbolHead {
                return try _parseSymbolUnquoted()
            }

            throw Sexp.Error.badChar(chr)
        }
    }

    private mutating func _parseList() throws -> Sexp {
        precondition(reader.read() == "(",
                     "Internal parser inconsistency")

        var stack: [Sexp] = []
        var tail: Sexp = .null

        _skipWhitespace()

    loop:
        while let chr = reader.peek() {
            switch chr {
            case ".":
                reader.skip()
                _skipWhitespace()

                tail = try _parseExpression()

                _skipWhitespace()
                break loop

            case ")":
                break loop

            default:
                try stack.push(_parseExpression())

                _skipWhitespace()
            }
        }

        guard reader.read() == ")"
        else { throw Sexp.Error.badList }

        var list = tail

        while let elt = stack.pop() {
            list = .pair(elt, list)
        }

        return list
    }

    private mutating func _parseNumber() throws -> Sexp {
        // what about +inf.0, -inf.0, +nan.0, -nan.0 ???

        guard let headChar = reader.read(),
              headChar.isSexpNumberHead
        else { preconditionFailure("Internal parser inconsistency") }

        var buffer = String(headChar)

        while let tailChar = reader.peek() {
            if tailChar.isSexpDelimiter {
                break
            }

            if !tailChar.isSexpNumberTail {
                throw Sexp.Error.badChar(tailChar) // .illegalNumberChar ???
            }

            reader.skip()

            buffer.append(tailChar)
        }

        if let value = Real(buffer) {
            return .number(value)
        }

        throw Sexp.Error.badNumber(buffer)
    }

    private mutating func _parseSpecial() throws -> Sexp {
        precondition(reader.read() == "#",
                     "Internal parser inconsistency")

        guard let chr = reader.read()
        else { throw Sexp.Error.endOfString }

        switch chr {
        case "f", "F":
            return .boolean(false)

        case "t", "T":
            return .boolean(true)

        default:
            throw Sexp.Error.badChar(chr)
        }
    }

    private mutating func _parseSymbolQuoted() throws -> Sexp {
        precondition(reader.read() == "|",
                     "Internal parser inconsistency")

        var buffer = ""

        while let chr = reader.read() {
            switch chr {
            case "\\":
                try buffer.append(_scanEscapedChar())

            case "|":
                return .symbol(buffer)

            default:
                buffer.append(chr)
            }
        }

        throw Sexp.Error.endOfString
    }

    private mutating func _parseSymbolUnquoted() throws -> Sexp {
        guard let headChar = reader.read(),
              headChar.isSexpSymbolHead
        else { preconditionFailure("Internal parser inconsistency") }

        var buffer = String(headChar)

        while let tailChar = reader.peek() {
            if tailChar.isSexpDelimiter {
                break
            }

            if !tailChar.isSexpSymbolTail {
                throw Sexp.Error.badChar(tailChar)
            }

            reader.skip()

            buffer.append(tailChar)
        }

        return .symbol(buffer)
    }

    private mutating func _scanEscapedChar() throws -> Character {
        guard let chr = reader.peek()
        else { throw Sexp.Error.endOfString }

        switch chr {
        case "\"", "\\", "|":
            reader.skip()

            return chr

        default:
            break
        }

        throw Sexp.Error.badEscape
    }

    private mutating func _skipWhitespace() {
        var inComment = false

        while let chr = reader.peek() {
            switch chr {
            case ";":
                if !inComment {
                    inComment = true
                }

            case "\n":
                if inComment {
                    inComment = false
                }

            default:
                if chr.isSexpWhitespace {
                    break
                }

                if !inComment {
                    return
                }
            }

            reader.skip()
        }
    }
}
