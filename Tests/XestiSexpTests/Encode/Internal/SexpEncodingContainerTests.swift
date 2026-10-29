// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpEncodingContainerTests {
}

// MARK: -

extension SexpEncodingContainerTests {
    @Test
    func sexp_encoderImpl() throws {
        let encoder = SexpEncoderImpl(codingPath: [],
                                      userInfo: [:])
        var container = encoder.singleValueContainer()

        try container.encode(true)

        let erased: any SexpEncodingContainer = encoder

        #expect(erased.sexp == Sexp(boolean: true))
    }

    @Test
    func sexp_encoderImplWithoutContainer() {
        let erased: any SexpEncodingContainer = SexpEncoderImpl(codingPath: [],
                                                                userInfo: [:])

        #expect(erased.sexp == Sexp())
    }

    @Test
    func sexp_keyedContainer() throws {
        let container = makeKeyedEncoderContainer()

        try container.encode(1,
                             forKey: SexpCodingKey("a"))

        let erased: any SexpEncodingContainer = container

        #expect(try erased.sexp == prs7("((a 1))"))
    }

    @Test
    func sexp_singleValueContainer() throws {
        let container = makeSingleValueEncoderContainer()

        try container.encode("hello")

        let erased: any SexpEncodingContainer = container

        #expect(erased.sexp == Sexp(symbol: Sexp.Symbol("hello", false)))
    }

    @Test
    func sexp_unkeyedContainer() throws {
        let container = makeUnkeyedEncoderContainer()

        try container.encode(1)
        try container.encode(2)

        let erased: any SexpEncodingContainer = container

        #expect(try erased.sexp == prs7("(1 2)"))
    }
}
