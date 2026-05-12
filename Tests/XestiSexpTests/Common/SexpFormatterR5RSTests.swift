// © 2024–2026 John Gary Pusey (see LICENSE.md)

import Testing
import XestiNumbers
@testable import XestiSexp
import XestiTools

struct SexpFormatterR5RSTests {
}

// MARK: -

extension SexpFormatterR5RSTests {
    @Test
    func format_boolean() throws {
        #expect(try fmt5(Sexp(boolean: true)) == "#t")
        #expect(try fmt5(Sexp(boolean: false)) == "#f")
    }

    @Test
    func format_bytevector() throws {
        #expect(throws: (any Error).self) { try fmt5(Sexp(bytevector: [])) }
        #expect(throws: (any Error).self) { try fmt5(Sexp(bytevector: [255])) }
        #expect(throws: (any Error).self) { try fmt5(Sexp(bytevector: [1, 2, 3])) }
    }

    @Test
    func format_character() throws {
        #expect(try fmt5(Sexp(character: "z")) == "#\\z")
        #expect(throws: (any Error).self) { try fmt5(Sexp(character: "\u{07}")) }
        #expect(try fmt5(Sexp(character: "\u{0a}")) == "#\\newline")
        #expect(throws: (any Error).self) { try fmt5(Sexp(character: "\u{a0}")) }
        #expect(try fmt5(Sexp(character: "ø")) == "#\\ø")
    }

    @Test
    func format_null() throws {
        #expect(try fmt5(Sexp()) == "()")
    }

    @Test
    func format_number() throws {
        #expect(try fmt5(Sexp(number: 3.141592)) == "3.141592")
        #expect(try fmt5(Sexp(number: -12_345)) == "-12345")
        #expect(try fmt5(Sexp(number: 12_345)) == "12345")
        #expect(try fmt5(Sexp(number: "12345678901234567890")) == "12345678901234567890")
        #expect(try fmt5(Sexp(number: "1234567/890")) == "1234567/890")
        #expect(try fmt5(Sexp(number: -456e23)) == "-4.56e+25")
    }

    @Test
    func format_pair() throws {
        #expect(try fmt5(Sexp(head: Sexp(symbol: "x"))) == "(x)")
        #expect(try fmt5(Sexp(head: Sexp(symbol: "x"),
                              tail: Sexp(symbol: "y"))) == "(x . y)")
        #expect(try fmt5(Sexp(head: Sexp(symbol: "x"),
                              tail: Sexp(head: Sexp(symbol: "y")))) == "(x y)")
        #expect(try fmt5(Sexp(head: Sexp(symbol: "x"),
                              tail: Sexp(head: Sexp(symbol: "y"),
                                         tail: Sexp(symbol: "z")))) == "(x y . z)")
        #expect(try fmt5(Sexp(head: Sexp(symbol: "x"),
                              tail: Sexp(head: Sexp(symbol: "y"),
                                         tail: Sexp(head: Sexp(symbol: "z"))))) == "(x y z)")
    }

    @Test
    func format_string() throws {
        #expect(try fmt5(Sexp(string: "")) == "\"\"")
        #expect(try fmt5(Sexp(string: "Bilbo")) == "\"Bilbo\"")
        #expect(try fmt5(Sexp(string: "Bilbo Baggins")) == "\"Bilbo Baggins\"")
        #expect(try fmt5(Sexp(string: "Bilbo \"Bäggins\"")) == "\"Bilbo \\\"Bäggins\\\"\"")
    }

    @Test
    func format_symbol() throws {
        #expect(throws: (any Error).self) { try fmt5(Sexp(symbol: "")) }
        #expect(try fmt5(Sexp(symbol: "Frodo")) == "Frodo")
        #expect(throws: (any Error).self) { try fmt5(Sexp(symbol: "Frodo Baggins")) }
        #expect(throws: (any Error).self) { try fmt5(Sexp(symbol: "Frodo | \"Bäggins\"")) }
    }

    @Test
    func format_vector() throws {
        #expect(try fmt5(Sexp(vector: [])) == "#()")
        #expect(try fmt5(Sexp(vector: [Sexp(symbol: "x"),
                                       Sexp()])) == "#(x ())")
        #expect(try fmt5(Sexp(vector: [Sexp(symbol: "x"),
                                       Sexp(symbol: "y")])) == "#(x y)")
        #expect(try fmt5(Sexp(vector: [Sexp(symbol: "x"),
                                       Sexp(head: Sexp(symbol: "y"))])) == "#(x (y))")
        #expect(try fmt5(Sexp(vector: [Sexp(symbol: "x"),
                                       Sexp(head: Sexp(symbol: "y"),
                                            tail: Sexp(symbol: "z"))])) == "#(x (y . z))")
        #expect(try fmt5(Sexp(vector: [Sexp(symbol: "x"),
                                       Sexp(vector: [Sexp(symbol: "y"),
                                                     Sexp(head: Sexp(symbol: "z"))])])) == "#(x #(y (z)))")
    }
}
