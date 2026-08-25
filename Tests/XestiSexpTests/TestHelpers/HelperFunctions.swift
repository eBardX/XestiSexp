// © 2026 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import XestiSexp
import XestiTools

internal func decodeText<T: Decodable>(_ type: T.Type,
                                       from text: String) throws -> T {
    try SexpDecoder().decode(type,
                             from: Data(text.utf8))
}

internal func fmt5(_ sexp: Sexp) throws -> String {
    try Sexp.Formatter(prettyPrint: false,
                       syntax: .r5rs,
                       tracing: .silent).format(sexp)
}

internal func fmt7(_ sexp: Sexp) throws -> String {
    try Sexp.Formatter(prettyPrint: false,
                       syntax: .r7rsPartial,
                       tracing: .silent).format(sexp)
}

internal func fmt7pp(_ sexp: Sexp) throws -> String {
    try Sexp.Formatter(prettyPrint: true,
                       syntax: .r7rsPartial,
                       tracing: .silent).format(sexp)
}

internal func makeKeyedDecoderContainer(_ text: String) throws -> SexpDecoderImpl.KeyedContainer<SexpCodingKey> {
    let sexp = try prs5(text)

    guard let (dictionary, keys) = sexp.dictionaryValue
    else { throw NotAKeyedValueError() }

    return SexpDecoderImpl.KeyedContainer(decoderImpl: SexpDecoderImpl(from: sexp,
                                                                       codingPath: [],
                                                                       userInfo: [:]),
                                          codingPath: [],
                                          dictionary: dictionary,
                                          keys: keys)
}

internal func makeKeyedEncoderContainer() -> SexpEncoderImpl.KeyedContainer<SexpCodingKey> {
    SexpEncoderImpl.KeyedContainer(encoderImpl: SexpEncoderImpl(codingPath: [],
                                                                userInfo: [:]),
                                   codingPath: [])
}

internal func makeSingleValueDecoderContainer(_ sexp: Sexp) -> SexpDecoderImpl.SingleValueContainer {
    SexpDecoderImpl.SingleValueContainer(decoderImpl: SexpDecoderImpl(from: sexp,
                                                                      codingPath: [],
                                                                      userInfo: [:]),
                                         codingPath: [],
                                         value: sexp)
}

internal func makeSingleValueEncoderContainer() -> SexpEncoderImpl.SingleValueContainer {
    SexpEncoderImpl.SingleValueContainer(encoderImpl: SexpEncoderImpl(codingPath: [],
                                                                      userInfo: [:]),
                                         codingPath: [])
}

internal func makeUnkeyedDecoderContainer(_ text: String) throws -> SexpDecoderImpl.UnkeyedContainer {
    let sexp = try prs5(text)

    guard let arrayValue = sexp.arrayValue
    else { throw NotAnUnkeyedValueError() }

    return SexpDecoderImpl.UnkeyedContainer(decoderImpl: SexpDecoderImpl(from: sexp,
                                                                         codingPath: [],
                                                                         userInfo: [:]),
                                            codingPath: [],
                                            arrayValue: arrayValue)
}

internal func makeUnkeyedEncoderContainer() -> SexpEncoderImpl.UnkeyedContainer {
    SexpEncoderImpl.UnkeyedContainer(encoderImpl: SexpEncoderImpl(codingPath: [],
                                                                  userInfo: [:]),
                                     codingPath: [])
}

internal func prs5(_ text: String) throws -> Sexp {
    try Sexp.Parser(syntax: .r5rs,
                    tracing: .silent).parse(input: text)
}

internal func prs7(_ text: String) throws -> Sexp {
    try Sexp.Parser(syntax: .r7rsPartial,
                    tracing: .silent).parse(input: text)
}
