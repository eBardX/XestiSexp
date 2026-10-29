// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
import XestiNumbers
@testable import XestiSexp

struct SexpNumberTests {
}

// MARK: -

extension SexpNumberTests {
    @Test
    func isXestiNumbersNumber() {
        #expect(Sexp.Number.self == XestiNumbers.Number.self)
    }

    @Test
    func numberValue_roundTrip() throws {
        let number = try #require(Sexp.Number.parse(input: "3/4"))
        let sexp = Sexp(number: number)

        #expect(sexp.numberValue == number)
    }
}
