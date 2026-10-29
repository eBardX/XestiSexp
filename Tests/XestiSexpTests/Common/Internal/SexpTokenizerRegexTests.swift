// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpTokenizerRegexTests {
}

// MARK: -

extension SexpTokenizerRegexTests {
    @Test
    func regexBooleanR5RS() {
        #expect("#t".wholeMatch(of: Sexp.Tokenizer.regexBooleanR5RS) != nil)
        #expect("#F".wholeMatch(of: Sexp.Tokenizer.regexBooleanR5RS) != nil)
        #expect("#true".wholeMatch(of: Sexp.Tokenizer.regexBooleanR5RS) == nil)
        #expect("#x".wholeMatch(of: Sexp.Tokenizer.regexBooleanR5RS) == nil)
    }

    @Test
    func regexBooleanR7RS() {
        #expect("#t".wholeMatch(of: Sexp.Tokenizer.regexBooleanR7RS) != nil)
        #expect("#true".wholeMatch(of: Sexp.Tokenizer.regexBooleanR7RS) != nil)
        #expect("#FALSE".wholeMatch(of: Sexp.Tokenizer.regexBooleanR7RS) != nil)
        #expect("#tru".wholeMatch(of: Sexp.Tokenizer.regexBooleanR7RS) == nil)
    }

    @Test
    func regexBytevectorR7RS() {
        #expect("#u8(".wholeMatch(of: Sexp.Tokenizer.regexBytevectorR7RS) != nil)
        #expect("#U8(".wholeMatch(of: Sexp.Tokenizer.regexBytevectorR7RS) != nil)
        #expect("#u8".wholeMatch(of: Sexp.Tokenizer.regexBytevectorR7RS) == nil)
    }

    @Test
    func regexCharacterR5RS() {
        #expect("#\\a".wholeMatch(of: Sexp.Tokenizer.regexCharacterR5RS) != nil)
        #expect("#\\(".wholeMatch(of: Sexp.Tokenizer.regexCharacterR5RS) != nil)
        #expect("#\\space".wholeMatch(of: Sexp.Tokenizer.regexCharacterR5RS) != nil)
        #expect("#\\NEWLINE".wholeMatch(of: Sexp.Tokenizer.regexCharacterR5RS) != nil)
        #expect("#\\alarm".wholeMatch(of: Sexp.Tokenizer.regexCharacterR5RS) == nil)
        #expect("#\\x41".wholeMatch(of: Sexp.Tokenizer.regexCharacterR5RS) == nil)
    }

    @Test
    func regexCharacterR7RS() {
        #expect("#\\a".wholeMatch(of: Sexp.Tokenizer.regexCharacterR7RS) != nil)
        #expect("#\\alarm".wholeMatch(of: Sexp.Tokenizer.regexCharacterR7RS) != nil)
        #expect("#\\delete".wholeMatch(of: Sexp.Tokenizer.regexCharacterR7RS) != nil)
        #expect("#\\x41".wholeMatch(of: Sexp.Tokenizer.regexCharacterR7RS) != nil)
        #expect("#\\X1F600".wholeMatch(of: Sexp.Tokenizer.regexCharacterR7RS) != nil)
        #expect("#\\bogus".wholeMatch(of: Sexp.Tokenizer.regexCharacterR7RS) == nil)
    }

    @Test
    func regexDotR5RS() {
        #expect(".".wholeMatch(of: Sexp.Tokenizer.regexDotR5RS) != nil)
        #expect("..".wholeMatch(of: Sexp.Tokenizer.regexDotR5RS) == nil)
    }

    @Test
    func regexDotR7RS() {
        #expect(".".wholeMatch(of: Sexp.Tokenizer.regexDotR7RS) != nil)
        #expect(".a".wholeMatch(of: Sexp.Tokenizer.regexDotR7RS) == nil)
    }

    @Test
    func regexNumberR5RS() {
        for text in ["0",
                     "42",
                     "-17",
                     "+3",
                     "3.25",
                     ".5",
                     "6.",
                     "1e10",
                     "2.5s-3",
                     "1/2",
                     "12#",
                     "#x1F",
                     "#b101",
                     "#o17",
                     "#d99",
                     "#e1.5",
                     "#x#i10",
                     "1+2i",
                     "-i",
                     "1@2"] {
            #expect(text.wholeMatch(of: Sexp.Tokenizer.regexNumberR5RS) != nil, "\(text)")
        }

        for text in ["abc", "#xg", "#b2", "1/", "+inf.0", "--1"] {
            #expect(text.wholeMatch(of: Sexp.Tokenizer.regexNumberR5RS) == nil, "\(text)")
        }
    }

