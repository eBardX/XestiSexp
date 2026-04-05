// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
import Testing
@testable import XestiSexp

struct SexpEncoderTests {
}

// MARK: -

extension SexpEncoderTests {
    @Test
    func test_encode_custom() throws {
        let manifest = MixedRecord(name: "foobar")
        let expectedValue = "((version 666) (name foobar))"
        let actualValue = try String(data: SexpEncoder().encode(manifest),
                                     encoding: .utf8)

        #expect(actualValue == expectedValue)
    }
}
