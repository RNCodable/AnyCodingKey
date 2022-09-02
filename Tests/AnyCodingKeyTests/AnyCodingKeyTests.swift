import XCTest
import AnyCodingKey

final class AnyCodingKeyTests: XCTestCase {
    // ACK supports both a stringValue and an intValue
    func testExplicitInitializer() {
        let key = AnyCodingKey(stringValue: "Item 1", intValue: 1)
        XCTAssertEqual(key.stringValue, "Item 1")
        XCTAssertEqual(key.intValue, 1)
    }

    // ACK is a CodingKey
    func testCodingKeyConformance() {
        let stringKey = AnyCodingKey(stringValue: "Alice")
        XCTAssertEqual(stringKey.stringValue, "Alice")
        XCTAssertEqual(stringKey.intValue, nil)

        let intKey = AnyCodingKey(intValue: 42)
        XCTAssertEqual(intKey.stringValue, "42")
        XCTAssertEqual(intKey.intValue, 42)
    }

    // ACK can be initialized with a String
    func testStringInitializer() {
        let otherKey = "a"
        let key = AnyCodingKey(otherKey)
        XCTAssertEqual(key.stringValue, "a")
        XCTAssertEqual(key.intValue, nil)
    }

    // ACK can be initialized with an Int
    func testIntInitializer() {
        let otherKey = 1
        let key = AnyCodingKey(otherKey)
        XCTAssertEqual(key.stringValue, "1")
        XCTAssertEqual(key.intValue, 1)
    }

    // ACK can be initialized with another CodingKey
    func testCodingKeyInitializer() {
        enum CodingKeys: CodingKey {
            case a, b, c
        }

        let key = AnyCodingKey(CodingKeys.a)
        XCTAssertEqual(key.stringValue, "a")
        XCTAssertEqual(key.intValue, nil)
    }

    // ACK can be initialized with a CodingKeyRepresentable
    @available(macOS 12.3, *)
    func testCodingKeyRepresentableInitializer() {
        let otherKey = 1 as CodingKeyRepresentable
        let key = AnyCodingKey(otherKey)
        XCTAssertEqual(key.stringValue, "1")
        XCTAssertEqual(key.intValue, 1)
    }

    // ACK conforms to CustomStringConvertible
    func testCustomStringConvertibleConformance() {
        let stringKey = AnyCodingKey(stringValue: "abc")
        XCTAssertEqual(stringKey.description, "abc")
        XCTAssertEqual("\(stringKey)", "abc")

        let intKey = AnyCodingKey(intValue: 1)
        XCTAssertEqual(intKey.description, "1")
        XCTAssertEqual("\(intKey)", "1")
    }

    // ACK conforms to ExpressibleByStringLiteral
    func testExpressibleByStringLiteralConformance() {
        let key: AnyCodingKey = "abc"
        XCTAssertEqual(key.stringValue, "abc")
        XCTAssertEqual(key.intValue, nil)
    }

    // ACK conforms to ExpressibleByIntegerLiteral
    func testExpressibleByIntegerLiteralConformance() {
        let key: AnyCodingKey = 42
        XCTAssertEqual(key.stringValue, "42")
        XCTAssertEqual(key.intValue, 42)
    }

    // ACK coding paths can be created from an array literal
    func testCodingPathLiteral() {
        let codingPath: [AnyCodingKey] = [1, 2, "abc", 3, "def"]
        XCTAssertEqual(codingPath[2], "abc")
    }

    // ACK conforms to Hashable
    func testHashableConformance() {
        let abcNilKey = AnyCodingKey(stringValue: "abc", intValue: nil)
        let abc42Key = AnyCodingKey(stringValue: "abc", intValue: 42)

        XCTAssertNotEqual(abcNilKey, abc42Key)
        XCTAssertEqual(abcNilKey, AnyCodingKey("abc"))
        XCTAssertNotEqual(abc42Key, AnyCodingKey("42"))

        var hasher1 = Hasher()
        hasher1.combine(abcNilKey)

        var hasher2 = Hasher()
        hasher2.combine(AnyCodingKey("abc"))

        XCTAssertEqual(hasher1.finalize(), hasher2.finalize())
    }

    // ACK conforms to Comparable
    func testComparableConformance() {
        XCTAssertLessThan(AnyCodingKey("abc"), AnyCodingKey("bcd"))
    }
}

