// © 2024 John Gary Pusey (see LICENSE.md)

import Foundation

public final class SexpEncoder {

    // MARK: Public Initializers

    public init() {
    }

    // MARK: Public Instance Properties

    public var userInfo: [CodingUserInfoKey: Any] = [:]

    // MARK: Public Instance Methods

    public func encode(_ value: any Encodable) throws -> Data {
        let encoder = SexpEncoderImpl(codingPath: [],
                                      userInfo: userInfo)

        try value.encode(to: encoder)

        return try Self._format(encoder.sexp,
                                prettyPrint: true)
    }

    // MARK: Private Type Methods

    private static func _format(_ sexp: Sexp,
                                prettyPrint: Bool) throws -> Data {
        let string = Sexp.Formatter.format(sexp,
                                           prettyPrint: prettyPrint)

        guard let data = string.data(using: .utf8)
        else { throw EncodingError.makeInvalidValueError(for: string,
                                                         at: [],
                                                         message: "") }

        return data
    }
}
