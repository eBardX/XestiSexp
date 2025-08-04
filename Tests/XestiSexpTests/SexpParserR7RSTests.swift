// © 2024–2025 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpParserR7RSTests {
}

// MARK: -

extension SexpParserR7RSTests {
    @Test
    func parse_boolean() throws {
        try _testParse("#f", Sexp(boolean: false))
        try _testParse("#false", Sexp(boolean: false))
        try _testParse("#t", Sexp(boolean: true))
        try _testParse("#true", Sexp(boolean: true))
    }

    @Test
    func parse_bytevector() throws {
        try _testParse("#u8()", Sexp(bytevector: []))
        try _testParse("#u8(255)", Sexp(bytevector: [255]))
        try _testParse("#u8(123 45 6)", Sexp(bytevector: [123, 45, 6]))
    }

    @Test
    func parse_character() throws {
        try _testParse("#\\z", Sexp(character: "z"))
        try _testParse("#\\alarm", Sexp(character: "\u{07}"))
        try _testParse("#\\newline", Sexp(character: "\n"))
        try _testParse("#\\space", Sexp(character: " "))
        try _testParse("#\\xf8", Sexp(character: "ø"))
    }

    @Test
    func parse_null() throws {
        try _testParse("()", Sexp())
        try _testParse("  (  )     ", Sexp())
        try _testParse("""
                       (
                       )
                       """, Sexp())
        try _testParse("""
                       (    ; this is an empty list
                       )
                       """, Sexp())
    }

    @Test
    func parse_number() throws {
        try _testParse("3.141592", Sexp(number: 3.141592))
        try _testParse("-12345", Sexp(number: -12_345))
        try _testParse("+12345", Sexp(number: 12_345))
        try _testParse("12345678901234567890", Sexp(number: "12345678901234567890"))
        try _testParse("1234567/890", Sexp(number: "1234567/890"))
        try _testParse("-456e+23", Sexp(number: -456e23))
        try _testParse("-inf.0", Sexp(number: .negativeInfinity))
        try _testParse("+inf.0", Sexp(number: .positiveInfinity))
        try _testParse("-nan.0", Sexp(number: .nan))
        try _testParse("+nan.0", Sexp(number: .nan))
    }

    @Test
    func parse_pair() throws {
        try _testParse("(x . ())", Sexp(head: Sexp(symbol: "x")))
        try _testParse("(x)", Sexp(head: Sexp(symbol: "x")))
        try _testParse("(x . y)", Sexp(head: Sexp(symbol: "x"),
                                       tail: Sexp(symbol: "y")))
        try _testParse("(x y)", Sexp(head: Sexp(symbol: "x"),
                                     tail: Sexp(head: Sexp(symbol: "y"))))
        try _testParse("(x y . z)", Sexp(head: Sexp(symbol: "x"),
                                         tail: Sexp(head: Sexp(symbol: "y"),
                                                    tail: Sexp(symbol: "z"))))
        try _testParse("(x y z)", Sexp(head: Sexp(symbol: "x"),
                                       tail: Sexp(head: Sexp(symbol: "y"),
                                                  tail: Sexp(head: Sexp(symbol: "z")))))
    }

    @Test
    func parse_string() throws {
        try _testParse("\"Bilbo\"", Sexp(string: "Bilbo"))
        try _testParse("\"Bilbo Baggins\"", Sexp(string: "Bilbo Baggins"))
        try _testParse("\"Bilbo \\\"B\\xe4;ggins\\\"\"", Sexp(string: "Bilbo \"Bäggins\""))
    }

    @Test
    func parse_symbol() throws {
        try _testParse("Frodo", Sexp(symbol: "Frodo"))
//        try _testParse("|Frodo Baggins|", Sexp(symbol: "Frodo Baggins"))
//        try _testParse("|Frodo \\| \"B\\xe4;ggins\"|", Sexp(symbol: "Frodo | \"Bäggins\""))
    }

    @Test
    func parse_vector() throws {
        try _testParse("#(x ())", Sexp(vector: [Sexp(symbol: "x"),
                                                Sexp()]))
        try _testParse("#(x y)", Sexp(vector: [Sexp(symbol: "x"),
                                               Sexp(symbol: "y")]))
        try _testParse("#(x (y))", Sexp(vector: [Sexp(symbol: "x"),
                                                 Sexp(head: Sexp(symbol: "y"))]))
        try _testParse("#(x (y . z))", Sexp(vector: [Sexp(symbol: "x"),
                                                     Sexp(head: Sexp(symbol: "y"),
                                                          tail: Sexp(symbol: "z"))]))
        try _testParse("#(x #(y (z)))", Sexp(vector: [Sexp(symbol: "x"),
                                                      Sexp(vector: [Sexp(symbol: "y"),
                                                                    Sexp(head: Sexp(symbol: "z"))])]))
    }
}

// MARK: -

extension SexpParserR7RSTests {
    private func _testParse(_ text: String,
                            _ expectedSexp: Sexp) throws {
        let actualSexp = try Sexp.Parser(syntax: .r7rsPartial,
                                         tracing: .quiet).parse(input: text)

        if let anumval = actualSexp.numberValue,
           let enumval = expectedSexp.numberValue {
            #expect(anumval.isNaN == enumval.isNaN || anumval == enumval)
        } else {
            #expect(actualSexp == expectedSexp)
        }
    }

    private func _testParseError(_ text: String) throws {
        #expect(throws: (any Error).self) {
            try Sexp.Parser(syntax: .r7rsPartial,
                            tracing: .quiet).parse(input: text)
        }
    }
}
