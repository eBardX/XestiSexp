// © 2026 John Gary Pusey (see LICENSE.md)

struct BoolRecord: Decodable {
    let flag: Bool
}

struct CodableRecord: Codable, Equatable {
    let name: String
    let age: Int
    let active: Bool
}

struct DoubleRecord: Decodable {
    let value: Double
}

struct MixedRecord: Encodable {
    static let currentVersion = 666

    init(name: String) {
        self.name = name
        self.version = Self.currentVersion
    }

    let name: String
    let version: Int

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(version,
                             forKey: .version)

        try container.encode(name,
                             forKey: .name)
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case version
    }
}

struct NestedRecord: Decodable {
    let label: String
    let inner: SimpleRecord
}

struct OptionalRecord: Decodable {
    let value: String?
}

struct SimpleRecord: Decodable, Equatable {
    let name: String
    let age: Int
}
