// © 2024–2026 John Gary Pusey (see LICENSE.md)

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

// MARK: -

extension SexpDecoderImpl {

    // MARK: Internal Instance Methods

    //
    // Decodes a value of `type` from this decoder's S-expression — the one way every container,
    // and `SexpDecoder` itself, decodes a nested value.  A `Sexp.Number` is read straight from a
    // number atom, which is how the encoder writes one in any container; `Number`'s own
    // `init(from:)` expects a string, so it's used only when the S-expression isn't a number atom.
    //
    internal func decodeValue<T: Decodable>(_ type: T.Type) throws -> T {
        if type == Sexp.Number.self,
           let numberValue = sexp.numberValue as? T {
            return numberValue
        }

        return try T(from: self)
    }
}

// MARK: - Decoder

extension SexpDecoderImpl: Decoder {

    // MARK: Internal Instance Methods

    internal func container<Key: CodingKey>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        guard let (dictionary, orderedKeys) = sexp.dictionaryValue
        else { throw DecodingError.makeTypeMismatchError(for: [String: Sexp].self,
                                                         at: codingPath,
                                                         message: "Expected a keyed decoding container, instead found: \(sexp)") }

        return KeyedDecodingContainer(KeyedContainer<Key>(decoderImpl: self,
                                                          codingPath: codingPath,
                                                          dictionary: dictionary,
                                                          keys: orderedKeys))
    }

    internal func singleValueContainer() throws -> any SingleValueDecodingContainer {
        SingleValueContainer(decoderImpl: self,
                             codingPath: codingPath,
                             value: sexp)
    }

    internal func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
        guard let arrayValue = sexp.arrayValue
        else { throw DecodingError.makeTypeMismatchError(for: [Sexp].self,
                                                         at: codingPath,
                                                         message: "Expected an unkeyed decoding container, instead found: \(sexp)") }

        return UnkeyedContainer(decoderImpl: self,
                                codingPath: codingPath,
                                arrayValue: arrayValue)
    }
}
