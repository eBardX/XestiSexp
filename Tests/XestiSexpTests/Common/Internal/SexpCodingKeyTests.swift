// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpCodingKeyTests {
}

// MARK: -

extension SexpCodingKeyTests {
    @Test
    func test_debugDescription() {
        #expect(SexpCodingKey("name").debugDescription == "name")
        #expect(SexpCodingKey(42).debugDescription == "[42]")
    }

    @Test
    func test_description() {
        #expect(SexpCodingKey("name").description == "name")
        #expect(SexpCodingKey(42).description == "[42]")
    }

    @Test
    func hashable() {
        let key1 = SexpCodingKey("name")
        let key2 = SexpCodingKey("name")
        let key3 = SexpCodingKey("age")

        #expect(key1 == key2)
        #expect(key1 != key3)
    }

    @Test
    func init_codingKey() {
        let original = SexpCodingKey("test")
        let copy = SexpCodingKey(original)

        #expect(copy.stringValue == "test")
        #expect(copy.intValue == nil)
    }

    @Test
    func init_codingKey_int() {
        let original = SexpCodingKey(42)
        let copy = SexpCodingKey(original)

        #expect(copy.stringValue == "42")
        #expect(copy.intValue == 42)
    }

    @Test
    func init_int() {
        let key = SexpCodingKey(42)

        #expect(key.stringValue == "42")
        #expect(key.intValue == 42)
    }

    @Test
    func init_intValue() throws {
        let key = try #require(SexpCodingKey(intValue: 7))

        #expect(key.stringValue == "7")
        #expect(key.intValue == 7)
    }

    @Test
    func init_string() {
        let key = SexpCodingKey("name")

        #expect(key.stringValue == "name")
        #expect(key.intValue == nil)
    }

    @Test
    func init_stringValue() throws {
        let key = try #require(SexpCodingKey(stringValue: "age"))

        #expect(key.stringValue == "age")
        #expect(key.intValue == nil)
    }
}
