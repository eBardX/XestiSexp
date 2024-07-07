// © 2024 John Gary Pusey (see LICENSE.md)

import XestiMath

extension SexpDecoderImpl {

    // MARK: Internal Nested Types

    internal struct SingleValueContainer {

        // MARK: Internal Initializers

        internal init(impl: SexpDecoderImpl,
                      codingPath: [any CodingKey],
                      value: Sexp) {
            self.codingPath = codingPath
            self.impl = impl
            self.value = value
        }

        // MARK: Internal Instance Properties

        internal let codingPath: [any CodingKey]
        internal let impl: SexpDecoderImpl
        internal let value: Sexp
    }
}

// MARK: - SingleValueDecodingContainer

extension SexpDecoderImpl.SingleValueContainer: SingleValueDecodingContainer {

    // MARK: Internal Instance Methods

    internal func decode(_ type: Bool.Type) throws -> Bool {
        guard let val = value.boolValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath,
                                                         message: "Expected a boolean, instead found: \(value)") }

        return val
    }

    internal func decode(_ type: Double.Type) throws -> Double {
        try _fetchRealValue(type).doubleValue
    }

    internal func decode(_ type: Float.Type) throws -> Float {
        try _fetchRealValue(type).floatValue
    }

    internal func decode(_ type: Int.Type) throws -> Int {
        try _fetchRealValue(type).intValue
    }

    internal func decode(_ type: Int8.Type) throws -> Int8 {
        try _fetchRealValue(type).int8Value
    }

    internal func decode(_ type: Int16.Type) throws -> Int16 {
        try _fetchRealValue(type).int16Value
    }

    internal func decode(_ type: Int32.Type) throws -> Int32 {
        try _fetchRealValue(type).int32Value
    }

    internal func decode(_ type: Int64.Type) throws -> Int64 {
        try _fetchRealValue(type).int64Value
    }

    internal func decode(_ type: String.Type) throws -> String {
        guard let val = value.stringValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath,
                                                         message: "Expected a string, instead found: \(value)") }

        return val
    }

    internal func decode(_ type: UInt.Type) throws -> UInt {
        try _fetchRealValue(type).uintValue
    }

    internal func decode(_ type: UInt8.Type) throws -> UInt8 {
        try _fetchRealValue(type).uint8Value
    }

    internal func decode(_ type: UInt16.Type) throws -> UInt16 {
        try _fetchRealValue(type).uint16Value
    }

    internal func decode(_ type: UInt32.Type) throws -> UInt32 {
        try _fetchRealValue(type).uint32Value
    }

    internal func decode(_ type: UInt64.Type) throws -> UInt64 {
        try _fetchRealValue(type).uint64Value
    }

    internal func decode<T: Decodable>(_ type: T.Type) throws -> T {
        guard type == Real.self,
              let value = try _fetchRealValue(type) as? T
        else { return try T(from: impl) }

        return value
    }

    internal func decodeNil() -> Bool {
        value == .null
    }

    // MARK: Private Instance Methods

    private func _fetchRealValue<T>(_ type: T.Type) throws -> Real {
        guard let val = value.realValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath,
                                                         message: "Expected a number, instead found: \(value)") }

        return val
    }
}
