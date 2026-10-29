// © 2026 John Gary Pusey (see LICENSE.md)

import XestiNumbers

class BaseRecord: Codable {
    init(a: Int) {
        self.a = a
    }

    let a: Int
}

struct BoolRecord {
    let flag: Bool
}

// MARK: - Decodable

extension BoolRecord: Decodable {
}

struct CodableRecord {
    let name: String
    let age: Int
    let active: Bool
}

// MARK: - Codable

extension CodableRecord: Codable {
}

// MARK: - Equatable

extension CodableRecord: Equatable {
}

// A subclass that encodes its superclass through a super encoder, keyed and unkeyed.
final class DerivedRecord: BaseRecord {
    init(a: Int,
         b: Int) {
        self.b = b

        super.init(a: a)
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.b = try container.decode(Int.self, forKey: .b)

        try super.init(from: container.superDecoder())
    }

    let b: Int

    override func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(b, forKey: .b)
        try super.encode(to: container.superEncoder())
    }

    private enum CodingKeys: String, CodingKey {
        case b
    }
}

struct DoubleRecord {
    let value: Double
}

// MARK: - Decodable

extension DoubleRecord: Decodable {
}

struct EmptyRecord {
}

// MARK: - Codable

extension EmptyRecord: Codable {
}

// MARK: - Equatable

extension EmptyRecord: Equatable {
}

struct MixedRecord {
    static let currentVersion = 666

    init(name: String) {
        self.name = name
        self.version = Self.currentVersion
    }

    let name: String
    let version: Int
}

// MARK: - Encodable

extension MixedRecord: Encodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case version
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(version,
                             forKey: .version)

        try container.encode(name,
                             forKey: .name)
    }
}

struct NestedRecord {
    let label: String
    let inner: SimpleRecord
}

// MARK: - Decodable

extension NestedRecord: Decodable {
}

struct NotAKeyedValueError {
}

// MARK: - Error

extension NotAKeyedValueError: Error {
}

struct NotAnUnkeyedValueError {
}

// MARK: - Error

extension NotAnUnkeyedValueError: Error {
}

// A `Number` in a keyed container, an unkeyed one, and an enum's associated value.
struct NumberRecord {
    let ratio: Number
    let ratios: [Number]
    let step: NumberStep
}

// MARK: - Codable

extension NumberRecord: Codable {
}

// MARK: - Equatable

extension NumberRecord: Equatable {
}

enum NumberStep {
    case relative(Number)
}

// MARK: - Codable

extension NumberStep: Codable {
}

// MARK: - Equatable

extension NumberStep: Equatable {
}

// Optionals whose values encode as `()`, as nil does.
struct OptionalCollectionsRecord {
    let array: [Int]?
    let empty: EmptyRecord?
    let nested: Int??
    let set: Set<Int>?
}

// MARK: - Codable

extension OptionalCollectionsRecord: Codable {
}

// MARK: - Equatable

extension OptionalCollectionsRecord: Equatable {
}

struct OptionalRecord {
    let value: String?
}

// MARK: - Decodable

extension OptionalRecord: Decodable {
}

struct SimpleCodableRecord {
    let name: String
}

// MARK: - Codable

extension SimpleCodableRecord: Codable {
}

// MARK: - Equatable

extension SimpleCodableRecord: Equatable {
}

struct SimpleRecord {
    let name: String
    let age: Int
}

// MARK: - Decodable

extension SimpleRecord: Decodable {
}

// MARK: - Equatable

extension SimpleRecord: Equatable {
}

struct UnkeyedSuperRecord {
    init(first: Int,
         inner: SimpleCodableRecord) {
        self.first = first
        self.inner = inner
    }

    init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()

        self.first = try container.decode(Int.self)
        self.inner = try SimpleCodableRecord(from: container.superDecoder())
    }

    let first: Int
    let inner: SimpleCodableRecord
}

// MARK: - Codable

extension UnkeyedSuperRecord: Codable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()

        try container.encode(first)
        try inner.encode(to: container.superEncoder())
    }
}

// MARK: - Equatable

extension UnkeyedSuperRecord: Equatable {
}
