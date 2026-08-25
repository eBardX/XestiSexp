// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpEncoderImplKeyedContainerTests {
}

// MARK: -

extension SexpEncoderImplKeyedContainerTests {
    @Test
    func encode() throws {
        let container = makeKeyedEncoderContainer()

        try container.encode("x", forKey: SexpCodingKey("name"))

        #expect(try fmt5(container.sexp) == "((name x))")
    }

    @Test
    func encodeNil() throws {
        let container = makeKeyedEncoderContainer()

        try container.encodeNil(forKey: SexpCodingKey("value"))

        #expect(try fmt5(container.sexp) == "((value ()))")
    }

    @Test
    func nestedContainer() throws {
        let container = makeKeyedEncoderContainer()
        var nested = container.nestedContainer(keyedBy: SexpCodingKey.self,
                                               forKey: SexpCodingKey("inner"))

        try nested.encode("x", forKey: SexpCodingKey("name"))

        #expect(try fmt5(container.sexp) == "((inner ((name x))))")
    }

    @Test
    func nestedUnkeyedContainer() throws {
        let container = makeKeyedEncoderContainer()
        var nested = container.nestedUnkeyedContainer(forKey: SexpCodingKey("items"))

        try nested.encode(1)

        #expect(try fmt5(container.sexp) == "((items (1)))")
    }

    @Test
    func sexp_preservesInsertionOrder() throws {
        let container = makeKeyedEncoderContainer()

        try container.encode(1, forKey: SexpCodingKey("b"))
        try container.encode(2, forKey: SexpCodingKey("a"))

        #expect(try fmt5(container.sexp) == "((b 1) (a 2))")
    }

    @Test
    func superEncoder() {
        let container = makeKeyedEncoderContainer()

        _ = container.superEncoder()
    }

    @Test
    func superEncoder_forKey() {
        let container = makeKeyedEncoderContainer()

        _ = container.superEncoder(forKey: SexpCodingKey("name"))
    }
}
