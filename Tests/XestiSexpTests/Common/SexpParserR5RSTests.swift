// © 2024–2026 John Gary Pusey (see LICENSE.md)

import Testing
import XestiMath
@testable import XestiSexp
import XestiTools

struct SexpParserR5RSTests {
}

// MARK: -

extension SexpParserR5RSTests {
    @Test
    func test_parse_boolean() throws {
        #expect(try prs5("#f") == Sexp(boolean: false))
        #expect(throws: (any Error).self) { try prs5("#false") }
        #expect(try prs5("#t") == Sexp(boolean: true))
        #expect(throws: (any Error).self) { try prs5("#true") }
    }

    @Test
    func test_parse_bytevector() throws {
        #expect(throws: (any Error).self) { try prs5("#u8()") }
        #expect(throws: (any Error).self) { try prs5("#u8(255)") }
        #expect(throws: (any Error).self) { try prs5("#u8(123 45 6)") }
    }

    @Test
    func test_parse_character() throws {
        #expect(try prs5("#\\z") == Sexp(character: "z"))
        #expect(throws: (any Error).self) { try prs5("#\\alarm") }
        #expect(try prs5("#\\newline") == Sexp(character: "\n"))
        #expect(try prs5("#\\space") == Sexp(character: " "))
        #expect(throws: (any Error).self) { try prs5("#\\xf8") }
    }

    @Test
    func test_parse_null() throws {
        #expect(try prs5("()") == Sexp())
        #expect(try prs5("  (  )     ") == Sexp())
        #expect(try prs5("""
                       (
                       )
                       """) == Sexp())
        #expect(try prs5("""
                       (    ; this is an empty list
                       )
                       """) == Sexp())
    }

    @Test
    func test_parse_number() throws {
        #expect(try prs5("3.141592") == Sexp(number: 3.141592))
        #expect(try prs5("-12345") == Sexp(number: -12_345))
        #expect(try prs5("+12345") == Sexp(number: 12_345))
        #expect(try prs5("12345678901234567890") == Sexp(number: "12345678901234567890"))
        #expect(try prs5("1234567/890") == Sexp(number: "1234567/890"))
        #expect(try prs5("-456e+23") == Sexp(number: -456e23))
        #expect(throws: (any Error).self) { try prs5("-inf.0") }
        #expect(throws: (any Error).self) { try prs5("+inf.0") }
        #expect(throws: (any Error).self) { try prs5("-nan.0") }
        #expect(throws: (any Error).self) { try prs5("+nan.0") }
    }

    @Test
    func test_parse_pair() throws {
        #expect(try prs5("(x . ())") == Sexp(head: Sexp(symbol: "x")))
        #expect(try prs5("(x)") == Sexp(head: Sexp(symbol: "x")))
        #expect(try prs5("(x . y)") == Sexp(head: Sexp(symbol: "x"),
                                            tail: Sexp(symbol: "y")))
        #expect(try prs5("(x y)") == Sexp(head: Sexp(symbol: "x"),
                                          tail: Sexp(head: Sexp(symbol: "y"))))
        #expect(try prs5("(x y . z)") == Sexp(head: Sexp(symbol: "x"),
                                              tail: Sexp(head: Sexp(symbol: "y"),
                                                         tail: Sexp(symbol: "z"))))
        #expect(try prs5("(x y z)") == Sexp(head: Sexp(symbol: "x"),
                                            tail: Sexp(head: Sexp(symbol: "y"),
                                                       tail: Sexp(head: Sexp(symbol: "z")))))
    }

    @Test
    func test_parse_string() throws {
        #expect(try prs5("\"\"") == Sexp(string: ""))
        #expect(try prs5("\"Bilbo\"") == Sexp(string: "Bilbo"))
        #expect(try prs5("\"Bilbo Baggins\"") == Sexp(string: "Bilbo Baggins"))
        #expect(throws: (any Error).self) { try prs5("\"Bilbo \\\"B\\xe4;ggins\\\"\"") }
    }

    @Test
    func test_parse_symbol() throws {
        #expect(throws: (any Error).self) { try prs5("||") }
        #expect(try prs5("Frodo") == Sexp(symbol: "Frodo"))
        #expect(throws: (any Error).self) { try prs5("|Frodo Baggins|") }
        #expect(throws: (any Error).self) { try prs5("|Frodo \\| \"B\\xe4;ggins\"|") }
    }

    @Test
    func test_parse_vector() throws {
        #expect(try prs5("#()") == Sexp(vector: []))
        #expect(try prs5("#(x ())") == Sexp(vector: [Sexp(symbol: "x"),
                                                     Sexp()]))
        #expect(try prs5("#(x y)") == Sexp(vector: [Sexp(symbol: "x"),
                                                    Sexp(symbol: "y")]))
        #expect(try prs5("#(x (y))") == Sexp(vector: [Sexp(symbol: "x"),
                                                      Sexp(head: Sexp(symbol: "y"))]))
        #expect(try prs5("#(x (y . z))") == Sexp(vector: [Sexp(symbol: "x"),
                                                          Sexp(head: Sexp(symbol: "y"),
                                                               tail: Sexp(symbol: "z"))]))
        #expect(try prs5("#(x #(y (z)))") == Sexp(vector: [Sexp(symbol: "x"),
                                                           Sexp(vector: [Sexp(symbol: "y"),
                                                                         Sexp(head: Sexp(symbol: "z"))])]))
    }
}
