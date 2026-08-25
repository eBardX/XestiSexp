// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpEncoderImplUnkeyedContainerTests {
}

// MARK: -

extension SexpEncoderImplUnkeyedContainerTests {
    @Test
    func count() throws {
        let container = makeUnkeyedEncoderContainer()

        try container.encode(1)
        try container.encode(2)

        #expect(container.count == 2)
    }

    @Test
    func encode() throws {
        let container = makeUnkeyedEncoderContainer()

        try container.encode(1)
        try container.encode(2)

        #expect(try fmt5(container.sexp) == "(1 2)")
    }

    @Test
    func encodeNil() throws {
        let container = makeUnkeyedEncoderContainer()

        try container.encodeNil()

        #expect(try fmt5(container.sexp) == "(())")
    }

    @Test
    func nestedContainer() throws {
        let container = makeUnkeyedEncoderContainer()
        var nested = container.nestedContainer(keyedBy: SexpCodingKey.self)

        try nested.encode("x", forKey: SexpCodingKey("name"))

        #expect(try fmt5(container.sexp) == "(((name x)))")
    }

    @Test
    func nestedUnkeyedContainer() throws {
        let container = makeUnkeyedEncoderContainer()
        var nested = container.nestedUnkeyedContainer()

        try nested.encode(1)

        #expect(try fmt5(container.sexp) == "((1))")
    }

    @Test
    func superEncoder() {
        let container = makeUnkeyedEncoderContainer()

        _ = container.superEncoder()
    }
}
