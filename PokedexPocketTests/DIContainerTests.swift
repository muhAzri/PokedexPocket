//
//  DIContainerTests.swift
//  PokedexPocketTests
//
//  Created by Azri on 01/08/25.
//

import XCTest
import SwiftData
@testable import PokedexPocket
import PokedexPocketCore
import PokedexPocketPokemon
import PokedexPocketFavourite

final class DIContainerTests: XCTestCase {
    
    var container: DIContainer!
    var mockModelContext: ModelContext!
    
    override func setUpWithError() throws {
        // Create a temporary in-memory model container for testing
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: FavouritePokemonDataModel.self, configurations: configuration)
        mockModelContext = ModelContext(modelContainer)
        
        // Get a fresh instance of DIContainer for each test
        container = DIContainer.shared
        container.setModelContext(mockModelContext)
    }
    
    override func tearDownWithError() throws {
        container = nil
        mockModelContext = nil
    }
    
    func testDIContainerIsSharedInstance() {
        // Given & When
        let container1 = DIContainer.shared
        let container2 = DIContainer.shared
        
        // Then
        XCTAssertTrue(container1 === container2, "DIContainer should be a singleton")
    }
    
    func testResolveNetworkConfiguration() {
        // Given & When
        let networkConfig = container.resolve(NetworkConfiguration.self)
        
        // Then
        XCTAssertNotNil(networkConfig, "Should be able to resolve NetworkConfiguration")
    }
    
    func testResolveNetworkService() {
        // Given & When
        let networkService = container.resolve(NetworkServiceProtocol.self)
        
        // Then
        XCTAssertNotNil(networkService, "Should be able to resolve NetworkServiceProtocol")
    }
    
    func testResolveCacheManager() {
        // Given & When
        let cacheManager = container.resolve(CacheManagerProtocol.self)
        
        // Then
        XCTAssertNotNil(cacheManager, "Should be able to resolve CacheManagerProtocol")
    }
    
    func testResolveViewModelFactory() {
        // Given & When
        let viewModelFactory = container.resolve(ViewModelFactory.self)
        
        // Then
        XCTAssertNotNil(viewModelFactory, "Should be able to resolve ViewModelFactory")
    }
    
    func testResolvePokemonRepositories() {
        // Given & When
        let pokemonListRepo = container.resolve(PokemonListRepositoryProtocol.self)
        let pokemonDetailRepo = container.resolve(PokemonDetailRepositoryProtocol.self)
        
        // Then
        XCTAssertNotNil(pokemonListRepo, "Should be able to resolve PokemonListRepositoryProtocol")
        XCTAssertNotNil(pokemonDetailRepo, "Should be able to resolve PokemonDetailRepositoryProtocol")
    }
    
    func testResolveFavoriteRepository() {
        // Given & When
        let favoriteRepo = container.resolve(FavoritePokemonRepositoryProtocol.self)
        
        // Then
        XCTAssertNotNil(favoriteRepo, "Should be able to resolve FavoritePokemonRepositoryProtocol")
    }
    
    func testResolvePokemonUseCases() {
        // Given & When
        let getPokemonListUseCase = container.resolve(GetPokemonListUseCaseProtocol.self)
        let getPokemonDetailUseCase = container.resolve(GetPokemonDetailUseCaseProtocol.self)
        let searchPokemonUseCase = container.resolve(SearchPokemonUseCaseProtocol.self)
        
        // Then
        XCTAssertNotNil(getPokemonListUseCase, "Should be able to resolve GetPokemonListUseCaseProtocol")
        XCTAssertNotNil(getPokemonDetailUseCase, "Should be able to resolve GetPokemonDetailUseCaseProtocol")
        XCTAssertNotNil(searchPokemonUseCase, "Should be able to resolve SearchPokemonUseCaseProtocol")
    }
    
    func testResolveFavoriteUseCases() {
        // Given & When
        let addFavoriteUseCase = container.resolve(AddFavoritePokemonUseCaseProtocol.self)
        let removeFavoriteUseCase = container.resolve(RemoveFavoritePokemonUseCaseProtocol.self)
        let getFavoritesUseCase = container.resolve(GetFavoritesPokemonUseCaseProtocol.self)
        let checkIsFavoriteUseCase = container.resolve(CheckIsFavoritePokemonUseCaseProtocol.self)
        let clearAllFavoritesUseCase = container.resolve(ClearAllFavoritesUseCaseProtocol.self)
        
        // Then
        XCTAssertNotNil(addFavoriteUseCase, "Should be able to resolve AddFavoritePokemonUseCaseProtocol")
        XCTAssertNotNil(removeFavoriteUseCase, "Should be able to resolve RemoveFavoritePokemonUseCaseProtocol")
        XCTAssertNotNil(getFavoritesUseCase, "Should be able to resolve GetFavoritesPokemonUseCaseProtocol")
        XCTAssertNotNil(checkIsFavoriteUseCase, "Should be able to resolve CheckIsFavoritePokemonUseCaseProtocol")
        XCTAssertNotNil(clearAllFavoritesUseCase, "Should be able to resolve ClearAllFavoritesUseCaseProtocol")
    }
    
    func testSetModelContextUpdatesContext() throws {
        // Given
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let newModelContainer = try ModelContainer(for: FavouritePokemonDataModel.self, configurations: configuration)
        let newModelContext = ModelContext(newModelContainer)
        
        // When
        container.setModelContext(newModelContext)
        
        // Then - Should not crash when resolving repository that depends on ModelContext
        let favoriteRepo = container.resolve(FavoritePokemonRepositoryProtocol.self)
        XCTAssertNotNil(favoriteRepo, "Should be able to resolve repository after setting ModelContext")
    }
}
