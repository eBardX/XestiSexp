// © 2025 John Gary Pusey (see LICENSE.md)

import RegexBuilder

// swiftlint:disable file_length

extension Sexp.Tokenizer {

    // MARK: Internal Type Properties

    internal static let regexBooleanR5RS = Regex<Substring> {
        "#"
        boolean
        delimiterLookaheadR5RS
    }.ignoresCase()

    internal static let regexBooleanR7RS = Regex<Substring> {
        "#"
        ChoiceOf {
            boolean
            "false"
            "true"
        }
        delimiterLookaheadR7RS
    }.ignoresCase()

    internal static let regexBytevectorR7RS = Regex<Substring> {
        "#u8("
    }.ignoresCase()

    internal static let regexCharacterR5RS = Regex<Substring> {
        ChoiceOf {
            charAny
            charNameR5RS
        }
        delimiterLookaheadR5RS
    }

    internal static let regexCharacterR7RS = Regex<Substring> {
        ChoiceOf {
            charAny
            charNameR7RS
            charHexScalarValueR7RS
        }
        delimiterLookaheadR7RS
    }

    internal static let regexDotR5RS = Regex<Substring> {
        "."
        delimiterLookaheadR5RS
    }

    internal static let regexDotR7RS = Regex<Substring> {
        "."
        delimiterLookaheadR7RS
    }

    internal static let regexNumberR5RS = Regex<Substring> {
        ChoiceOf {
            binNumberR5RS
            octNumberR5RS
            decNumberR5RS
            hexNumberR5RS
        }
        delimiterLookaheadR5RS
    }.ignoresCase()

    internal static let regexNumberR7RS = Regex<Substring> {
        ChoiceOf {
            binNumberR7RS
            octNumberR7RS
            decNumberR7RS
            hexNumberR7RS
        }
        delimiterLookaheadR7RS
    }.ignoresCase()

    internal static let regexReservedR5RS = Regex<Substring> {
        reservedR5RS
    }

    internal static let regexReservedR7RS = Regex<Substring> {
        reservedR7RS
    }

    internal static let regexStringR5RS = Regex<Substring> {
        "\""
        ZeroOrMore {
            strElementR5RS
        }
        "\""
    }

    internal static let regexStringR7RS = Regex<Substring> {
        "\""
        ZeroOrMore {
            strElementR7RS
        }
        "\""
    }

    internal static let regexSymbolR5RS = Regex<Substring> {
        ChoiceOf {
            "..."
            sign
            Regex<Substring> {
                symInitial
                ZeroOrMore {
                    symSubsequent
                }
            }.ignoresCase()
        }
        delimiterLookaheadR5RS
    }

    internal static let regexSymbolR7RS = Regex<Substring> {
        ChoiceOf {
            symPeculiarR7RS
            Regex<Substring> {
                symInitial
                ZeroOrMore {
                    symSubsequent
                }
            }.ignoresCase()
            Regex<Substring> {
                "|"
                ZeroOrMore {
                    symElementR7RS
                }
                "|"
            }
        }
        delimiterLookaheadR7RS
    }
}

// MARK: -

extension Sexp.Tokenizer {

    // MARK: Private Type Properties

