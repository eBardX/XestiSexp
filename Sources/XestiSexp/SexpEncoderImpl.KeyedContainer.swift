// © 2024 John Gary Pusey (see LICENSE.md)

import XestiTools

extension SexpEncoderImpl {

    // MARK: Internal Nested Types

    internal final class KeyedContainer<Key: CodingKey> {

        // MARK: Internal Initializers

        internal init(impl: SexpEncoderImpl,
                      codingPath: [any CodingKey]) {
            self.codingPath = codingPath
            self.containerKeys = []
            self.containers = [:]
            self.impl = impl
        }

        // MARK: Internal Instance Properties

        internal let codingPath: [any CodingKey]
        internal let impl: SexpEncoderImpl

        // MARK: Private Instance Properties

        private var containerKeys: [String]
        private var containers: [String: any SexpEncodingContainer]
    }
}

// MARK: - KeyedEncodingContainerProtocol

extension SexpEncoderImpl.KeyedContainer: KeyedEncodingContainerProtocol {

    // MARK: Internal Instance Methods

    internal func encode<T: Encodable>(_ value: T,
                                       forKey key: Key) throws {
        let container = SexpEncoderImpl.SingleValueContainer(impl: impl,
                                                             codingPath: codingPath + [key])

        let tmpKey = key.stringValue

        containers[tmpKey] = container

        containerKeys.append(tmpKey)

        try container.encode(value)
    }

    internal func encodeNil(forKey key: Key) throws {
        let container = SexpEncoderImpl.SingleValueContainer(impl: impl,
                                                             codingPath: codingPath + [key])

        let tmpKey = key.stringValue

        containers[tmpKey] = container

        containerKeys.append(tmpKey)

        try container.encodeNil()
    }

    internal func nestedContainer<NestedKey: CodingKey>(keyedBy keyType: NestedKey.Type,
                                                        forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        let container = SexpEncoderImpl.KeyedContainer<NestedKey>(impl: impl,
                                                                  codingPath: codingPath + [key])

        let tmpKey = key.stringValue

        containers[tmpKey] = container

        containerKeys.append(tmpKey)

        return KeyedEncodingContainer(container)
    }

    internal func nestedUnkeyedContainer(forKey key: Key) -> any UnkeyedEncodingContainer {
        let container = SexpEncoderImpl.UnkeyedContainer(impl: impl,
                                                         codingPath: codingPath + [key])

        let tmpKey = key.stringValue

        containers[tmpKey] = container

        containerKeys.append(tmpKey)

        return container
    }

    internal func superEncoder() -> any Encoder {
        SexpEncoderImpl(codingPath: codingPath + [SexpCodingKey("super")],
                        userInfo: impl.userInfo)
    }

    internal func superEncoder(forKey key: Key) -> any Encoder {
        SexpEncoderImpl(codingPath: codingPath + [key],
                        userInfo: impl.userInfo)
    }
}

// MARK: - SexpEncodingContainer

extension SexpEncoderImpl.KeyedContainer: SexpEncodingContainer {
    internal var sexp: Sexp {
        Sexp(containers.mapValues { $0.sexp },
             containerKeys)
    }
}
