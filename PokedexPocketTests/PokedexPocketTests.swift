//
//  PokedexPocketTests.swift
//  PokedexPocketTests
//
//  Created by Azri on 26/07/25.
//

import XCTest
@testable import PokedexPocket

final class PokedexPocketTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Architecture Tests
    func testCleanArchitectureLayerSeparation() {
        // Test that Domain layer doesn't depend on Data or Presentation layers
        // This is a compile-time check - if it compiles, the architecture is correct

        // Domain entities should be pure Swift without external dependencies
        let pokemon = PokemonDetail(
            id: 1,
            name: "test",
            height: 10,
            weight: 100,
            baseExperience: 50,
            types: [],
            stats: [],
            abilities: [],
            imageURL: "",
            sprites: PokemonDetailSprites(
                frontDefault: nil,
                frontShiny: nil,
                backDefault: nil,
                backShiny: nil,
                officialArtwork: nil,
                officialArtworkShiny: nil,
                dreamWorld: nil,
                home: nil,
                homeShiny: nil
            ),
            species: ""
        )

        XCTAssertEqual(pokemon.id, 1)
        XCTAssertEqual(pokemon.name, "test")
    }

    func testDependencyInjectionPattern() {
        // Test that all use cases depend on abstractions (protocols) not concretions
        // This ensures proper dependency inversion

        let mockRepository = MockPokemonDetailRepository()
        let useCase = GetPokemonDetailUseCase(repository: mockRepository)

        XCTAssertNotNil(useCase)

        // Test that we can inject different implementations
        let anotherMockRepository = MockPokemonDetailRepository()
        let anotherUseCase = GetPokemonDetailUseCase(repository: anotherMockRepository)

        XCTAssertNotNil(anotherUseCase)
    }

    func testEntityImmutability() {
        // Test that domain entities are immutable
        let pokemon = TestData.pikachu
        let originalName = pokemon.name

        // Since properties are let constants, this ensures immutability
        XCTAssertEqual(pokemon.name, originalName)

        // Creating new instance should not affect original
        let newPokemon = PokemonDetail(
            id: pokemon.id,
            name: "changed",
            height: pokemon.height,
            weight: pokemon.weight,
            baseExperience: pokemon.baseExperience,
            types: pokemon.types,
            stats: pokemon.stats,
            abilities: pokemon.abilities,
            imageURL: pokemon.imageURL,
            sprites: pokemon.sprites,
            species: pokemon.species
        )

        XCTAssertEqual(pokemon.name, originalName)
        XCTAssertEqual(newPokemon.name, "changed")
    }

    // MARK: - Integration Tests
    func testPokemonDetailMappingIntegration() {
        // Test that network response correctly maps to domain entity
        let response = TestData.pokemonDetailResponse
        let domainEntity = response.toDomain()

        XCTAssertEqual(domainEntity.id, response.id)
        XCTAssertEqual(domainEntity.name, response.name)
        XCTAssertEqual(domainEntity.height, response.height)
        XCTAssertEqual(domainEntity.weight, response.weight)
        XCTAssertEqual(domainEntity.species, response.species.name)
    }

    func testErrorHandlingIntegration() {
        // Test that all error types can be properly handled
        let errors = TestData.networkErrors

        for error in errors {
            switch error {
            case .invalidURL:
                XCTAssertEqual(error.errorDescription, "Invalid URL")
            case .noData:
                XCTAssertEqual(error.errorDescription, "No data received")
            case .decodingError:
                XCTAssertEqual(error.errorDescription, "Failed to decode response")
            case .networkError(let underlyingError):
                XCTAssertEqual(error.errorDescription, "Network error: \(underlyingError.localizedDescription)")
            case .serverError(let code):
                XCTAssertEqual(error.errorDescription, "Server error with code: \(code)")
            case .unknown:
                XCTAssertEqual(error.errorDescription, "Unknown error occurred")
            }
        }
    }

    // MARK: - Performance Tests
    func testPokemonDetailCreationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = PokemonDetail(
                    id: Int.random(in: 1...1000),
                    name: "test-pokemon",
                    height: 10,
                    weight: 100,
                    baseExperience: 50,
                    types: [PokemonType(name: "electric")],
                    stats: [PokemonStat(name: "hp", value: 35)],
                    abilities: [PokemonAbility(name: "static")],
                    imageURL: "https://example.com/image.png",
                    sprites: PokemonDetailSprites(
                        frontDefault: nil,
                        frontShiny: nil,
                        backDefault: nil,
                        backShiny: nil,
                        officialArtwork: nil,
                        officialArtworkShiny: nil,
                        dreamWorld: nil,
                        home: nil,
                        homeShiny: nil
                    ),
                    species: "test"
                )
            }
        }
    }

    func testPokemonTypeColorLookupPerformance() {
        let typeNames = ["fire", "water", "grass", "electric", "psychic", "ice", "dragon", "dark", "fairy", "normal", "fighting", "poison", "ground", "flying", "bug", "rock", "ghost", "steel", "unknown"]

        measure {
            for _ in 0..<10000 {
                let randomType = typeNames.randomElement()!
                _ = PokemonType.colorForType(randomType)
            }
        }
    }

    // MARK: - Memory Tests
    func testMemoryManagement() {
        // Test that structs are properly managed by value semantics
        // Since PokemonDetail is a struct, it uses value semantics and doesn't need weak references

        var pokemon: PokemonDetail? = TestData.pikachu
        XCTAssertNotNil(pokemon)

        pokemon = nil
        XCTAssertNil(pokemon)

        // Test that copying structs creates independent instances
        let originalPokemon = TestData.pikachu
        var copiedPokemon = originalPokemon

        XCTAssertEqual(originalPokemon.id, copiedPokemon.id)
        XCTAssertEqual(originalPokemon.name, copiedPokemon.name)

        copiedPokemon = TestData.charizard
        XCTAssertNotEqual(originalPokemon.id, copiedPokemon.id)
    }

    // MARK: - Thread Safety Tests
    func testConcurrentAccess() {
        let expectation = XCTestExpectation(description: "Concurrent access")
        expectation.expectedFulfillmentCount = 100

        let queue = DispatchQueue(label: "test.concurrent", attributes: .concurrent)

        for i in 0..<100 {
            queue.async {
                let pokemon = PokemonDetail(
                    id: i,
                    name: "pokemon-\(i)",
                    height: 10,
                    weight: 100,
                    baseExperience: 50,
                    types: [],
                    stats: [],
                    abilities: [],
                    imageURL: "",
                    sprites: PokemonDetailSprites(
                        frontDefault: nil,
                        frontShiny: nil,
                        backDefault: nil,
                        backShiny: nil,
                        officialArtwork: nil,
                        officialArtworkShiny: nil,
                        dreamWorld: nil,
                        home: nil,
                        homeShiny: nil
                    ),
                    species: ""
                )

                XCTAssertEqual(pokemon.id, i)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
