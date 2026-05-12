// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
import XestiNumbers
@testable import XestiSexp
import XestiTools

struct SexpDescriptionTests {
}

// MARK: -

extension SexpDescriptionTests {
    @Test
    func test_boolean() {
        #expect(Sexp(boolean: true).description == "boolean(true)")
        #expect(Sexp(boolean: false).description == "boolean(false)")
    }

    @Test
    func test_bytevector() {
        #expect(Sexp(bytevector: []).description == "bytevector([])")
        #expect(Sexp(bytevector: [1, 2, 3]).description == "bytevector([1, 2, 3])")
    }

    @Test
    func test_character() {
        #expect(Sexp(character: "z").description == "character(z)")
    }

    @Test
    func null() {
        #expect(Sexp().description == "null")
    }

    @Test
    func test_number() {
        #expect(Sexp(number: 42).description == "number(42)")
    }

    @Test
    func pair() {
        #expect(Sexp(head: Sexp(symbol: "x")).description == "pair(symbol(x),null)")
        #expect(Sexp(head: Sexp(symbol: "x"),
                     tail: Sexp(symbol: "y")).description == "pair(symbol(x),symbol(y))")
    }

    @Test
    func test_string() {
        #expect(Sexp(string: "hello").description == "string(hello)")
    }

    @Test
    func test_symbol() {
        #expect(Sexp(symbol: "foo").description == "symbol(foo)")
    }

    @Test
    func test_vector() {
        #expect(Sexp(vector: []).description == "vector([])")
        #expect(Sexp(vector: [Sexp(symbol: "x")]).description == "vector([symbol(x)])")
    }
}
