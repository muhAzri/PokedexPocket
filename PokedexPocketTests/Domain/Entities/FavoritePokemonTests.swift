//
//  FavoritePokemonTests.swift
//  PokedexPocketTests
//
//  Created by Azri on 30/07/25.
//

import XCTest
@testable import PokedexPocket

final class FavoritePokemonTests: XCTestCase {

    // MARK: - Test Properties
    func testFavoritePokemonIdentifiable() {
        let pokemon = TestData.favoritePikachu
        XCTAssertEqual(pokemon.id, 25)
    }

    func testFavoritePokemonEquality() {
        let pokemon1 = TestData.favoritePikachu
        let pokemon2 = TestData.favoritePikachu
        let pokemon3 = TestData.favoriteCharizard

        XCTAssertEqual(pokemon1, pokemon2)
        XCTAssertNotEqual(pokemon1, pokemon3)

        // Test equality is based on ID only
        let pokemon4 = FavoritePokemon(
            id: 25,
            name: "different-name",
            primaryType: "different-type",
            imageURL: "different-url",
            dateAdded: Date()
        )
        XCTAssertEqual(pokemon1, pokemon4)
    }

    func testFormattedName() {
        let pokemon = TestData.favoritePikachu
        XCTAssertEqual(pokemon.formattedName, "Pikachu")

        let emptyNamePokemon = FavoritePokemon(
            id: 1,
            name: "",
            primaryType: "normal",
            imageURL: ""
        )
        XCTAssertEqual(emptyNamePokemon.formattedName, "")

        let mixedCasePokemon = FavoritePokemon(
            id: 1,
            name: "pIkAcHu",
            primaryType: "electric",
            imageURL: ""
        )
        XCTAssertEqual(mixedCasePokemon.formattedName, "Pikachu")

        let multiWordPokemon = FavoritePokemon(
            id: 1,
            name: "mr. mime",
            primaryType: "psychic",
            imageURL: ""
        )
        XCTAssertEqual(multiWordPokemon.formattedName, "Mr. Mime")
    }

    func testPokemonNumber() {
        let pokemon = TestData.favoritePikachu
        XCTAssertEqual(pokemon.pokemonNumber, "#025")

        let pokemon6 = TestData.favoriteCharizard
        XCTAssertEqual(pokemon6.pokemonNumber, "#006")

        let pokemon1 = FavoritePokemon(
            id: 1,
            name: "bulbasaur",
            primaryType: "grass",
            imageURL: ""
        )
        XCTAssertEqual(pokemon1.pokemonNumber, "#001")

        let pokemon150 = FavoritePokemon(
            id: 150,
            name: "mewtwo",
            primaryType: "psychic",
            imageURL: ""
        )
        XCTAssertEqual(pokemon150.pokemonNumber, "#150")

        let pokemon1000 = FavoritePokemon(
            id: 1000,
            name: "test",
            primaryType: "normal",
            imageURL: ""
        )
        XCTAssertEqual(pokemon1000.pokemonNumber, "#1000")
    }

    // MARK: - Test Initialization
    func testInitializationWithAllParameters() {
        let customDate = Date(timeIntervalSince1970: 1000000000)
        let pokemon = FavoritePokemon(
            id: 144,
            name: "articuno",
            primaryType: "ice",
            imageURL: "https://example.com/articuno.png",
            dateAdded: customDate
        )

        XCTAssertEqual(pokemon.id, 144)
        XCTAssertEqual(pokemon.name, "articuno")
        XCTAssertEqual(pokemon.primaryType, "ice")
        XCTAssertEqual(pokemon.imageURL, "https://example.com/articuno.png")
        XCTAssertEqual(pokemon.dateAdded, customDate)
    }

    func testInitializationWithDefaultDate() {
        let beforeCreation = Date()
        let pokemon = FavoritePokemon(
            id: 1,
            name: "bulbasaur",
            primaryType: "grass",
            imageURL: "https://example.com/bulbasaur.png"
        )
        let afterCreation = Date()

        XCTAssertEqual(pokemon.id, 1)
        XCTAssertEqual(pokemon.name, "bulbasaur")
        XCTAssertEqual(pokemon.primaryType, "grass")
        XCTAssertEqual(pokemon.imageURL, "https://example.com/bulbasaur.png")
        XCTAssertTrue(pokemon.dateAdded >= beforeCreation)
        XCTAssertTrue(pokemon.dateAdded <= afterCreation)
    }

    func testInitializationWithEmptyValues() {
        let pokemon = FavoritePokemon(
            id: 0,
            name: "",
            primaryType: "",
            imageURL: ""
        )

        XCTAssertEqual(pokemon.id, 0)
        XCTAssertEqual(pokemon.name, "")
        XCTAssertEqual(pokemon.primaryType, "")
        XCTAssertEqual(pokemon.imageURL, "")
    }

    func testInitializationWithNegativeId() {
        let pokemon = FavoritePokemon(
            id: -1,
            name: "test",
            primaryType: "normal",
            imageURL: ""
        )

        XCTAssertEqual(pokemon.id, -1)
        XCTAssertEqual(pokemon.pokemonNumber, "#-01")
    }

    // MARK: - Edge Cases
    func testInitializationWithMaxInt() {
        let pokemon = FavoritePokemon(
            id: Int.max,
            name: "max-pokemon",
            primaryType: "unknown",
            imageURL: ""
        )

        XCTAssertEqual(pokemon.id, Int.max)
        XCTAssertEqual(pokemon.pokemonNumber, String(format: "#%03d", Int.max))
    }

    func testInitializationWithMinInt() {
        let pokemon = FavoritePokemon(
            id: Int.min,
            name: "min-pokemon",
            primaryType: "unknown",
            imageURL: ""
        )

        XCTAssertEqual(pokemon.id, Int.min)
        XCTAssertEqual(pokemon.pokemonNumber, String(format: "#%03d", Int.min))
    }

    func testInitializationWithSpecialCharacters() {
        let pokemon = FavoritePokemon(
            id: 83,
            name: "farfetch'd",
            primaryType: "normal",
            imageURL: "https://example.com/farfetchd.png"
        )

        XCTAssertEqual(pokemon.name, "farfetch'd")
        XCTAssertEqual(pokemon.formattedName, "Farfetch'd")
    }

    func testInitializationWithLongURL() {
        let longURL = "https://very-long-domain-name-for-testing-purposes.example.com/path/to/very/long/pokemon/image/url/that/might/be/used/in/production/environments/pokemon.png"
        let pokemon = FavoritePokemon(
            id: 1,
            name: "test",
            primaryType: "normal",
            imageURL: longURL
        )

        XCTAssertEqual(pokemon.imageURL, longURL)
    }
}
