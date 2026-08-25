// © 2024–2026 John Gary Pusey (see LICENSE.md)

import Testing
import XestiNumbers
@testable import XestiSexp
import XestiTools

struct SexpFormatterTests {
}

// MARK: -

extension SexpFormatterTests {
    @Test
    func format_boolean_r5rs() throws {
        #expect(try fmt5(Sexp(boolean: true)) == "#t")
        #expect(try fmt5(Sexp(boolean: false)) == "#f")
    }

    @Test
    func format_boolean_r7rs() throws {
        #expect(try fmt7(Sexp(boolean: true)) == "#t")
        #expect(try fmt7(Sexp(boolean: false)) == "#f")
    }

    @Test
    func format_bytevector_r5rs() throws {
        #expect(throws: (any Error).self) { try fmt5(Sexp(bytevector: [])) }
        #expect(throws: (any Error).self) { try fmt5(Sexp(bytevector: [255])) }
        #expect(throws: (any Error).self) { try fmt5(Sexp(bytevector: [1, 2, 3])) }
    }

    @Test
    func format_bytevector_r7rs() throws {
        #expect(try fmt7(Sexp(bytevector: [])) == "#u8()")
        #expect(try fmt7(Sexp(bytevector: [255])) == "#u8(255)")
        #expect(try fmt7(Sexp(bytevector: [1, 2, 3])) == "#u8(1 2 3)")
    }

    @Test
    func format_character_r5rs() throws {
        #expect(try fmt5(Sexp(character: "z")) == "#\\z")
        #expect(throws: (any Error).self) { try fmt5(Sexp(character: "\u{07}")) }
        #expect(try fmt5(Sexp(character: "\u{0a}")) == "#\\newline")
        #expect(throws: (any Error).self) { try fmt5(Sexp(character: "\u{a0}")) }
        #expect(try fmt5(Sexp(character: "ø")) == "#\\ø")
    }

    @Test
    func format_character_r7rs() throws {
        #expect(try fmt7(Sexp(character: "z")) == "#\\z")
        #expect(try fmt7(Sexp(character: "\u{07}")) == "#\\alarm")
        #expect(try fmt7(Sexp(character: "\u{0a}")) == "#\\newline")
        #expect(try fmt7(Sexp(character: "\u{a0}")) == "#\\xa0")
        #expect(try fmt7(Sexp(character: "ø")) == "#\\ø")
    }

    @Test
    func format_complexList_r7rsPrettyPrint() throws {
        let sexp = Sexp(array: [Sexp(symbol: "a"),
                                Sexp(symbol: "b"),
                                Sexp(symbol: "c"),
                                Sexp(symbol: "d"),
                                Sexp(symbol: "e")])

        let result = try fmt7pp(sexp)

        #expect(result == "(a\n b\n c\n d\n e)")
    }

    @Test
    func format_nestedComplex_r7rsPrettyPrint() throws {
        let sexp = Sexp(array: [Sexp(array: [Sexp(symbol: "a"),
                                             Sexp(symbol: "b")]),
                                Sexp(array: [Sexp(symbol: "c"),
                                             Sexp(symbol: "d")]),
                                Sexp(array: [Sexp(symbol: "e"),
                                             Sexp(symbol: "f")])])

        let result = try fmt7pp(sexp)

        #expect(result == "((a b)\n (c d)\n (e f))")
    }

    @Test
    func format_null_r5rs() throws {
        #expect(try fmt5(Sexp()) == "()")
    }

    @Test
    func format_null_r7rs() throws {
        #expect(try fmt7(Sexp()) == "()")
    }

    @Test
    func format_number_r5rs() throws {
        #expect(try fmt5(Sexp(number: 3.141592)) == "3.141592")
        #expect(try fmt5(Sexp(number: -12_345)) == "-12345")
        #expect(try fmt5(Sexp(number: 12_345)) == "12345")
        #expect(try fmt5(Sexp(number: "12345678901234567890")) == "12345678901234567890")
        #expect(try fmt5(Sexp(number: "1234567/890")) == "1234567/890")
        #expect(try fmt5(Sexp(number: -456e23)) == "-4.56e+25")
    }

