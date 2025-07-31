//
//  PokemonTests.swift
//  PokedexPocketTests
//
//  Created by Azri on 30/07/25.
//

import XCTest
@testable import PokedexPocket

final class PokemonTests: XCTestCase {

    // MARK: - Test Properties
    func testPokemonIdentifiable() {
        let pokemon = TestData.pokemonBulbasaur
        XCTAssertEqual(pokemon.id, 1)
    }

    func testPokemonEquality() {
        let pokemon1 = TestData.pokemonBulbasaur
        let pokemon2 = TestData.pokemonBulbasaur
        let pokemon3 = TestData.pokemonIvysaur

        XCTAssertEqual(pokemon1, pokemon2)
        XCTAssertNotEqual(pokemon1, pokemon3)
    }

    func testFormattedName() {
        let pokemon = TestData.pokemonBulbasaur
        XCTAssertEqual(pokemon.formattedName, "Bulbasaur")

        let emptyNamePokemon = Pokemon(id: 1, name: "", url: "")
        XCTAssertEqual(emptyNamePokemon.formattedName, "")

        let mixedCasePokemon = Pokemon(id: 1, name: "pIkAcHu", url: "")
        XCTAssertEqual(mixedCasePokemon.formattedName, "Pikachu")
    }

    func testPokemonNumber() {
        let pokemon = TestData.pokemonBulbasaur
        XCTAssertEqual(pokemon.pokemonNumber, "#001")

        let pokemon25 = Pokemon(id: 25, name: "pikachu", url: "")
        XCTAssertEqual(pokemon25.pokemonNumber, "#025")

        let pokemon150 = Pokemon(id: 150, name: "mewtwo", url: "")
        XCTAssertEqual(pokemon150.pokemonNumber, "#150")

        let pokemon1000 = Pokemon(id: 1000, name: "test", url: "")
        XCTAssertEqual(pokemon1000.pokemonNumber, "#1000")
    }

    func testHeightInMeters() {
        let pokemon = TestData.pokemonBulbasaur
        XCTAssertEqual(pokemon.heightInMeters, 0.7, accuracy: 0.01)

        let tallPokemon = Pokemon(id: 1, name: "test", url: "", height: 100)
        XCTAssertEqual(tallPokemon.heightInMeters, 10.0, accuracy: 0.01)

        let zeroPokemon = Pokemon(id: 1, name: "test", url: "", height: 0)
        XCTAssertEqual(zeroPokemon.heightInMeters, 0.0, accuracy: 0.01)
    }

    func testWeightInKilograms() {
        let pokemon = TestData.pokemonBulbasaur
        XCTAssertEqual(pokemon.weightInKilograms, 6.9, accuracy: 0.01)

        let heavyPokemon = Pokemon(id: 1, name: "test", url: "", weight: 1000)
        XCTAssertEqual(heavyPokemon.weightInKilograms, 100.0, accuracy: 0.01)

        let zeroPokemon = Pokemon(id: 1, name: "test", url: "", weight: 0)
        XCTAssertEqual(zeroPokemon.weightInKilograms, 0.0, accuracy: 0.01)
    }

    // MARK: - Test Initialization
    func testInitializationWithAllParameters() {
        let pokemon = Pokemon(
            id: 25,
            name: "pikachu",
            url: "https://pokeapi.co/api/v2/pokemon/25/",
            imageURL: "https://example.com/pikachu.png",
            types: [PokemonType(name: "electric")],
            height: 4,
            weight: 60,
            stats: [PokemonStat(name: "hp", value: 35)]
        )

        XCTAssertEqual(pokemon.id, 25)
        XCTAssertEqual(pokemon.name, "pikachu")
        XCTAssertEqual(pokemon.url, "https://pokeapi.co/api/v2/pokemon/25/")
        XCTAssertEqual(pokemon.imageURL, "https://example.com/pikachu.png")
        XCTAssertEqual(pokemon.types.count, 1)
        XCTAssertEqual(pokemon.types.first?.name, "electric")
        XCTAssertEqual(pokemon.height, 4)
        XCTAssertEqual(pokemon.weight, 60)
        XCTAssertEqual(pokemon.stats.count, 1)
        XCTAssertEqual(pokemon.stats.first?.name, "hp")
    }

    func testInitializationWithMinimalParameters() {
        let pokemon = Pokemon(id: 1, name: "test", url: "https://example.com")

        XCTAssertEqual(pokemon.id, 1)
        XCTAssertEqual(pokemon.name, "test")
        XCTAssertEqual(pokemon.url, "https://example.com")
        XCTAssertEqual(pokemon.imageURL, "")
        XCTAssertEqual(pokemon.types.count, 0)
        XCTAssertEqual(pokemon.height, 0)
        XCTAssertEqual(pokemon.weight, 0)
        XCTAssertEqual(pokemon.stats.count, 0)
    }

    func testInitializationWithDefaults() {
        let pokemon = Pokemon(
            id: 150,
            name: "mewtwo",
            url: "https://pokeapi.co/api/v2/pokemon/150/"
        )

        XCTAssertEqual(pokemon.imageURL, "")
        XCTAssertTrue(pokemon.types.isEmpty)
        XCTAssertEqual(pokemon.height, 0)
        XCTAssertEqual(pokemon.weight, 0)
        XCTAssertTrue(pokemon.stats.isEmpty)
    }
}

