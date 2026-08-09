// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
import XestiNumbers
@testable import XestiSexp
import XestiTools

struct SexpTests {
}

// MARK: -

extension SexpTests {
    @Test
    func array() {
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
    func boolean() {
        #expect(Sexp(boolean: false).booleanValue == false)
        #expect(Sexp(boolean: true).booleanValue == true)
    }

    @Test
    func bytevector() {
        #expect(Sexp(bytevector: []).bytevectorValue?.isEmpty ?? false)
        #expect(Sexp(bytevector: [255]).bytevectorValue == [255])
        #expect(Sexp(bytevector: [123, 45, 6]).bytevectorValue == [123, 45, 6])
    }

    @Test
    func character() {
        #expect(Sexp(character: "z").characterValue == "z")
        #expect(Sexp(character: "\u{07}").characterValue == "\u{07}")
        #expect(Sexp(character: "\n").characterValue == "\n")
        #expect(Sexp(character: " ").characterValue == " ")
        #expect(Sexp(character: "ø").characterValue == "ø")
    }

    @Test
    func description_boolean() {
        #expect(Sexp(boolean: true).description == "boolean(true)")
        #expect(Sexp(boolean: false).description == "boolean(false)")
    }

    @Test
    func description_bytevector() {
        #expect(Sexp(bytevector: []).description == "bytevector([])")
        #expect(Sexp(bytevector: [1, 2, 3]).description == "bytevector([1, 2, 3])")
    }

    @Test
    func description_character() {
        #expect(Sexp(character: "z").description == "character(z)")
    }

    @Test
    func description_null() {
        #expect(Sexp().description == "null")
    }

    @Test
    func description_number() {
        #expect(Sexp(number: 42).description == "number(42)")
    }

    @Test
    func description_pair() {
        #expect(Sexp(head: Sexp(symbol: "x")).description == "pair(symbol(x),null)")
        #expect(Sexp(head: Sexp(symbol: "x"),
                     tail: Sexp(symbol: "y")).description == "pair(symbol(x),symbol(y))")
    }

    @Test
    func description_string() {
        #expect(Sexp(string: "hello").description == "string(hello)")
    }

    @Test
    func description_symbol() {
        #expect(Sexp(symbol: "foo").description == "symbol(foo)")
    }

    @Test
    func description_vector() {
        #expect(Sexp(vector: []).description == "vector([])")
        #expect(Sexp(vector: [Sexp(symbol: "x")]).description == "vector([symbol(x)])")
    }

    @Test
    func dictionary() {
        #expect(Sexp(dictionary: [:],
                     orderedKeys: []).dictionaryValue.require() == ([:], []))
        #expect(Sexp(dictionary: ["name": Sexp(symbol: "Fubar"),
                                  "version": Sexp(number: 666)],
                     orderedKeys: ["name", "version"]).dictionaryValue.require() == (["name": Sexp(symbol: "Fubar"),
                                                                                      "version": Sexp(number: 666)],
                                                                                     ["name", "version"]))
    }

    @Test
    func equality_boolean() {
        let sexpTrue = Sexp(boolean: true)
        let sexpFalse = Sexp(boolean: false)

        #expect(sexpTrue == Sexp(boolean: true))
        #expect(sexpFalse == Sexp(boolean: false))
        #expect(sexpTrue != sexpFalse)
    }

    @Test
    func equality_bytevector() {
        let sexpEmpty = Sexp(bytevector: [])
        let sexpAB = Sexp(bytevector: [1, 2])

        #expect(sexpEmpty == Sexp(bytevector: []))
        #expect(sexpAB == Sexp(bytevector: [1, 2]))
        #expect(sexpAB != Sexp(bytevector: [3, 4]))
    }

    @Test
    func equality_character() {
        let sexp = Sexp(character: "a")

        #expect(sexp == Sexp(character: "a"))
        #expect(sexp != Sexp(character: "b"))
    }

    @Test
    func equality_differentTypes() {
        #expect(Sexp(boolean: true) != Sexp(string: "true"))
        #expect(Sexp(number: 0) != Sexp(boolean: false))
        #expect(Sexp() != Sexp(string: ""))
        #expect(Sexp(string: "x") != Sexp(symbol: "x"))
    }

    @Test
    func equality_nan() {
        let sexp = Sexp(number: .nan)

        #expect(sexp == Sexp(number: .nan))
    }

    @Test
    func equality_null() {
        let sexp = Sexp()

        #expect(sexp == Sexp())
    }

    @Test
    func equality_number() {
        let sexp42 = Sexp(number: 42)
        let sexpPi = Sexp(number: 3.14)
        let sexpPosInf = Sexp(number: .positiveInfinity)
        let sexpNegInf = Sexp(number: .negativeInfinity)

        #expect(sexp42 == Sexp(number: 42))
        #expect(sexpPi == Sexp(number: 3.14))
        #expect(sexpPosInf == Sexp(number: .positiveInfinity))
        #expect(sexpNegInf == Sexp(number: .negativeInfinity))
        #expect(sexp42 != sexpPi)
        #expect(sexpPosInf != sexpNegInf)
        #expect(sexp42 != Sexp(number: 0))
    }

    @Test
    func equality_pair() {
        let sexpX = Sexp(head: Sexp(symbol: "x"))
        let sexpXY = Sexp(head: Sexp(symbol: "x"),
                          tail: Sexp(symbol: "y"))

        #expect(sexpX == Sexp(head: Sexp(symbol: "x")))
        #expect(sexpXY == Sexp(head: Sexp(symbol: "x"),
                               tail: Sexp(symbol: "y")))
        #expect(sexpX != Sexp(head: Sexp(symbol: "y")))
    }

    @Test
    func equality_string() {
        let sexp = Sexp(string: "hello")
        let sexpEmpty = Sexp(string: "")

        #expect(sexp == Sexp(string: "hello"))
        #expect(sexp != Sexp(string: "world"))
        #expect(sexpEmpty == Sexp(string: ""))
    }

    @Test
    func equality_symbol() {
        let sexp = Sexp(symbol: "foo")

        #expect(sexp == Sexp(symbol: "foo"))
        #expect(sexp != Sexp(symbol: "bar"))
    }

    @Test
    func equality_vector() {
        let sexpEmpty = Sexp(vector: [])
        let sexpX = Sexp(vector: [Sexp(symbol: "x")])

        #expect(sexpEmpty == Sexp(vector: []))
        #expect(sexpX == Sexp(vector: [Sexp(symbol: "x")]))
        #expect(sexpX != Sexp(vector: [Sexp(symbol: "y")]))
    }

    @Test
    func init_number() {
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
    func null() {
        #expect(Sexp().isNull)
    }

    @Test
    func pair() {
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
    func string() {
        #expect(Sexp(string: "").stringValue?.isEmpty ?? false)
        #expect(Sexp(string: "Bilbo").stringValue == "Bilbo")
        #expect(Sexp(string: "Bilbo Baggins").stringValue == "Bilbo Baggins")
        #expect(Sexp(string: "Bilbo \"Bäggins\"").stringValue == "Bilbo \"Bäggins\"")
    }

    @Test
    func symbol() {
        #expect(Sexp(symbol: "").symbolValue?.stringValue.isEmpty ?? false)
        #expect(Sexp(symbol: "Frodo").symbolValue == "Frodo")
        #expect(Sexp(symbol: "Frodo Baggins").symbolValue == "Frodo Baggins")
        #expect(Sexp(symbol: "Frodo | \"Bäggins\"").symbolValue == "Frodo | \"Bäggins\"")
    }

    @Test
    func vector() {
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
