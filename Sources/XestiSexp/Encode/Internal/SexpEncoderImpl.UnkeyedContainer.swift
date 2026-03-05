// © 2024—2026 John Gary Pusey (see LICENSE.md)

extension SexpEncoderImpl {

    // MARK: Internal Nested Types

    internal final class UnkeyedContainer {

        // MARK: Internal Initializers

        internal init(encoderImpl: SexpEncoderImpl,
                      codingPath: [any CodingKey]) {
            self.codingPath = codingPath
            self.containers = []
            self.encoderImpl = encoderImpl
        }

        // MARK: Internal Instance Properties

        internal let codingPath: [any CodingKey]
        internal let encoderImpl: SexpEncoderImpl

        // MARK: Private Instance Properties

        private var containers: [any SexpEncodingContainer]
    }
}

// MARK: - SexpEncodingContainer

extension SexpEncoderImpl.UnkeyedContainer: SexpEncodingContainer {
    internal var sexp: Sexp {
        Sexp(array: containers.map { $0.sexp })
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
        let container = SexpEncoderImpl.SingleValueContainer(encoderImpl: encoderImpl,
                                                             codingPath: currentCodingPath)

        try container.encode(value)

        containers.append(container)
    }

    internal func encodeNil() throws {
        let container = SexpEncoderImpl.SingleValueContainer(encoderImpl: encoderImpl,
                                                             codingPath: currentCodingPath)

        try container.encodeNil()

        containers.append(container)
    }

    internal func nestedContainer<NestedKey: CodingKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        let container = SexpEncoderImpl.KeyedContainer<NestedKey>(encoderImpl: encoderImpl,
                                                                  codingPath: currentCodingPath)

        containers.append(container)

        return KeyedEncodingContainer(container)
    }

    internal func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer {
        let container = SexpEncoderImpl.UnkeyedContainer(encoderImpl: encoderImpl,
                                                         codingPath: currentCodingPath)

        containers.append(container)

        return container
    }

    internal func superEncoder() -> any Encoder {
        SexpEncoderImpl(codingPath: currentCodingPath,
                        userInfo: encoderImpl.userInfo)
    }

    // MARK: Private Instance Properties

    private var currentCodingPath: [any CodingKey] {
        codingPath + [SexpCodingKey(count)]
    }
}
