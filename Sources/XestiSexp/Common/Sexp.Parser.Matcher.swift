// © 2025 John Gary Pusey (see LICENSE.md)

import XestiMath
import XestiTools

extension Sexp.Parser {

    // MARK: Internal Nested Types

    internal final class Matcher {

        // MARK: Internal Initializers

        internal init(parser: Sexp.Parser,
                      tokens: [Tokenizer.Token]) {
            self.parser = parser
            self.tokenReader = TokenReader(tokens)
        }

        // MARK: Internal Instance Properties

        private let parser: Sexp.Parser

        private var tokenReader: TokenReader
    }
}

// MARK: -

extension Sexp.Parser.Matcher {

    // MARK: Internal Instance Methods

    internal func matchSexp() throws -> Sexp {
        let datum = try _matchDatum()

        guard !tokenReader.hasMore
        else { throw Sexp.Error.trailingGarbage }

        return datum
    }

    // MARK: Private Instance Methods

    private func _matchBoolean() throws -> Sexp {
        let token = try tokenReader.readMustMatch(.boolean)

        guard let cvtValue = _convertBoolean(token.value)
        else { throw Sexp.Error.invalidBoolean(token.value) }

        return Sexp(boolean: cvtValue)
    }

    private func _matchBytevector() throws -> Sexp {
        try tokenReader.readMustMatch(.byteVectorBegin)

        var cvtValues: [UInt8] = []

        while let token = tokenReader.readIfMatches(.number) {
            guard let cvtValue = _convertNumber(token.value)
            else { throw Sexp.Error.invalidNumber(token.value) }

            guard _isByte(cvtValue)
            else { throw Sexp.Error.invalidBytevectorElement(cvtValue) }

            cvtValues.append(cvtValue.uint8Value)
        }

        try tokenReader.readMustMatch(.sequenceEnd)

        return Sexp(bytevector: cvtValues)
    }

    private func _matchCharacter() throws -> Sexp {
        let token = try tokenReader.readMustMatch(.character)

        guard let cvtValue = _convertCharacter(token.value)
        else { throw Sexp.Error.invalidCharacter(token.value) }

        return Sexp(character: cvtValue)
    }

    private func _matchDatum() throws -> Sexp {
        if tokenReader.nextMatches(.boolean) {
            return try _matchBoolean()
        }

        if tokenReader.nextMatches(.byteVectorBegin),
           parser.syntax == .r7rsPartial {
            return try _matchBytevector()
        }

        if tokenReader.nextMatches(.character) {
            return try _matchCharacter()
        }

        if tokenReader.nextMatches(.number) {
            return try _matchNumber()
        }

        if tokenReader.nextMatches(.pairBegin) {
            return try _matchPairOrNull()
        }

        if tokenReader.nextMatches(.string) {
            return try _matchString()
        }

        if tokenReader.nextMatches(.symbol) {
            return try _matchSymbol()
        }

        if tokenReader.nextMatches(.vectorBegin) {
            return try _matchVector()
        }

        try tokenReader.failOnNext()

        fatalError("Bad logic!")
    }

    private func _matchNumber() throws -> Sexp {
        let token = try tokenReader.readMustMatch(.number)

        guard let cvtValue = _convertNumber(token.value)
        else { throw Sexp.Error.invalidNumber(token.value) }

        return Sexp(number: cvtValue)
    }

    private func _matchPairOrNull() throws -> Sexp {
        try tokenReader.readMustMatch(.pairBegin)

        var stack: [Sexp] = []
        var last = Sexp()

        while !tokenReader.nextMatches(.sequenceEnd) {
            if tokenReader.readIfMatches(.dot) != nil {
                last = try _matchDatum()
                break
            }

            try stack.push(_matchDatum())
        }

        try tokenReader.readMustMatch(.sequenceEnd)

        var list = last

        while let element = stack.pop() {
            list = Sexp(head: element,
                        tail: list)
        }

        return list
    }

    private func _matchString() throws -> Sexp {
        let token = try tokenReader.readMustMatch(.string)

        guard let cvtValue = _convertStringish(token.value)
        else { throw Sexp.Error.invalidString(token.value) }

        return Sexp(string: cvtValue)
    }

