// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
import XestiNumbers
@testable import XestiSexp
import XestiTools

struct SexpValueTests {
}

// MARK: -

extension SexpValueTests {
    @Test
    func boolean() {
        guard case let .boolean(value) = Sexp(boolean: true).value
        else { Issue.record("Expected .boolean"); return }

        #expect(value)
    }

    @Test
    func bytevector() {
        guard case let .bytevector(value) = Sexp(bytevector: [1, 2, 3]).value
        else { Issue.record("Expected .bytevector"); return }

        #expect(value == [1, 2, 3])
    }

    @Test
    func character() {
        guard case let .character(value) = Sexp(character: "z").value
        else { Issue.record("Expected .character"); return }

        #expect(value == "z")
    }

    @Test
    func null() {
        guard case .null = Sexp().value
        else { Issue.record("Expected .null"); return }
    }

    @Test
    func number() {
        guard case let .number(value) = Sexp(number: 42).value
        else { Issue.record("Expected .number"); return }

        #expect(value == 42)
    }

    @Test
    func pair() {
        guard case let .pair(head, tail) = Sexp(head: Sexp(symbol: "x")).value
        else { Issue.record("Expected .pair"); return }

        #expect(head == Sexp(symbol: "x"))
        #expect(tail == Sexp())
    }

    @Test
    func string() {
        guard case let .string(value) = Sexp(string: "hi").value
        else { Issue.record("Expected .string"); return }

        #expect(value == "hi")
    }

    @Test
    func symbol() {
        guard case let .symbol(value) = Sexp(symbol: "x").value
        else { Issue.record("Expected .symbol"); return }

        #expect(value == Sexp.Symbol("x", false))
    }

    @Test
    func vector() {
        guard case let .vector(value) = Sexp(vector: [Sexp(symbol: "x")]).value
        else { Issue.record("Expected .vector"); return }

        #expect(value == [Sexp(symbol: "x")])
    }
}
