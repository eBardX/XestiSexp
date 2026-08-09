// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiSexp

struct CharacterSexpTests {
}

// MARK: -

extension CharacterSexpTests {
    @Test
    func isSexpSymbolHead() {
        #expect(Character("a").isSexpSymbolHead)
        #expect(Character("Z").isSexpSymbolHead)
        #expect(Character("_").isSexpSymbolHead)
        #expect(Character(":").isSexpSymbolHead)
        #expect(Character("!").isSexpSymbolHead)
        #expect(Character("?").isSexpSymbolHead)
        #expect(Character("*").isSexpSymbolHead)
        #expect(Character("/").isSexpSymbolHead)
        #expect(Character("&").isSexpSymbolHead)
        #expect(Character("%").isSexpSymbolHead)
        #expect(Character("^").isSexpSymbolHead)
        #expect(Character("<").isSexpSymbolHead)
        #expect(Character("=").isSexpSymbolHead)
        #expect(Character(">").isSexpSymbolHead)
        #expect(Character("~").isSexpSymbolHead)
        #expect(Character("$").isSexpSymbolHead)
        #expect(!Character("0").isSexpSymbolHead)
        #expect(!Character("-").isSexpSymbolHead)
        #expect(!Character(".").isSexpSymbolHead)
        #expect(!Character("+").isSexpSymbolHead)
        #expect(!Character(" ").isSexpSymbolHead)
        #expect(!Character("(").isSexpSymbolHead)
    }

    @Test
    func isSexpSymbolTail() {
        #expect(Character("a").isSexpSymbolTail)
        #expect(Character("Z").isSexpSymbolTail)
        #expect(Character("0").isSexpSymbolTail)
        #expect(Character("9").isSexpSymbolTail)
        #expect(Character("-").isSexpSymbolTail)
        #expect(Character(".").isSexpSymbolTail)
        #expect(Character("+").isSexpSymbolTail)
        #expect(Character("_").isSexpSymbolTail)
        #expect(!Character(" ").isSexpSymbolTail)
        #expect(!Character("(").isSexpSymbolTail)
        #expect(!Character(")").isSexpSymbolTail)
    }

    @Test
    func isSexpVisible() {
        #expect(Character("a").isSexpVisible)
        #expect(Character("Z").isSexpVisible)
        #expect(Character("0").isSexpVisible)
        #expect(Character("ø").isSexpVisible)
        #expect(!Character("\u{00}").isSexpVisible)
        #expect(!Character("\u{1f}").isSexpVisible)
        #expect(!Character("\u{7f}").isSexpVisible)
        #expect(!Character("\u{a0}").isSexpVisible)
        #expect(!Character("\u{034f}").isSexpVisible)
    }

    @Test
    func sexpHexScalarValues() {
        #expect(Character("a").sexpHexScalarValues == ["61"])
        #expect(Character("ø").sexpHexScalarValues == ["f8"])
        #expect(Character("\u{00}").sexpHexScalarValues == ["0"])
    }

    @Test
    func sexpMnemonicEscape() {
        #expect(Character("\u{07}").sexpMnemonicEscape == "\\a")
        #expect(Character("\u{08}").sexpMnemonicEscape == "\\b")
        #expect(Character("\u{09}").sexpMnemonicEscape == "\\t")
        #expect(Character("\u{0a}").sexpMnemonicEscape == "\\n")
        #expect(Character("\u{0d}").sexpMnemonicEscape == "\\r")
        #expect(Character("a").sexpMnemonicEscape == nil)
        #expect(Character(" ").sexpMnemonicEscape == nil)
    }

    @Test
    func sexpNameR5RS() {
        #expect(Character("\u{0a}").sexpNameR5RS == "newline")
        #expect(Character("\u{20}").sexpNameR5RS == "space")
        #expect(Character("a").sexpNameR5RS == nil)
        #expect(Character("\u{07}").sexpNameR5RS == nil)
    }

    @Test
    func sexpNameR7RS() {
        #expect(Character("\u{00}").sexpNameR7RS == "null")
        #expect(Character("\u{07}").sexpNameR7RS == "alarm")
        #expect(Character("\u{08}").sexpNameR7RS == "backspace")
        #expect(Character("\u{09}").sexpNameR7RS == "tab")
        #expect(Character("\u{0a}").sexpNameR7RS == "newline")
        #expect(Character("\u{0d}").sexpNameR7RS == "return")
        #expect(Character("\u{1b}").sexpNameR7RS == "escape")
        #expect(Character("\u{20}").sexpNameR7RS == "space")
        #expect(Character("\u{7f}").sexpNameR7RS == "delete")
        #expect(Character("a").sexpNameR7RS == nil)
    }
}
