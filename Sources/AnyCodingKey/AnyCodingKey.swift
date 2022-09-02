public struct AnyCodingKey: Hashable {
    public let stringValue: String
    public var intValue: Int?
    public init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
}

extension AnyCodingKey: CodingKey {
    public init(stringValue: String) { self.init(stringValue: stringValue, intValue: nil) }
    public init(intValue: Int) { self.init(stringValue: "\(intValue)", intValue: intValue) }
}

extension AnyCodingKey {
    public init(_ key: String) {
        self.init(stringValue: key)
    }

    public init(_ key: Int) {
        self.init(intValue: key)
    }

    public init(_ key: some CodingKey) {
        self.init(stringValue: key.stringValue, intValue: key.intValue)
    }

    @available(macOS 12.3, iOS 15.4, watchOS 8.5, tvOS 15.4, *)
    public init(_ key: some CodingKeyRepresentable) {
        self.init(key.codingKey)
    }
}

extension AnyCodingKey: CustomStringConvertible {
    public var description: String { stringValue }
}

extension AnyCodingKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self.init(stringValue: value) }
}

extension AnyCodingKey: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) { self.init(intValue: value) }
}

extension AnyCodingKey: Comparable {
    public static func < (lhs: AnyCodingKey, rhs: AnyCodingKey) -> Bool {
        lhs.stringValue < rhs.stringValue
    }
}

// MARK: - Decoding extensions

extension Decoder {
    public func anyKeyedContainer() throws -> KeyedDecodingContainer<AnyCodingKey> {
        try container(keyedBy: AnyCodingKey.self)
    }
}

extension KeyedDecodingContainer {
    public func nestedAnyContainer(forKey key: Key) throws -> KeyedDecodingContainer<AnyCodingKey> {
        try nestedContainer(keyedBy: AnyCodingKey.self, forKey: key)
    }
}

extension UnkeyedDecodingContainer {
    public mutating func nestedAnyContainer() throws -> KeyedDecodingContainer<AnyCodingKey> {
        try nestedContainer(keyedBy: AnyCodingKey.self)
    }
}

// MARK: - Encoding extensions
extension Encoder {
    public func anyKeyedContainer() -> KeyedEncodingContainer<AnyCodingKey> {
        container(keyedBy: AnyCodingKey.self)
    }
}

extension KeyedEncodingContainer {
    public mutating func nestedAnyContainer(forKey key: Key) -> KeyedEncodingContainer<AnyCodingKey> {
        nestedContainer(keyedBy: AnyCodingKey.self, forKey: key)
    }
}

extension UnkeyedEncodingContainer {
    public mutating func nestedAnyContainer()  -> KeyedEncodingContainer<AnyCodingKey> {
        nestedContainer(keyedBy: AnyCodingKey.self)
    }
}