final class AnyCodingKeyDecodingTests: XCTestCase {
    // Decoder.anyKeyedContainer returns a KeyedDecodingContainer<AnyCodingKey>
    func testAnyKeyedContainer() throws {
        struct S: Decodable { let x, y: Int
            init(from decoder: Decoder) throws {
                let c = try decoder.anyKeyedContainer()
                self.x = try c.decode(Int.self, forKey: "x")
                self.y = try c.decode(Int.self, forKey: "y")
            }
        }

        let json = Data(#"""
        { "x": 1, "y": 2 }
        """#.utf8)

        let s = try JSONDecoder().decode(S.self, from: json)
        XCTAssertEqual(s.x, 1)
        XCTAssertEqual(s.y, 2)
    }

    // KeyedDecodingContainer.nestedAnyContainer returns a KeyedDecodingContainer<AnyCodingKey>
    func testKeyedNestedAnyContainer() throws {
        struct S: Decodable { let x, y: Int
            init(from decoder: Decoder) throws {
                let c = try decoder
                    .anyKeyedContainer()
                    .nestedAnyContainer(forKey: "values")
                self.x = try c.decode(Int.self, forKey: "x")
                self.y = try c.decode(Int.self, forKey: "y")
            }
        }

        let json = Data(#"""
        { "values" : { "x": 1, "y": 2 } }
        """#.utf8)

        let s = try JSONDecoder().decode(S.self, from: json)
        XCTAssertEqual(s.x, 1)
        XCTAssertEqual(s.y, 2)
    }

    // UnkeyedDecodingContainer.nestedAnyContainer returns a KeyedDecodingContainer<AnyCodingKey>
    func testUnkeyedNestedAnyContainer() throws {
        struct S: Decodable { let x, y: Int
            init(from decoder: Decoder) throws {
                var list = try decoder
                    .unkeyedContainer()

                let c = try list.nestedAnyContainer()
                self.x = try c.decode(Int.self, forKey: "x")
                self.y = try c.decode(Int.self, forKey: "y")
            }
        }

        let json = Data(#"""
        [ { "x": 1, "y": 2 } ]
        """#.utf8)

        let s = try JSONDecoder().decode(S.self, from: json)
        XCTAssertEqual(s.x, 1)
        XCTAssertEqual(s.y, 2)
    }
}

final class AnyCodingKeyEncodingTests: XCTestCase {
    // Encoder.anyKeyedContainer returns a KeyedEncodingContainer<AnyCodingKey>
    // { "x": 1, "y": 2 }
    func testAnyKeyedContainer() throws {
        struct S: Encodable { let x, y: Int
            func encode(to encoder: Encoder) throws {
                var c = encoder.anyKeyedContainer()
                try c.encode(x, forKey: "x")
                try c.encode(y, forKey: "y")
            }
        }

        let s = S(x: 1, y: 2)

        let json = try JSONEncoder().encode(s)
        let result = try XCTUnwrap(JSONSerialization.jsonObject(with: json) as? [String: Int])

        XCTAssertEqual(result["x"], 1)
        XCTAssertEqual(result["y"], 2)
    }

    // KeyedEncodingContainer.nestedAnyContainer returns a KeyedEncodingContainer<AnyCodingKey>
    // { "values" : { "x": 1, "y": 2 } }
    func testKeyedNestedAnyContainer() throws {
        struct S: Encodable { let x, y: Int
            func encode(to encoder: Encoder) throws {
                var c = encoder.anyKeyedContainer()
                var values = c.nestedAnyContainer(forKey: "values")
                try values.encode(x, forKey: "x")
                try values.encode(y, forKey: "y")
            }
        }

        let s = S(x: 1, y: 2)

        let json = try JSONEncoder().encode(s)
        let result = try XCTUnwrap(JSONSerialization.jsonObject(with: json) as? [String: [String: Int]])

        XCTAssertEqual(result["values"]?["x"], 1)
        XCTAssertEqual(result["values"]?["y"], 2)
    }

    // UnkeyedEncodingContainer.nestedAnyContainer returns a KeyedEncodingContainer<AnyCodingKey>
    // [ { "x": 1, "y": 2 } ]
    func testUnkeyedNestedAnyContainer() throws {
        struct S: Encodable { let x, y: Int
            func encode(to encoder: Encoder) throws {
                var c = encoder.unkeyedContainer()
                var values = c.nestedAnyContainer()
                try values.encode(x, forKey: "x")
                try values.encode(y, forKey: "y")
            }
        }

        let s = S(x: 1, y: 2)

        let json = try JSONEncoder().encode(s)
        let result = try XCTUnwrap(JSONSerialization.jsonObject(with: json) as? [[String: Int]])

        XCTAssertEqual(result.first?["x"], 1)
        XCTAssertEqual(result.first?["y"], 2)
    }
}
