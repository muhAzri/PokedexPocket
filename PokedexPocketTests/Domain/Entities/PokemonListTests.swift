//
//  PokemonListTests.swift
//  PokedexPocketTests
//
//  Created by Azri on 30/07/25.
//

import XCTest
@testable import PokedexPocket

final class PokemonListTests: XCTestCase {

    // MARK: - PokemonList Tests
    func testPokemonListEquality() {
        let list1 = TestData.pokemonList
        let list2 = TestData.pokemonList
        let list3 = PokemonList(
            count: 1000,
            next: nil,
            previous: nil,
            results: []
        )

        XCTAssertEqual(list1, list2)
        XCTAssertNotEqual(list1, list3)
    }

    func testHasNext() {
        let listWithNext = PokemonList(
            count: 1302,
            next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
            previous: nil,
            results: []
        )
        XCTAssertTrue(listWithNext.hasNext)

        let listWithoutNext = PokemonList(
            count: 20,
            next: nil,
            previous: nil,
            results: []
        )
        XCTAssertFalse(listWithoutNext.hasNext)

        let listWithEmptyNext = PokemonList(
            count: 20,
            next: "",
            previous: nil,
            results: []
        )
        XCTAssertTrue(listWithEmptyNext.hasNext) // Empty string is still not nil
    }

    func testHasPrevious() {
        let listWithPrevious = PokemonList(
            count: 1302,
            next: nil,
            previous: "https://pokeapi.co/api/v2/pokemon?offset=0&limit=20",
            results: []
        )
        XCTAssertTrue(listWithPrevious.hasPrevious)

        let listWithoutPrevious = PokemonList(
            count: 20,
            next: nil,
            previous: nil,
            results: []
        )
        XCTAssertFalse(listWithoutPrevious.hasPrevious)

        let listWithEmptyPrevious = PokemonList(
            count: 20,
            next: nil,
            previous: "",
            results: []
        )
        XCTAssertTrue(listWithEmptyPrevious.hasPrevious) // Empty string is still not nil
    }

    func testPokemonListCodable() throws {
        let list = TestData.pokemonList

        let encodedData = try JSONEncoder().encode(list)
        let decodedList = try JSONDecoder().decode(PokemonList.self, from: encodedData)

        XCTAssertEqual(list, decodedList)
    }

    func testEmptyPokemonList() {
        let emptyList = PokemonList(
            count: 0,
            next: nil,
            previous: nil,
            results: []
        )

        XCTAssertEqual(emptyList.count, 0)
        XCTAssertFalse(emptyList.hasNext)
        XCTAssertFalse(emptyList.hasPrevious)
        XCTAssertTrue(emptyList.results.isEmpty)
    }
}

// MARK: - PokemonListItem Tests
final class PokemonListItemTests: XCTestCase {

    func testPokemonListItemIdentifiable() {
        let item = TestData.pokemonListItemBulbasaur
        XCTAssertEqual(item.id, "bulbasaur")
    }

    func testPokemonListItemEquality() {
        let item1 = TestData.pokemonListItemBulbasaur
        let item2 = TestData.pokemonListItemBulbasaur
        let item3 = TestData.pokemonListItemIvysaur

        XCTAssertEqual(item1, item2)
        XCTAssertNotEqual(item1, item3)
    }

    func testPokemonListItemInitialization() {
        let item = PokemonListItem(
            name: "pikachu",
            url: "https://pokeapi.co/api/v2/pokemon/25/"
        )

        XCTAssertEqual(item.id, "pikachu")
        XCTAssertEqual(item.name, "pikachu")
        XCTAssertEqual(item.url, "https://pokeapi.co/api/v2/pokemon/25/")
    }

    func testPokemonId() {
        let item1 = TestData.pokemonListItemBulbasaur
        XCTAssertEqual(item1.pokemonId, 1)

        let item2 = TestData.pokemonListItemIvysaur
        XCTAssertEqual(item2.pokemonId, 2)

        let item25 = PokemonListItem(
            name: "pikachu",
            url: "https://pokeapi.co/api/v2/pokemon/25/"
        )
        XCTAssertEqual(item25.pokemonId, 25)

        let item150 = PokemonListItem(
            name: "mewtwo",
            url: "https://pokeapi.co/api/v2/pokemon/150/"
        )
        XCTAssertEqual(item150.pokemonId, 150)
    }

    func testPokemonIdWithInvalidURL() {
        let invalidItem = PokemonListItem(
            name: "invalid",
            url: "invalid-url"
        )
        XCTAssertEqual(invalidItem.pokemonId, 0)

        let emptyUrlItem = PokemonListItem(
            name: "empty",
            url: ""
        )
        XCTAssertEqual(emptyUrlItem.pokemonId, 0)

        let noIdItem = PokemonListItem(
            name: "no-id",
            url: "https://pokeapi.co/api/v2/pokemon/"
        )
        XCTAssertEqual(noIdItem.pokemonId, 0)

        let nonNumericItem = PokemonListItem(
            name: "non-numeric",
            url: "https://pokeapi.co/api/v2/pokemon/abc/"
        )
        XCTAssertEqual(nonNumericItem.pokemonId, 0)
    }

