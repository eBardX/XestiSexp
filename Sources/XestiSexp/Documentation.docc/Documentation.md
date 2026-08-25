# ``XestiSexp``

@Metadata {
    @PageColor(blue)
}

An S-expression encoder and decoder.

## Overview

The XestiSexp framework provides a Swift encoder and decoder that represents
values as S-expressions like in Scheme. Encoding and decoding revolve around
two `Codable`-style types:

 Stage    | Type              | Input → Output
:-----    |:----              |:--------------
 Encode   | ``SexpEncoder``   | `Encodable` → `Data`
 Decode   | ``SexpDecoder``   | `Data` → `Decodable`

```swift
import Foundation
import XestiSexp

struct Greeting: Codable {
    let lang: String
    let text: String
}

let greeting = Greeting(lang: "en",
                        text: "Hello!")

let data    = try SexpEncoder().encode(greeting)
let decoded = try SexpDecoder().decode(Greeting.self, from: data)
```

Underneath, a ``Sexp`` represents any S-expression datum — boolean,
bytevector, character, null, number, pair, string, symbol, or vector —
and ``Sexp/Parser`` and ``Sexp/Formatter`` convert between a ``Sexp`` and its
textual representation, under either the R⁵RS or the (partial) R⁷RS syntax
standard:

```swift
let sexp   = try Sexp.Parser(syntax: .r7rsPartial,
                             tracing: .silent).parse(input: "(1 2 3)")
let output = try Sexp.Formatter(prettyPrint: false,
                                syntax: .r7rsPartial,
                                tracing: .silent).format(sexp)
```

See ``SexpEncoder``, ``SexpDecoder``, ``Sexp/Parser``, and ``Sexp/Formatter``
for the full details of what each supports — and for the handful of
documented limitations of each.

## Topics

### Encoding and decoding

- ``SexpEncoder``
- ``SexpDecoder``

### Parsing and formatting

- ``Sexp/Parser``
- ``Sexp/Formatter``

### S-expression values

- ``Sexp``
- ``Sexp/Symbol``
- ``Sexp/Number``

### Syntax and errors

- ``Sexp/Syntax``
- ``Sexp/Error``
