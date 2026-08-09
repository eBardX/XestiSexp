// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpSymbolTests {
}

// MARK: -

extension SexpSymbolTests {
    @Test
    func equality() {
        let sym1 = Sexp.Symbol("foo", false)
        let sym2 = Sexp.Symbol("foo", false)
        let sym3 = Sexp.Symbol("bar", false)

        #expect(sym1 == sym2)
        #expect(sym1 != sym3)
    }

    @Test
    func hashable() {
        let sym1 = Sexp.Symbol("foo", false)
        let sym2 = Sexp.Symbol("foo", false)

        #expect(sym1.hashValue == sym2.hashValue)
    }

    @Test
    func init_notSpecial() {
        let sym = Sexp.Symbol("hello", false)

        #expect(sym.stringValue == "hello")
        #expect(!sym.isSpecial)
    }

    @Test
    func init_special() {
        let sym = Sexp.Symbol("hello world", true)

        #expect(sym.stringValue == "hello world")
        #expect(sym.isSpecial)
    }

    @Test
    func init_stringValue() throws {
        let sym = try #require(Sexp.Symbol(stringValue: "foo"))

        #expect(sym.stringValue == "foo")
        #expect(!sym.isSpecial)
    }

    @Test
    func init_stringValue_special() throws {
        let sym = try #require(Sexp.Symbol(stringValue: "foo bar"))

        #expect(sym.stringValue == "foo bar")
        #expect(sym.isSpecial)
    }

    @Test
    func isSpecial_false() {
        #expect(!Sexp.Symbol.isSpecial("foo"))
        #expect(!Sexp.Symbol.isSpecial("foo-bar"))
        #expect(!Sexp.Symbol.isSpecial("foo.bar"))
        #expect(!Sexp.Symbol.isSpecial("x"))
        #expect(!Sexp.Symbol.isSpecial("x+y"))
    }

    @Test
    func isSpecial_true() {
        #expect(Sexp.Symbol.isSpecial(""))
        #expect(Sexp.Symbol.isSpecial("foo bar"))
        #expect(Sexp.Symbol.isSpecial("123"))
        #expect(Sexp.Symbol.isSpecial("-foo"))
        #expect(Sexp.Symbol.isSpecial("+"))
    }

    @Test
    func isValid() {
        #expect(Sexp.Symbol.isValid("anything"))
        #expect(Sexp.Symbol.isValid(""))
        #expect(Sexp.Symbol.isValid("123"))
        #expect(Sexp.Symbol.isValid("hello world"))
    }
}
