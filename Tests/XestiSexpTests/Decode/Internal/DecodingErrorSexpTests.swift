// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct DecodingErrorSexpTests {
}

// MARK: -

extension DecodingErrorSexpTests {
    @Test
    func makeDataCorruptedError() {
        let path = [SexpCodingKey("a"), SexpCodingKey(1)]
        let error = DecodingError.makeDataCorruptedError(at: path,
                                                         message: "bad data")

        guard case let .dataCorrupted(context) = error
        else { Issue.record("Unexpected error: \(error)"); return }

        #expect(context.codingPath.map(\.stringValue) == ["a", "1"])
        #expect(context.debugDescription == "bad data")
        #expect(context.underlyingError == nil)
    }

    @Test
    func makeDataCorruptedError_underlyingError() {
        let error = DecodingError.makeDataCorruptedError(at: [],
                                                         message: "bad data",
                                                         underlyingError: Sexp.Error.trailingGarbage)

        guard case let .dataCorrupted(context) = error
        else { Issue.record("Unexpected error: \(error)"); return }

        #expect(context.underlyingError is Sexp.Error)
    }

    @Test
    func makeKeyNotFoundError() {
        let error = DecodingError.makeKeyNotFoundError(for: SexpCodingKey("name"),
                                                       at: [SexpCodingKey("outer")],
                                                       message: "no key")

        guard case let .keyNotFound(key, context) = error
        else { Issue.record("Unexpected error: \(error)"); return }

        #expect(key.stringValue == "name")
        #expect(context.codingPath.map(\.stringValue) == ["outer"])
        #expect(context.debugDescription == "no key")
    }

    @Test
    func makeTypeMismatchError() {
        let error = DecodingError.makeTypeMismatchError(for: Int.self,
                                                        at: [SexpCodingKey("age")],
                                                        message: "not an int")

        guard case let .typeMismatch(type, context) = error
        else { Issue.record("Unexpected error: \(error)"); return }

        #expect(type is Int.Type)
        #expect(context.codingPath.map(\.stringValue) == ["age"])
        #expect(context.debugDescription == "not an int")
    }

    @Test
    func makeValueNotFoundError() {
        let error = DecodingError.makeValueNotFoundError(for: String.self,
                                                         at: [SexpCodingKey(0)],
                                                         message: "at end")

        guard case let .valueNotFound(type, context) = error
        else { Issue.record("Unexpected error: \(error)"); return }

        #expect(type is String.Type)
        #expect(context.codingPath.map(\.stringValue) == ["0"])
        #expect(context.debugDescription == "at end")
    }
}
