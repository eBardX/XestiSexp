// © 2026 John Gary Pusey (see LICENSE.md)

internal import XestiNumbers

extension Number {

    // MARK: Internal Instance Methods

    //
    // This exact integer as `type`, or `nil` if it's outside `type`'s range — so that decoding an
    // integer that doesn't fit throws, rather than trapping in the conversion.
    //
    internal func integer<T: FixedWidthInteger>(as type: T.Type) -> T? {
        guard self >= Self(T.min),
              self <= Self(T.max)
        else { return nil }

        return T.isSigned ? T(int128Value) : T(uint128Value)
    }
}
