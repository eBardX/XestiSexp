// © 2025–2026 John Gary Pusey (see LICENSE.md)

import Foundation
import Testing
import XestiNumbers
@testable import XestiSexp

struct SexpEncoderTests {
}

// MARK: -

extension SexpEncoderTests {
    @Test
    func encode_custom() throws {
        let manifest = MixedRecord(name: "foobar")
        let expectedValue = "((version 666) (name foobar))"
        let actualValue = try String(data: SexpEncoder().encode(manifest),
                                     encoding: .utf8)

        #expect(actualValue == expectedValue)
    }

    @Test
    func encode_numberTopLevel() throws {
        let number = Sexp.Number(numerator: 3, denominator: 4)

        #expect(try String(data: SexpEncoder().encode(number), encoding: .utf8) == "3/4")
        #expect(try String(data: SexpEncoder().encode([number]), encoding: .utf8) == "(3/4)")
    }
}