    private func _matchSymbol() throws -> Sexp {
        let token = try tokenReader.readMustMatch(.symbol)

        guard let cvtValue = _convertSymbol(token.value)
        else { throw Sexp.Error.invalidSymbol(token.value) }

        return Sexp(symbol: cvtValue)
    }

    private func _matchVector() throws -> Sexp {
        try tokenReader.readMustMatch(.vectorBegin)

        var elements: [Sexp] = []

        while !tokenReader.nextMatches(.sequenceEnd) {
            try elements.append(_matchDatum())
        }

        try tokenReader.readMustMatch(.sequenceEnd)

        return Sexp(vector: elements)
    }
}

// MARK: - Private Constants

private let booleanMap: [String: Bool] = ["#f": false,
                                          "#false": false,
                                          "#t": true,
                                          "#true": true]

private let characterMap: [String: Character] = ["#\\null": "\u{00}",
                                                 "#\\alarm": "\u{07}",
                                                 "#\\backspace": "\u{08}",
                                                 "#\\tab": "\u{09}",
                                                 "#\\newline": "\u{0a}",
                                                 "#\\return": "\u{0d}",
                                                 "#\\escape": "\u{1b}",
                                                 "#\\space": "\u{20}",
                                                 "#\\delete": "\u{7f}"]

// MARK: - Private Functions

private func _convertBoolean(_ value: Substring) -> Bool? {
    //
    // ⟨boolean⟩ -> #t | #f | #true | #false
    //
    booleanMap[value.lowercased()]
}

private func _convertCharacter(_ value: Substring) -> Character? {
    //
    // ⟨character⟩ -> #\ ⟨any character⟩
    //
    if value.count == 3 {
        return value.last
    }

    let lcValue = value.lowercased()

    //
    // ⟨character⟩ -> #\ ⟨character-name⟩
    //
    if let cvtValue = characterMap[lcValue] {
        return cvtValue
    }

    //
    // ⟨character⟩ -> #\x ⟨hex-digit⟩+
    //
    if lcValue.hasPrefix("#\\x") {
        return _convertHexString(String(lcValue.dropFirst(3)))
    }

    return nil
}

private func _convertEscapedCharacter(_ reader: inout SequenceReader<Substring>) -> Character? {
    guard let chr = reader.read()
    else { return nil }

    switch chr {
    case "\"", "\\", "|":
        return chr

    case "a", "A":
        return "\u{07}"

    case "b", "B":
        return "\u{08}"

    case "n", "N":
        return "\u{0a}"

    case "r", "R":
        return "\u{0d}"

    case "t", "T":
        return "\u{09}"

    case "x", "X":
        var hexStr = ""

        while let hexChr = reader.read() {
            if hexChr == ";" {
                break
            }

            hexStr.append(hexChr)
        }

        return _convertHexString(hexStr)

    default:
        return nil
    }
}

private func _convertHexString(_ hexString: String) -> Character? {
    guard let uintValue = UInt32(hexString,
                                 radix: 16),
          let scalar = Unicode.Scalar(uintValue)
    else { return nil }

    return Character(scalar)
}

private func _convertNumber(_ value: Substring) -> Sexp.Number? {
    Sexp.Number.parse(value)
}

private func _convertStringish(_ value: Substring) -> String? {
    var reader = SequenceReader<Substring>(value)

    guard let delimiter = reader.read()
    else { return nil }

    var cvtValue = ""

    while let chr = reader.read() {
        if chr == "\\" {
            guard let cvtChr = _convertEscapedCharacter(&reader)
            else { return nil }

            cvtValue.append(cvtChr)
        } else if chr != delimiter {
            cvtValue.append(chr)
        } else {
            return cvtValue
        }
    }

    return nil
}

private func _convertSymbol(_ value: Substring) -> Sexp.Symbol? {
    if value.hasPrefix("|") {
        guard let cvtValue = _convertStringish(value)
        else { return nil }

        return Sexp.Symbol(cvtValue)
    }

    let cvtValue = Sexp.Symbol(String(value))

    guard !cvtValue.isSpecial
    else { return nil }

    return cvtValue
}

private func _isByte(_ value: Sexp.Number) -> Bool {
    value.isExact && value.isInteger && !value.isNegative && value < 256
}
