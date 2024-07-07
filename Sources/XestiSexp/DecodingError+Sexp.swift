// © 2024 John Gary Pusey (see LICENSE.md)

extension DecodingError {

    // MARK: Internal Type Methods

    internal static func makeDataCorruptedError(at path: [any CodingKey],
                                                message: String,
                                                underlyingError: (any Error)? = nil) -> DecodingError {
        .dataCorrupted(.init(codingPath: path,
                             debugDescription: message,
                             underlyingError: underlyingError))
    }

    internal static func makeKeyNotFoundError(for key: any CodingKey,
                                              at path: [any CodingKey],
                                              message: String) -> DecodingError {
        .keyNotFound(key,
                     .init(codingPath: path,
                           debugDescription: message))
    }

    internal static func makeTypeMismatchError(for type: Any.Type,
                                               at path: [any CodingKey],
                                               message: String) -> DecodingError {
        .typeMismatch(type,
                      .init(codingPath: path,
                            debugDescription: message))
    }

    internal static func makeValueNotFoundError(for type: Any.Type,
                                                at path: [any CodingKey],
                                                message: String) -> DecodingError {
        .valueNotFound(type,
                       .init(codingPath: path,
                             debugDescription: message))
    }
}
