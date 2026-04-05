import Foundation
@testable import XestiSexp
import XestiTools

internal func decodeText<T: Decodable>(_ type: T.Type,
                                       from text: String) throws -> T {
    try SexpDecoder().decode(type,
                             from: Data(text.utf8))
}

internal func fmt5(_ sexp: Sexp) throws -> String {
    try Sexp.Formatter(prettyPrint: false,
                       syntax: .r5rs,
                       tracing: .silent).format(sexp)
}

internal func fmt7(_ sexp: Sexp) throws -> String {
    try Sexp.Formatter(prettyPrint: false,
                       syntax: .r7rsPartial,
                       tracing: .silent).format(sexp)
}

internal func fmt7pp(_ sexp: Sexp) throws -> String {
    try Sexp.Formatter(prettyPrint: true,
                       syntax: .r7rsPartial,
                       tracing: .silent).format(sexp)
}

internal func prs5(_ text: String) throws -> Sexp {
    try Sexp.Parser(syntax: .r5rs,
                    tracing: .silent).parse(input: text)
}

internal func prs7(_ text: String) throws -> Sexp {
    try Sexp.Parser(syntax: .r7rsPartial,
                    tracing: .silent).parse(input: text)
}
