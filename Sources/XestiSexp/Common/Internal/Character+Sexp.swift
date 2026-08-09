// © 2024–2026 John Gary Pusey (see LICENSE.md)

private import Foundation

extension Character {

    // MARK: Internal Instance Properties

    internal var isSexpSymbolHead: Bool {
        switch self {
        case "_",
             ":",
             "!",
             "?",
             "*",
             "/",
             "&",
             "%",
             "^",
             "<",
             "=",
             ">",
             "~",
             "$",
             "a"..."z",
             "A"..."Z":
            true

        default:
            false
        }
    }

    internal var isSexpSymbolTail: Bool {
        switch self {
        case "-",
             ".",
             "+",
             "0"..."9":
            true

        default:
            isSexpSymbolHead
        }
    }

    internal var isSexpVisible: Bool {
        switch self {
        case "\u{00}"..."\u{1f}",
             "\u{7f}"..."\u{a0}",
             "\u{034f}":
            false

        default:
            true
        }
    }

    internal var sexpHexScalarValues: [String] {
        unicodeScalars.map {
            String(format: "%1$lx",
                   $0.value)
        }
    }

    internal var sexpMnemonicEscape: String? {
        Self.mnemonicEscapesByCharacter[self]
    }

    internal var sexpNameR5RS: String? {
        Self.namesR5RSByCharacter[self]
    }

    internal var sexpNameR7RS: String? {
        Self.namesR7RSByCharacter[self]
    }

    // MARK: Private Type Properties

    private static let mnemonicEscapesByCharacter: [Character: String] = ["\u{07}": "\\a",
                                                                          "\u{08}": "\\b",
                                                                          "\u{09}": "\\t",
                                                                          "\u{0a}": "\\n",
                                                                          "\u{0d}": "\\r"]

    private static let namesR5RSByCharacter: [Character: String] = ["\u{0a}": "newline",
                                                                    "\u{20}": "space"]

    private static let namesR7RSByCharacter: [Character: String] = ["\u{00}": "null",
                                                                    "\u{07}": "alarm",
                                                                    "\u{08}": "backspace",
                                                                    "\u{09}": "tab",
                                                                    "\u{0a}": "newline",
                                                                    "\u{0d}": "return",
                                                                    "\u{1b}": "escape",
                                                                    "\u{20}": "space",
                                                                    "\u{7f}": "delete"]
}
