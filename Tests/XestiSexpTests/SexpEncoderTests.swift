// © 2025—2026 John Gary Pusey (see LICENSE.md)

import Foundation
import Testing
@testable import XestiSexp

struct SexpEncoderTests {
}

// MARK: -

extension SexpEncoderTests {
    @Test
    func test_encode_custom() throws {
        let manifest = Manifest(name: "foobar")
        let expectedValue = "((version 666) (name foobar))"
        let actualValue = try String(data: SexpEncoder().encode(manifest),
                                     encoding: .utf8)

        #expect(actualValue == expectedValue)
    }
}

// MARK: -

struct Manifest: Encodable {
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

    // MARK: Private Nested Types

    private enum CodingKeys: String, CodingKey {
        case name
        case version
    }
}
