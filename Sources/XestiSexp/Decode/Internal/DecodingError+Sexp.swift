// © 2024—2026 John Gary Pusey (see LICENSE.md)

extension DecodingError {

    // MARK: Internal Type Methods

    internal static func makeDataCorruptedError(at path: [any CodingKey],
                                                message: String,
                                                underlyingError: (any Error)? = nil) -> DecodingError {
        .dataCorrupted(Context(codingPath: path,
                               debugDescription: message,
                               underlyingError: underlyingError))
    }

    internal static func makeKeyNotFoundError(for key: any CodingKey,
                                              at path: [any CodingKey],
                                              message: String) -> DecodingError {
        .keyNotFound(key,
                     Context(codingPath: path,
                             debugDescription: message))
    }

    internal static func makeTypeMismatchError(for type: Any.Type,
                                               at path: [any CodingKey],
                                               message: String) -> DecodingError {
        .typeMismatch(type,
                      Context(codingPath: path,
                              debugDescription: message))
    }

    internal static func makeValueNotFoundError(for type: Any.Type,
                                                at path: [any CodingKey],
                                                message: String) -> DecodingError {
        .valueNotFound(type,
                       Context(codingPath: path,
                               debugDescription: message))
    }
}
