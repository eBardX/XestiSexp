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
    func sexp_repeatedKeyAppearsOnce() throws {
        let container = makeKeyedEncoderContainer()

        try container.encode(1, forKey: SexpCodingKey("a"))
        try container.encode(2, forKey: SexpCodingKey("b"))
        try container.encode(3, forKey: SexpCodingKey("a"))

        _ = container.superEncoder()
        _ = container.superEncoder()

        #expect(try fmt5(container.sexp) == "((a 3) (b 2) (super ()))")
    }

    @Test
    func superEncoder() throws {
        let container = makeKeyedEncoderContainer()

        try container.encode(2, forKey: SexpCodingKey("b"))

        var superContainer = container.superEncoder().singleValueContainer()

        try superContainer.encode(1)

        #expect(try fmt5(container.sexp) == "((b 2) (super 1))")
    }

    @Test
    func superEncoder_forKey() throws {
        let container = makeKeyedEncoderContainer()

        var superContainer = container.superEncoder(forKey: SexpCodingKey("name")).singleValueContainer()

        try superContainer.encode("Alice")

        #expect(try fmt5(container.sexp) == "((name Alice))")
    }
}
