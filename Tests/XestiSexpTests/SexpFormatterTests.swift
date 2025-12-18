// © 2024–2025 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpFormatterTests {
}

// MARK: -

extension SexpFormatterTests {
    @Test
    func format_boolean() {
        #expect(_fmt(Sexp(boolean: true)) == "#t")
        #expect(_fmt(Sexp(boolean: false)) == "#f")
    }

    @Test
    func format_bytevector() {
        #expect(_fmt(Sexp(bytevector: [])) == "#u8()")
        #expect(_fmt(Sexp(bytevector: [255])) == "#u8(255)")
        #expect(_fmt(Sexp(bytevector: [1, 2, 3])) == "#u8(1 2 3)")
    }

    @Test
    func format_character() {
        #expect(_fmt(Sexp(character: "z")) == "#\\z")
        #expect(_fmt(Sexp(character: "\u{07}")) == "#\\alarm")
        #expect(_fmt(Sexp(character: "ø")) == "#\\xf8")
    }

    @Test
    func format_null() {
        #expect(_fmt(Sexp()) == "()")
    }

    @Test
    func format_number() {
        #expect(_fmt(Sexp(number: 3.141592)) == "3.141592")
        #expect(_fmt(Sexp(number: -12_345)) == "-12345")
        #expect(_fmt(Sexp(number: 12_345)) == "12345")
        #expect(_fmt(Sexp(number: "12345678901234567890")) == "12345678901234567890")
        #expect(_fmt(Sexp(number: "1234567/890")) == "1234567/890")
        #expect(_fmt(Sexp(number: -456e23)) == "-4.56e+25")
    }

    @Test
    func format_pair() {
        #expect(_fmt(Sexp(head: Sexp(symbol: "x"))) == "(x)")
        #expect(_fmt(Sexp(head: Sexp(symbol: "x"),
                          tail: Sexp(symbol: "y"))) == "(x . y)")
        #expect(_fmt(Sexp(head: Sexp(symbol: "x"),
                          tail: Sexp(head: Sexp(symbol: "y")))) == "(x y)")
        #expect(_fmt(Sexp(head: Sexp(symbol: "x"),
                          tail: Sexp(head: Sexp(symbol: "y"),
                                     tail: Sexp(symbol: "z")))) == "(x y . z)")
        #expect(_fmt(Sexp(head: Sexp(symbol: "x"),
                          tail: Sexp(head: Sexp(symbol: "y"),
                                     tail: Sexp(head: Sexp(symbol: "z"))))) == "(x y z)")
    }

    @Test
    func format_string() {
        #expect(_fmt(Sexp(string: "Bilbo")) == "\"Bilbo\"")
        #expect(_fmt(Sexp(string: "Bilbo Baggins")) == "\"Bilbo Baggins\"")
        #expect(_fmt(Sexp(string: "Bilbo \"Bäggins\"")) == "\"Bilbo \\\"B\\xe4;ggins\\\"\"")
    }

    @Test
    func format_symbol() {
        #expect(_fmt(Sexp(symbol: "Frodo")) == "Frodo")
        #expect(_fmt(Sexp(symbol: "Frodo Baggins")) == "|Frodo Baggins|")
        #expect(_fmt(Sexp(symbol: "Frodo | \"Bäggins\"")) == "|Frodo \\| \"B\\xe4;ggins\"|")
    }

    @Test
    func format_vector() {
        #expect(_fmt(Sexp(vector: [Sexp(symbol: "x"),
                                   Sexp()])) == "#(x ())")
        #expect(_fmt(Sexp(vector: [Sexp(symbol: "x"),
                                   Sexp(symbol: "y")])) == "#(x y)")
        #expect(_fmt(Sexp(vector: [Sexp(symbol: "x"),
                                   Sexp(head: Sexp(symbol: "y"))])) == "#(x (y))")
        #expect(_fmt(Sexp(vector: [Sexp(symbol: "x"),
                                   Sexp(head: Sexp(symbol: "y"),
                                        tail: Sexp(symbol: "z"))])) == "#(x (y . z))")
        #expect(_fmt(Sexp(vector: [Sexp(symbol: "x"),
                                   Sexp(vector: [Sexp(symbol: "y"),
                                                 Sexp(head: Sexp(symbol: "z"))])])) == "#(x #(y (z)))")
    }
}

// MARK: -

extension SexpFormatterTests {
    private func _fmt(_ sexp: Sexp) -> String {
        Sexp.Formatter.format(sexp,
                              prettyPrint: false)
    }
}
