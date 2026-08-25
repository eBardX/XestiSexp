// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpFormatterContextTests {
}

// MARK: -

extension SexpFormatterContextTests {
    @Test
    func emit() {
        var context = Sexp.Formatter.Context()

        context.emit("abc")

        #expect(context.workBuffer == "abc")
        #expect(context.position == 3)
    }

    @Test
    func emit_accumulates() {
        var context = Sexp.Formatter.Context()

        context.emit("ab")
        context.emit("cd")

        #expect(context.workBuffer == "abcd")
        #expect(context.position == 4)
    }

    @Test
    func emitln_resetsPosition() {
        var context = Sexp.Formatter.Context()

        context.emit("abc")
        context.emitln()

        #expect(context.workBuffer == "abc\n")
        #expect(context.position == 0)
    }

    @Test
    func emitln_withString() {
        var context = Sexp.Formatter.Context()

        context.emitln("abc")

        #expect(context.workBuffer == "abc\n")
        #expect(context.position == 0)
    }

    @Test
    func indent_beyondPosition() {
        var context = Sexp.Formatter.Context()

        context.emit("ab")
        context.indent(to: 5)

        #expect(context.workBuffer == "ab   ")
        #expect(context.position == 5)
    }

    @Test
    func indent_notBeyondPosition() {
        var context = Sexp.Formatter.Context()

        context.emit("abcde")
        context.indent(to: 2)

        #expect(context.workBuffer == "abcde")
        #expect(context.position == 5)
    }

    @Test
    func initialState() {
        let context = Sexp.Formatter.Context()

        #expect(context.position == 0)
        #expect(context.workBuffer.isEmpty)
    }
}
