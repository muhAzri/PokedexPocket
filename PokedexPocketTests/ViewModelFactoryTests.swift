//
//  ViewModelFactoryTests.swift
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

final class ViewModelFactoryTests: XCTestCase {
    
    var viewModelFactory: DefaultViewModelFactory!
    var container: DIContainer!
    var mockModelContext: ModelContext!
    
    override func setUpWithError() throws {
        // Create a temporary in-memory model container for testing
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: FavouritePokemonDataModel.self, configurations: configuration)
        mockModelContext = ModelContext(modelContainer)
        
        // Setup DI container with test context
        container = DIContainer.shared
        container.setModelContext(mockModelContext)
        
        // Create view model factory
        viewModelFactory = DefaultViewModelFactory(container: container)
    }
    
    override func tearDownWithError() throws {
        viewModelFactory = nil
        container = nil
        mockModelContext = nil
    }
    
    func testMakePokemonListViewModel() {
        // Given & When
        let viewModel = viewModelFactory.makePokemonListViewModel()
        
        // Then
        XCTAssertNotNil(viewModel, "Should create PokemonListViewModel")
        XCTAssertTrue(type(of: viewModel) == PokedexPocketPokemon.PokemonListViewModel.self,
                     "Should return correct PokemonListViewModel type")
    }
    
    func testMakePokemonDetailViewModel() {
        // Given
        let pokemonId = 25
        
        // When
        let viewModel = viewModelFactory.makePokemonDetailViewModel(pokemonId: pokemonId)
        
        // Then
        XCTAssertNotNil(viewModel, "Should create PokemonDetailViewModel")
        XCTAssertTrue(type(of: viewModel) == PokedexPocketPokemon.PokemonDetailViewModel.self,
                     "Should return correct PokemonDetailViewModel type")
    }
    
    func testMakeFavoritePokemonViewModel() {
        // Given & When
        let viewModel = viewModelFactory.makeFavoritePokemonViewModel()
        
        // Then
        XCTAssertNotNil(viewModel, "Should create FavoritePokemonViewModel")
        XCTAssertTrue(type(of: viewModel) == FavoritePokemonViewModel.self,
                     "Should return correct FavoritePokemonViewModel type")
    }
    
    func testViewModelFactoryUsesCorrectContainer() {
        // Given
        let customContainer = DIContainer.shared
        let factoryWithCustomContainer = DefaultViewModelFactory(container: customContainer)
        
        // When
        let viewModel = factoryWithCustomContainer.makePokemonListViewModel()
        
        // Then
        XCTAssertNotNil(viewModel, "Should create view model with custom container")
    }
    
    func testMultiplePokemonDetailViewModelsWithDifferentIds() {
        // Given
        let pokemonId1 = 1
        let pokemonId2 = 150
        
        // When
        let viewModel1 = viewModelFactory.makePokemonDetailViewModel(pokemonId: pokemonId1)
        let viewModel2 = viewModelFactory.makePokemonDetailViewModel(pokemonId: pokemonId2)
        
        // Then
        XCTAssertNotNil(viewModel1, "Should create first PokemonDetailViewModel")
        XCTAssertNotNil(viewModel2, "Should create second PokemonDetailViewModel")
        XCTAssertFalse(viewModel1 === viewModel2, "Should create different instances")
    }
    
    func testFactoryCreatesNewInstancesEachTime() {
        // Given & When
        let viewModel1 = viewModelFactory.makePokemonListViewModel()
        let viewModel2 = viewModelFactory.makePokemonListViewModel()
        
        // Then
        XCTAssertNotNil(viewModel1, "Should create first PokemonListViewModel")
        XCTAssertNotNil(viewModel2, "Should create second PokemonListViewModel")
        XCTAssertFalse(viewModel1 === viewModel2, "Should create new instances each time")
    }
    
    func testFavoriteViewModelCreation() {
        // Given & When
        let favoriteViewModel1 = viewModelFactory.makeFavoritePokemonViewModel()
        let favoriteViewModel2 = viewModelFactory.makeFavoritePokemonViewModel()
        
        // Then
        XCTAssertNotNil(favoriteViewModel1, "Should create first FavoritePokemonViewModel")
        XCTAssertNotNil(favoriteViewModel2, "Should create second FavoritePokemonViewModel")
        XCTAssertFalse(favoriteViewModel1 === favoriteViewModel2, "Should create new instances each time")
    }
}