    @Test
    func regexNumberR7RS() {
        for text in ["0",
                     "42",
                     "-17",
                     "3.25",
                     ".5",
                     "1e10",
                     "1/2",
                     "#xff",
                     "#b101",
                     "+inf.0",
                     "-nan.0",
                     "1+inf.0i",
                     "#e1.5"] {
            #expect(text.wholeMatch(of: Sexp.Tokenizer.regexNumberR7RS) != nil, "\(text)")
        }

        for text in ["abc", "12#", "2.5s-3", "inf.0", "#o8"] {
            #expect(text.wholeMatch(of: Sexp.Tokenizer.regexNumberR7RS) == nil, "\(text)")
        }
    }

    @Test
    func regexReservedR5RS() {
        for text in ["[", "]", "{", "}", "|"] {
            #expect(text.wholeMatch(of: Sexp.Tokenizer.regexReservedR5RS) != nil, "\(text)")
        }

        #expect("a".wholeMatch(of: Sexp.Tokenizer.regexReservedR5RS) == nil)
    }

    @Test
    func regexReservedR7RS() {
        for text in ["[", "]", "{", "}"] {
            #expect(text.wholeMatch(of: Sexp.Tokenizer.regexReservedR7RS) != nil, "\(text)")
        }

        #expect("|".wholeMatch(of: Sexp.Tokenizer.regexReservedR7RS) == nil)
    }

    @Test
    func regexStringR5RS() {
        #expect("\"\"".wholeMatch(of: Sexp.Tokenizer.regexStringR5RS) != nil)
        #expect("\"abc\"".wholeMatch(of: Sexp.Tokenizer.regexStringR5RS) != nil)
        #expect("\"a\\\"b\"".wholeMatch(of: Sexp.Tokenizer.regexStringR5RS) != nil)
        #expect("\"a\\\\b\"".wholeMatch(of: Sexp.Tokenizer.regexStringR5RS) != nil)
        #expect("\"a\\nb\"".wholeMatch(of: Sexp.Tokenizer.regexStringR5RS) == nil)
        #expect("\"abc".wholeMatch(of: Sexp.Tokenizer.regexStringR5RS) == nil)
    }

    @Test
    func regexStringR7RS() {
        #expect("\"abc\"".wholeMatch(of: Sexp.Tokenizer.regexStringR7RS) != nil)
        #expect("\"a\\nb\"".wholeMatch(of: Sexp.Tokenizer.regexStringR7RS) != nil)
        #expect("\"\\x41;\"".wholeMatch(of: Sexp.Tokenizer.regexStringR7RS) != nil)
        #expect("\"a\\\"b\"".wholeMatch(of: Sexp.Tokenizer.regexStringR7RS) != nil)
        #expect("\"a\\qb\"".wholeMatch(of: Sexp.Tokenizer.regexStringR7RS) == nil)
        #expect("\"abc".wholeMatch(of: Sexp.Tokenizer.regexStringR7RS) == nil)
    }

    @Test
    func regexSymbolR5RS() {
        for text in ["abc", "ABC", "list->vector", "set!", "x1", "...", "+", "-"] {
            #expect(text.wholeMatch(of: Sexp.Tokenizer.regexSymbolR5RS) != nil, "\(text)")
        }

        for text in ["1abc", "+a", ".a", "|a b|"] {
            #expect(text.wholeMatch(of: Sexp.Tokenizer.regexSymbolR5RS) == nil, "\(text)")
        }
    }

    @Test
    func regexSymbolR7RS() {
        for text in ["abc",
                     "list->vector",
                     "...",
                     "+",
                     "-",
                     "+a",
                     "-@x",
                     ".a",
                     "+.x",
                     "|a b|",
                     "||",
                     "|a\\|b|",
                     "|\\x41;|"] {
            #expect(text.wholeMatch(of: Sexp.Tokenizer.regexSymbolR7RS) != nil, "\(text)")
        }

        for text in ["1abc", "|abc", "+1"] {
            #expect(text.wholeMatch(of: Sexp.Tokenizer.regexSymbolR7RS) == nil, "\(text)")
        }
    }
}