    private static let binComplexR5RS = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                binRealR5RS
                Optionally {
                    ChoiceOf {
                        Regex<Substring> {
                            "@"
                            binRealR5RS
                        }
                        Regex<Substring> {
                            sign
                            Optionally {
                                binURealR5RS
                            }
                            "i"
                        }
                    }
                }
            }
            Regex<Substring> {
                sign
                Optionally {
                    binURealR5RS
                }
                "i"
            }
        }
    }.ignoresCase()

    private static let binComplexR7RS = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                binRealR7RS
                Optionally {
                    ChoiceOf {
                        Regex<Substring> {
                            "@"
                            binRealR7RS
                        }
                        Regex<Substring> {
                            sign
                            Optionally {
                                ChoiceOf {
                                    binURealR7RS
                                    infnanR7RS
                                }
                            }
                            "i"
                        }
                    }
                }
            }
            Regex<Substring> {
                sign
                Optionally {
                    ChoiceOf {
                        binURealR7RS
                        infnanR7RS
                    }
                }
                "i"
            }
        }
    }.ignoresCase()

    private static let binNumberR5RS = Regex<Substring> {
        binPrefix
        binComplexR5RS
    }

    private static let binNumberR7RS = Regex<Substring> {
        binPrefix
        binComplexR7RS
    }

    private static let binPrefix = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                binRadix
                exactness
            }
            Regex<Substring> {
                exactness
                binRadix
            }
        }
    }

    private static let binRadix = Regex<Substring> {
        "#b"
    }.ignoresCase()

    private static let binRealR5RS = Regex<Substring> {
        Regex<Substring> {
            Optionally {
                sign
            }
            binURealR7RS
        }
    }

    private static let binRealR7RS = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                Optionally {
                    sign
                }
                binURealR7RS
            }
            Regex<Substring> {
                sign
                infnanR7RS
            }
        }
    }

    private static let binUIntegerR5RS = Regex<Substring> {
        OneOrMore {
            binDigit
        }
        ZeroOrMore {
            "#"
        }
    }

    private static let binUIntegerR7RS = Regex<Substring> {
        OneOrMore {
            binDigit
        }
    }

    private static let binURealR5RS = Regex<Substring> {
        binUIntegerR5RS
        Optionally {
            "/"
            binUIntegerR5RS
        }
    }

    private static let binURealR7RS = Regex<Substring> {
        binUIntegerR7RS
        Optionally {
            "/"
            binUIntegerR7RS
        }
    }

    private static let charAny = Regex<Substring> {
        "#\\"
        /./
    }

    private static let charHexScalarValueR7RS = Regex<Substring> {
        "#\\x"
        hexUIntegerR7RS
    }.ignoresCase()

    private static let charNameR5RS = Regex<Substring> {
        "#\\"
        ChoiceOf {
            "newline"
            "space"
        }
    }.ignoresCase()

    private static let charNameR7RS = Regex<Substring> {
        "#\\"
        ChoiceOf {
            "alarm"
            "backspace"
            "delete"
            "escape"
            "newline"
            "null"
            "return"
            "space"
            "tab"
        }
    }.ignoresCase()

    private static let decComplexR5RS = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                decRealR5RS
                Optionally {
                    ChoiceOf {
                        Regex<Substring> {
                            "@"
                            decRealR5RS
                        }
                        Regex<Substring> {
                            sign
                            Optionally {
                                decURealR5RS
                            }
                            "i"
                        }
                    }
                }
            }
            Regex<Substring> {
                sign
                Optionally {
                    decURealR5RS
                }
                "i"
            }
        }
    }.ignoresCase()

    private static let decComplexR7RS = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                decRealR7RS
                Optionally {
                    ChoiceOf {
                        Regex<Substring> {
                            "@"
                            decRealR7RS
                        }
                        Regex<Substring> {
                            sign
                            Optionally {
                                ChoiceOf {
                                    decURealR7RS
                                    infnanR7RS
                                }
                            }
                            "i"
                        }
                    }
                }
            }
            Regex<Substring> {
                sign
                Optionally {
                    ChoiceOf {
                        decURealR7RS
                        infnanR7RS
                    }
                }
                "i"
            }
        }
    }.ignoresCase()

    private static let decNumberR5RS = Regex<Substring> {
        decPrefix
        decComplexR5RS
    }

    private static let decNumberR7RS = Regex<Substring> {
        decPrefix
        decComplexR7RS
    }

    private static let decPrefix = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                decRadix
                exactness
            }
            Regex<Substring> {
                exactness
                decRadix
            }
        }
    }

    private static let decRadix = Regex<Substring> {
        Optionally {
            "#d"
        }
    }.ignoresCase()

    private static let decRealR5RS = Regex<Substring> {
        Regex<Substring> {
            Optionally {
                sign
            }
            decURealR5RS
        }
    }

    private static let decRealR7RS = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                Optionally {
                    sign
                }
                decURealR7RS
            }
            Regex<Substring> {
                sign
                infnanR7RS
            }
        }
    }

    private static let decSuffixR5RS = Regex<Substring> {
        exponentR5RS
        Optionally {
            sign
        }
        OneOrMore {
            decDigit
        }
    }

    private static let decSuffixR7RS = Regex<Substring> {
        exponentR7RS
        Optionally {
            sign
        }
        decUIntegerR7RS
    }

    private static let decUIntegerR5RS = Regex<Substring> {
        OneOrMore {
            decDigit
        }
        ZeroOrMore {
            "#"
        }
    }

    private static let decUIntegerR7RS = Regex<Substring> {
        OneOrMore {
            decDigit
        }
    }

    private static let decUFloatR5RS = Regex<Substring> {
        ChoiceOf {
            decUIntegerR5RS
            Regex<Substring> {
                "."
                OneOrMore {
                    decDigit
                }
                ZeroOrMore {
                    "#"
                }
            }
            Regex<Substring> {
                OneOrMore {
                    decDigit
                }
                "."
                ZeroOrMore {
                    decDigit
                }
                ZeroOrMore {
                    "#"
                }
            }
            Regex<Substring> {
                OneOrMore {
                    decDigit
                }
                OneOrMore {
                    "#"
                }
                "."
                ZeroOrMore {
                    "#"
                }
            }
        }
        Optionally {
            decSuffixR5RS
        }
    }

    private static let decUFloatR7RS = Regex<Substring> {
        ChoiceOf {
            decUIntegerR7RS
            Regex<Substring> {
                "."
                decUIntegerR7RS
            }
            Regex<Substring> {
                decUIntegerR7RS
                "."
                Optionally {
                    decUIntegerR7RS
                }
            }
        }
        Optionally {
            decSuffixR7RS
        }
    }

    private static let decURealR5RS = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                decUIntegerR5RS
                Optionally {
                    "/"
                    decUIntegerR5RS
                }
            }
            decUFloatR5RS
        }
    }

    private static let decURealR7RS = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                decUIntegerR7RS
                Optionally {
                    "/"
                    decUIntegerR7RS
                }
            }
            decUFloatR7RS
        }
    }

    private static let delimiterLookaheadR5RS = Regex<Substring> {
        Lookahead {
            ChoiceOf {
                delimiterR5RS
                /$/
            }
        }
    }

    private static let delimiterLookaheadR7RS = Regex<Substring> {
        Lookahead {
            ChoiceOf {
                delimiterR7RS
                /$/
            }
        }
    }

    private static let exactness = Regex<Substring> {
        Optionally {
            Regex<Substring> {
                "#"
                CharacterClass.anyOf("ei")
            }
        }
    }.ignoresCase()

    private static let hexComplexR5RS = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                hexRealR5RS
                Optionally {
                    ChoiceOf {
                        Regex<Substring> {
                            "@"
                            hexRealR5RS
                        }
                        Regex<Substring> {
                            sign
                            Optionally {
                                hexURealR5RS
                            }
                            "i"
                        }
                    }
                }
            }
            Regex<Substring> {
                sign
                Optionally {
                    hexURealR5RS
                }
                "i"
            }
        }
    }.ignoresCase()

    private static let hexComplexR7RS = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                hexRealR7RS
                Optionally {
                    ChoiceOf {
                        Regex<Substring> {
                            "@"
                            hexRealR7RS
                        }
                        Regex<Substring> {
                            sign
                            Optionally {
                                ChoiceOf {
                                    hexURealR7RS
                                    infnanR7RS
                                }
                            }
                            "i"
                        }
                    }
                }
            }
            Regex<Substring> {
                sign
                Optionally {
                    ChoiceOf {
                        hexURealR7RS
                        infnanR7RS
                    }
                }
                "i"
            }
        }
    }.ignoresCase()

    private static let hexNumberR5RS = Regex<Substring> {
        hexPrefix
        hexComplexR5RS
    }

    private static let hexNumberR7RS = Regex<Substring> {
        hexPrefix
        hexComplexR7RS
    }

    private static let hexPrefix = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                hexRadix
                exactness
            }
            Regex<Substring> {
                exactness
                hexRadix
            }
        }
    }

    private static let hexRadix = Regex<Substring> {
        "#h"
    }.ignoresCase()

    private static let hexRealR5RS = Regex<Substring> {
        Regex<Substring> {
            Optionally {
                sign
            }
            hexURealR5RS
        }
    }

    private static let hexRealR7RS = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                Optionally {
                    sign
                }
                hexURealR7RS
            }
            Regex<Substring> {
                sign
                infnanR7RS
            }
        }
    }

    private static let hexUIntegerR5RS = Regex<Substring> {
        OneOrMore {
            hexDigit
        }
        ZeroOrMore {
            "#"
        }
    }

    private static let hexUIntegerR7RS = Regex<Substring> {
        OneOrMore {
            hexDigit
        }
    }

    private static let hexURealR5RS = Regex<Substring> {
        hexUIntegerR5RS
        Optionally {
            "/"
            hexUIntegerR5RS
        }
    }

    private static let hexURealR7RS = Regex<Substring> {
        hexUIntegerR7RS
        Optionally {
            "/"
            hexUIntegerR7RS
        }
    }

    private static let infnanR7RS = Regex<Substring> {
        ChoiceOf {
            "inf"
            "nan"
        }
        ".0"
    }

    private static let inlineHexEscapeR7RS = Regex<Substring> {
        "\\x"
        hexUIntegerR7RS
        ";"
    }.ignoresCase()

    private static let mnemonicEscapeR7RS = Regex<Substring> {
        "\\"
        mnemonic
    }.ignoresCase()

    private static let octComplexR5RS = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                octRealR5RS
                Optionally {
                    ChoiceOf {
                        Regex<Substring> {
                            "@"
                            octRealR5RS
                        }
                        Regex<Substring> {
                            sign
                            Optionally {
                                octURealR5RS
                            }
                            "i"
                        }
                    }
                }
            }
            Regex<Substring> {
                sign
                Optionally {
                    octURealR5RS
                }
                "i"
            }
        }
    }.ignoresCase()

    private static let octComplexR7RS = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                octRealR7RS
                Optionally {
                    ChoiceOf {
                        Regex<Substring> {
                            "@"
                            octRealR7RS
                        }
                        Regex<Substring> {
                            sign
                            Optionally {
                                ChoiceOf {
                                    octURealR7RS
                                    infnanR7RS
                                }
                            }
                            "i"
                        }
                    }
                }
            }
            Regex<Substring> {
                sign
                Optionally {
                    ChoiceOf {
                        octURealR7RS
                        infnanR7RS
                    }
                }
                "i"
            }
        }
    }.ignoresCase()

    private static let octNumberR5RS = Regex<Substring> {
        octPrefix
        octComplexR5RS
    }

    private static let octNumberR7RS = Regex<Substring> {
        octPrefix
        octComplexR7RS
    }

    private static let octPrefix = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                octRadix
                exactness
            }
            Regex<Substring> {
                exactness
                octRadix
            }
        }
    }

    private static let octRadix = Regex<Substring> {
        "#o"
    }.ignoresCase()

    private static let octRealR5RS = Regex<Substring> {
        Regex<Substring> {
            Optionally {
                sign
            }
            octURealR5RS
        }
    }

    private static let octRealR7RS = Regex<Substring> {
        ChoiceOf {
            Regex<Substring> {
                Optionally {
                    sign
                }
                octURealR7RS
            }
            Regex<Substring> {
                sign
                infnanR7RS
            }
        }
    }

    private static let octUIntegerR5RS = Regex<Substring> {
        OneOrMore {
            octDigit
        }
        ZeroOrMore {
            "#"
        }
    }

    private static let octUIntegerR7RS = Regex<Substring> {
        OneOrMore {
            octDigit
        }
    }

    private static let octURealR5RS = Regex<Substring> {
        octUIntegerR5RS
        Optionally {
            "/"
            octUIntegerR5RS
        }
    }

    private static let octURealR7RS = Regex<Substring> {
        octUIntegerR7RS
        Optionally {
            "/"
            octUIntegerR7RS
        }
    }

    private static let strElementR5RS = Regex<Substring> {
        ChoiceOf {
            CharacterClass.anyOf("\"\\").inverted
            "\\\""
            "\\\\"
        }
    }

    private static let strElementR7RS = Regex<Substring> {
        ChoiceOf {
            CharacterClass.anyOf("\"\\").inverted
            inlineHexEscapeR7RS
            mnemonicEscapeR7RS
            // Regex<Substring> {
            //    ZeroOrMore(whitespace)
            //    ChoiceOf {
            //        "\r\n"
            //        "\n"
            //        "\r"
            //    }
            //    ZeroOrMore(whitespace)
            // }
            "\\\""
            "\\\\"
        }
    }

    private static let symElementR7RS = Regex<Substring> {
        ChoiceOf {
            CharacterClass.anyOf("|\\").inverted
            inlineHexEscapeR7RS
            mnemonicEscapeR7RS
            "\\|"
            "\\\\"
        }
    }

    private static let symPeculiarR7RS = Regex<Substring> {
        ChoiceOf {
            sign
            Regex<Substring> {
                sign
                symSignSubsequentR7RS
                ZeroOrMore {
                    symSubsequent
                }
            }
            Regex<Substring> {
                Optionally {
                    sign
                }
                "."
                ChoiceOf {
                    symSignSubsequentR7RS
                    "."
                }
                ZeroOrMore {
                    symSubsequent
                }
            }
        }
    }

    private static let symSignSubsequentR7RS = Regex<Substring> {
        ChoiceOf {
            symInitial
            sign
            "@"
        }
    }

    private static let binDigit: CharacterClass   = "0"..."1"
    private static let boolean: CharacterClass    = .anyOf("ft")
    private static let decDigit: CharacterClass   = "0"..."9"
    private static let hexDigit: CharacterClass   = decDigit.union("a"..."f")
    private static let letter: CharacterClass     = "a"..."z"
    private static let mnemonic: CharacterClass   = .anyOf("abnrt")
    private static let octDigit: CharacterClass   = "0"..."7"
    private static let sign: CharacterClass       = .anyOf("-+")
    private static let whitespace: CharacterClass = .anyOf(" \t")

    private static let delimiterR5RS: CharacterClass = .anyOf(" \n\r\t;\"()")
    private static let delimiterR7RS: CharacterClass = delimiterR5RS.union(.anyOf("|"))
    private static let exponentR5RS: CharacterClass  = .anyOf("defls")
    private static let exponentR7RS: CharacterClass  = .anyOf("e")
    private static let reservedR5RS: CharacterClass  = reservedR7RS.union(.anyOf("|"))
    private static let reservedR7RS: CharacterClass  = .anyOf("[]{}")

    private static let symInitial: CharacterClass           = letter.union(symSpecialInitial)
    private static let symSpecialInitial: CharacterClass    = .anyOf("_:!?*/&%^<=>~$")
    private static let symSpecialSubsequent: CharacterClass = sign.union(.anyOf(".@"))
    private static let symSubsequent: CharacterClass        = symInitial.union(decDigit).union(symSpecialSubsequent)
}
