// © 2024 John Gary Pusey (see LICENSE.md)

import XCTest
import XestiMath
@testable import XestiSexp

internal class SexpFormatterTests: XCTestCase {
}

// MARK: -

extension SexpFormatterTests {
    func test_format_null() {
        _testFormat(.null, "()")
    }

    func test_format_number() {
        _testFormat(.number(3.141592), "3.141592")
        _testFormat(.number(-12_345), "-12345")
        _testFormat(.number(12_345), "12345")
        _testFormat(.number(Real("12345678901234567890")), "12345678901234567890")
        _testFormat(.number(Real("1234567/890")), "1234567/890")
        _testFormat(.number(-456e23), "-4.56e+25")
    }

    func test_format_pair() {
        _testFormat(.pair(.symbol("x"), .null), "(x)")

        _testFormat(.pair(.symbol("x"), .symbol("y")), "(x . y)")
        _testFormat(.pair(.symbol("x"), .pair(.symbol("y"), .null)), "(x y)")

        _testFormat(.pair(.symbol("x"), .pair(.symbol("y"), .symbol("z"))), "(x y . z)")
        _testFormat(.pair(.symbol("x"), .pair(.symbol("y"), .pair(.symbol("z"), .null))), "(x y z)")
    }

//    func test_format_string() {
//        _testFormat(.string("Bilbo"), "\"Bilbo\"")
//        _testFormat(.string("Bilbo Baggins"), "\"Bilbo Baggins\"")
//        _testFormat(.string("Bilbo \"Baggins\""), "\"Bilbo \\\"Baggins\\\"\"")
//    }

    func test_format_symbol() {
        _testFormat(.symbol("Frodo"), "Frodo")
        _testFormat(.symbol("Frodo Baggins"), "|Frodo Baggins|")
        _testFormat(.symbol("Frodo | \"Baggins\""), "|Frodo \\| \"Baggins\"|")
    }
}

// MARK: -

extension SexpFormatterTests {
    private func _testFormat(_ sexp: Sexp,
                             _ expectedText: String) {
        let actualText = Sexp.Formatter.format(sexp,
                                               prettyPrint: false)

        XCTAssertEqual(actualText, expectedText)
    }
}
