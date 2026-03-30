// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp
import XestiTools

struct SexpFormatterPrettyPrintTests {
}

// MARK: -

extension SexpFormatterPrettyPrintTests {
    @Test
    func test_format_complex_list() throws {
        let sexp = Sexp(array: [Sexp(symbol: "a"),
                                Sexp(symbol: "b"),
                                Sexp(symbol: "c"),
                                Sexp(symbol: "d"),
                                Sexp(symbol: "e")])

        let result = try _fmt(sexp)

        #expect(result == "(a\n b\n c\n d\n e)")
    }

    @Test
    func test_format_nested_complex() throws {
        let sexp = Sexp(array: [Sexp(array: [Sexp(symbol: "a"),
                                             Sexp(symbol: "b")]),
                                Sexp(array: [Sexp(symbol: "c"),
                                             Sexp(symbol: "d")]),
                                Sexp(array: [Sexp(symbol: "e"),
                                             Sexp(symbol: "f")])])

        let result = try _fmt(sexp)

        #expect(result == "((a b)\n (c d)\n (e f))")
    }

    @Test
    func test_format_simple_list() throws {
        let sexp = Sexp(array: [Sexp(symbol: "a"),
                                Sexp(symbol: "b"),
                                Sexp(symbol: "c")])

        let result = try _fmt(sexp)

        #expect(result == "(a b c)")
    }

    @Test
    func test_format_simple_pair() throws {
        let sexp = Sexp(head: Sexp(symbol: "x"),
                        tail: Sexp(symbol: "y"))

        let result = try _fmt(sexp)

        #expect(result == "(x . y)")
    }

    @Test
    func test_format_vector_complex() throws {
        let sexp = Sexp(vector: [Sexp(symbol: "a"),
                                 Sexp(symbol: "b"),
                                 Sexp(symbol: "c"),
                                 Sexp(symbol: "d"),
                                 Sexp(symbol: "e")])

        let result = try _fmt(sexp)

        #expect(result == "#(a\n  b\n  c\n  d\n  e\n)")
    }

    @Test
    func test_format_vector_simple() throws {
        let sexp = Sexp(vector: [Sexp(symbol: "x"),
                                 Sexp(symbol: "y")])

        let result = try _fmt(sexp)

        #expect(result == "#(x y)")
    }
}

// MARK: -

extension SexpFormatterPrettyPrintTests {
    private func _fmt(_ sexp: Sexp) throws -> String {
        try Sexp.Formatter(prettyPrint: true,
                           syntax: .r7rsPartial,
                           tracing: .silent).format(sexp)
    }
}
