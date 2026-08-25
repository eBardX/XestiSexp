# XestiSexp

An S-expression encoder and decoder.

## <a name="overview">Overview</a>

The XestiSexp framework provides a Swift encoder and decoder that represents
values as S-expressions like in Scheme. Encoding and decoding revolve around
two `Codable`-style types:

 Stage    | Type            | Input → Output
:-----    |:----            |:--------------
 Encode   | `SexpEncoder`   | `Encodable` → `Data`
 Decode   | `SexpDecoder`   | `Data` → `Decodable`

Underneath, a `Sexp` represents any S-expression datum — boolean, bytevector,
character, null, number, pair, string, symbol, or vector — and `Sexp.Parser`
and `Sexp.Formatter` convert between a `Sexp` and its textual representation,
under either the R⁵RS or the (partial) R⁷RS syntax standard.

## <a name="requirements">Requirements</a>

* iOS 18.0+ / macOS 15.0+
* Swift 6 language mode

## <a name="installation">Installation</a>

### <a name="spm_installation">Swift Package Manager</a>

XestiSexp is distributed exclusively through the [Swift Package Manager][spm].

To add XestiSexp to a Swift package, add it to the `dependencies` in your
`Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/eBardX/XestiSexp.git",
             .upToNextMajor(from: "4.1.0"))
]
```

Then add `XestiSexp` to the dependencies of any target that uses it:

```swift
.target(name: "MyTarget",
        dependencies: [.product(name: "XestiSexp",
                                package: "XestiSexp")])
```

To add XestiSexp to an Xcode project, choose **File ▸ Add Package Dependencies…**
and enter the repository URL:

```
https://github.com/eBardX/XestiSexp.git
```

## <a name="quick_start">Quick Start</a>

Encode any `Codable` value to S-expression data, then decode it back:

```swift
import Foundation
import XestiSexp

struct Greeting: Codable {
    let lang: String
    let text: String
}

let greeting = Greeting(lang: "en",
                        text: "Hello!")

// 1. Encode a value into S-expression data.
let data = try SexpEncoder().encode(greeting)

String(data: data, encoding: .utf8)
// ((lang en) (text Hello!))

// 2. Decode S-expression data back into a value.
let decoded = try SexpDecoder().decode(Greeting.self, from: data)

decoded.lang   // "en"
decoded.text   // "Hello!"
```

To work directly with S-expression text — without going through `Codable` —
parse and format a `Sexp` value instead:

```swift
let sexp   = try Sexp.Parser(syntax: .r7rsPartial,
                             tracing: .silent).parse(input: "(1 2 3)")
let output = try Sexp.Formatter(prettyPrint: false,
                                syntax: .r7rsPartial,
                                tracing: .silent).format(sexp)
```

## <a name="documentation">Documentation</a>

Every public declaration carries a DocC comment; `SexpEncoder`, `SexpDecoder`,
`Sexp.Parser`, and `Sexp.Formatter` in particular describe their behavior —
and limitations — in detail.

## <a name="reference_documentation">Reference Documentation</a>

Full [reference documentation][refdoc] is available courtesy of [DocC][docc].

## <a name="credits">Credits</a>

John Gary Pusey (ebardx@gmail.com)

## <a name="license">License</a>

XestiSexp is available under [the MIT license][license].

[docc]:     https://www.swift.org/documentation/docc/
[license]:  https://github.com/eBardX/XestiSexp/blob/main/LICENSE.md
[refdoc]:   https://eBardX.github.io/xesti-packages-docs/documentation/xestisexp
[spm]:      https://swift.org/package-manager/
