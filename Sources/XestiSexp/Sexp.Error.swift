// © 2024 John Gary Pusey (see LICENSE.md)

extension Sexp {

    // MARK: Public Nested Types

    public enum Error: Swift.Error {
        case badChar(Character)
        case badEscape
        case badExpression
        case badList
        case badNumber(String)
        case endOfString
    }
}
