// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpDecoderImplUnkeyedContainerTests {
}

// MARK: -

extension SexpDecoderImplUnkeyedContainerTests {
    @Test
    func count() throws {
        let container = try makeUnkeyedDecoderContainer("(1 2 3)")

        #expect(container.count == 3)
    }

    @Test
    func decode_advancesIndex() throws {
        var container = try makeUnkeyedDecoderContainer("(1 2 3)")

        #expect(try container.decode(Int.self) == 1)
        #expect(try container.decode(Int.self) == 2)
        #expect(container.currentIndex == 2)
    }

    @Test
    func decode_atEndThrows() throws {
        var container = try makeUnkeyedDecoderContainer("()")

        #expect(throws: DecodingError.self) {
            try container.decode(Int.self)
        }
    }

    @Test
    func decode_bool() throws {
        var container = try makeUnkeyedDecoderContainer("(#t #f)")

        #expect(try container.decode(Bool.self))
        #expect(try !container.decode(Bool.self))
    }

    @Test
    func decode_string() throws {
        var container = try makeUnkeyedDecoderContainer("(x)")

        #expect(try container.decode(String.self) == "x")
    }

    @Test
    func decodeNil_false() throws {
        var container = try makeUnkeyedDecoderContainer("(1)")

        #expect(try !container.decodeNil())
        #expect(container.currentIndex == 0)
    }

    @Test
    func decodeNil_true() throws {
        var container = try makeUnkeyedDecoderContainer("(())")

        #expect(try container.decodeNil())
        #expect(container.currentIndex == 1)
    }

    @Test
    func isAtEnd() throws {
        var container = try makeUnkeyedDecoderContainer("(1)")

        #expect(!container.isAtEnd)

        _ = try container.decode(Int.self)

        #expect(container.isAtEnd)
    }

    @Test
    func nestedContainer() throws {
        var container = try makeUnkeyedDecoderContainer("(((name x)))")

        _ = try container.nestedContainer(keyedBy: SexpCodingKey.self)
    }

    @Test
    func nestedUnkeyedContainer() throws {
        var container = try makeUnkeyedDecoderContainer("((1 2))")

        _ = try container.nestedUnkeyedContainer()
    }

    @Test
    func superDecoder() throws {
        var container = try makeUnkeyedDecoderContainer("(1)")

        _ = try container.superDecoder()
    }
}
