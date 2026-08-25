// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp
import XestiTools

struct SexpDecoderImplTests {
}

// MARK: -

extension SexpDecoderImplTests {
    @Test
    func container_keyedByFromList() throws {
        let sexp = try prs5("((name x))")
        let impl = SexpDecoderImpl(from: sexp,
                                   codingPath: [],
                                   userInfo: [:])

        _ = try impl.container(keyedBy: SexpCodingKey.self)
    }

    @Test
    func container_keyedByThrowsForNonList() {
        let impl = SexpDecoderImpl(from: Sexp(symbol: "x"),
                                   codingPath: [],
                                   userInfo: [:])

        #expect(throws: DecodingError.self) {
            _ = try impl.container(keyedBy: SexpCodingKey.self)
        }
    }

    @Test
    func init_setsProperties() {
        let sexp = Sexp(symbol: "x")
        let impl = SexpDecoderImpl(from: sexp,
                                   codingPath: [],
                                   userInfo: [:])

        #expect(impl.codingPath.isEmpty)
        #expect(impl.sexp == sexp)
        #expect(impl.userInfo.isEmpty)
    }

    @Test
    func singleValueContainer() throws {
        let impl = SexpDecoderImpl(from: Sexp(symbol: "x"),
                                   codingPath: [],
                                   userInfo: [:])

        _ = try impl.singleValueContainer()
    }

    @Test
    func unkeyedContainer() throws {
        let sexp = try prs5("(1 2 3)")
        let impl = SexpDecoderImpl(from: sexp,
                                   codingPath: [],
                                   userInfo: [:])

        _ = try impl.unkeyedContainer()
    }

    @Test
    func unkeyedContainer_throwsForNonList() {
        let impl = SexpDecoderImpl(from: Sexp(symbol: "x"),
                                   codingPath: [],
                                   userInfo: [:])

        #expect(throws: DecodingError.self) {
            _ = try impl.unkeyedContainer()
        }
    }
}
