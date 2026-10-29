// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct EncodingErrorSexpTests {
}

// MARK: -

extension EncodingErrorSexpTests {
    @Test
    func makeInvalidValueError() {
        let error = EncodingError.makeInvalidValueError(for: 42,
                                                        at: [SexpCodingKey("count")],
                                                        message: "invalid")

        guard case let .invalidValue(value, context) = error
        else { Issue.record("Unexpected error: \(error)"); return }

        #expect(value as? Int == 42)
        #expect(context.codingPath.map(\.stringValue) == ["count"])
        #expect(context.debugDescription == "invalid")
    }
}
