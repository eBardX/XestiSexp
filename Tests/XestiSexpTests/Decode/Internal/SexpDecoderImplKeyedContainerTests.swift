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
    func allKeys_repeatedKey() throws {
        let container = try makeKeyedDecoderContainer("((a 1) (b 2) (a 3))")

        #expect(container.allKeys.map(\.stringValue) == ["a", "b"])
        #expect(try container.decode(Int.self, forKey: SexpCodingKey("a")) == 3)
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
    func decode_int_outOfRange() throws {
        let container = try makeKeyedDecoderContainer("((big 300) (negative -1))")

        #expect(try container.decode(Int16.self, forKey: SexpCodingKey("big")) == 300)

        #expect(throws: DecodingError.self) {
            try container.decode(Int8.self, forKey: SexpCodingKey("big"))
        }

        #expect(throws: DecodingError.self) {
            try container.decode(UInt.self, forKey: SexpCodingKey("negative"))
        }
    }

    @Test
    func decode_int_typeMismatch() {
        #expect(throws: DecodingError.self) {
            let container = try makeKeyedDecoderContainer("((age 30.5))")

            _ = try container.decode(Int.self, forKey: SexpCodingKey("age"))
        }
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
    func decodeIfPresent_emptyListIsEmptyValueWhereItCanBe() throws {
        let container = try makeKeyedDecoderContainer("((list ()) (number ()) (present 7))")

        #expect(try container.decodeIfPresent([Int].self, forKey: SexpCodingKey("list"))?.isEmpty == true)
        #expect(try container.decodeIfPresent(Int?.self, forKey: SexpCodingKey("list")) == .some(nil))
        #expect(try container.decodeIfPresent(Int.self, forKey: SexpCodingKey("number")) == nil)
        #expect(try container.decodeIfPresent(Int.self, forKey: SexpCodingKey("present")) == 7)
        #expect(try container.decodeIfPresent([Int].self, forKey: SexpCodingKey("missing")) == nil)
    }

    @Test
    func decodeIfPresent_wrongTypeStillThrows() throws {
        let container = try makeKeyedDecoderContainer("((list (1 x)))")

        #expect(throws: DecodingError.self) {
            try container.decodeIfPresent([Int].self, forKey: SexpCodingKey("list"))
        }
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
