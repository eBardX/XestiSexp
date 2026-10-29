// © 2024–2026 John Gary Pusey (see LICENSE.md)

private import XestiTools

extension SexpEncoderImpl {

    // MARK: Internal Nested Types

    internal final class KeyedContainer<Key: CodingKey> {

        // MARK: Internal Initializers

        internal init(encoderImpl: SexpEncoderImpl,
                      codingPath: [any CodingKey]) {
            self.codingPath = codingPath
            self.containerKeys = []
            self.containers = [:]
            self.encoderImpl = encoderImpl
        }

        // MARK: Internal Instance Properties

        internal let codingPath: [any CodingKey]
        internal let encoderImpl: SexpEncoderImpl

        // MARK: Private Instance Properties

        private var containerKeys: [String]
        private var containers: [String: any SexpEncodingContainer]
    }
}

// MARK: - KeyedEncodingContainerProtocol

extension SexpEncoderImpl.KeyedContainer: KeyedEncodingContainerProtocol {

    // MARK: Internal Instance Methods

    internal func encode(_ value: some Encodable,
                         forKey key: Key) throws {
        let container = SexpEncoderImpl.SingleValueContainer(encoderImpl: encoderImpl,
                                                             codingPath: codingPath + [key])

        _register(container,
                  forKey: key)

        try container.encode(value)
    }

    internal func encodeNil(forKey key: Key) throws {
        let container = SexpEncoderImpl.SingleValueContainer(encoderImpl: encoderImpl,
                                                             codingPath: codingPath + [key])

        _register(container,
                  forKey: key)

        try container.encodeNil()
    }

    internal func nestedContainer<NestedKey: CodingKey>(keyedBy keyType: NestedKey.Type,
                                                        forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        let container = SexpEncoderImpl.KeyedContainer<NestedKey>(encoderImpl: encoderImpl,
                                                                  codingPath: codingPath + [key])

        _register(container,
                  forKey: key)

        return KeyedEncodingContainer(container)
    }

    internal func nestedUnkeyedContainer(forKey key: Key) -> any UnkeyedEncodingContainer {
        let container = SexpEncoderImpl.UnkeyedContainer(encoderImpl: encoderImpl,
                                                         codingPath: codingPath + [key])

        _register(container,
                  forKey: key)

        return container
    }

    internal func superEncoder() -> any Encoder {
        _superEncoder(forKey: SexpCodingKey("super"))
    }

    internal func superEncoder(forKey key: Key) -> any Encoder {
        _superEncoder(forKey: key)
    }

    // MARK: Private Instance Methods

    //
    // Each key appears once, where it was first encoded; encoding it again replaces its value, as
    // `JSONEncoder` does.
    //
    private func _register(_ container: any SexpEncodingContainer,
                           forKey key: any CodingKey) {
        let tmpKey = key.stringValue

        if containers.updateValue(container,
                                  forKey: tmpKey) == nil {
            containerKeys.append(tmpKey)
        }
    }

    //
    // Held under `key`, like a nested container, so that what's encoded through it isn't lost.
    // The decoder's `superDecoder()` reads the same `super` key.
    //
    private func _superEncoder(forKey key: any CodingKey) -> SexpEncoderImpl {
        let encoder = SexpEncoderImpl(codingPath: codingPath + [key],
                                      userInfo: encoderImpl.userInfo)

        _register(encoder,
                  forKey: key)

        return encoder
    }
}

// MARK: - SexpEncodingContainer

extension SexpEncoderImpl.KeyedContainer: SexpEncodingContainer {
    internal var sexp: Sexp {
        Sexp(dictionary: containers.mapValues { $0.sexp },
             orderedKeys: containerKeys)
    }
}
