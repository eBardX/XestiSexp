// © 2024 John Gary Pusey (see LICENSE.md)

import XestiMath
import XestiTools

extension Sexp {

    // MARK: Internal Nested Types

    internal struct Parser {

        // MARK: Private Instance Properties

        private let string: String

        private var index: String.Index
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
        self.index = string.startIndex
        self.string = string
    }

    // MARK: Internal Instance Methods

    internal mutating func parse() throws -> Sexp {
        _skipWhitespace()

        let sexp = try _parseExpression()

        _skipWhitespace()

        guard isAtEnd
        else { throw Sexp.Error.badExpression }

        return sexp
    }

    // MARK: Private Instance Properties

    private var isAtEnd: Bool {
        index == string.endIndex
    }

    // MARK: Private Instance Methods

    private mutating func _parseExpression() throws -> Sexp {
        guard let chr = _peekChar()
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
        precondition(_scanChar() == "(",
                     "Internal parser inconsistency")

        var stack: [Sexp] = []
        var tail: Sexp = .null

        _skipWhitespace()

    loop:
        while let chr = _peekChar() {
            switch chr {
            case ".":
                _skipChar()
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

        guard _scanChar() == ")"
        else { throw Sexp.Error.badList }

        var list = tail

        while let elt = stack.pop() {
            list = .pair(elt, list)
        }

        return list
    }

    private mutating func _parseNumber() throws -> Sexp {
        // what about +inf.0, -inf.0, +nan.0, -nan.0 ???

        guard let headChar = _scanChar(),
              headChar.isSexpNumberHead
        else { preconditionFailure("Internal parser inconsistency") }

        var buffer = String(headChar)

        while let tailChar = _peekChar() {
            if tailChar.isSexpDelimiter {
                break
            }

            if !tailChar.isSexpNumberTail {
                throw Sexp.Error.badChar(tailChar) // .illegalNumberChar ???
            }

            _skipChar()

            buffer.append(tailChar)
        }

        if let value = Real(buffer) {
            return .number(value)
        }

        throw Sexp.Error.badNumber(buffer)
    }

    private mutating func _parseSpecial() throws -> Sexp {
        precondition(_scanChar() == "#",
                     "Internal parser inconsistency")

        guard let chr = _scanChar()
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
        precondition(_scanChar() == "|",
                     "Internal parser inconsistency")

        var buffer = ""

        while let chr = _scanChar() {
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
        guard let headChar = _scanChar(),
              headChar.isSexpSymbolHead
        else { preconditionFailure("Internal parser inconsistency") }

        var buffer = String(headChar)

        while let tailChar = _peekChar() {
            if tailChar.isSexpDelimiter {
                break
            }

            if !tailChar.isSexpSymbolTail {
                throw Sexp.Error.badChar(tailChar)
            }

            _skipChar()

            buffer.append(tailChar)
        }

        return .symbol(buffer)
    }

    private func _peekChar() -> Character? {
        guard index < string.endIndex
        else { return nil }

        return string[index]
    }

    private mutating func _scanChar() -> Character? {
        guard index < string.endIndex
        else { return nil }

        defer { index = string.index(after: index) }

        return string[index]
    }

    private mutating func _scanEscapedChar() throws -> Character {
        guard let chr = _peekChar()
        else { throw Sexp.Error.endOfString }

        switch chr {
        case "\"", "\\", "|":
            _skipChar()

            return chr

        default:
            break
        }

        throw Sexp.Error.badEscape
    }

    private mutating func _skipChar() {
        guard index < string.endIndex
        else { return }

        index = string.index(after: index)
    }

    private mutating func _skipWhitespace() {
        var inComment = false

        while let chr = _peekChar() {
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

            _skipChar()
        }
    }
}