    @Test
    func format_number_r7rs() throws {
        #expect(try fmt7(Sexp(number: 3.141592)) == "3.141592")
        #expect(try fmt7(Sexp(number: -12_345)) == "-12345")
        #expect(try fmt7(Sexp(number: 12_345)) == "12345")
        #expect(try fmt7(Sexp(number: "12345678901234567890")) == "12345678901234567890")
        #expect(try fmt7(Sexp(number: "1234567/890")) == "1234567/890")
        #expect(try fmt7(Sexp(number: -456e23)) == "-4.56e+25")
    }

    @Test
    func format_pair_r5rs() throws {
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
    func format_pair_r7rs() throws {
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
    func format_simpleList_r7rsPrettyPrint() throws {
        let sexp = Sexp(array: [Sexp(symbol: "a"),
                                Sexp(symbol: "b"),
                                Sexp(symbol: "c")])

        let result = try fmt7pp(sexp)

        #expect(result == "(a b c)")
    }

    @Test
    func format_simplePair_r7rsPrettyPrint() throws {
        let sexp = Sexp(head: Sexp(symbol: "x"),
                        tail: Sexp(symbol: "y"))

        let result = try fmt7pp(sexp)

        #expect(result == "(x . y)")
    }

    @Test
    func format_string_r5rs() throws {
        #expect(try fmt5(Sexp(string: "")) == "\"\"")
        #expect(try fmt5(Sexp(string: "Bilbo")) == "\"Bilbo\"")
        #expect(try fmt5(Sexp(string: "Bilbo Baggins")) == "\"Bilbo Baggins\"")
        #expect(try fmt5(Sexp(string: "Bilbo \"Bäggins\"")) == "\"Bilbo \\\"Bäggins\\\"\"")
    }

    @Test
    func format_string_r7rs() throws {
        #expect(try fmt7(Sexp(string: "")) == "\"\"")
        #expect(try fmt7(Sexp(string: "Bilbo")) == "\"Bilbo\"")
        #expect(try fmt7(Sexp(string: "Bilbo Baggins")) == "\"Bilbo Baggins\"")
        #expect(try fmt7(Sexp(string: "Bilbo \"Bäggins\"")) == "\"Bilbo \\\"Bäggins\\\"\"")
    }

    @Test
    func format_symbol_r5rs() throws {
        #expect(throws: (any Error).self) { try fmt5(Sexp(symbol: "")) }
        #expect(try fmt5(Sexp(symbol: "Frodo")) == "Frodo")
        #expect(throws: (any Error).self) { try fmt5(Sexp(symbol: "Frodo Baggins")) }
        #expect(throws: (any Error).self) { try fmt5(Sexp(symbol: "Frodo | \"Bäggins\"")) }
    }

    @Test
    func format_symbol_r7rs() throws {
        #expect(try fmt7(Sexp(symbol: "")) == "||")
        #expect(try fmt7(Sexp(symbol: "Frodo")) == "Frodo")
        #expect(try fmt7(Sexp(symbol: "Frodo Baggins")) == "|Frodo Baggins|")
        #expect(try fmt7(Sexp(symbol: "Frodo | \"Bäggins\"")) == "|Frodo \\| \"Bäggins\"|")
    }

    @Test
    func format_vector_r5rs() throws {
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

    @Test
    func format_vector_r7rs() throws {
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

    @Test
    func format_vectorComplex_r7rsPrettyPrint() throws {
        let sexp = Sexp(vector: [Sexp(symbol: "a"),
                                 Sexp(symbol: "b"),
                                 Sexp(symbol: "c"),
                                 Sexp(symbol: "d"),
                                 Sexp(symbol: "e")])

        let result = try fmt7pp(sexp)

        #expect(result == "#(a\n  b\n  c\n  d\n  e\n)")
    }

    @Test
    func format_vectorSimple_r7rsPrettyPrint() throws {
        let sexp = Sexp(vector: [Sexp(symbol: "x"),
                                 Sexp(symbol: "y")])

        let result = try fmt7pp(sexp)

        #expect(result == "#(x y)")
    }
}
