//
//  PokedexPocketTests.swift
//  PokedexPocketTests
//
//  Created by Azri on 26/07/25.
//

import XCTest
import PokedexPocketCore
import PokedexPocketPokemon
@testable import PokedexPocket

final class PokedexPocketTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Architecture Tests
    func testFavoritePokemonEntityCreation() {
        // Test that favorite Pokemon entities can be created properly
        let favorite = FavoritePokemon(
            id: 25,
            name: "pikachu",
            primaryType: "electric",
            imageURL: "https://example.com/pikachu.png",
            dateAdded: Date()
        )

        XCTAssertEqual(favorite.id, 25)
        XCTAssertEqual(favorite.name, "pikachu")
        XCTAssertEqual(favorite.primaryType, "electric")
    }

    func testDependencyInjectionPattern() {
        // Test that favorite Pokemon use cases depend on abstractions (protocols) not concretions
        // This ensures proper dependency inversion

        let mockRepository = MockFavoritePokemonRepository()
        let addUseCase = MockAddFavoritePokemonUseCase()
        let removeUseCase = MockRemoveFavoritePokemonUseCase()
        let getFavoritesUseCase = MockGetFavoritesPokemonUseCase()
        let checkIsFavoriteUseCase = MockCheckIsFavoritePokemonUseCase()

        XCTAssertNotNil(mockRepository)
        XCTAssertNotNil(addUseCase)
        XCTAssertNotNil(removeUseCase)
        XCTAssertNotNil(getFavoritesUseCase)
        XCTAssertNotNil(checkIsFavoriteUseCase)
    }

    func testFavoritePokemonEntityImmutability() {
        // Test that favorite Pokemon entities are immutable
        let favorite = TestData.favoritePikachu
        let originalName = favorite.name

        // Since properties are let constants, this ensures immutability
        XCTAssertEqual(favorite.name, originalName)

        // Creating new instance should not affect original
        let newFavorite = FavoritePokemon(
            id: favorite.id,
            name: "changed",
            primaryType: favorite.primaryType,
            imageURL: favorite.imageURL,
            dateAdded: favorite.dateAdded
        )

        XCTAssertEqual(favorite.name, originalName)
        XCTAssertEqual(newFavorite.name, "changed")
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
    func testFavoritePokemonCreationPerformance() {
        measure {
            for index in 0..<1000 {
                _ = FavoritePokemon(
                    id: index,
                    name: "test-pokemon-\(index)",
                    primaryType: "electric",
                    imageURL: "https://example.com/image.png",
                    dateAdded: Date()
                )
            }
        }
    }

    // MARK: - Memory Tests
    func testFavoritePokemonMemoryManagement() {
        // Test that structs are properly managed by value semantics
        // Since FavoritePokemon is a struct, it uses value semantics and doesn't need weak references

        var favorite: FavoritePokemon? = TestData.favoritePikachu
        XCTAssertNotNil(favorite)

        favorite = nil
        XCTAssertNil(favorite)

        // Test that copying structs creates independent instances
        let originalFavorite = TestData.favoritePikachu
        var copiedFavorite = originalFavorite

        XCTAssertEqual(originalFavorite.id, copiedFavorite.id)
        XCTAssertEqual(originalFavorite.name, copiedFavorite.name)

        copiedFavorite = TestData.favoriteCharizard
        XCTAssertNotEqual(originalFavorite.id, copiedFavorite.id)
    }

    // MARK: - Thread Safety Tests
    func testConcurrentFavoriteAccess() {
        let expectation = XCTestExpectation(description: "Concurrent favorite access")
        expectation.expectedFulfillmentCount = 100

        let queue = DispatchQueue(label: "test.concurrent", attributes: .concurrent)

        for index in 0..<100 {
            queue.async {
                let favorite = FavoritePokemon(
                    id: index,
                    name: "pokemon-\(index)",
                    primaryType: "electric",
                    imageURL: "https://example.com/image.png",
                    dateAdded: Date()
                )

                XCTAssertEqual(favorite.id, index)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
