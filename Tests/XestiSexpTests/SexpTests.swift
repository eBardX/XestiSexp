// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp
import XestiTools

struct SexpTests {
}

// MARK: -

extension SexpTests {
    @Test
    func test_array() {
        #expect(Sexp(array: []).arrayValue?.isEmpty ?? false)
        #expect(Sexp(array: [Sexp(symbol: "x"),
                             Sexp()]).arrayValue == [Sexp(symbol: "x"),
                                                     Sexp()])
        #expect(Sexp(array: [Sexp(symbol: "x"),
                             Sexp(symbol: "y")]).arrayValue == [Sexp(symbol: "x"),
                                                                Sexp(symbol: "y")])
        #expect(Sexp(array: [Sexp(symbol: "x"),
                             Sexp(head: Sexp(symbol: "y"))]).arrayValue == [Sexp(symbol: "x"),
                                                                            Sexp(head: Sexp(symbol: "y"))])
        #expect(Sexp(array: [Sexp(symbol: "x"),
                             Sexp(head: Sexp(symbol: "y"),
                                  tail: Sexp(symbol: "z"))]).arrayValue == [Sexp(symbol: "x"),
                                                                            Sexp(head: Sexp(symbol: "y"),
                                                                                 tail: Sexp(symbol: "z"))])
        #expect(Sexp(array: [Sexp(symbol: "x"),
                             Sexp(array: [Sexp(symbol: "y"),
                                          Sexp(head: Sexp(symbol: "z"))])]).arrayValue == [Sexp(symbol: "x"),
                                                                                           Sexp(array: [Sexp(symbol: "y"),
                                                                                                        Sexp(head: Sexp(symbol: "z"))])])
    }

    @Test
    func test_boolean() {
        #expect(Sexp(boolean: false).booleanValue == false)
        #expect(Sexp(boolean: true).booleanValue == true)
    }

    @Test
    func test_bytevector() {
        #expect(Sexp(bytevector: []).bytevectorValue?.isEmpty ?? false)
        #expect(Sexp(bytevector: [255]).bytevectorValue == [255])
        #expect(Sexp(bytevector: [123, 45, 6]).bytevectorValue == [123, 45, 6])
    }

    @Test
    func test_character() {
        #expect(Sexp(character: "z").characterValue == "z")
        #expect(Sexp(character: "\u{07}").characterValue == "\u{07}")
        #expect(Sexp(character: "\n").characterValue == "\n")
        #expect(Sexp(character: " ").characterValue == " ")
        #expect(Sexp(character: "ø").characterValue == "ø")
    }

    @Test
    func test_dictionary() {
        #expect(Sexp(dictionary: [:],
                     orderedKeys: []).dictionaryValue.require() == ([:], []))
        #expect(Sexp(dictionary: ["name": Sexp(symbol: "Fubar"),
                                  "version": Sexp(number: 666)],
                     orderedKeys: ["name", "version"]).dictionaryValue.require() == (["name": Sexp(symbol: "Fubar"),
                                                                                      "version": Sexp(number: 666)],
                                                                                     ["name", "version"]))
    }

    @Test
    func test_null() {
        #expect(Sexp().isNullValue)
    }

    @Test
    func test_init_number() {
        #expect(Sexp(number: 3.141592).numberValue == 3.141592)
        #expect(Sexp(number: -12_345).numberValue == -12_345)
        #expect(Sexp(number: 12_345).numberValue == 12_345)
        #expect(Sexp(number: "12345678901234567890").numberValue == "12345678901234567890")
        #expect(Sexp(number: "1234567/890").numberValue == "1234567/890")
        #expect(Sexp(number: -456e23).numberValue == -456e23)
        #expect(Sexp(number: .negativeInfinity).numberValue == .negativeInfinity)
        #expect(Sexp(number: .positiveInfinity).numberValue == .positiveInfinity)
        #expect(Sexp(number: .nan).numberValue?.isNaN ?? false)
    }

    @Test
    func test_pair() {
        #expect(Sexp(head: Sexp(symbol: "x")).pairValue.require() == (Sexp(symbol: "x"), nil))
        #expect(Sexp(head: Sexp(symbol: "x"),
                     tail: Sexp(symbol: "y")).pairValue.require() == (Sexp(symbol: "x"),
                                                                      Sexp(symbol: "y")))
        #expect(Sexp(head: Sexp(symbol: "x"),
                     tail: Sexp(head: Sexp(symbol: "y"))).pairValue.require() == (Sexp(symbol: "x"),
                                                                                  Sexp(head: Sexp(symbol: "y"))))
        #expect(Sexp(head: Sexp(symbol: "x"),
                     tail: Sexp(head: Sexp(symbol: "y"),
                                tail: Sexp(symbol: "z"))).pairValue.require() == (Sexp(symbol: "x"),
                                                                                  Sexp(head: Sexp(symbol: "y"),
                                                                                       tail: Sexp(symbol: "z"))))
        #expect(Sexp(head: Sexp(symbol: "x"),
                     tail: Sexp(head: Sexp(symbol: "y"),
                                tail: Sexp(head: Sexp(symbol: "z")))).pairValue.require() == (Sexp(symbol: "x"),
                                                                                              Sexp(head: Sexp(symbol: "y"),
                                                                                                   tail: Sexp(head: Sexp(symbol: "z")))))
    }

    @Test
    func test_string() {
        #expect(Sexp(string: "Bilbo").stringValue == "Bilbo")
        #expect(Sexp(string: "Bilbo Baggins").stringValue == "Bilbo Baggins")
        #expect(Sexp(string: "Bilbo \"Bäggins\"").stringValue == "Bilbo \"Bäggins\"")
    }

    @Test
    func test_symbol() {
        #expect(Sexp(symbol: "Frodo").symbolValue == "Frodo")
        #expect(Sexp(symbol: "Frodo Baggins").symbolValue == "Frodo Baggins")
        #expect(Sexp(symbol: "Frodo | \"Bäggins\"").symbolValue == "Frodo | \"Bäggins\"")
    }

    @Test
    func test_vector() {
        #expect(Sexp(vector: []).vectorValue?.isEmpty ?? false)
        #expect(Sexp(vector: [Sexp(symbol: "x"),
                              Sexp()]).vectorValue == [Sexp(symbol: "x"),
                                                       Sexp()])
        #expect(Sexp(vector: [Sexp(symbol: "x"),
                              Sexp(symbol: "y")]).vectorValue == [Sexp(symbol: "x"),
                                                                  Sexp(symbol: "y")])
        #expect(Sexp(vector: [Sexp(symbol: "x"),
                              Sexp(head: Sexp(symbol: "y"))]).vectorValue == [Sexp(symbol: "x"),
                                                                              Sexp(head: Sexp(symbol: "y"))])
        #expect(Sexp(vector: [Sexp(symbol: "x"),
                              Sexp(head: Sexp(symbol: "y"),
                                   tail: Sexp(symbol: "z"))]).vectorValue == [Sexp(symbol: "x"),
                                                                              Sexp(head: Sexp(symbol: "y"),
                                                                                   tail: Sexp(symbol: "z"))])
        #expect(Sexp(vector: [Sexp(symbol: "x"),
                              Sexp(vector: [Sexp(symbol: "y"),
                                            Sexp(head: Sexp(symbol: "z"))])]).vectorValue == [Sexp(symbol: "x"),
                                                                                              Sexp(vector: [Sexp(symbol: "y"),
                                                                                                            Sexp(head: Sexp(symbol: "z"))])])
    }
}
