// © 2024–2026 John Gary Pusey (see LICENSE.md)

import Testing
import XestiMath
@testable import XestiSexp
import XestiTools

struct SexpParserR7RSTests {
}

// MARK: -

extension SexpParserR7RSTests {
    @Test
    func test_parse_boolean() throws {
        #expect(try prs7("#f") == Sexp(boolean: false))
        #expect(try prs7("#false") == Sexp(boolean: false))
        #expect(try prs7("#t") == Sexp(boolean: true))
        #expect(try prs7("#true") == Sexp(boolean: true))
    }

    @Test
    func test_parse_bytevector() throws {
        #expect(try prs7("#u8()") == Sexp(bytevector: []))
        #expect(try prs7("#u8(255)") == Sexp(bytevector: [255]))
        #expect(try prs7("#u8(123 45 6)") == Sexp(bytevector: [123, 45, 6]))
    }

    @Test
    func test_parse_character() throws {
        #expect(try prs7("#\\z") == Sexp(character: "z"))
        #expect(try prs7("#\\alarm") == Sexp(character: "\u{07}"))
        #expect(try prs7("#\\newline") == Sexp(character: "\n"))
        #expect(try prs7("#\\space") == Sexp(character: " "))
        #expect(try prs7("#\\xf8") == Sexp(character: "ø"))
    }

    @Test
    func test_parse_null() throws {
        #expect(try prs7("()") == Sexp())
        #expect(try prs7("  (  )     ") == Sexp())
        #expect(try prs7("""
                       (
                       )
                       """) == Sexp())
        #expect(try prs7("""
                       (    ; this is an empty list
                       )
                       """) == Sexp())
    }

    @Test
    func test_parse_number() throws {
        #expect(try prs7("3.141592") == Sexp(number: 3.141592))
        #expect(try prs7("-12345") == Sexp(number: -12_345))
        #expect(try prs7("+12345") == Sexp(number: 12_345))
        #expect(try prs7("12345678901234567890") == Sexp(number: "12345678901234567890"))
        #expect(try prs7("1234567/890") == Sexp(number: "1234567/890"))
        #expect(try prs7("-456e+23") == Sexp(number: -456e23))
        #expect(try prs7("-inf.0") == Sexp(number: .negativeInfinity))
        #expect(try prs7("+inf.0") == Sexp(number: .positiveInfinity))
        #expect(try prs7("-nan.0") == Sexp(number: .nan))
        #expect(try prs7("+nan.0") == Sexp(number: .nan))
    }

    @Test
    func test_parse_pair() throws {
        #expect(try prs7("(x . ())") == Sexp(head: Sexp(symbol: "x")))
        #expect(try prs7("(x)") == Sexp(head: Sexp(symbol: "x")))
        #expect(try prs7("(x . y)") == Sexp(head: Sexp(symbol: "x"),
                                            tail: Sexp(symbol: "y")))
        #expect(try prs7("(x y)") == Sexp(head: Sexp(symbol: "x"),
                                          tail: Sexp(head: Sexp(symbol: "y"))))
        #expect(try prs7("(x y . z)") == Sexp(head: Sexp(symbol: "x"),
                                              tail: Sexp(head: Sexp(symbol: "y"),
                                                         tail: Sexp(symbol: "z"))))
        #expect(try prs7("(x y z)") == Sexp(head: Sexp(symbol: "x"),
                                            tail: Sexp(head: Sexp(symbol: "y"),
                                                       tail: Sexp(head: Sexp(symbol: "z")))))
    }

    @Test
    func test_parse_string() throws {
        #expect(try prs7("\"\"") == Sexp(string: ""))
        #expect(try prs7("\"Bilbo\"") == Sexp(string: "Bilbo"))
        #expect(try prs7("\"Bilbo Baggins\"") == Sexp(string: "Bilbo Baggins"))
        #expect(try prs7("\"Bilbo \\\"B\\xe4;ggins\\\"\"") == Sexp(string: "Bilbo \"Bäggins\""))
    }

    @Test
    func test_parse_symbol() throws {
        #expect(try prs7("||") == Sexp(symbol: ""))
        #expect(try prs7("Frodo") == Sexp(symbol: "Frodo"))
        #expect(try prs7("|Frodo Baggins|") == Sexp(symbol: "Frodo Baggins"))
        #expect(try prs7("|Frodo \\| \"B\\xe4;ggins\"|") == Sexp(symbol: "Frodo | \"Bäggins\""))
    }

    @Test
    func test_parse_vector() throws {
        #expect(try prs7("#()") == Sexp(vector: []))
        #expect(try prs7("#(x ())") == Sexp(vector: [Sexp(symbol: "x"),
                                                     Sexp()]))
        #expect(try prs7("#(x y)") == Sexp(vector: [Sexp(symbol: "x"),
                                                    Sexp(symbol: "y")]))
        #expect(try prs7("#(x (y))") == Sexp(vector: [Sexp(symbol: "x"),
                                                      Sexp(head: Sexp(symbol: "y"))]))
        #expect(try prs7("#(x (y . z))") == Sexp(vector: [Sexp(symbol: "x"),
                                                          Sexp(head: Sexp(symbol: "y"),
                                                               tail: Sexp(symbol: "z"))]))
        #expect(try prs7("#(x #(y (z)))") == Sexp(vector: [Sexp(symbol: "x"),
                                                           Sexp(vector: [Sexp(symbol: "y"),
                                                                         Sexp(head: Sexp(symbol: "z"))])]))
    }
}
