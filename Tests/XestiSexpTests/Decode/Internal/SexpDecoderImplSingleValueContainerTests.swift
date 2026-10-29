// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
import XestiNumbers
@testable import XestiSexp
import XestiTools

struct SexpDecoderImplSingleValueContainerTests {
}

// MARK: -

extension SexpDecoderImplSingleValueContainerTests {
    @Test
    func decode_bool() throws {
        #expect(try makeSingleValueDecoderContainer(Sexp(boolean: true)).decode(Bool.self))
    }

    @Test
    func decode_bool_typeMismatch() {
        #expect(throws: DecodingError.self) {
            try makeSingleValueDecoderContainer(Sexp(symbol: "x")).decode(Bool.self)
        }
    }

    @Test
    func decode_double() throws {
        #expect(try makeSingleValueDecoderContainer(Sexp(number: 3.5)).decode(Double.self) == 3.5)
    }

    @Test
    func decode_int() throws {
        #expect(try makeSingleValueDecoderContainer(Sexp(number: 42)).decode(Int.self) == 42)
    }

    @Test
    func decode_int_outOfRange() throws {
        #expect(try makeSingleValueDecoderContainer(Sexp(number: 255)).decode(UInt8.self) == 255)
        #expect(try makeSingleValueDecoderContainer(Sexp(number: -128)).decode(Int8.self) == -128)

        #expect(throws: DecodingError.self) {
            try makeSingleValueDecoderContainer(Sexp(number: 256)).decode(UInt8.self)
        }

        #expect(throws: DecodingError.self) {
            try makeSingleValueDecoderContainer(Sexp(number: -129)).decode(Int8.self)
        }
    }

    @Test
    func decode_int_typeMismatch() {
        #expect(throws: DecodingError.self) {
            try makeSingleValueDecoderContainer(Sexp(number: 3.5)).decode(Int.self)
        }
    }

    @Test
    func decode_number() throws {
        let number = Sexp.Number(42)

        #expect(try makeSingleValueDecoderContainer(Sexp(number: number)).decode(Sexp.Number.self) == number)
    }

    @Test
    func decode_number_fromString() throws {
        #expect(try makeSingleValueDecoderContainer(Sexp(string: "3/4")).decode(Sexp.Number.self) == Sexp.Number(numerator: 3, denominator: 4))
    }

    @Test
    func decode_string() throws {
        #expect(try makeSingleValueDecoderContainer(Sexp(string: "hi")).decode(String.self) == "hi")
    }

    @Test
    func decode_string_fromSymbol() throws {
        #expect(try makeSingleValueDecoderContainer(Sexp(symbol: "hi")).decode(String.self) == "hi")
    }

    @Test
    func decode_string_typeMismatch() {
        #expect(throws: DecodingError.self) {
            try makeSingleValueDecoderContainer(Sexp(number: 1)).decode(String.self)
        }
    }

    @Test
    func decodeNil_false() {
        #expect(!makeSingleValueDecoderContainer(Sexp(number: 1)).decodeNil())
    }

    @Test
    func decodeNil_true() {
        #expect(makeSingleValueDecoderContainer(Sexp()).decodeNil())
    }
}
