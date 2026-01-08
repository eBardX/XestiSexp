// © 2024–2026 John Gary Pusey (see LICENSE.md)

extension SexpDecoderImpl {

    // MARK: Internal Nested Types

    internal struct UnkeyedContainer {

        // MARK: Internal Initializers

        internal init(decoderImpl: SexpDecoderImpl,
                      codingPath: [any CodingKey],
                      arrayValue: [Sexp]) {
            self.arrayValue = arrayValue
            self.codingPath = codingPath
            self.currentIndex = 0
            self.decoderImpl = decoderImpl
        }

        // MARK: Internal Instance Properties

        internal let arrayValue: [Sexp]
        internal let codingPath: [any CodingKey]
        internal let decoderImpl: SexpDecoderImpl

        internal var currentIndex: Int
    }
}

// MARK: - UnkeyedDecodingContainer

extension SexpDecoderImpl.UnkeyedContainer: UnkeyedDecodingContainer {

    // MARK: Internal Instance Properties

    internal var count: Int? {
        arrayValue.count
    }

    internal var isAtEnd: Bool {
        currentIndex >= arrayValue.count
    }

    // MARK: Internal Instance Methods

    internal mutating func decode(_ type: Bool.Type) throws -> Bool {
        let value = try _fetchValue(type)

        guard let boolValue = value.booleanValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: currentCodingPath,
                                                         message: "Expected a boolean, instead found: \(value)") }

        currentIndex += 1

        return boolValue
    }

    internal mutating func decode(_ type: Double.Type) throws -> Double {
        try _fetchNumberValue(type).doubleValue
    }

    internal mutating func decode(_ type: Float.Type) throws -> Float {
        try _fetchNumberValue(type).floatValue
    }

    internal mutating func decode(_ type: Int.Type) throws -> Int {
        try _fetchNumberValue(type).intValue
    }

    internal mutating func decode(_ type: Int8.Type) throws -> Int8 {
        try _fetchNumberValue(type).int8Value
    }

    internal mutating func decode(_ type: Int16.Type) throws -> Int16 {
        try _fetchNumberValue(type).int16Value
    }

    internal mutating func decode(_ type: Int32.Type) throws -> Int32 {
        try _fetchNumberValue(type).int32Value
    }

    internal mutating func decode(_ type: Int64.Type) throws -> Int64 {
        try _fetchNumberValue(type).int64Value
    }

    @available(iOS 18.0, macOS 15.0, *)
    internal mutating func decode(_ type: Int128.Type) throws -> Int128 {
        try _fetchNumberValue(type).int128Value
    }

    internal mutating func decode(_ type: String.Type) throws -> String {
        let value = try _fetchValue(type)

        guard let stringValue = value.symbolValue?.stringValue ?? value.stringValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: currentCodingPath,
                                                         message: "Expected a string or symbol, instead found: \(value)") }

        currentIndex += 1

        return stringValue
    }

    internal mutating func decode(_ type: UInt.Type) throws -> UInt {
        try _fetchNumberValue(type).uintValue
    }

    internal mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        try _fetchNumberValue(type).uint8Value
    }

    internal mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        try _fetchNumberValue(type).uint16Value
    }

    internal mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        try _fetchNumberValue(type).uint32Value
    }

    internal mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        try _fetchNumberValue(type).uint64Value
    }

    internal mutating func decode<T: Decodable>(_ type: T.Type) throws -> T {
        let decoder = SexpDecoderImpl(from: try _fetchValue(type),
                                      codingPath: currentCodingPath,
                                      userInfo: decoderImpl.userInfo)
        let result = try T(from: decoder)

        currentIndex += 1

        return result
    }

    internal mutating func decodeNil() throws -> Bool {
        guard try _fetchValue(Never.self) == Sexp()
        else { return false }

        currentIndex += 1

        return true
    }

    internal mutating func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
        let decoder = SexpDecoderImpl(from: try _fetchValue(KeyedDecodingContainer<NestedKey>.self),
                                      codingPath: currentCodingPath,
                                      userInfo: decoderImpl.userInfo)
        let container = try decoder.container(keyedBy: type)

        currentIndex += 1

        return container
    }

    internal mutating func nestedUnkeyedContainer() throws -> any UnkeyedDecodingContainer {
        let decoder = SexpDecoderImpl(from: try _fetchValue((any UnkeyedDecodingContainer).self),
                                      codingPath: currentCodingPath,
                                      userInfo: decoderImpl.userInfo)
        let container = try decoder.unkeyedContainer()

        currentIndex += 1

        return container
    }

    internal mutating func superDecoder() throws -> any Decoder {
        let decoder = SexpDecoderImpl(from: try _fetchValue((any Decoder).self),
                                      codingPath: currentCodingPath,
                                      userInfo: decoderImpl.userInfo)

        currentIndex += 1

        return decoder
    }

    // MARK: Private Instance Properties

    private var currentCodingPath: [any CodingKey] {
        codingPath + [SexpCodingKey(currentIndex)]
    }

    // MARK: Private Instance Methods

    private mutating func _fetchNumberValue<T>(_ type: T.Type) throws -> Sexp.Number {
        let value = try _fetchValue(type)

        guard let numberValue = value.numberValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath + [SexpCodingKey(currentIndex)],
                                                         message: "Expected a number, instead found: \(value)") }

        currentIndex += 1

        return numberValue
    }

    private func _fetchValue<T>(_ type: T.Type) throws -> Sexp {
        guard !isAtEnd
        else { throw DecodingError.makeValueNotFoundError(for: type,
                                                          at: codingPath + [SexpCodingKey(currentIndex)],
                                                          message: "Unkeyed decoding container is at end") }

        return arrayValue[currentIndex]
    }
}
