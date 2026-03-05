// © 2025—2026 John Gary Pusey (see LICENSE.md)

extension Sexp {

    // MARK: Public Nested Types

    /// A type that represents the syntax standard for interpreting an
    /// S-expression.
    public enum Syntax {
        /// The R⁵RS syntax standard.
        ///
        /// In particular, this refers to the syntax defined in § 7.1.2 of the
        /// [Revised⁵ Report on the Algorithmic Language
        /// Scheme](https://conservatory.scheme.org/schemers/Documents/Standards/R5RS/r5rs.pdf).
        case r5rs

        /// The R⁷RS syntax standard.
        ///
        /// In particular, this refers to the syntax defined in § 7.1.2 of the
        /// [Revised⁷ Report on the Algorithmic Language
        /// Scheme](https://small.r7rs.org/attachment/r7rs.pdf).
        ///
        /// - Note: This syntax standard is only _partially_ implemented.
        case r7rsPartial
    }
}

// MARK: - Sendable

extension Sexp.Syntax: Sendable {
}
