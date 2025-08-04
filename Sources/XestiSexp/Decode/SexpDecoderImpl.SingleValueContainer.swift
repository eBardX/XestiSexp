// © 2024–2025 John Gary Pusey (see LICENSE.md)

extension SexpDecoderImpl {

    // MARK: Internal Nested Types

    internal struct SingleValueContainer {

        // MARK: Internal Initializers

        internal init(decoderImpl: SexpDecoderImpl,
                      codingPath: [any CodingKey],
                      value: Sexp) {
            self.codingPath = codingPath
            self.decoderImpl = decoderImpl
            self.value = value
        }

        // MARK: Internal Instance Properties

        internal let codingPath: [any CodingKey]
        internal let decoderImpl: SexpDecoderImpl
        internal let value: Sexp
    }
}

// MARK: - SingleValueDecodingContainer

extension SexpDecoderImpl.SingleValueContainer: SingleValueDecodingContainer {

    // MARK: Internal Instance Methods

    internal func decode(_ type: Bool.Type) throws -> Bool {
        guard let boolValue = value.booleanValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath,
                                                         message: "Expected a boolean, instead found: \(value)") }

        return boolValue
    }

    internal func decode(_ type: Double.Type) throws -> Double {
        try _fetchNumberValue(type).doubleValue
    }

    internal func decode(_ type: Float.Type) throws -> Float {
        try _fetchNumberValue(type).floatValue
    }

    internal func decode(_ type: Int.Type) throws -> Int {
        try _fetchNumberValue(type).intValue
    }

    internal func decode(_ type: Int8.Type) throws -> Int8 {
        try _fetchNumberValue(type).int8Value
    }

    internal func decode(_ type: Int16.Type) throws -> Int16 {
        try _fetchNumberValue(type).int16Value
    }

    internal func decode(_ type: Int32.Type) throws -> Int32 {
        try _fetchNumberValue(type).int32Value
    }

    internal func decode(_ type: Int64.Type) throws -> Int64 {
        try _fetchNumberValue(type).int64Value
    }

    internal func decode(_ type: String.Type) throws -> String {
        guard let stringValue = value.stringValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath,
                                                         message: "Expected a string, instead found: \(value)") }

        return stringValue
    }

    internal func decode(_ type: UInt.Type) throws -> UInt {
        try _fetchNumberValue(type).uintValue
    }

    internal func decode(_ type: UInt8.Type) throws -> UInt8 {
        try _fetchNumberValue(type).uint8Value
    }

    internal func decode(_ type: UInt16.Type) throws -> UInt16 {
        try _fetchNumberValue(type).uint16Value
    }

    internal func decode(_ type: UInt32.Type) throws -> UInt32 {
        try _fetchNumberValue(type).uint32Value
    }

    internal func decode(_ type: UInt64.Type) throws -> UInt64 {
        try _fetchNumberValue(type).uint64Value
    }

    internal func decode<T: Decodable>(_ type: T.Type) throws -> T {
        guard type == Sexp.Number.self,
              let value = try _fetchNumberValue(type) as? T
        else { return try T(from: decoderImpl) }

        return value
    }

    internal func decodeNil() -> Bool {
        value == Sexp()
    }

    // MARK: Private Instance Methods

    private func _fetchNumberValue<T>(_ type: T.Type) throws -> Sexp.Number {
        guard let numberValue = value.numberValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath,
                                                         message: "Expected a number, instead found: \(value)") }

        return numberValue
    }
}
