// © 2026 John Gary Pusey (see LICENSE.md)

import Foundation
import Testing
import XestiNumbers
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

        #expect(throws: DecodingError.self) {
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
    func decode_errorTrailingGarbage() {
        let data = Data("((flag #t)) x".utf8)

        #expect(throws: DecodingError.self) {
            try SexpDecoder().decode(BoolRecord.self, from: data)
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
    func decode_errorUnrecognizedToken() {
        let data = Data("((flag #z))".utf8)

        #expect(throws: DecodingError.self) {
            try SexpDecoder().decode(BoolRecord.self, from: data)
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
    func decode_numberInEveryContainer() throws {
        let record = try decodeText(NumberRecord.self,
                                    from: "((ratio 1/2) (ratios (1 3/4 2.5)) (step ((relative ((_0 2))))))")

        #expect(record == NumberRecord(ratio: Number(numerator: 1, denominator: 2),
                                       ratios: [1, Number(numerator: 3, denominator: 4), 2.5],
                                       step: .relative(2)))
    }

    @Test
    func decode_numberTopLevel() throws {
        #expect(try decodeText(Number.self, from: "3/4") == Number(numerator: 3, denominator: 4))
        #expect(try decodeText(Number.self, from: "\"3/4\"") == Number(numerator: 3, denominator: 4))
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

    @Test
    func roundtrip_emptyOptionals() throws {
        for original in [OptionalCollectionsRecord(array: [], empty: EmptyRecord(), nested: .some(nil), set: []),
                         OptionalCollectionsRecord(array: nil, empty: nil, nested: nil, set: nil),
                         OptionalCollectionsRecord(array: [1], empty: nil, nested: 2, set: [3])] {
            let encoded = try SexpEncoder().encode(original)

            #expect(try SexpDecoder().decode(OptionalCollectionsRecord.self, from: encoded) == original)
        }
    }

    @Test
    func roundtrip_numbers() throws {
        let original = NumberRecord(ratio: Number(numerator: 1, denominator: 3),
                                    ratios: [0, 1, Number(numerator: 7, denominator: 8)],
                                    step: .relative(Number(numerator: 3, denominator: 2)))

        let encoded = try SexpEncoder().encode(original)
        let decoded = try SexpDecoder().decode(NumberRecord.self, from: encoded)

        #expect(decoded == original)
    }

    @Test
    func roundtrip_superEncoderKeyed() throws {
        var encoder = SexpEncoder()

        encoder.prettyPrint = false

        let encoded = try encoder.encode(DerivedRecord(a: 1, b: 2))
        let decoded = try SexpDecoder().decode(DerivedRecord.self, from: encoded)

        #expect(String(data: encoded, encoding: .utf8) == "((b 2) (super ((a 1))))")
        #expect(decoded.a == 1)
        #expect(decoded.b == 2)
    }

    @Test
    func roundtrip_superEncoderUnkeyed() throws {
        let original = UnkeyedSuperRecord(first: 1,
                                          inner: SimpleCodableRecord(name: "Alice"))

        let encoded = try SexpEncoder().encode(original)

        #expect(String(data: encoded, encoding: .utf8) == "(1 ((name Alice)))")
        #expect(try SexpDecoder().decode(UnkeyedSuperRecord.self, from: encoded) == original)
    }
}
