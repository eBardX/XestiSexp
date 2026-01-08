// © 2024–2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpFormatterR5RSTests {
}

// MARK: -

extension SexpFormatterR5RSTests {
    @Test
    func test_format_boolean() throws {
        #expect(try _fmt(Sexp(boolean: true)) == "#t")
        #expect(try _fmt(Sexp(boolean: false)) == "#f")
    }

    @Test
    func test_format_bytevector() throws {
        #expect(throws: (any Error).self) { try _fmt(Sexp(bytevector: [])) }
        #expect(throws: (any Error).self) { try _fmt(Sexp(bytevector: [255])) }
        #expect(throws: (any Error).self) { try _fmt(Sexp(bytevector: [1, 2, 3])) }
    }

    @Test
    func test_format_character() throws {
        #expect(try _fmt(Sexp(character: "z")) == "#\\z")
        #expect(throws: (any Error).self) { try _fmt(Sexp(character: "\u{07}")) }
        #expect(try _fmt(Sexp(character: "\u{0a}")) == "#\\newline")
        #expect(throws: (any Error).self) { try _fmt(Sexp(character: "\u{a0}")) }
        #expect(try _fmt(Sexp(character: "ø")) == "#\\ø")
    }

    @Test
    func test_format_null() throws {
        #expect(try _fmt(Sexp()) == "()")
    }

    @Test
    func test_format_number() throws {
        #expect(try _fmt(Sexp(number: 3.141592)) == "3.141592")
        #expect(try _fmt(Sexp(number: -12_345)) == "-12345")
        #expect(try _fmt(Sexp(number: 12_345)) == "12345")
        #expect(try _fmt(Sexp(number: "12345678901234567890")) == "12345678901234567890")
        #expect(try _fmt(Sexp(number: "1234567/890")) == "1234567/890")
        #expect(try _fmt(Sexp(number: -456e23)) == "-4.56e+25")
    }

    @Test
    func test_format_pair() throws {
        #expect(try _fmt(Sexp(head: Sexp(symbol: "x"))) == "(x)")
        #expect(try _fmt(Sexp(head: Sexp(symbol: "x"),
                              tail: Sexp(symbol: "y"))) == "(x . y)")
        #expect(try _fmt(Sexp(head: Sexp(symbol: "x"),
                              tail: Sexp(head: Sexp(symbol: "y")))) == "(x y)")
        #expect(try _fmt(Sexp(head: Sexp(symbol: "x"),
                              tail: Sexp(head: Sexp(symbol: "y"),
                                         tail: Sexp(symbol: "z")))) == "(x y . z)")
        #expect(try _fmt(Sexp(head: Sexp(symbol: "x"),
                              tail: Sexp(head: Sexp(symbol: "y"),
                                         tail: Sexp(head: Sexp(symbol: "z"))))) == "(x y z)")
    }

    @Test
    func test_format_string() throws {
        #expect(try _fmt(Sexp(string: "Bilbo")) == "\"Bilbo\"")
        #expect(try _fmt(Sexp(string: "Bilbo Baggins")) == "\"Bilbo Baggins\"")
        #expect(try _fmt(Sexp(string: "Bilbo \"Bäggins\"")) == "\"Bilbo \\\"Bäggins\\\"\"")
    }

    @Test
    func test_format_symbol() throws {
        #expect(try _fmt(Sexp(symbol: "Frodo")) == "Frodo")
        #expect(throws: (any Error).self) { try _fmt(Sexp(symbol: "Frodo Baggins")) }
        #expect(throws: (any Error).self) { try _fmt(Sexp(symbol: "Frodo | \"Bäggins\"")) }
    }

    @Test
    func test_format_vector() throws {
        #expect(try _fmt(Sexp(vector: [Sexp(symbol: "x"),
                                       Sexp()])) == "#(x ())")
        #expect(try _fmt(Sexp(vector: [Sexp(symbol: "x"),
                                       Sexp(symbol: "y")])) == "#(x y)")
        #expect(try _fmt(Sexp(vector: [Sexp(symbol: "x"),
                                       Sexp(head: Sexp(symbol: "y"))])) == "#(x (y))")
        #expect(try _fmt(Sexp(vector: [Sexp(symbol: "x"),
                                       Sexp(head: Sexp(symbol: "y"),
                                            tail: Sexp(symbol: "z"))])) == "#(x (y . z))")
        #expect(try _fmt(Sexp(vector: [Sexp(symbol: "x"),
                                       Sexp(vector: [Sexp(symbol: "y"),
                                                     Sexp(head: Sexp(symbol: "z"))])])) == "#(x #(y (z)))")
    }
}

// MARK: -

extension SexpFormatterR5RSTests {
    private func _fmt(_ sexp: Sexp) throws -> String {
        try Sexp.Formatter(prettyPrint: false,
                           syntax: .r5rs,
                           tracing: .silent).format(sexp)
    }
}
