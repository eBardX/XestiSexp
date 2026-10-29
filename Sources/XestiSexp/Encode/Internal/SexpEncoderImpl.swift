// © 2024–2026 John Gary Pusey (see LICENSE.md)

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

    // MARK: Private Instance Properties

    private var container: (any SexpEncodingContainer)?
}

// MARK: - Encoder

extension SexpEncoderImpl: Encoder {

    // MARK: Internal Instance Methods

    internal func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
        precondition(container == nil)

        let tmpContainer = KeyedContainer<Key>(encoderImpl: self,
                                               codingPath: codingPath)

        container = tmpContainer

        return KeyedEncodingContainer(tmpContainer)
    }

    internal func singleValueContainer() -> any SingleValueEncodingContainer {
        precondition(container == nil)

        let tmpContainer = SingleValueContainer(encoderImpl: self,
                                                codingPath: codingPath)

        container = tmpContainer

        return tmpContainer
    }

    internal func unkeyedContainer() -> any UnkeyedEncodingContainer {
        precondition(container == nil)

        let tmpContainer = UnkeyedContainer(encoderImpl: self,
                                            codingPath: codingPath)

        container = tmpContainer

        return tmpContainer
    }
}

// MARK: - SexpEncodingContainer

//
// So that a super encoder can be held by the container that made it, like any nested container,
// and what's encoded through it ends up in that container's S-expression.
//
extension SexpEncoderImpl: SexpEncodingContainer {

    // MARK: Internal Instance Properties

    internal var sexp: Sexp {
        container?.sexp ?? Sexp()
    }
}
