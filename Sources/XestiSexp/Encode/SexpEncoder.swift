// © 2024—2026 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiTools

/// An encoder that encodes instances of a data type as S-expressions.
public struct SexpEncoder {

    // MARK: Public Initializers

    /// Creates a new, reusable S-expression encoder with the default
    /// pretty-print, syntax standard, and tracing verbosity.
    public init() {
        self.prettyPrint = true
        self.syntax = .r7rsPartial
        self.tracing = .silent
        self.userInfo = [:]
    }

    // MARK: Public Instance Properties

    /// Specifies whether encoding should pretty-print the S-expression.
    ///
    /// By default, pretty-printing is enabled.
    public var prettyPrint: Bool

    /// The syntax standard to apply when encoding an S-expression.
    ///
    /// The default syntax standard is ``Sexp/Syntax/r7rsPartial``.
    public var syntax: Sexp.Syntax

    /// The tracing verbosity to use when encoding an S-expression.
    ///
    /// The default tracing verbosity is `.silent`.
    public var tracing: Verbosity

    /// A dictionary you use to customize the encoding process by providing
    /// contextual information.
    public var userInfo: [CodingUserInfoKey: Any]

    // MARK: Public Instance Methods

    /// Returns an S-expression that represents an encoded version of the
    /// provided value.
    ///
    /// - Parameter value:  The value to encode as an S-expression.
    ///
    /// - Returns:  The encoded S-expression.
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
