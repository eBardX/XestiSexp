// © 2024 John Gary Pusey (see LICENSE.md)

internal struct SexpDecoderImpl {

    // MARK: Internal Initializers

    internal init(from sexp: Sexp,
                  codingPath: [any CodingKey],
                  userInfo: [CodingUserInfoKey: Any]) {
        self.codingPath = codingPath
        self.sexp = sexp
        self.userInfo = userInfo
    }

    // MARK: Internal Instance Properties

    internal let codingPath: [any CodingKey]
    internal let sexp: Sexp
    internal let userInfo: [CodingUserInfoKey: Any]
}

// MARK: - Decoder

extension SexpDecoderImpl: Decoder {

    // MARK: Internal Instance Methods

    internal func container<Key: CodingKey>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        guard let (dictionary, keys) = sexp.dictionaryValue
        else { throw DecodingError.makeTypeMismatchError(for: [String: Sexp].self,
                                                         at: codingPath,
                                                         message: "Expected a keyed decoding container, instead found: \(sexp)") }

        return KeyedDecodingContainer(KeyedContainer<Key>(impl: self,
                                                          codingPath: codingPath,
                                                          dictionary: dictionary,
                                                          keys: keys))
    }

    internal func singleValueContainer() throws -> any SingleValueDecodingContainer {
        SingleValueContainer(impl: self,
                             codingPath: codingPath,
                             value: sexp)
    }

    internal func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
        guard let array = sexp.arrayValue
        else { throw DecodingError.makeTypeMismatchError(for: [Sexp].self,
                                                         at: codingPath,
                                                         message: "Expected an unkeyed decoding container, instead found: \(sexp)") }

        return UnkeyedContainer(impl: self,
                                codingPath: codingPath,
                                array: array)
    }
}
