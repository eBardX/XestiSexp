// © 2024 John Gary Pusey (see LICENSE.md)

import Foundation

public final class SexpDecoder {

    // MARK: Public Initializers

    public init() {
    }

    // MARK: Public Instance Properties

    public var userInfo: [CodingUserInfoKey: Any] = [:]

    // MARK: Public Instance Methods

    public func decode<T: Decodable>(_ type: T.Type,
                                     from data: Data) throws -> T {
        let decoder = SexpDecoderImpl(from: try Self._parse(data),
                                      codingPath: [],
                                      userInfo: userInfo)

        return try T(from: decoder)
    }

    // MARK: Private Type Methods

    private static func _parse(_ data: Data) throws -> Sexp {
        guard let string = String(data: data,
                                  encoding: .utf8)
        else { throw DecodingError.makeDataCorruptedError(at: [],
                                                          message: "Invalid UTF-8 in data") }

        do {
            return try Sexp.Parser.parse(string)
        } catch let error as Sexp.Error {
            throw DecodingError.makeDataCorruptedError(at: [],
                                                       message: "Invalid S-expression in data",
                                                       underlyingError: error)
        } catch {
            throw error
        }
    }
}
