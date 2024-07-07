// © 2024 John Gary Pusey (see LICENSE.md)

extension EncodingError {

    // MARK: Internal Type Methods

    internal static func makeInvalidValueError(for value: Any,
                                               at path: [any CodingKey],
                                               message: String) -> EncodingError {
        .invalidValue(value,
                      .init(codingPath: path,
                            debugDescription: message))
    }
}
