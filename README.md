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

## Adding AnyCodingKey as a Dependency

To use the `AnyCodingKey` library in a SwiftPM project, add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/RNCodable/AnyCodingKey", from: "1.0.0"),
```

Include `"AnyCodingKey"` as a dependency for your executable target:

```swift
.target(name: "<target>", dependencies: [
    .product(name: "AnyCodingKey"),
]),
```

Finally, add `import AnyCodingKey` to your source code.
