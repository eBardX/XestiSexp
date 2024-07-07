// © 2024 John Gary Pusey (see LICENSE.md)

extension Character {

    // MARK: Internal Instance Properties

    internal var isSexpDelimiter: Bool {
        switch self {
        case ";", "\"", "(", ")":
            return true

        default:
            return isSexpWhitespace
        }
    }

    internal var isSexpNumberHead: Bool {
        switch self {
        case "0"..."9", "-", "+":
            return true

        default:
            return false
        }
    }

    internal var isSexpNumberTail: Bool {
        switch self {
        case ".", "@", "/", "e", "E", "i", "I":
            return true

        default:
            return isSexpNumberHead
        }
    }

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

    internal var isSexpWhitespace: Bool {
        switch self {
        case "\n", "\r", "\t", " ":
            return true

        default:
            return false
        }
    }
}
