// © 2024–2025 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpFormatterTests {
}

// MARK: -

extension SexpFormatterTests {
    @Test
    func format_boolean() {
        _testFormat(Sexp(boolean: true), "#t")
        _testFormat(Sexp(boolean: false), "#f")
    }

    @Test
    func format_bytevector() {
        _testFormat(Sexp(bytevector: []), "#u8()")
        _testFormat(Sexp(bytevector: [255]), "#u8(255)")
        _testFormat(Sexp(bytevector: [1, 2, 3]), "#u8(1 2 3)")
    }

    @Test
    func format_character() {
        _testFormat(Sexp(character: "z"), "#\\z")
        _testFormat(Sexp(character: "\u{07}"), "#\\alarm")
        _testFormat(Sexp(character: "ø"), "#\\xf8")
    }

    @Test
    func format_null() {
        _testFormat(Sexp(), "()")
    }

    @Test
    func format_number() {
        _testFormat(Sexp(number: 3.141592), "3.141592")
        _testFormat(Sexp(number: -12_345), "-12345")
        _testFormat(Sexp(number: 12_345), "12345")
        _testFormat(Sexp(number: "12345678901234567890"), "12345678901234567890")
        _testFormat(Sexp(number: "1234567/890"), "1234567/890")
        _testFormat(Sexp(number: -456e23), "-4.56e+25")
    }

    @Test
    func format_pair() {
        _testFormat(Sexp(head: Sexp(symbol: "x")), "(x)")
        _testFormat(Sexp(head: Sexp(symbol: "x"),
                         tail: Sexp(symbol: "y")), "(x . y)")
        _testFormat(Sexp(head: Sexp(symbol: "x"),
                         tail: Sexp(head: Sexp(symbol: "y"))), "(x y)")
        _testFormat(Sexp(head: Sexp(symbol: "x"),
                         tail: Sexp(head: Sexp(symbol: "y"),
                                    tail: Sexp(symbol: "z"))), "(x y . z)")
        _testFormat(Sexp(head: Sexp(symbol: "x"),
                         tail: Sexp(head: Sexp(symbol: "y"),
                                    tail: Sexp(head: Sexp(symbol: "z")))), "(x y z)")
    }

    @Test
    func format_string() {
        _testFormat(Sexp(string: "Bilbo"), "\"Bilbo\"")
        _testFormat(Sexp(string: "Bilbo Baggins"), "\"Bilbo Baggins\"")
        _testFormat(Sexp(string: "Bilbo \"Bäggins\""), "\"Bilbo \\\"B\\xe4;ggins\\\"\"")
    }

    @Test
    func format_symbol() {
        _testFormat(Sexp(symbol: "Frodo"), "Frodo")
        _testFormat(Sexp(symbol: "Frodo Baggins"), "|Frodo Baggins|")
        _testFormat(Sexp(symbol: "Frodo | \"Bäggins\""), "|Frodo \\| \"B\\xe4;ggins\"|")
    }

    @Test
    func format_vector() {
        _testFormat(Sexp(vector: [Sexp(symbol: "x"),
                                  Sexp()]), "#(x ())")
        _testFormat(Sexp(vector: [Sexp(symbol: "x"),
                                  Sexp(symbol: "y")]), "#(x y)")
        _testFormat(Sexp(vector: [Sexp(symbol: "x"),
                                  Sexp(head: Sexp(symbol: "y"))]), "#(x (y))")
        _testFormat(Sexp(vector: [Sexp(symbol: "x"),
                                  Sexp(head: Sexp(symbol: "y"),
                                       tail: Sexp(symbol: "z"))]), "#(x (y . z))")
        _testFormat(Sexp(vector: [Sexp(symbol: "x"),
                                  Sexp(vector: [Sexp(symbol: "y"),
                                                Sexp(head: Sexp(symbol: "z"))])]), "#(x #(y (z)))")
    }
}

// MARK: -

extension SexpFormatterTests {
    private func _testFormat(_ sexp: Sexp,
                             _ expectedText: String) {
        let actualText = Sexp.Formatter.format(sexp,
                                               prettyPrint: false)

        #expect(actualText == expectedText)
    }
}
