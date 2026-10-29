// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
import XestiNumbers
@testable import XestiSexp

struct NumberSexpTests {
}

// MARK: -

extension NumberSexpTests {
    @Test
    func integer_aboveMax() {
        #expect(Number(128).integer(as: Int8.self) == nil)
        #expect(Number(256).integer(as: UInt8.self) == nil)
    }

    @Test
    func integer_belowMin() {
        #expect(Number(-129).integer(as: Int8.self) == nil)
        #expect(Number(-1).integer(as: UInt.self) == nil)
    }

    @Test
    func integer_bounds() {
        #expect(Number(Int8.min).integer(as: Int8.self) == Int8.min)
        #expect(Number(Int8.max).integer(as: Int8.self) == Int8.max)
        #expect(Number(UInt64.max).integer(as: UInt64.self) == UInt64.max)
        #expect(Number(Int64.min).integer(as: Int64.self) == Int64.min)
    }

    @Test
    func integer_inRange() {
        #expect(Number(42).integer(as: Int.self) == 42)
        #expect(Number(-42).integer(as: Int16.self) == -42)
        #expect(Number(200).integer(as: UInt8.self) == 200)
    }
}
