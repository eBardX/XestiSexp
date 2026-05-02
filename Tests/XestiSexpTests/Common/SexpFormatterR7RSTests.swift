// © 2024–2026 John Gary Pusey (see LICENSE.md)

import Testing
import XestiNumbers
@testable import XestiSexp
import XestiTools

struct SexpFormatterR7RSTests {
}

// MARK: -

extension SexpFormatterR7RSTests {
    @Test
    func test_format_boolean() throws {
        #expect(try fmt7(Sexp(boolean: true)) == "#t")
        #expect(try fmt7(Sexp(boolean: false)) == "#f")
    }

    @Test
    func test_format_bytevector() throws {
        #expect(try fmt7(Sexp(bytevector: [])) == "#u8()")
        #expect(try fmt7(Sexp(bytevector: [255])) == "#u8(255)")
        #expect(try fmt7(Sexp(bytevector: [1, 2, 3])) == "#u8(1 2 3)")
    }

    @Test
    func test_format_character() throws {
        #expect(try fmt7(Sexp(character: "z")) == "#\\z")
        #expect(try fmt7(Sexp(character: "\u{07}")) == "#\\alarm")
        #expect(try fmt7(Sexp(character: "\u{0a}")) == "#\\newline")
        #expect(try fmt7(Sexp(character: "\u{a0}")) == "#\\xa0")
        #expect(try fmt7(Sexp(character: "ø")) == "#\\ø")
    }

    @Test
    func test_format_null() throws {
        #expect(try fmt7(Sexp()) == "()")
    }

    @Test
    func test_format_number() throws {
        #expect(try fmt7(Sexp(number: 3.141592)) == "3.141592")
        #expect(try fmt7(Sexp(number: -12_345)) == "-12345")
        #expect(try fmt7(Sexp(number: 12_345)) == "12345")
        #expect(try fmt7(Sexp(number: "12345678901234567890")) == "12345678901234567890")
        #expect(try fmt7(Sexp(number: "1234567/890")) == "1234567/890")
        #expect(try fmt7(Sexp(number: -456e23)) == "-4.56e+25")
    }

    @Test
    func test_format_pair() throws {
        #expect(try fmt7(Sexp(head: Sexp(symbol: "x"))) == "(x)")
        #expect(try fmt7(Sexp(head: Sexp(symbol: "x"),
                              tail: Sexp(symbol: "y"))) == "(x . y)")
        #expect(try fmt7(Sexp(head: Sexp(symbol: "x"),
                              tail: Sexp(head: Sexp(symbol: "y")))) == "(x y)")
        #expect(try fmt7(Sexp(head: Sexp(symbol: "x"),
                              tail: Sexp(head: Sexp(symbol: "y"),
                                         tail: Sexp(symbol: "z")))) == "(x y . z)")
        #expect(try fmt7(Sexp(head: Sexp(symbol: "x"),
                              tail: Sexp(head: Sexp(symbol: "y"),
                                         tail: Sexp(head: Sexp(symbol: "z"))))) == "(x y z)")
    }

    @Test
    func test_format_string() throws {
        #expect(try fmt7(Sexp(string: "")) == "\"\"")
        #expect(try fmt7(Sexp(string: "Bilbo")) == "\"Bilbo\"")
        #expect(try fmt7(Sexp(string: "Bilbo Baggins")) == "\"Bilbo Baggins\"")
        #expect(try fmt7(Sexp(string: "Bilbo \"Bäggins\"")) == "\"Bilbo \\\"Bäggins\\\"\"")
    }

    @Test
    func test_format_symbol() throws {
        #expect(try fmt7(Sexp(symbol: "")) == "||")
        #expect(try fmt7(Sexp(symbol: "Frodo")) == "Frodo")
        #expect(try fmt7(Sexp(symbol: "Frodo Baggins")) == "|Frodo Baggins|")
        #expect(try fmt7(Sexp(symbol: "Frodo | \"Bäggins\"")) == "|Frodo \\| \"Bäggins\"|")
    }

    @Test
    func test_format_vector() throws {
        #expect(try fmt7(Sexp(vector: [])) == "#()")
        #expect(try fmt7(Sexp(vector: [Sexp(symbol: "x"),
                                       Sexp()])) == "#(x ())")
        #expect(try fmt7(Sexp(vector: [Sexp(symbol: "x"),
                                       Sexp(symbol: "y")])) == "#(x y)")
        #expect(try fmt7(Sexp(vector: [Sexp(symbol: "x"),
                                       Sexp(head: Sexp(symbol: "y"))])) == "#(x (y))")
        #expect(try fmt7(Sexp(vector: [Sexp(symbol: "x"),
                                       Sexp(head: Sexp(symbol: "y"),
                                            tail: Sexp(symbol: "z"))])) == "#(x (y . z))")
        #expect(try fmt7(Sexp(vector: [Sexp(symbol: "x"),
                                       Sexp(vector: [Sexp(symbol: "y"),
                                                     Sexp(head: Sexp(symbol: "z"))])])) == "#(x #(y (z)))")
    }
}
