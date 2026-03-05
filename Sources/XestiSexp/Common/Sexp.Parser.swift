// © 2024–2026 John Gary Pusey (see LICENSE.md)

import XestiMath
import XestiTools

extension Sexp {

    // MARK: Public Nested Types

    /// An S-expression parser.
    public struct Parser {

        // MARK: Public Initializers

        /// Creates a new, reusable S-expression parser with the provided syntax
        /// standard and tracing verbosity.
        ///
        /// - Parameter syntax:     The syntax standard to apply when parsing an
        ///                         S-expression.
        /// - Parameter tracing:    The tracing verbosity to use when parsing an
        ///                         S-expression.
        public init(syntax: Syntax,
                    tracing: Verbosity) {
            self.tokenizer = Sexp.Tokenizer(syntax: syntax,
                                            tracing: tracing)
        }

        // MARK: Public Instance Properties

        /// The syntax standard applied when parsing an S-expression.
        public var syntax: Syntax {
            tokenizer.syntax
        }

        /// The tracing verbosity used when parsing an S-expression.
        public var tracing: Verbosity {
            tokenizer.tracing
        }

        // MARK: Public Instance Methods

        /// Parses the provided input string into an S-expression.
        ///
        /// - Parameter input:  The input string to parse.
        ///
        /// - Returns:  The parsed S-expression.
        public func parse(input: String) throws -> Sexp {
            var matcher = try Matcher(parser: self,
                                      tokens: tokenizer.tokenize(input: input))

            return try matcher.matchSexp()
        }

        // MARK: Internal Instance Properties

        private let tokenizer: Sexp.Tokenizer
    }
}
