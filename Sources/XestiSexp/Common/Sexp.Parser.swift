// © 2024–2026 John Gary Pusey (see LICENSE.md)

import XestiMath
import XestiTools

extension Sexp {

    // MARK: Public Nested Types

    public struct Parser {

        // MARK: Public Initializers

        public init(syntax: Syntax,
                    tracing: Verbosity) {
            self.tokenizer = Sexp.Tokenizer(syntax: syntax,
                                            tracing: tracing)
        }

        // MARK: Public Instance Properties

        public var syntax: Syntax {
            tokenizer.syntax
        }

        public var tracing: Verbosity {
            tokenizer.tracing
        }

        // MARK: Public Instance Methods

        public func parse(input: String) throws -> Sexp {
            var matcher = try Matcher(parser: self,
                                      tokens: tokenizer.tokenize(input: input))

            return try matcher.matchSexp()
        }

        // MARK: Internal Instance Properties

        private let tokenizer: Sexp.Tokenizer
    }
}
