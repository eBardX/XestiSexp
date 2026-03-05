// © 2024–2026 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiTools

public struct SexpDecoder {

    // MARK: Public Initializers

    public init() {
        self.syntax = .r7rsPartial
        self.tracing = .silent
        self.userInfo = [:]
    }

    // MARK: Public Instance Properties

    public var syntax: Sexp.Syntax
    public var tracing: Verbosity
    public var userInfo: [CodingUserInfoKey: Any]

    // MARK: Public Instance Methods

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
