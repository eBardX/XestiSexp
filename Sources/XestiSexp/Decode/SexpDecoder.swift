// © 2024–2026 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiTools

/// A decoder that decodes instances of a data type from S-expressions.
public struct SexpDecoder {

    // MARK: Public Initializers

    /// Creates a new, reusable S-expression decoder with the default syntax
    /// standard and tracing verbosity.
    public init() {
        self.syntax = .r7rsPartial
        self.tracing = .silent
        self.userInfo = [:]
    }

    // MARK: Public Instance Properties

    /// The syntax standard to apply when decoding an S-expression.
    ///
    /// The default syntax standard is ``Sexp/Syntax/r7rsPartial``.
    public var syntax: Sexp.Syntax

    /// The tracing verbosity to use when decoding an S-expression.
    ///
    /// The default tracing verbosity is `.silent`.
    public var tracing: Verbosity

    /// A dictionary you use to customize the decoding process by providing
    /// contextual information.
    public var userInfo: [CodingUserInfoKey: Any]

    // MARK: Public Instance Methods

    /// Returns a value of the provided type by decoding an S-expression.
    ///
    /// - Parameter type:   The type of the value to decode from the provided
    ///                     S-expression.
    /// - Parameter data:   The S-expression to decode.
    ///
    /// - Returns:  A value of the specified type.
    public func decode<T: Decodable>(_ type: T.Type,
                                     from data: Data) throws -> T {
        let decoder = try SexpDecoderImpl(from: _parse(data),
                                          codingPath: [],
                                          userInfo: userInfo)

        return try T(from: decoder)
    }

    // MARK: Private Instance Methods

    private func _parse(_ data: Data) throws -> Sexp {
        guard let string = String(data: data,
                                  encoding: .utf8)
        else { throw DecodingError.makeDataCorruptedError(at: [],
                                                          message: "Invalid UTF-8 in data") }

        do {
            return try Sexp.Parser(syntax: syntax,
                                   tracing: tracing).parse(input: string)
        } catch let error as Sexp.Error {
            throw DecodingError.makeDataCorruptedError(at: [],
                                                       message: "Invalid S-expression in data",
                                                       underlyingError: error)
        } catch {
            throw error
        }
    }
}
