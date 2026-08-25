// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp
import XestiTokens
import XestiTools

struct SexpTokenizerTests {
}

// MARK: -

extension SexpTokenizerTests {
    @Test
    func init_setsSyntax() {
        let tokenizer = Sexp.Tokenizer(syntax: .r5rs,
                                       tracing: .silent)

        #expect(tokenizer.syntax == .r5rs)
    }

    @Test
    func tokenize_bytevectorBegin_r7rs() throws {
        let tokenizer = Sexp.Tokenizer(syntax: .r7rsPartial,
                                       tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "#u8()")

        #expect(tokens.map(\.kind) == [.byteVectorBegin,
                                       .sequenceEnd])
    }

    @Test
    func tokenize_bytevectorBegin_unrecognizedInR5RS() {
        let tokenizer = Sexp.Tokenizer(syntax: .r5rs,
                                       tracing: .silent)

        #expect(throws: (any Error).self) {
            try tokenizer.tokenize(input: "#u8()")
        }
    }

    @Test
    func tokenize_comment() throws {
        let tokenizer = Sexp.Tokenizer(syntax: .r5rs,
                                       tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "x ; a comment\ny")

        #expect(tokens.map(\.kind) == [.symbol,
                                       .symbol])
        #expect(tokens.map(\.value) == ["x",
                                        "y"])
    }

    @Test
    func tokenize_pairAndSequence() throws {
        let tokenizer = Sexp.Tokenizer(syntax: .r5rs,
                                       tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "(x . y)")

        #expect(tokens.map(\.kind) == [.pairBegin,
                                       .symbol,
                                       .dot,
                                       .symbol,
                                       .sequenceEnd])
    }

    @Test
    func tokenize_quoteFamily() throws {
        let tokenizer = Sexp.Tokenizer(syntax: .r5rs,
                                       tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "' ` , ,@")

        #expect(tokens.map(\.kind) == [.quote,
                                       .quasiquote,
                                       .unquote,
                                       .unquoteSplicing])
    }

    @Test
    func tokenize_reserved_r5rs() throws {
        let tokenizer = Sexp.Tokenizer(syntax: .r5rs,
                                       tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "|")

        #expect(tokens.map(\.kind) == [.reserved])
    }

    @Test
    func tokenize_reserved_r7rs() throws {
        let tokenizer = Sexp.Tokenizer(syntax: .r7rsPartial,
                                       tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "[")

        #expect(tokens.map(\.kind) == [.reserved])
    }

    @Test
    func tokenize_skipsWhitespace() throws {
        let tokenizer = Sexp.Tokenizer(syntax: .r5rs,
                                       tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "  x  \n\t y  ")

        #expect(tokens.map(\.kind) == [.symbol,
                                       .symbol])
    }

    @Test
    func tokenize_vectorBegin() throws {
        let tokenizer = Sexp.Tokenizer(syntax: .r5rs,
                                       tracing: .silent)
        let tokens = try tokenizer.tokenize(input: "#()")

        #expect(tokens.map(\.kind) == [.vectorBegin,
                                       .sequenceEnd])
    }

    @Test
    func tracing() {
        let tokenizer = Sexp.Tokenizer(syntax: .r5rs,
                                       tracing: .verbose)

        #expect(tokenizer.tracing == .verbose)
    }
}
