// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpEncoderImplTests {
}

// MARK: -

extension SexpEncoderImplTests {
    @Test
    func container_keyed() {
        let impl = SexpEncoderImpl(codingPath: [],
                                   userInfo: [:])

        _ = impl.container(keyedBy: SexpCodingKey.self)
    }

    @Test
    func init_setsProperties() {
        let impl = SexpEncoderImpl(codingPath: [],
                                   userInfo: [:])

        #expect(impl.codingPath.isEmpty)
        #expect(impl.userInfo.isEmpty)
    }

    @Test
    func sexp_withoutContainer() {
        let impl = SexpEncoderImpl(codingPath: [],
                                   userInfo: [:])

        #expect(impl.sexp == Sexp())
    }

    @Test
    func singleValueContainer() throws {
        let impl = SexpEncoderImpl(codingPath: [],
                                   userInfo: [:])
        var container = impl.singleValueContainer()

        try container.encode(true)

        #expect(impl.sexp == Sexp(boolean: true))
    }

    @Test
    func unkeyedContainer() {
        let impl = SexpEncoderImpl(codingPath: [],
                                   userInfo: [:])

        _ = impl.unkeyedContainer()
    }
}
