// © 2024–2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpParserR5RSTests {
}

// MARK: -

extension SexpParserR5RSTests {
    @Test
    func test_parse_boolean() throws {
        #expect(try _prs("#f") == Sexp(boolean: false))
        #expect(throws: (any Error).self) { try _prs("#false") }
        #expect(try _prs("#t") == Sexp(boolean: true))
        #expect(throws: (any Error).self) { try _prs("#true") }
    }

    @Test
    func test_parse_bytevector() throws {
        #expect(throws: (any Error).self) { try _prs("#u8()") }
        #expect(throws: (any Error).self) { try _prs("#u8(255)") }
        #expect(throws: (any Error).self) { try _prs("#u8(123 45 6)") }
    }

    @Test
    func test_parse_character() throws {
        #expect(try _prs("#\\z") == Sexp(character: "z"))
        #expect(throws: (any Error).self) { try _prs("#\\alarm") }
        #expect(try _prs("#\\newline") == Sexp(character: "\n"))
        #expect(try _prs("#\\space") == Sexp(character: " "))
        #expect(throws: (any Error).self) { try _prs("#\\xf8") }
    }

    @Test
    func test_parse_null() throws {
        #expect(try _prs("()") == Sexp())
        #expect(try _prs("  (  )     ") == Sexp())
        #expect(try _prs("""
                       (
                       )
                       """) == Sexp())
        #expect(try _prs("""
                       (    ; this is an empty list
                       )
                       """) == Sexp())
    }

    @Test
    func test_parse_number() throws {
        #expect(try _prs("3.141592") == Sexp(number: 3.141592))
        #expect(try _prs("-12345") == Sexp(number: -12_345))
        #expect(try _prs("+12345") == Sexp(number: 12_345))
        #expect(try _prs("12345678901234567890") == Sexp(number: "12345678901234567890"))
        #expect(try _prs("1234567/890") == Sexp(number: "1234567/890"))
        #expect(try _prs("-456e+23") == Sexp(number: -456e23))
        #expect(throws: (any Error).self) { try _prs("-inf.0") }
        #expect(throws: (any Error).self) { try _prs("+inf.0") }
        #expect(throws: (any Error).self) { try _prs("-nan.0") }
        #expect(throws: (any Error).self) { try _prs("+nan.0") }
    }

    @Test
    func test_parse_pair() throws {
        #expect(try _prs("(x . ())") == Sexp(head: Sexp(symbol: "x")))
        #expect(try _prs("(x)") == Sexp(head: Sexp(symbol: "x")))
        #expect(try _prs("(x . y)") == Sexp(head: Sexp(symbol: "x"),
                                            tail: Sexp(symbol: "y")))
        #expect(try _prs("(x y)") == Sexp(head: Sexp(symbol: "x"),
                                          tail: Sexp(head: Sexp(symbol: "y"))))
        #expect(try _prs("(x y . z)") == Sexp(head: Sexp(symbol: "x"),
                                              tail: Sexp(head: Sexp(symbol: "y"),
                                                         tail: Sexp(symbol: "z"))))
        #expect(try _prs("(x y z)") == Sexp(head: Sexp(symbol: "x"),
                                            tail: Sexp(head: Sexp(symbol: "y"),
                                                       tail: Sexp(head: Sexp(symbol: "z")))))
    }

    @Test
    func test_parse_string() throws {
        #expect(try _prs("\"Bilbo\"") == Sexp(string: "Bilbo"))
        #expect(try _prs("\"Bilbo Baggins\"") == Sexp(string: "Bilbo Baggins"))
        #expect(throws: (any Error).self) { try _prs("\"Bilbo \\\"B\\xe4;ggins\\\"\"") }
    }

    @Test
    func test_parse_symbol() throws {
        #expect(try _prs("Frodo") == Sexp(symbol: "Frodo"))
        #expect(throws: (any Error).self) { try _prs("|Frodo Baggins|") }
        #expect(throws: (any Error).self) { try _prs("|Frodo \\| \"B\\xe4;ggins\"|") }
    }

    @Test
    func test_parse_vector() throws {
        #expect(try _prs("#(x ())") == Sexp(vector: [Sexp(symbol: "x"),
                                                     Sexp()]))
        #expect(try _prs("#(x y)") == Sexp(vector: [Sexp(symbol: "x"),
                                                    Sexp(symbol: "y")]))
        #expect(try _prs("#(x (y))") == Sexp(vector: [Sexp(symbol: "x"),
                                                      Sexp(head: Sexp(symbol: "y"))]))
        #expect(try _prs("#(x (y . z))") == Sexp(vector: [Sexp(symbol: "x"),
                                                          Sexp(head: Sexp(symbol: "y"),
                                                               tail: Sexp(symbol: "z"))]))
        #expect(try _prs("#(x #(y (z)))") == Sexp(vector: [Sexp(symbol: "x"),
                                                           Sexp(vector: [Sexp(symbol: "y"),
                                                                         Sexp(head: Sexp(symbol: "z"))])]))
    }
}

// MARK: -

extension SexpParserR5RSTests {
    private func _prs(_ text: String) throws -> Sexp {
        try Sexp.Parser(syntax: .r5rs,
                        tracing: .silent).parse(input: text)
    }
}
