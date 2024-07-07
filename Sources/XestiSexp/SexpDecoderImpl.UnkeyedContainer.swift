// © 2024 John Gary Pusey (see LICENSE.md)

import XestiMath

extension SexpDecoderImpl {

    // MARK: Internal Nested Types

    internal struct UnkeyedContainer {

        // MARK: Internal Initializers

        internal init(impl: SexpDecoderImpl,
                      codingPath: [any CodingKey],
                      array: [Sexp]) {
            self.array = array
            self.codingPath = codingPath
            self.currentIndex = 0
            self.impl = impl
        }

        // MARK: Internal Instance Properties

        internal let array: [Sexp]
        internal let codingPath: [any CodingKey]
        internal let impl: SexpDecoderImpl

        internal var currentIndex: Int
    }
}

// MARK: - UnkeyedDecodingContainer

extension SexpDecoderImpl.UnkeyedContainer: UnkeyedDecodingContainer {

    // MARK: Internal Instance Properties

    internal var count: Int? {
        array.count
    }

    internal var isAtEnd: Bool {
        currentIndex >= (count ?? 0)
    }

    // MARK: Internal Instance Methods

    internal mutating func decode(_ type: Bool.Type) throws -> Bool {
        let value = try _fetchValue(type)

        guard let val = value.boolValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath + [SexpCodingKey(currentIndex)],
                                                         message: "Expected a boolean, instead found: \(value)") }

        currentIndex += 1

        return val
    }

    internal mutating func decode(_ type: Double.Type) throws -> Double {
        try _fetchRealValue(type).doubleValue
    }

    internal mutating func decode(_ type: Float.Type) throws -> Float {
        try _fetchRealValue(type).floatValue
    }

    internal mutating func decode(_ type: Int.Type) throws -> Int {
        try _fetchRealValue(type).intValue
    }

    internal mutating func decode(_ type: Int8.Type) throws -> Int8 {
        try _fetchRealValue(type).int8Value
    }

    internal mutating func decode(_ type: Int16.Type) throws -> Int16 {
        try _fetchRealValue(type).int16Value
    }

    internal mutating func decode(_ type: Int32.Type) throws -> Int32 {
        try _fetchRealValue(type).int32Value
    }

    internal mutating func decode(_ type: Int64.Type) throws -> Int64 {
        try _fetchRealValue(type).int64Value
    }

    internal mutating func decode(_ type: String.Type) throws -> String {
        let value = try _fetchValue(type)

        guard let val = value.stringValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath + [SexpCodingKey(currentIndex)],
                                                         message: "Expected a string, instead found: \(value)") }

        currentIndex += 1

        return val
    }

    internal mutating func decode(_ type: UInt.Type) throws -> UInt {
        try _fetchRealValue(type).uintValue
    }

    internal mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        try _fetchRealValue(type).uint8Value
    }

    internal mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        try _fetchRealValue(type).uint16Value
    }

    internal mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        try _fetchRealValue(type).uint32Value
    }

    internal mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        try _fetchRealValue(type).uint64Value
    }

    internal mutating func decode<T: Decodable>(_ type: T.Type) throws -> T {
        let decoder = SexpDecoderImpl(from: try _fetchValue(type),
                                      codingPath: codingPath + [SexpCodingKey(currentIndex)],
                                      userInfo: impl.userInfo)
        let result = try T(from: decoder)

        currentIndex += 1

        return result
    }

    internal mutating func decodeNil() throws -> Bool {
        guard try _fetchValue(Never.self) == .null
        else { return false }

        currentIndex += 1

        return true
    }

    internal mutating func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
        let decoder = SexpDecoderImpl(from: try _fetchValue(KeyedDecodingContainer<NestedKey>.self),
                                      codingPath: codingPath + [SexpCodingKey(currentIndex)],
                                      userInfo: impl.userInfo)
        let container = try decoder.container(keyedBy: type)

        currentIndex += 1

        return container
    }

    internal mutating func nestedUnkeyedContainer() throws -> any UnkeyedDecodingContainer {
        let decoder = SexpDecoderImpl(from: try _fetchValue((any UnkeyedDecodingContainer).self),
                                      codingPath: codingPath + [SexpCodingKey(currentIndex)],
                                      userInfo: impl.userInfo)
        let container = try decoder.unkeyedContainer()

        currentIndex += 1

        return container
    }

    internal mutating func superDecoder() throws -> any Decoder {
        let decoder = SexpDecoderImpl(from: try _fetchValue((any Decoder).self),
                                      codingPath: codingPath + [SexpCodingKey(currentIndex)],
                                      userInfo: impl.userInfo)

        currentIndex += 1

        return decoder
    }

    // MARK: Private Instance Methods

    private mutating func _fetchRealValue<T>(_ type: T.Type) throws -> Real {
        let value = try _fetchValue(type)

        guard let val = value.realValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath + [SexpCodingKey(currentIndex)],
                                                         message: "Expected a number, instead found: \(value)") }

        currentIndex += 1

        return val
    }

    private func _fetchValue<T>(_ type: T.Type) throws -> Sexp {
        guard !isAtEnd
        else { throw DecodingError.makeValueNotFoundError(for: type,
                                                          at: codingPath + [SexpCodingKey(currentIndex)],
                                                          message: "Unkeyed decoding container is at end") }

        return array[currentIndex]
    }
}
