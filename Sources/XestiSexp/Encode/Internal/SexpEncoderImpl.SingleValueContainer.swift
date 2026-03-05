// © 2024–2026 John Gary Pusey (see LICENSE.md)

extension SexpEncoderImpl {

    // MARK: Internal Nested Types

    internal final class SingleValueContainer {

        // MARK: Internal Initializers

        internal init(encoderImpl: SexpEncoderImpl,
                      codingPath: [any CodingKey]) {
            self.codingPath = codingPath
            self.encoderImpl = encoderImpl
        }

        // MARK: Internal Instance Properties

        internal let codingPath: [any CodingKey]
        internal let encoderImpl: SexpEncoderImpl

        // MARK: Private Instance Properties

        private var storage: Sexp?
    }
}

// MARK: - SexpEncodingContainer

extension SexpEncoderImpl.SingleValueContainer: SexpEncodingContainer {
    internal var sexp: Sexp {
        storage.require(hint: "Single value container does not contain a value!")
    }
}

// MARK: - SingleValueEncodingContainer

extension SexpEncoderImpl.SingleValueContainer: SingleValueEncodingContainer {

    // MARK: Internal Instance Methods

    internal func encode(_ value: Bool) throws {
        try _checkStorageEmpty(value)

        storage = Sexp(boolean: value)
    }

    internal func encode(_ value: Double) throws {
        try _checkStorageEmpty(value)

        storage = Sexp(number: Sexp.Number(value))
    }

    internal func encode(_ value: Float) throws {
        try _checkStorageEmpty(value)

        storage = Sexp(number: Sexp.Number(value))
    }

    internal func encode(_ value: Int) throws {
        try _checkStorageEmpty(value)

        storage = Sexp(number: Sexp.Number(value))
    }

    internal func encode(_ value: Int8) throws {
        try _checkStorageEmpty(value)

        storage = Sexp(number: Sexp.Number(value))
    }

    internal func encode(_ value: Int16) throws {
        try _checkStorageEmpty(value)

        storage = Sexp(number: Sexp.Number(value))
    }

    internal func encode(_ value: Int32) throws {
        try _checkStorageEmpty(value)

        storage = Sexp(number: Sexp.Number(value))
    }

    internal func encode(_ value: Int64) throws {
        try _checkStorageEmpty(value)

        storage = Sexp(number: Sexp.Number(value))
    }

    @available(iOS 18.0, macOS 15.0, *)
    internal func encode(_ value: Int128) throws {
        try _checkStorageEmpty(value)

        storage = Sexp(number: Sexp.Number(value))
    }

    internal func encode(_ value: String) throws {
        try _checkStorageEmpty(value)

        if Sexp.Symbol.isSpecial(value) {
            storage = Sexp(string: value)
        } else {
            storage = Sexp(symbol: Sexp.Symbol(value, false))
        }
    }

    internal func encode(_ value: UInt) throws {
        try _checkStorageEmpty(value)

        storage = Sexp(number: Sexp.Number(value))
    }

    internal func encode(_ value: UInt8) throws {
        try _checkStorageEmpty(value)

        storage = Sexp(number: Sexp.Number(value))
    }

    internal func encode(_ value: UInt16) throws {
        try _checkStorageEmpty(value)

        storage = Sexp(number: Sexp.Number(value))
    }

    internal func encode(_ value: UInt32) throws {
        try _checkStorageEmpty(value)

        storage = Sexp(number: Sexp.Number(value))
    }

    internal func encode(_ value: UInt64) throws {
        try _checkStorageEmpty(value)

        storage = Sexp(number: Sexp.Number(value))
    }

    @available(iOS 18.0, macOS 15.0, *)
    internal func encode(_ value: UInt128) throws {
        try _checkStorageEmpty(value)

        storage = Sexp(number: Sexp.Number(value))
    }

    internal func encode<T: Encodable>(_ value: T) throws {
        try _checkStorageEmpty(value)

        if let numberValue = value as? Sexp.Number {
            storage = Sexp(number: numberValue)
        } else {
            let encoder = SexpEncoderImpl(codingPath: [],
                                          userInfo: [:])

            try value.encode(to: encoder)

            storage = encoder.sexp
        }
    }

    internal func encodeNil() throws {
        try _checkStorageEmpty(nil)

        storage = Sexp()
    }

    // MARK: Private Instance Methods

    private func _checkStorageEmpty(_ value: Any?) throws {
        guard storage == nil
        else { throw EncodingError.makeInvalidValueError(for: value as Any,
                                                         at: codingPath,
                                                         message: "Single value container already contains a value") }
    }
}
