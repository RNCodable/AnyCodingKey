//
//  AnyCodingKeySampleTests.swift
//  
//
//  Created by Rob Napier on 9/3/22.
//

import XCTest
import AnyCodingKey

final class AnyCodingKeySampleTests: XCTestCase {

    func testExample() throws {
        let data = Data(#"""
        {
            "number": "658",
            "name": "Greninja",
            "species": "Ninja",
            "types": [
              "Water",
              "Dark"
            ]
        }
        """#.utf8)

        struct Pokemon: Decodable {
            let number, name, species: String
            let types: [String]

            init(from decoder: Decoder) throws {
                let c = try decoder.anyKeyedContainer()

                number = try c.decode(String.self, forKey: "number")
                name = try c.decode(String.self, forKey: "name")
                species = try c.decode(String.self, forKey: "species")
                types = try c.decode([String].self, forKey: "types")
            }
        }

        let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)

        XCTAssertEqual(pokemon.number, "658")
        XCTAssertEqual(pokemon.name, "Greninja")
        XCTAssertEqual(pokemon.species, "Ninja")
        XCTAssertEqual(pokemon.types, ["Water", "Dark"])
    }
}
