// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp
import XestiTools

struct SexpParserMatcherTests {
}

// MARK: -

extension SexpParserMatcherTests {
    @Test
    func matchSexp() throws {
        let parser = Sexp.Parser(syntax: .r5rs,
                                 tracing: .silent)
        let tokenizer = Sexp.Tokenizer(syntax: .r5rs,
                                       tracing: .silent)
        var matcher = try Sexp.Parser.Matcher(parser: parser,
                                              tokens: tokenizer.tokenize(input: "x"))

        #expect(try matcher.matchSexp() == Sexp(symbol: "x"))
    }

    @Test
    func matchSexp_trailingGarbage() throws {
        let parser = Sexp.Parser(syntax: .r5rs,
                                 tracing: .silent)
        let tokenizer = Sexp.Tokenizer(syntax: .r5rs,
                                       tracing: .silent)
        var matcher = try Sexp.Parser.Matcher(parser: parser,
                                              tokens: tokenizer.tokenize(input: "x y"))

        #expect(throws: Sexp.Error.self) {
            try matcher.matchSexp()
        }
    }
}
