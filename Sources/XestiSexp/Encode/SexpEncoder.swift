// © 2024—2026 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiTools

public struct SexpEncoder {

    // MARK: Public Initializers

    public init() {
        self.prettyPrint = true
        self.syntax = .r7rsPartial
        self.tracing = .silent
        self.userInfo = [:]
    }

    // MARK: Public Instance Properties

    public var prettyPrint: Bool
    public var syntax: Sexp.Syntax
    public var tracing: Verbosity
    public var userInfo: [CodingUserInfoKey: Any]

    // MARK: Public Instance Methods

    public func encode(_ value: any Encodable) throws -> Data {
        let encoder = SexpEncoderImpl(codingPath: [],
                                      userInfo: userInfo)

        try value.encode(to: encoder)

        return try _format(encoder.sexp)
    }

    // MARK: Private Instance Methods

    private func _format(_ sexp: Sexp) throws -> Data {
        let string = try Sexp.Formatter(prettyPrint: prettyPrint,
                                        syntax: syntax,
                                        tracing: tracing).format(sexp)

        guard let data = string.data(using: .utf8)
        else { throw EncodingError.makeInvalidValueError(for: string,
                                                         at: [],
                                                         message: "") }

        return data
    }
}
