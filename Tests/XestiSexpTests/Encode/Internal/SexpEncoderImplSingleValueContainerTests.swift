// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
import XestiNumbers
@testable import XestiSexp
import XestiTools

struct SexpEncoderImplSingleValueContainerTests {
}

// MARK: -

extension SexpEncoderImplSingleValueContainerTests {
    @Test
    func encode_bool() throws {
        let container = makeSingleValueEncoderContainer()

        try container.encode(true)

        #expect(container.sexp == Sexp(boolean: true))
    }

    @Test
    func encode_double() throws {
        let container = makeSingleValueEncoderContainer()

        try container.encode(3.5)

        #expect(container.sexp == Sexp(number: 3.5))
    }

    @Test
    func encode_int() throws {
        let container = makeSingleValueEncoderContainer()

        try container.encode(42)

        #expect(container.sexp == Sexp(number: 42))
    }

    @Test
    func encode_number() throws {
        let container = makeSingleValueEncoderContainer()
        let number = Sexp.Number(42)

        try container.encode(number)

        #expect(container.sexp == Sexp(number: number))
    }

    @Test
    func encode_string() throws {
        let container = makeSingleValueEncoderContainer()

        try container.encode("hi")

        #expect(container.sexp == Sexp(symbol: "hi"))
    }

    @Test
    func encode_string_special() throws {
        let container = makeSingleValueEncoderContainer()

        try container.encode("hi there")

        #expect(container.sexp == Sexp(string: "hi there"))
    }

    @Test
    func encode_valueAlreadyPresentThrows() throws {
        let container = makeSingleValueEncoderContainer()

        try container.encode(true)

        #expect(throws: EncodingError.self) {
            try container.encode(false)
        }
    }

    @Test
    func encodeNil() throws {
        let container = makeSingleValueEncoderContainer()

        try container.encodeNil()

        #expect(container.sexp == Sexp())
    }
}
