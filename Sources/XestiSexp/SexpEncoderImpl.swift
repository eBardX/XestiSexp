// © 2024 John Gary Pusey (see LICENSE.md)

internal final class SexpEncoderImpl {

    // MARK: Internal Initializers

    internal init(codingPath: [any CodingKey],
                  userInfo: [CodingUserInfoKey: Any]) {
        self.codingPath = codingPath
        self.userInfo = userInfo
    }

    // MARK: Internal Instance Properties

    internal let codingPath: [any CodingKey]
    internal let userInfo: [CodingUserInfoKey: Any]

    internal var sexp: Sexp {
        container?.sexp ?? .null
    }

    // MARK: Private Instance Properties

    private var container: (any SexpEncodingContainer)?
}

// MARK: - Encoder

extension SexpEncoderImpl: Encoder {

    // MARK: Internal Instance Methods

    internal func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
        precondition(container == nil)

        let tmpContainer = KeyedContainer<Key>(impl: self,
                                               codingPath: codingPath)

        container = tmpContainer

        return KeyedEncodingContainer(tmpContainer)
    }

    internal func singleValueContainer() -> any SingleValueEncodingContainer {
        precondition(container == nil)

        let tmpContainer = SingleValueContainer(impl: self,
                                                codingPath: codingPath)

        container = tmpContainer

        return tmpContainer
    }

    internal func unkeyedContainer() -> any UnkeyedEncodingContainer {
        precondition(container == nil)

        let tmpContainer = UnkeyedContainer(impl: self,
                                            codingPath: codingPath)

        container = tmpContainer

        return tmpContainer
    }
}
