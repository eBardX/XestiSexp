// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct SexpSyntaxTests {
}

// MARK: -

extension SexpSyntaxTests {
    @Test
    func distinctCases() {
        #expect(Sexp.Syntax.r5rs != Sexp.Syntax.r7rsPartial)
    }
}
