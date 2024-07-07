// © 2024 John Gary Pusey (see LICENSE.md)

import XestiMath

extension SexpEncoderImpl {

    // MARK: Internal Nested Types

    internal final class SingleValueContainer {

        // MARK: Internal Initializers

        internal init(impl: SexpEncoderImpl,
                      codingPath: [any CodingKey]) {
            self.codingPath = codingPath
            self.impl = impl
        }

        // MARK: Internal Instance Properties

        internal let codingPath: [any CodingKey]
        internal let impl: SexpEncoderImpl

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

        storage = .boolean(value)
    }

    internal func encode(_ value: Double) throws {
        try _checkStorageEmpty(value)

        storage = .number(Real(value))
    }

    internal func encode(_ value: Float) throws {
        try _checkStorageEmpty(value)

        storage = .number(Real(value))
    }

    internal func encode(_ value: Int) throws {
        try _checkStorageEmpty(value)

        storage = .number(Real(value))
    }

    internal func encode(_ value: Int8) throws {
        try _checkStorageEmpty(value)

        storage = .number(Real(value))
    }

    internal func encode(_ value: Int16) throws {
        try _checkStorageEmpty(value)

        storage = .number(Real(value))
    }

    internal func encode(_ value: Int32) throws {
        try _checkStorageEmpty(value)

        storage = .number(Real(value))
    }

    internal func encode(_ value: Int64) throws {
        try _checkStorageEmpty(value)

        storage = .number(Real(value))
    }

    internal func encode(_ value: String) throws {
        try _checkStorageEmpty(value)

        // Add special handling for symbols?

        storage = .symbol(value)
    }

    internal func encode(_ value: UInt) throws {
        try _checkStorageEmpty(value)

        storage = .number(Real(value))
    }

    internal func encode(_ value: UInt8) throws {
        try _checkStorageEmpty(value)

        storage = .number(Real(value))
    }

    internal func encode(_ value: UInt16) throws {
        try _checkStorageEmpty(value)

        storage = .number(Real(value))
    }

    internal func encode(_ value: UInt32) throws {
        try _checkStorageEmpty(value)

        storage = .number(Real(value))
    }

    internal func encode(_ value: UInt64) throws {
        try _checkStorageEmpty(value)

        storage = .number(Real(value))
    }

    internal func encode<T: Encodable>(_ value: T) throws {
        try _checkStorageEmpty(value)

        if let realValue = value as? Real {
            storage = .number(realValue)
        } else {
            let encoder = SexpEncoderImpl(codingPath: [],
                                          userInfo: [:])

            try value.encode(to: encoder)

            storage = encoder.sexp
        }
    }

    internal func encodeNil() throws {
        try _checkStorageEmpty(nil)

        storage = .null
    }

    // MARK: Private Instance Methods

    private func _checkStorageEmpty(_ value: Any?) throws {
        guard storage == nil
        else { throw EncodingError.makeInvalidValueError(for: value as Any,
                                                         at: codingPath,
                                                         message: "Single value container already contains a value") }
    }
}