    func testPokemonIdWithSpecialUrls() {
        let urlWithQuery = PokemonListItem(
            name: "test",
            url: "https://pokeapi.co/api/v2/pokemon/25/?query=value"
        )
        XCTAssertEqual(urlWithQuery.pokemonId, 25)

        let urlWithFragment = PokemonListItem(
            name: "test",
            url: "https://pokeapi.co/api/v2/pokemon/25/#fragment"
        )
        XCTAssertEqual(urlWithFragment.pokemonId, 25)

        let urlWithoutTrailingSlash = PokemonListItem(
            name: "test",
            url: "https://pokeapi.co/api/v2/pokemon/25"
        )
        XCTAssertEqual(urlWithoutTrailingSlash.pokemonId, 25)
    }

    func testImageURL() {
        let item1 = TestData.pokemonListItemBulbasaur
        let expectedURL1 = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites" +
            "/pokemon/other/official-artwork/1.png"
        XCTAssertEqual(item1.imageURL, expectedURL1)

        let item25 = PokemonListItem(
            name: "pikachu",
            url: "https://pokeapi.co/api/v2/pokemon/25/"
        )
        let expectedURL25 = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites" +
            "/pokemon/other/official-artwork/25.png"
        XCTAssertEqual(item25.imageURL, expectedURL25)

        let invalidItem = PokemonListItem(
            name: "invalid",
            url: "invalid-url"
        )
        let expectedInvalidURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites" +
            "/pokemon/other/official-artwork/0.png"
        XCTAssertEqual(invalidItem.imageURL, expectedInvalidURL)
    }

    func testFormattedName() {
        let item = TestData.pokemonListItemBulbasaur
        XCTAssertEqual(item.formattedName, "Bulbasaur")

        let emptyNameItem = PokemonListItem(
            name: "",
            url: "https://pokeapi.co/api/v2/pokemon/1/"
        )
        XCTAssertEqual(emptyNameItem.formattedName, "")

        let mixedCaseItem = PokemonListItem(
            name: "pIkAcHu",
            url: "https://pokeapi.co/api/v2/pokemon/25/"
        )
        XCTAssertEqual(mixedCaseItem.formattedName, "Pikachu")

        let hyphenatedItem = PokemonListItem(
            name: "mr-mime",
            url: "https://pokeapi.co/api/v2/pokemon/122/"
        )
        XCTAssertEqual(hyphenatedItem.formattedName, "Mr-Mime")
    }

    func testPokemonNumber() {
        let item1 = TestData.pokemonListItemBulbasaur
        XCTAssertEqual(item1.pokemonNumber, "#001")

        let item25 = PokemonListItem(
            name: "pikachu",
            url: "https://pokeapi.co/api/v2/pokemon/25/"
        )
        XCTAssertEqual(item25.pokemonNumber, "#025")

        let item150 = PokemonListItem(
            name: "mewtwo",
            url: "https://pokeapi.co/api/v2/pokemon/150/"
        )
        XCTAssertEqual(item150.pokemonNumber, "#150")

        let invalidItem = PokemonListItem(
            name: "invalid",
            url: "invalid-url"
        )
        XCTAssertEqual(invalidItem.pokemonNumber, "#000")
    }

    func testPokemonListItemCodable() throws {
        let item = TestData.pokemonListItemBulbasaur

        let encodedData = try JSONEncoder().encode(item)
        let decodedItem = try JSONDecoder().decode(PokemonListItem.self, from: encodedData)

        XCTAssertEqual(item, decodedItem)
    }

    func testPokemonListItemWithSpecialCharacters() {
        let specialItem = PokemonListItem(
            name: "farfetch'd",
            url: "https://pokeapi.co/api/v2/pokemon/83/"
        )

        XCTAssertEqual(specialItem.name, "farfetch'd")
        XCTAssertEqual(specialItem.formattedName, "Farfetch'd")
        XCTAssertEqual(specialItem.pokemonId, 83)
    }

    // MARK: - Edge Cases
    func testPokemonIdWithLargeNumbers() {
        let largeIdItem = PokemonListItem(
            name: "test",
            url: "https://pokeapi.co/api/v2/pokemon/999999/"
        )
        XCTAssertEqual(largeIdItem.pokemonId, 999999)

        let maxIntItem = PokemonListItem(
            name: "test",
            url: "https://pokeapi.co/api/v2/pokemon/\(Int.max)/"
        )
        XCTAssertEqual(maxIntItem.pokemonId, Int.max)
    }

    func testPokemonIdWithZero() {
        let zeroItem = PokemonListItem(
            name: "test",
            url: "https://pokeapi.co/api/v2/pokemon/0/"
        )
        XCTAssertEqual(zeroItem.pokemonId, 0)
    }

    func testPokemonIdWithNegativeNumber() {
        let negativeItem = PokemonListItem(
            name: "test",
            url: "https://pokeapi.co/api/v2/pokemon/-1/"
        )
        XCTAssertEqual(negativeItem.pokemonId, -1)
    }
}
