// © 2024 John Gary Pusey (see LICENSE.md)

import XCTest
import XestiMath
@testable import XestiSexp

internal class SexpParserTests: XCTestCase {
}

// MARK: -

extension SexpParserTests {
    func test_parse_null() throws {
        try _testParse("()", .null)
        try _testParse("  (  )     ", .null)
        try _testParse("""
                       (
                       )
                       """, .null)
        try _testParse("""
                       (    ; this is an empty list
                       )
                       """, .null)
    }

    func test_parse_number() throws {
        try _testParse("3.141592", .number(3.141592))
        try _testParse("-12345", .number(-12_345))
        try _testParse("+12345", .number(12_345))
        try _testParse("12345678901234567890", .number(Real("12345678901234567890")))
        try _testParse("1234567/890", .number(Real("1234567/890")))
        try _testParse("-456e+23", .number(-456e23))
        // try _testParse("-inf.0", .number(0))
        // try _testParse("+inf.0", .number(0))
        // try _testParse("-nan.0", .number(0))
        // try _testParse("+nan.0", .number(0))
    }

    func test_parse_pair() throws {
        try _testParse("(x . ())", .pair(.symbol("x"), .null))
        try _testParse("(x)", .pair(.symbol("x"), .null))

        try _testParse("(x . y)", .pair(.symbol("x"), .symbol("y")))
        try _testParse("(x y)", .pair(.symbol("x"), .pair(.symbol("y"), .null)))

        try _testParse("(x y . z)", .pair(.symbol("x"), .pair(.symbol("y"), .symbol("z"))))
        try _testParse("(x y z)", .pair(.symbol("x"), .pair(.symbol("y"), .pair(.symbol("z"), .null))))
    }

//    func test_parse_string() throws {
//        try _testParse("\"Bilbo\"", .string("Bilbo"))
//        try _testParse("\"Bilbo Baggins\"", .string("Bilbo Baggins"))
//        try _testParse("\"Bilbo \\\"Baggins\\\"\"", .string("Bilbo \"Baggins\""))
//    }

    func test_parse_symbol() throws {
        try _testParse("Frodo", .symbol("Frodo"))
        try _testParse("|Frodo Baggins|", .symbol("Frodo Baggins"))
        try _testParse("|Frodo \\| \"Baggins\"|", .symbol("Frodo | \"Baggins\""))
    }
}

// MARK: -

extension SexpParserTests {
    private func _testParse(_ text: String,
                            _ expectedSexp: Sexp) throws {
        let actualSexp = try Sexp.Parser.parse(text)

        XCTAssertEqual(actualSexp, expectedSexp)
    }
}
