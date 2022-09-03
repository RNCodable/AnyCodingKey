# AnyCodingKey

A `CodingKey` for any encoding or decoding container.

## Overview

`AnyCodingKey` provides a wrapper for a String (and optionally an Int), and conforms to `CodingKey`. It
allows easy creation of arbitrary keys for `KeyedDecodingContainer` and `KeyedEncodingContainer`, or for use
in coding paths. `AnyCodingKey` conforms to `ExpressibleByStringLiteral` and `ExpressibleByIntegerLiteral`
to make use particularly easy.

## Common Use Cases

### Avoiding manual CodingKey enums

```swift
struct Pokemon: Decodable {
    let number, name, species: String
    let types: [String]

    init(from decoder: Decoder) throws {
        // Create a KeyedDecodingContainer keyed by AnyCodingKey.
        let c = try decoder.anyKeyedContainer()

        // Use String literals to create AnyCodingKeys
        number = try c.decode(String.self, forKey: "number")
        name = try c.decode(String.self, forKey: "name")
        species = try c.decode(String.self, forKey: "species")
        types = try c.decode([String].self, forKey: "types")
    }
}
```
