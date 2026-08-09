// © 2026 John Gary Pusey (see LICENSE.md)

import Foundation
import Testing
@testable import XestiSexp

struct SexpDecoderTests {
}

// MARK: -

extension SexpDecoderTests {
    @Test
    func decode_boolean() throws {
        let record = try decodeText(BoolRecord.self,
                                    from: "((flag #t))")

        #expect(record.flag)
    }

    @Test
    func decode_errorInvalidData() {
        let data = Data([0xff])

        #expect(throws: DecodingError.self) {
            try SexpDecoder().decode(BoolRecord.self, from: data)
        }
    }

    @Test
    func decode_errorInvalidSexp() {
        let data = Data("((((".utf8)

        #expect(throws: (any Error).self) {
            try SexpDecoder().decode(BoolRecord.self, from: data)
        }
    }

    @Test
    func decode_errorKeyNotFound() {
        let data = Data("((name Alice))".utf8)

        #expect(throws: DecodingError.self) {
            try SexpDecoder().decode(SimpleRecord.self, from: data)
        }
    }

    @Test
    func decode_errorTypeMismatch() {
        let data = Data("((name 42) (age 30))".utf8)

        #expect(throws: DecodingError.self) {
            try SexpDecoder().decode(SimpleRecord.self, from: data)
        }
    }

    @Test
    func decode_keyed() throws {
        let record = try decodeText(SimpleRecord.self,
                                    from: "((name Alice) (age 30))")

        #expect(record.name == "Alice")
        #expect(record.age == 30)
    }

    @Test
    func decode_nested() throws {
        let record = try decodeText(NestedRecord.self,
                                    from: "((label outer) (inner ((name Bob) (age 25))))")

        #expect(record.label == "outer")
        #expect(record.inner.name == "Bob")
        #expect(record.inner.age == 25)
    }

    @Test
    func decode_nil() throws {
        let record = try decodeText(OptionalRecord.self,
                                    from: "((value ()))")

        #expect(record.value == nil)
    }

    @Test
    func decode_numberDouble() throws {
        let record = try decodeText(DoubleRecord.self,
                                    from: "((value 3.14))")

        #expect(record.value == 3.14)
    }

    @Test
    func decode_stringQuoted() throws {
        let record = try decodeText(SimpleRecord.self,
                                    from: "((name \"hello world\") (age 1))")

        #expect(record.name == "hello world")
    }

    @Test
    func decode_unkeyed() throws {
        let data = Data("(1 2 3)".utf8)

        let values = try SexpDecoder().decode([Int].self, from: data)

        #expect(values == [1, 2, 3])
    }

    @Test
    func roundtrip() throws {
        let original = CodableRecord(name: "Alice",
                                     age: 30,
                                     active: true)

        let encoded = try SexpEncoder().encode(original)
        let decoded = try SexpDecoder().decode(CodableRecord.self, from: encoded)

        #expect(decoded == original)
    }
}
