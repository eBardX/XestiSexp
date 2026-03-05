// © 2026 John Gary Pusey (see LICENSE.md)

import XestiTools

extension Sexp.Formatter {

    // MARK: Internal Nested Types

    internal struct Context {

        // MARK: Internal Instance Properties

        internal var position: Int = 0
        internal var workBuffer: String = ""
    }
}

// MARK: -

extension Sexp.Formatter.Context {

    // MARK: Internal Instance Methods

    internal mutating func emit(_ string: String) {
        workBuffer.append(string)

        position += string.count
    }

    internal mutating func emitln(_ string: String? = nil) {
        if let string {
            workBuffer.append(string)
        }

        workBuffer.append("\n")

        position = 0
    }
    internal mutating func indent(to pos: Int) {
        guard pos > position
        else { return }

        emit(String(repeating: " " as Character,
                    count: pos - position))
    }
}

// MARK: - Sendable

extension Sexp.Formatter.Context: Sendable {
}
