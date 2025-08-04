// © 2024 John Gary Pusey (see LICENSE.md)

extension Character {

    // MARK: Internal Instance Properties

    internal var isSexpSymbolHead: Bool {
        switch self {
        case "A"..."Z", "a"..."z",
            "_", ":", "!", "?", "*", "/", "&",
            "%", "^", "<", "=", ">", "~", "$":
            return true

        default:
            return false
        }
    }

    internal var isSexpSymbolTail: Bool {
        switch self {
        case "0"..."9", "-", ".", "+":
            return true

        default:
            return isSexpSymbolHead
        }
    }

    internal var sexpHexScalarValues: [String] {
        unicodeScalars.map {
            String(format: "%1$lx",
                   $0.value)
        }
    }

    internal var sexpMnemonicEscape: String? {
        switch self {
        case "\u{07}":
            "\\a"

        case "\u{08}":
            "\\b"

        case "\u{09}":
            "\\t"

        case "\u{0a}":
            "\\n"

        case "\u{0d}":
            "\\r"

        default:
            nil
        }
    }

    internal var sexpName: String? {
        switch self {
        case "\u{00}":
            "null"

        case "\u{07}":
            "alarm"

        case "\u{08}":
            "backspace"

        case "\u{09}":
            "tab"

        case "\u{0a}":
            "newline"

        case "\u{0d}":
            "return"

        case "\u{1b}":
            "escape"

        case "\u{20}":
            "space"

        case "\u{7f}":
            "delete"

        default:
            nil
        }
    }
}
