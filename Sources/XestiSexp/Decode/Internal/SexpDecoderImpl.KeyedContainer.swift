// © 2024–2026 John Gary Pusey (see LICENSE.md)

private import XestiNumbers

extension SexpDecoderImpl {

    // MARK: Internal Nested Types

    internal struct KeyedContainer<Key: CodingKey> {

        // MARK: Internal Initializers

        internal init(decoderImpl: SexpDecoderImpl,
                      codingPath: [any CodingKey],
                      dictionary: [String: Sexp],
                      keys: [String]) {
            self.codingPath = codingPath
            self.decoderImpl = decoderImpl
            self.dictionary = dictionary
            self.keys = keys
        }

        // MARK: Internal Instance Properties

        internal let codingPath: [any CodingKey]
        internal let decoderImpl: SexpDecoderImpl
        internal let dictionary: [String: Sexp]
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

        guard let boolValue = value.booleanValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath + [key],
                                                         message: "Expected a boolean, instead found: \(value)") }

        return boolValue
    }

    internal func decode(_ type: Double.Type,
                         forKey key: Key) throws -> Double {
        try _fetchRealNumberValue(type, key).doubleValue
    }

    internal func decode(_ type: Float.Type,
                         forKey key: Key) throws -> Float {
        try _fetchRealNumberValue(type, key).floatValue
    }

    internal func decode(_ type: Int.Type,
                         forKey key: Key) throws -> Int {
        try _fetchInteger(type, key)
    }

    internal func decode(_ type: Int8.Type,
                         forKey key: Key) throws -> Int8 {
        try _fetchInteger(type, key)
    }

    internal func decode(_ type: Int16.Type,
                         forKey key: Key) throws -> Int16 {
        try _fetchInteger(type, key)
    }

    internal func decode(_ type: Int32.Type,
                         forKey key: Key) throws -> Int32 {
        try _fetchInteger(type, key)
    }

    internal func decode(_ type: Int64.Type,
                         forKey key: Key) throws -> Int64 {
        try _fetchInteger(type, key)
    }

    @available(iOS 18.0, macOS 15.0, *)
    internal func decode(_ type: Int128.Type,
                         forKey key: Key) throws -> Int128 {
        try _fetchInteger(type, key)
    }

    internal func decode(_ type: String.Type,
                         forKey key: Key) throws -> String {
        let value = try _fetchValue(key)

        guard let stringValue = value.symbolValue?.stringValue ?? value.stringValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath + [key],
                                                         message: "Expected a string or symbol, instead found: \(value)") }

        return stringValue
    }

    internal func decode(_ type: UInt.Type,
                         forKey key: Key) throws -> UInt {
        try _fetchInteger(type, key)
    }

    internal func decode(_ type: UInt8.Type,
                         forKey key: Key) throws -> UInt8 {
        try _fetchInteger(type, key)
    }

    internal func decode(_ type: UInt16.Type,
                         forKey key: Key) throws -> UInt16 {
        try _fetchInteger(type, key)
    }

    internal func decode(_ type: UInt32.Type,
                         forKey key: Key) throws -> UInt32 {
        try _fetchInteger(type, key)
    }

    internal func decode(_ type: UInt64.Type,
                         forKey key: Key) throws -> UInt64 {
        try _fetchInteger(type, key)
    }

    @available(iOS 18.0, macOS 15.0, *)
    internal func decode(_ type: UInt128.Type,
                         forKey key: Key) throws -> UInt128 {
        try _fetchInteger(type, key)
    }

    internal func decode<T: Decodable>(_ type: T.Type,
                                       forKey key: Key) throws -> T {
        try _decoderForKey(key).decodeValue(type)
    }

    //
    // Nil and an empty list are both `()`, so `()` alone can't say whether an optional is `nil` or
    // holds an empty value — an empty array, a struct with no properties, or an optional that is
    // itself `nil`.  Synthesized `Codable` leaves a `nil` optional out rather than writing `()`, so
    // a key that is present is taken to hold a value when its type can be decoded from `()`, and
    // `nil` only when it can't.
    //
    internal func decodeIfPresent<T: Decodable>(_ type: T.Type,
                                                forKey key: Key) throws -> T? {
        guard let value = dictionary[key.stringValue]
        else { return nil }

        guard value == Sexp()
        else { return try decode(type,
                                 forKey: key) }

        return try? decode(type,
                           forKey: key)
    }

    internal func decodeNil(forKey key: Key) throws -> Bool {
        try _fetchValue(key) == Sexp()
    }

    internal func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type,
                                                        forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> {
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
        try SexpDecoderImpl(from: _fetchValue(key),
                            codingPath: codingPath + [key],
                            userInfo: decoderImpl.userInfo)
    }

    private func _decoderForKeyNoThrow(_ key: any CodingKey) -> SexpDecoderImpl {
        let value: Sexp

        do {
            value = try _fetchValue(key)
        } catch {
            value = Sexp()
        }

        return SexpDecoderImpl(from: value,
                               codingPath: codingPath + [key],
                               userInfo: decoderImpl.userInfo)
    }

    private func _fetchInteger<T: FixedWidthInteger>(_ type: T.Type,
                                                     _ key: any CodingKey) throws -> T {
        let numberValue = try _fetchNumberValue(type, key)

        guard numberValue.isExact,
              numberValue.isInteger
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath + [key],
                                                         message: "Expected an exact integer, instead found: \(numberValue)") }

        guard let integer = numberValue.integer(as: type)
        else { throw DecodingError.makeDataCorruptedError(at: codingPath + [key],
                                                          message: "Number \(numberValue) does not fit in \(type)") }

        return integer
    }

    private func _fetchNumberValue(_ type: (some Any).Type,
                                   _ key: any CodingKey) throws -> Sexp.Number {
        let value = try _fetchValue(key)

        guard let numberValue = value.numberValue
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath + [key],
                                                         message: "Expected a number, instead found: \(value)") }

        return numberValue
    }

    private func _fetchRealNumberValue(_ type: (some Any).Type,
                                       _ key: any CodingKey) throws -> Sexp.Number {
        let numberValue = try _fetchNumberValue(type, key)

        guard numberValue.isReal
        else { throw DecodingError.makeTypeMismatchError(for: type,
                                                         at: codingPath + [key],
                                                         message: "Expected a real number, instead found: \(numberValue)") }

        return numberValue
    }

    private func _fetchValue(_ key: any CodingKey) throws -> Sexp {
        guard let value = dictionary[key.stringValue]
        else { throw DecodingError.makeKeyNotFoundError(for: key,
                                                        at: codingPath,
                                                        message: "No value associated with key \(key) (\"\(key.stringValue)\")") }

        return value
    }
}
