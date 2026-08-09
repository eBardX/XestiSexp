// © 2024–2026 John Gary Pusey (see LICENSE.md)

internal struct SexpCodingKey: CodingKey {

    // MARK: Internal Initializers

    internal init(_ intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }

    internal init(_ key: any CodingKey) {
        self.intValue = key.intValue
        self.stringValue = key.stringValue
    }

    internal init(_ stringValue: String) {
        self.intValue = nil
        self.stringValue = stringValue
    }

    internal init?(intValue: Int) {
        self.init(intValue)
    }

    internal init?(stringValue: String) {
        self.init(stringValue)
    }

    // MARK: Internal Instance Properties

    internal var intValue: Int?
    internal var stringValue: String
}

// MARK: - CustomDebugStringConvertible

extension SexpCodingKey: CustomDebugStringConvertible {
    internal var debugDescription: String {
        description
    }
}

// MARK: - CustomStringConvertible

extension SexpCodingKey: CustomStringConvertible {
    internal var description: String {
        if let ival = intValue {
            return "[\(ival)]"
        }

        return stringValue
    }
}

// MARK: - Hashable

extension SexpCodingKey: Hashable {
}

// MARK: - Sendable

extension SexpCodingKey: Sendable {
}
