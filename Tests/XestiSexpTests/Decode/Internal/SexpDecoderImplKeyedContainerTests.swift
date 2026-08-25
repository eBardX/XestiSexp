// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpDecoderImplKeyedContainerTests {
}

// MARK: -

extension SexpDecoderImplKeyedContainerTests {
    @Test
    func allKeys() throws {
        let container = try makeKeyedDecoderContainer("((name x) (age 30))")

        #expect(container.allKeys.map(\.stringValue) == ["name", "age"])
    }

    @Test
    func contains() throws {
        let container = try makeKeyedDecoderContainer("((name x))")

        #expect(container.contains(SexpCodingKey("name")))
        #expect(!container.contains(SexpCodingKey("age")))
    }

    @Test
    func decode_bool() throws {
        let container = try makeKeyedDecoderContainer("((flag #t))")

        #expect(try container.decode(Bool.self, forKey: SexpCodingKey("flag")))
    }

    @Test
    func decode_int() throws {
        let container = try makeKeyedDecoderContainer("((age 30))")

        #expect(try container.decode(Int.self, forKey: SexpCodingKey("age")) == 30)
    }

    @Test
    func decode_keyNotFound() {
        #expect(throws: DecodingError.self) {
            let container = try makeKeyedDecoderContainer("()")

            _ = try container.decode(Int.self, forKey: SexpCodingKey("age"))
        }
    }

    @Test
    func decode_string() throws {
        let container = try makeKeyedDecoderContainer("((name x))")

        #expect(try container.decode(String.self, forKey: SexpCodingKey("name")) == "x")
    }

    @Test
    func decodeNil() throws {
        let container = try makeKeyedDecoderContainer("((value ()))")

        #expect(try container.decodeNil(forKey: SexpCodingKey("value")))
    }

    @Test
    func nestedContainer() throws {
        let container = try makeKeyedDecoderContainer("((inner ((name x))))")

        _ = try container.nestedContainer(keyedBy: SexpCodingKey.self,
                                          forKey: SexpCodingKey("inner"))
    }

    @Test
    func nestedUnkeyedContainer() throws {
        let container = try makeKeyedDecoderContainer("((items (1 2 3)))")

        _ = try container.nestedUnkeyedContainer(forKey: SexpCodingKey("items"))
    }

    @Test
    func superDecoder() throws {
        let container = try makeKeyedDecoderContainer("((name x))")

        _ = try container.superDecoder()
    }

    @Test
    func superDecoder_forKey() throws {
        let container = try makeKeyedDecoderContainer("((name x))")

        _ = try container.superDecoder(forKey: SexpCodingKey("name"))
    }
}
