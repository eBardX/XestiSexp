// © 2025 John Gary Pusey (see LICENSE.md)

import XestiTools

extension Sexp {

    // MARK: Internal Nested Types

    internal struct Tokenizer {

        // MARK: Internal Nested Types

        internal typealias BaseTokenizer = XestiTools.Tokenizer // swiftlint:disable:this nesting
        internal typealias Rule          = BaseTokenizer.Rule   // swiftlint:disable:this nesting
        internal typealias Token         = BaseTokenizer.Token  // swiftlint:disable:this nesting

        // MARK: Internal Initializers

        internal init(syntax: Syntax,
                      tracing: Verbosity) {
            self.baseTokenizer = .init(rules: Self._makeRules(syntax),
                                       tracing: tracing)
            self.syntax = syntax
        }

        // MARK: Internal Instance Properties

        internal let syntax: Syntax

        internal var tracing: Verbosity {
            baseTokenizer.tracing
        }

        // MARK: Private Type Properties

        private static let rulesCommon: [Rule] = [.init(/'/, .quote),
                                                  .init(/`/, .quasiquote),
                                                  .init(/,/, .unquote),
                                                  .init(/,@/, .unquoteSplicing),
                                                  .init(/\(/, .pairBegin),
                                                  .init(/\)/, .sequenceEnd),
                                                  .init(/#\(/, .vectorBegin),
                                                  .init(regex: /;.*(?=[\n\r]|$)/,
                                                        disposition: .skip(nil)),
                                                  .init(regex: /[ \n\r\t]+/,
                                                        disposition: .skip(nil))]

        private static let rulesR5RS: [Rule] = [.init(regexDotR5RS, .dot),
                                                .init(regexBooleanR5RS, .boolean),
                                                .init(regexCharacterR5RS, .character),
                                                .init(regexNumberR5RS, .number),
                                                .init(regexReservedR5RS, .reserved),
                                                .init(regexStringR5RS, .string),
                                                .init(regexSymbolR5RS, .symbol)]

        private static let rulesR7RS: [Rule] = [.init(regexDotR7RS, .dot),
                                                .init(regexBooleanR7RS, .boolean),
                                                .init(regexBytevectorR7RS, .byteVectorBegin),
                                                .init(regexCharacterR7RS, .character),
                                                .init(regexNumberR7RS, .number),
                                                .init(regexReservedR7RS, .reserved),
                                                .init(regexStringR7RS, .string),
                                                .init(regexSymbolR7RS, .symbol)]

        // MARK: Private Type Methods

        private static func _makeRules(_ syntax: Syntax) -> [Rule] {
            switch syntax {
            case .r5rs:
                rulesCommon + rulesR5RS

            case .r7rsPartial:
                rulesCommon + rulesR7RS
            }
        }

        // MARK: Private Instance Properties

        private let baseTokenizer: BaseTokenizer
    }
}

// MARK: -

extension Sexp.Tokenizer {

    // MARK: Internal Instance Methods

    internal func tokenize(input: String) throws -> [Token] {
        try baseTokenizer.tokenize(input: input)
    }
}

// MARK: -

extension Tokenizer.Token.Kind {
    internal static let boolean         = Self("boolean")
    internal static let byteVectorBegin = Self("byteVectorBegin")
    internal static let character       = Self("character")
    internal static let dot             = Self("dot")
    internal static let number          = Self("number")
    internal static let pairBegin       = Self("pairBegin")
    internal static let quasiquote      = Self("quasiquote")
    internal static let quote           = Self("quote")
    internal static let reserved        = Self("reserved")
    internal static let sequenceEnd     = Self("sequenceEnd")
    internal static let string          = Self("string")
    internal static let symbol          = Self("symbol")
    internal static let unquote         = Self("unquote")
    internal static let unquoteSplicing = Self("unquoteSplicing")
    internal static let vectorBegin     = Self("vectorBegin")
}
