// © 2024–2025 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpParserR7RSTests {
}

// MARK: -

extension SexpParserR7RSTests {
    @Test
    func parse_boolean() throws {
        #expect(try _prs("#f") == Sexp(boolean: false))
        #expect(try _prs("#false") == Sexp(boolean: false))
        #expect(try _prs("#t") == Sexp(boolean: true))
        #expect(try _prs("#true") == Sexp(boolean: true))
    }

    @Test
    func parse_bytevector() throws {
        #expect(try _prs("#u8()") == Sexp(bytevector: []))
        #expect(try _prs("#u8(255)") == Sexp(bytevector: [255]))
        #expect(try _prs("#u8(123 45 6)") == Sexp(bytevector: [123, 45, 6]))
    }

    @Test
    func parse_character() throws {
        #expect(try _prs("#\\z") == Sexp(character: "z"))
        #expect(try _prs("#\\alarm") == Sexp(character: "\u{07}"))
        #expect(try _prs("#\\newline") == Sexp(character: "\n"))
        #expect(try _prs("#\\space") == Sexp(character: " "))
        #expect(try _prs("#\\xf8") == Sexp(character: "ø"))
    }

    @Test
    func parse_null() throws {
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
    func parse_number() throws {
        #expect(try _prs("3.141592") == Sexp(number: 3.141592))
        #expect(try _prs("-12345") == Sexp(number: -12_345))
        #expect(try _prs("+12345") == Sexp(number: 12_345))
        #expect(try _prs("12345678901234567890") == Sexp(number: "12345678901234567890"))
        #expect(try _prs("1234567/890") == Sexp(number: "1234567/890"))
        #expect(try _prs("-456e+23") == Sexp(number: -456e23))
        #expect(try _prs("-inf.0") == Sexp(number: .negativeInfinity))
        #expect(try _prs("+inf.0") == Sexp(number: .positiveInfinity))
        #expect(try _prs("-nan.0") == Sexp(number: .nan))
        #expect(try _prs("+nan.0") == Sexp(number: .nan))
    }

    @Test
    func parse_pair() throws {
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
    func parse_string() throws {
        #expect(try _prs("\"Bilbo\"") == Sexp(string: "Bilbo"))
        #expect(try _prs("\"Bilbo Baggins\"") == Sexp(string: "Bilbo Baggins"))
        #expect(try _prs("\"Bilbo \\\"B\\xe4;ggins\\\"\"") == Sexp(string: "Bilbo \"Bäggins\""))
    }

    @Test
    func parse_symbol() throws {
        #expect(try _prs("Frodo") == Sexp(symbol: "Frodo"))
        #expect(try _prs("|Frodo Baggins|") == Sexp(symbol: "Frodo Baggins"))
        #expect(try _prs("|Frodo \\| \"B\\xe4;ggins\"|") == Sexp(symbol: "Frodo | \"Bäggins\""))
    }

    @Test
    func parse_vector() throws {
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

extension SexpParserR7RSTests {
    private func _prs(_ text: String) throws -> Sexp {
        try Sexp.Parser(syntax: .r7rsPartial,
                        tracing: .silent).parse(input: text)
    }
}
