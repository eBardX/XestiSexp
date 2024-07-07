// © 2024 John Gary Pusey (see LICENSE.md)

import XestiMath

extension SexpDecoderImpl {

    // MARK: Internal Nested Types

    internal struct KeyedContainer<Key: CodingKey> {

        // MARK: Internal Initializers

        internal init(impl: SexpDecoderImpl,
                      codingPath: [any CodingKey],
                      dictionary: [String: Sexp],
                      keys: [String]) {
            self.codingPath = codingPath
            self.dictionary = dictionary
            self.impl = impl
            self.keys = keys
        }

        // MARK: Internal Instance Properties

        internal let codingPath: [any CodingKey]
        internal let dictionary: [String: Sexp]
        internal let impl: SexpDecoderImpl
        internal let keys: [String]
    }
}

// MARK: - KeyedDecodingContainerProtocol

extension SexpDecoderImpl.KeyedContainer: KeyedDecodingContainerProtocol {

    // MARK: Internal Instance Properties

    internal var allKeys: [Key] {
        keys.compactMap { Key(stringValue: $0) }
    }

    // MARK: Internal Instance Methods

    internal func contains(_ key: Key) -> Bool {
        dictionary[key.stringValue] != nil
    }

    internal func decode(_ type: Bool.Type,
                         forKey key: Key) throws -> Bool {
        let value = try _fetchValue(key)

        guard let val = value.boolValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath + [key],
                                                         message: "Expected a boolean, instead found: \(value)") }

        return val
    }

    internal func decode(_ type: Double.Type,
                         forKey key: Key) throws -> Double {
        try _fetchRealValue(type, key).doubleValue
    }

    internal func decode(_ type: Float.Type,
                         forKey key: Key) throws -> Float {
        try _fetchRealValue(type, key).floatValue
    }

    internal func decode(_ type: Int.Type,
                         forKey key: Key) throws -> Int {
        try _fetchRealValue(type, key).intValue
    }

    internal func decode(_ type: Int8.Type,
                         forKey key: Key) throws -> Int8 {
        try _fetchRealValue(type, key).int8Value
    }

    internal func decode(_ type: Int16.Type,
                         forKey key: Key) throws -> Int16 {
        try _fetchRealValue(type, key).int16Value
    }

    internal func decode(_ type: Int32.Type,
                         forKey key: Key) throws -> Int32 {
        try _fetchRealValue(type, key).int32Value
    }

    internal func decode(_ type: Int64.Type,
                         forKey key: Key) throws -> Int64 {
        try _fetchRealValue(type, key).int64Value
    }

    internal func decode(_ type: String.Type,
                         forKey key: Key) throws -> String {
        let value = try _fetchValue(key)

        guard let val = value.stringValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath + [key],
                                                         message: "Expected a string, instead found: \(value)") }

        return val
    }

    internal func decode(_ type: UInt.Type,
                         forKey key: Key) throws -> UInt {
        try _fetchRealValue(type, key).uintValue
    }

    internal func decode(_ type: UInt8.Type,
                         forKey key: Key) throws -> UInt8 {
        try _fetchRealValue(type, key).uint8Value
    }

    internal func decode(_ type: UInt16.Type,
                         forKey key: Key) throws -> UInt16 {
        try _fetchRealValue(type, key).uint16Value
    }

    internal func decode(_ type: UInt32.Type,
                         forKey key: Key) throws -> UInt32 {
        try _fetchRealValue(type, key).uint32Value
    }

    internal func decode(_ type: UInt64.Type,
                         forKey key: Key) throws -> UInt64 {
        try _fetchRealValue(type, key).uint64Value
    }

    internal func decode<T: Decodable>(_ type: T.Type,
                                       forKey key: Key) throws -> T {
        try T(from: _decoderForKey(key))
    }

    internal func decodeNil(forKey key: Key) throws -> Bool {
        try _fetchValue(key) == .null
    }

    internal func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type,
                                             forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        try _decoderForKey(key).container(keyedBy: type)
    }

    internal func nestedUnkeyedContainer(forKey key: Key) throws -> any UnkeyedDecodingContainer {
        try _decoderForKey(key).unkeyedContainer()
    }

    internal func superDecoder() throws -> any Decoder {
        _decoderForKeyNoThrow(SexpCodingKey("super"))
    }

    internal func superDecoder(forKey key: Key) throws -> any Decoder {
        _decoderForKeyNoThrow(key)
    }

    // MARK: Private Instance Methods

    private func _decoderForKey(_ key: any CodingKey) throws -> SexpDecoderImpl {
        SexpDecoderImpl(from: try _fetchValue(key),
                        codingPath: codingPath + [key],
                        userInfo: impl.userInfo)
    }

    private func _decoderForKeyNoThrow(_ key: any CodingKey) -> SexpDecoderImpl {
        let value: Sexp

        do {
            value = try _fetchValue(key)
        } catch {
            value = .null
        }

        return SexpDecoderImpl(from: value,
                               codingPath: codingPath + [key],
                               userInfo: impl.userInfo)
    }

    private func _fetchRealValue<T>(_ type: T.Type,
                                    _ key: any CodingKey) throws -> Real {
        let value = try _fetchValue(key)

        guard let val = value.realValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath + [key],
                                                         message: "Expected a number, instead found: \(value)") }

        return val
    }

    private func _fetchValue(_ key: any CodingKey) throws -> Sexp {
        guard let value = dictionary[key.stringValue]
        else { throw DecodingError.makeKeyNotFoundError(for: key,
                                                        at: codingPath,
                                                        message: "No value associated with key \(key) (\"\(key.stringValue)\")") }

        return value
    }
}
