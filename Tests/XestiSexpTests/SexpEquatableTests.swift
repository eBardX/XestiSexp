// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
import XestiMath
@testable import XestiSexp
import XestiTools

struct SexpEquatableTests {
}

// MARK: -

extension SexpEquatableTests {
    @Test
    func test_boolean() {
        let sexpTrue = Sexp(boolean: true)
        let sexpFalse = Sexp(boolean: false)

        #expect(sexpTrue == Sexp(boolean: true))
        #expect(sexpFalse == Sexp(boolean: false))
        #expect(sexpTrue != sexpFalse)
    }

    @Test
    func test_bytevector() {
        let sexpEmpty = Sexp(bytevector: [])
        let sexpAB = Sexp(bytevector: [1, 2])

        #expect(sexpEmpty == Sexp(bytevector: []))
        #expect(sexpAB == Sexp(bytevector: [1, 2]))
        #expect(sexpAB != Sexp(bytevector: [3, 4]))
    }

    @Test
    func test_character() {
        let sexp = Sexp(character: "a")

        #expect(sexp == Sexp(character: "a"))
        #expect(sexp != Sexp(character: "b"))
    }

    @Test
    func test_different_types() {
        #expect(Sexp(boolean: true) != Sexp(string: "true"))
        #expect(Sexp(number: 0) != Sexp(boolean: false))
        #expect(Sexp() != Sexp(string: ""))
        #expect(Sexp(string: "x") != Sexp(symbol: "x"))
    }

    @Test
    func test_null() {
        let sexp = Sexp()

        #expect(sexp == Sexp())
    }

    @Test
    func test_number() {
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
    func test_nan() {
        let sexp = Sexp(number: .nan)

        #expect(sexp == Sexp(number: .nan))
    }

    @Test
    func test_pair() {
        let sexpX = Sexp(head: Sexp(symbol: "x"))
        let sexpXY = Sexp(head: Sexp(symbol: "x"),
                          tail: Sexp(symbol: "y"))

        #expect(sexpX == Sexp(head: Sexp(symbol: "x")))
        #expect(sexpXY == Sexp(head: Sexp(symbol: "x"),
                               tail: Sexp(symbol: "y")))
        #expect(sexpX != Sexp(head: Sexp(symbol: "y")))
    }

    @Test
    func test_string() {
        let sexp = Sexp(string: "hello")
        let sexpEmpty = Sexp(string: "")

        #expect(sexp == Sexp(string: "hello"))
        #expect(sexp != Sexp(string: "world"))
        #expect(sexpEmpty == Sexp(string: ""))
    }

    @Test
    func test_symbol() {
        let sexp = Sexp(symbol: "foo")

        #expect(sexp == Sexp(symbol: "foo"))
        #expect(sexp != Sexp(symbol: "bar"))
    }

    @Test
    func test_vector() {
        let sexpEmpty = Sexp(vector: [])
        let sexpX = Sexp(vector: [Sexp(symbol: "x")])

        #expect(sexpEmpty == Sexp(vector: []))
        #expect(sexpX == Sexp(vector: [Sexp(symbol: "x")]))
        #expect(sexpX != Sexp(vector: [Sexp(symbol: "y")]))
    }
}
