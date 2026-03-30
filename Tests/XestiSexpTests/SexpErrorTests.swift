// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
import XestiMath
@testable import XestiSexp
import XestiTools

struct SexpErrorTests {
}

// MARK: -

extension SexpErrorTests {
    @Test
    func test_message_formatFailed() {
        let error = Sexp.Error.formatFailed("test", Sexp.Syntax.r5rs)

        #expect(error.message.contains("Failed to format"))
    }

    @Test
    func test_message_invalidBoolean() {
        let error = Sexp.Error.invalidBoolean("#x")

        #expect(error.message.contains("Invalid boolean"))
        #expect(error.message.contains("#x"))
    }

    @Test
    func test_message_invalidBytevectorElement() {
        let error = Sexp.Error.invalidBytevectorElement(999)

        #expect(error.message.contains("Invalid bytevector element"))
    }

    @Test
    func test_message_invalidCharacter() {
        let error = Sexp.Error.invalidCharacter("#\\xyz")

        #expect(error.message.contains("Invalid character"))
    }

    @Test
    func test_message_invalidNumber() {
        let error = Sexp.Error.invalidNumber("abc")

        #expect(error.message.contains("Invalid number"))
    }

    @Test
    func test_message_invalidString() {
        let error = Sexp.Error.invalidString("bad")

        #expect(error.message.contains("Invalid string"))
    }

    @Test
    func test_message_invalidSymbol() {
        let error = Sexp.Error.invalidSymbol("bad")

        #expect(error.message.contains("Invalid symbol"))
    }

    @Test
    func test_message_trailingGarbage() {
        let error = Sexp.Error.trailingGarbage

        #expect(error.message.contains("trailing garbage"))
    }

    @Test
    func test_parse_trailing_garbage() {
        #expect(throws: (any Error).self) {
            try Sexp.Parser(syntax: .r7rsPartial,
                            tracing: .silent).parse(input: "foo bar")
        }
    }
}
