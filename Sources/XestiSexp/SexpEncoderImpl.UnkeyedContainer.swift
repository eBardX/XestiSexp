// © 2024 John Gary Pusey (see LICENSE.md)

extension SexpEncoderImpl {

    // MARK: Internal Nested Types

    internal final class UnkeyedContainer {

        // MARK: Internal Initializers

        internal init(impl: SexpEncoderImpl,
                      codingPath: [any CodingKey]) {
            self.codingPath = codingPath
            self.containers = []
            self.impl = impl
        }

        // MARK: Internal Instance Properties

        internal let codingPath: [any CodingKey]
        internal let impl: SexpEncoderImpl

        // MARK: Private Instance Properties

        private var containers: [any SexpEncodingContainer]
    }
}

// MARK: - SexpEncodingContainer

extension SexpEncoderImpl.UnkeyedContainer: SexpEncodingContainer {
    internal var sexp: Sexp {
        Sexp(containers.map { $0.sexp })
    }
}

// MARK: - UnkeyedEncodingContainer

extension SexpEncoderImpl.UnkeyedContainer: UnkeyedEncodingContainer {

    // MARK: Internal Instance Properties

    internal var count: Int {
        containers.count
    }

    // MARK: Internal Instance Methods

    internal func encode<T: Encodable>(_ value: T) throws {
        let container = SexpEncoderImpl.SingleValueContainer(impl: impl,
                                                             codingPath: codingPath + [SexpCodingKey(count)])

        try container.encode(value)

        containers.append(container)
    }

    internal func encodeNil() throws {
        let container = SexpEncoderImpl.SingleValueContainer(impl: impl,
                                                             codingPath: codingPath + [SexpCodingKey(count)])

        try container.encodeNil()

        containers.append(container)
    }

    internal func nestedContainer<NestedKey: CodingKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        let container = SexpEncoderImpl.KeyedContainer<NestedKey>(impl: impl,
                                                                  codingPath: codingPath + [SexpCodingKey(count)])

        containers.append(container)

        return KeyedEncodingContainer(container)
    }

    internal func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer {
        let container = SexpEncoderImpl.UnkeyedContainer(impl: impl,
                                                         codingPath: codingPath + [SexpCodingKey(count)])

        containers.append(container)

        return container
    }

    internal func superEncoder() -> any Encoder {
        SexpEncoderImpl(codingPath: codingPath + [SexpCodingKey(count)],
                        userInfo: impl.userInfo)
    }
}
