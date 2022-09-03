/// A  `CodingKey` for any encoding or decoding container.
public struct AnyCodingKey: Hashable {

    /// The string to use in a named collection (e.g. a string-keyed dictionary).
    public var stringValue: String

    /// The value to use in an integer-indexed collection (e.g. an int-keyed
    /// dictionary).
    public var intValue: Int?

    /// Creates a new instance from the given string and integer.
    ///
    /// - parameter stringValue: The string value of the desired key.
    /// - parameter intValue: The integer value of the desired key.
    public init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
}

extension AnyCodingKey: CodingKey {
    /// Creates a new instance from the given string.
    ///
    /// - parameter stringValue: The string value of the desired key.
    public init(stringValue: String) {
        self.init(stringValue: stringValue, intValue: nil)
    }

    /// Creates a new instance from the specified integer.
    ///
    /// The `stringValue` is the `description` of the integer.
    ///
    /// - parameter intValue: The integer value of the desired key.
    public init(intValue: Int) {
        self.init(stringValue: "\(intValue)", intValue: intValue)
    }
}

extension AnyCodingKey {
    /// Creates a new instance from the given string.
    ///
    /// - parameter key: The string value of the desired key.
    public init(_ key: String) {
        self.init(stringValue: key)
    }

    /// Creates a new instance from the specified integer.
    ///
    /// The `stringValue` is the `description` of the integer.
    ///
    /// - parameter key: The integer value of the desired key.
    public init(_ key: Int) {
        self.init(intValue: key)
    }

    /// Creates a new instance from the given `CodingKey`.
    ///
    /// - parameter key: The `CodingKey` that provides the `stringValue` and `intValue`.
    public init(_ key: some CodingKey) {
        self.init(stringValue: key.stringValue, intValue: key.intValue)
    }

    /// Creates a new instance from the given `CodingKeyRepresentable`.
    ///
    /// - parameter key: The `CodingKeyRepresentable` that provides the `stringValue` and `intValue`.
    @available(macOS 12.3, iOS 15.4, watchOS 8.5, tvOS 15.4, *)
    public init(_ key: some CodingKeyRepresentable) {
        self.init(key.codingKey)
    }
}

extension AnyCodingKey: CustomStringConvertible {
    /// A textual representation of this key.
    public var description: String { stringValue }
}

extension AnyCodingKey: CustomDebugStringConvertible {
    /// A textual representation of this key, suitable for debugging.
    public var debugDescription: String { stringValue.debugDescription }
}

extension AnyCodingKey: ExpressibleByStringLiteral {
    /// Creates a new instance from the given string literal
    ///
    /// - parameter stringLiteral: The string value of the desired key.
    public init(stringLiteral value: String) { self.init(stringValue: value) }
}

extension AnyCodingKey: ExpressibleByIntegerLiteral {
    /// Creates a new instance from the given integer literal
    ///
    /// - parameter integerLiteral: The integer value of the desired key. The `stringValue` will be the integer's `description`.
    public init(integerLiteral value: Int) { self.init(intValue: value) }
}

extension AnyCodingKey: Comparable {
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func < (lhs: AnyCodingKey, rhs: AnyCodingKey) -> Bool {
        lhs.stringValue < rhs.stringValue
    }
}

// MARK: - Decoding extensions

extension Decoder {
    /// Returns a `KeyedDecodingContainer<AnyCodingKey>` for the current `Decoder`.
    public func anyKeyedContainer() throws -> KeyedDecodingContainer<AnyCodingKey> {
        try container(keyedBy: AnyCodingKey.self)
    }
}

extension KeyedDecodingContainer {
    /// Returns a `KeyedDecodingContainer<AnyCodingKey>` for the current `KeyedDecodingContainer`.
    ///
    /// - Parameters:
    ///   - key: The key to associate the container with.
    public func nestedAnyContainer(forKey key: Key) throws -> KeyedDecodingContainer<AnyCodingKey> {
        try nestedContainer(keyedBy: AnyCodingKey.self, forKey: key)
    }
}

extension UnkeyedDecodingContainer {
    /// Returns a `KeyedDecodingContainer<AnyCodingKey>` for the current `UnkeyedDecodingContainer`.
    public mutating func nestedAnyContainer() throws -> KeyedDecodingContainer<AnyCodingKey> {
        try nestedContainer(keyedBy: AnyCodingKey.self)
    }
}

// MARK: - Encoding extensions
extension Encoder {
    /// Returns a `KeyedEncodingContainer<AnyCodingKey>` for the current `Encoder`.
    public func anyKeyedContainer() -> KeyedEncodingContainer<AnyCodingKey> {
        container(keyedBy: AnyCodingKey.self)
    }
}

extension KeyedEncodingContainer {
    /// Returns a `KeyedEncodingContainer<AnyCodingKey>` for the current `KeyedEncodingContainer`.
    ///
    /// - Parameters:
    ///   - key: The key to associate the container with.
    public mutating func nestedAnyContainer(forKey key: Key) -> KeyedEncodingContainer<AnyCodingKey> {
        nestedContainer(keyedBy: AnyCodingKey.self, forKey: key)
    }
}

extension UnkeyedEncodingContainer {
    /// Returns a `KeyedEncodingContainer<AnyCodingKey>` for the current `UnkeyedEncodingContainer`.
    public mutating func nestedAnyContainer()  -> KeyedEncodingContainer<AnyCodingKey> {
        nestedContainer(keyedBy: AnyCodingKey.self)
    }
}
