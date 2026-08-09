// © 2024–2026 John Gary Pusey (see LICENSE.md)

import Testing
import XestiNumbers
@testable import XestiSexp
import XestiTools

struct SexpParserTests {
}

// MARK: -

extension SexpParserTests {
    @Test
    func parse_boolean_r5rs() throws {
        #expect(try prs5("#f") == Sexp(boolean: false))
        #expect(throws: (any Error).self) { try prs5("#false") }
        #expect(try prs5("#t") == Sexp(boolean: true))
        #expect(throws: (any Error).self) { try prs5("#true") }
    }

    @Test
    func parse_boolean_r7rs() throws {
        #expect(try prs7("#f") == Sexp(boolean: false))
        #expect(try prs7("#false") == Sexp(boolean: false))
        #expect(try prs7("#t") == Sexp(boolean: true))
        #expect(try prs7("#true") == Sexp(boolean: true))
    }

    @Test
    func parse_bytevector_r5rs() throws {
        #expect(throws: (any Error).self) { try prs5("#u8()") }
        #expect(throws: (any Error).self) { try prs5("#u8(255)") }
        #expect(throws: (any Error).self) { try prs5("#u8(123 45 6)") }
    }

    @Test
    func parse_bytevector_r7rs() throws {
        #expect(try prs7("#u8()") == Sexp(bytevector: []))
        #expect(try prs7("#u8(255)") == Sexp(bytevector: [255]))
        #expect(try prs7("#u8(123 45 6)") == Sexp(bytevector: [123, 45, 6]))
    }

    @Test
    func parse_character_r5rs() throws {
        #expect(try prs5("#\\z") == Sexp(character: "z"))
        #expect(throws: (any Error).self) { try prs5("#\\alarm") }
        #expect(try prs5("#\\newline") == Sexp(character: "\n"))
        #expect(try prs5("#\\space") == Sexp(character: " "))
        #expect(throws: (any Error).self) { try prs5("#\\xf8") }
    }

    @Test
    func parse_character_r7rs() throws {
        #expect(try prs7("#\\z") == Sexp(character: "z"))
        #expect(try prs7("#\\alarm") == Sexp(character: "\u{07}"))
        #expect(try prs7("#\\newline") == Sexp(character: "\n"))
        #expect(try prs7("#\\space") == Sexp(character: " "))
        #expect(try prs7("#\\xf8") == Sexp(character: "ø"))
    }

    @Test
    func parse_null_r5rs() throws {
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
    func parse_null_r7rs() throws {
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
    func parse_number_r5rs() throws {
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
    func parse_number_r7rs() throws {
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
    func parse_pair_r5rs() throws {
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
    func parse_pair_r7rs() throws {
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
    func parse_string_r5rs() throws {
        #expect(try prs5("\"\"") == Sexp(string: ""))
        #expect(try prs5("\"Bilbo\"") == Sexp(string: "Bilbo"))
        #expect(try prs5("\"Bilbo Baggins\"") == Sexp(string: "Bilbo Baggins"))
        #expect(throws: (any Error).self) { try prs5("\"Bilbo \\\"B\\xe4;ggins\\\"\"") }
    }

    @Test
    func parse_string_r7rs() throws {
        #expect(try prs7("\"\"") == Sexp(string: ""))
        #expect(try prs7("\"Bilbo\"") == Sexp(string: "Bilbo"))
        #expect(try prs7("\"Bilbo Baggins\"") == Sexp(string: "Bilbo Baggins"))
        #expect(try prs7("\"Bilbo \\\"B\\xe4;ggins\\\"\"") == Sexp(string: "Bilbo \"Bäggins\""))
    }

    @Test
    func parse_symbol_r5rs() throws {
        #expect(throws: (any Error).self) { try prs5("||") }
        #expect(try prs5("Frodo") == Sexp(symbol: "Frodo"))
        #expect(throws: (any Error).self) { try prs5("|Frodo Baggins|") }
        #expect(throws: (any Error).self) { try prs5("|Frodo \\| \"B\\xe4;ggins\"|") }
    }

    @Test
    func parse_symbol_r7rs() throws {
        #expect(try prs7("||") == Sexp(symbol: ""))
        #expect(try prs7("Frodo") == Sexp(symbol: "Frodo"))
        #expect(try prs7("|Frodo Baggins|") == Sexp(symbol: "Frodo Baggins"))
        #expect(try prs7("|Frodo \\| \"B\\xe4;ggins\"|") == Sexp(symbol: "Frodo | \"Bäggins\""))
    }

    @Test
    func parse_vector_r5rs() throws {
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

    @Test
    func parse_vector_r7rs() throws {
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