// MARK: - PokemonType Tests
final class PokemonTypeTests: XCTestCase {

    func testTypeInitialization() {
        let fireType = PokemonType(name: "fire")

        XCTAssertEqual(fireType.id, "fire")
        XCTAssertEqual(fireType.name, "fire")
        XCTAssertEqual(fireType.color, "#F08030")
    }

    func testTypeEquality() {
        let type1 = PokemonType(name: "fire")
        let type2 = PokemonType(name: "fire")
        let type3 = PokemonType(name: "water")

        XCTAssertEqual(type1, type2)
        XCTAssertNotEqual(type1, type3)
    }

    func testPrimaryTypeColors() {
        XCTAssertEqual(PokemonType(name: "fire").color, "#F08030")
        XCTAssertEqual(PokemonType(name: "water").color, "#6890F0")
        XCTAssertEqual(PokemonType(name: "grass").color, "#78C850")
        XCTAssertEqual(PokemonType(name: "electric").color, "#F8D030")
        XCTAssertEqual(PokemonType(name: "psychic").color, "#F85888")
        XCTAssertEqual(PokemonType(name: "ice").color, "#98D8D8")
        XCTAssertEqual(PokemonType(name: "dragon").color, "#7038F8")
        XCTAssertEqual(PokemonType(name: "dark").color, "#705848")
        XCTAssertEqual(PokemonType(name: "fairy").color, "#EE99AC")
    }

    func testSecondaryTypeColors() {
        XCTAssertEqual(PokemonType(name: "normal").color, "#A8A878")
        XCTAssertEqual(PokemonType(name: "fighting").color, "#C03028")
        XCTAssertEqual(PokemonType(name: "poison").color, "#A040A0")
        XCTAssertEqual(PokemonType(name: "ground").color, "#E0C068")
        XCTAssertEqual(PokemonType(name: "flying").color, "#A890F0")
        XCTAssertEqual(PokemonType(name: "bug").color, "#A8B820")
        XCTAssertEqual(PokemonType(name: "rock").color, "#B8A038")
        XCTAssertEqual(PokemonType(name: "ghost").color, "#705898")
        XCTAssertEqual(PokemonType(name: "steel").color, "#B8B8D0")
    }

    func testDefaultColor() {
        let unknownType = PokemonType(name: "unknown")
        XCTAssertEqual(unknownType.color, "#68A090")

        let emptyType = PokemonType(name: "")
        XCTAssertEqual(emptyType.color, "#68A090")
    }

    func testCaseInsensitiveColor() {
        let upperCaseType = PokemonType(name: "FIRE")
        XCTAssertEqual(upperCaseType.color, "#F08030")

        let mixedCaseType = PokemonType(name: "WaTeR")
        XCTAssertEqual(mixedCaseType.color, "#6890F0")
    }

    func testColorForTypeStaticMethod() {
        XCTAssertEqual(PokemonType.colorForType("fire"), "#F08030")
        XCTAssertEqual(PokemonType.colorForType("FIRE"), "#F08030")
        XCTAssertEqual(PokemonType.colorForType("unknown"), "#68A090")
        XCTAssertEqual(PokemonType.colorForType(""), "#68A090")
    }

    func testTypeCodable() throws {
        let type = PokemonType(name: "electric")

        let encodedData = try JSONEncoder().encode(type)
        let decodedType = try JSONDecoder().decode(PokemonType.self, from: encodedData)

        XCTAssertEqual(type, decodedType)
    }
}

// MARK: - PokemonStat Tests
final class PokemonStatTests: XCTestCase {

    func testStatInitialization() {
        let stat = PokemonStat(name: "hp", value: 35)

        XCTAssertEqual(stat.id, "hp")
        XCTAssertEqual(stat.name, "hp")
        XCTAssertEqual(stat.value, 35)
    }

    func testStatEquality() {
        let stat1 = PokemonStat(name: "hp", value: 35)
        let stat2 = PokemonStat(name: "hp", value: 35)
        let stat3 = PokemonStat(name: "hp", value: 50)
        let stat4 = PokemonStat(name: "attack", value: 35)

        XCTAssertEqual(stat1, stat2)
        XCTAssertNotEqual(stat1, stat3)
        XCTAssertNotEqual(stat1, stat4)
    }

    func testStatWithZeroValue() {
        let stat = PokemonStat(name: "defense", value: 0)

        XCTAssertEqual(stat.name, "defense")
        XCTAssertEqual(stat.value, 0)
    }

    func testStatWithNegativeValue() {
        let stat = PokemonStat(name: "speed", value: -10)

        XCTAssertEqual(stat.name, "speed")
        XCTAssertEqual(stat.value, -10)
    }

    func testStatWithEmptyName() {
        let stat = PokemonStat(name: "", value: 100)

        XCTAssertEqual(stat.id, "")
        XCTAssertEqual(stat.name, "")
        XCTAssertEqual(stat.value, 100)
    }

    func testStatCodable() throws {
        let stat = PokemonStat(name: "special-attack", value: 90)

        let encodedData = try JSONEncoder().encode(stat)
        let decodedStat = try JSONDecoder().decode(PokemonStat.self, from: encodedData)

        XCTAssertEqual(stat, decodedStat)
    }
}
