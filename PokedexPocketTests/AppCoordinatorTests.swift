//
//  AppCoordinatorTests.swift
//  PokedexPocketTests
//
//  Created by Azri on 01/08/25.
//

import XCTest
import SwiftUI
@testable import PokedexPocket

@MainActor
final class AppCoordinatorTests: XCTestCase {
    
    var coordinator: AppCoordinator!
    
    override func setUpWithError() throws {
        coordinator = AppCoordinator()
    }
    
    override func tearDownWithError() throws {
        coordinator = nil
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        // Then
        XCTAssertEqual(coordinator.selectedTab, .home, "Should start with home tab selected")
        XCTAssertEqual(coordinator.navigationPath.count, 0, "Home navigation path should be empty initially")
        XCTAssertEqual(coordinator.favouritesNavigationPath.count, 0, "Favorites navigation path should be empty initially")
        XCTAssertEqual(coordinator.aboutNavigationPath.count, 0, "About navigation path should be empty initially")
    }
    
    // MARK: - Tab Switching Tests
    
    func testSwitchToFavoritesTab() {
        // When
        coordinator.switchTab(to: .favourites)
        
        // Then
        XCTAssertEqual(coordinator.selectedTab, .favourites, "Should switch to favorites tab")
    }
    
    func testSwitchToAboutTab() {
        // When
        coordinator.switchTab(to: .about)
        
        // Then
        XCTAssertEqual(coordinator.selectedTab, .about, "Should switch to about tab")
    }
    
    func testSwitchBackToHomeTab() {
        // Given
        coordinator.switchTab(to: .favourites)
        
        // When
        coordinator.switchTab(to: .home)
        
        // Then
        XCTAssertEqual(coordinator.selectedTab, .home, "Should switch back to home tab")
    }
    
    // MARK: - Navigation Tests
    
    func testNavigateFromHomeTab() {
        // Given
        coordinator.selectedTab = .home
        let destination = AppDestination.pokemonDetail(pokemonId: 25, pokemonName: "Pikachu")
        
        // When
        coordinator.navigate(to: destination)
        
        // Then
        XCTAssertEqual(coordinator.navigationPath.count, 1, "Should add destination to home navigation path")
        XCTAssertEqual(coordinator.favouritesNavigationPath.count, 0, "Should not affect favorites navigation path")
        XCTAssertEqual(coordinator.aboutNavigationPath.count, 0, "Should not affect about navigation path")
    }
    
    func testNavigateFromFavoritesTab() {
        // Given
        coordinator.selectedTab = .favourites
        let destination = AppDestination.pokemonDetail(pokemonId: 150, pokemonName: "Mewtwo")
        
        // When
        coordinator.navigate(to: destination)
        
        // Then
        XCTAssertEqual(coordinator.favouritesNavigationPath.count, 1, "Should add destination to favorites navigation path")
        XCTAssertEqual(coordinator.navigationPath.count, 0, "Should not affect home navigation path")
        XCTAssertEqual(coordinator.aboutNavigationPath.count, 0, "Should not affect about navigation path")
    }
    
    func testNavigateFromAboutTab() {
        // Given
        coordinator.selectedTab = .about
        let destination = AppDestination.pokemonList
        
        // When
        coordinator.navigate(to: destination)
        
        // Then
        XCTAssertEqual(coordinator.aboutNavigationPath.count, 1, "Should add destination to about navigation path")
        XCTAssertEqual(coordinator.navigationPath.count, 0, "Should not affect home navigation path")
        XCTAssertEqual(coordinator.favouritesNavigationPath.count, 0, "Should not affect favorites navigation path")
    }
    
    func testNavigateToPokemonDetailHelper() {
        // Given
        coordinator.selectedTab = .home
        let pokemonId = 1
        let pokemonName = "Bulbasaur"
        
        // When
        coordinator.navigateToPokemonDetail(pokemonId: pokemonId, pokemonName: pokemonName)
        
        // Then
        XCTAssertEqual(coordinator.navigationPath.count, 1, "Should add pokemon detail to navigation path")
    }
    
    // MARK: - Navigation Back Tests
    
    func testNavigateBackFromHomeTab() {
        // Given
        coordinator.selectedTab = .home
        coordinator.navigate(to: .pokemonList)
        coordinator.navigate(to: .pokemonDetail(pokemonId: 25, pokemonName: "Pikachu"))
        XCTAssertEqual(coordinator.navigationPath.count, 2, "Should have 2 items in navigation path")
        
        // When
        coordinator.navigateBack()
        
        // Then
        XCTAssertEqual(coordinator.navigationPath.count, 1, "Should remove last item from home navigation path")
    }
    
    func testNavigateBackFromFavoritesTab() {
        // Given
        coordinator.selectedTab = .favourites
        coordinator.navigate(to: .pokemonDetail(pokemonId: 150, pokemonName: "Mewtwo"))
        XCTAssertEqual(coordinator.favouritesNavigationPath.count, 1, "Should have 1 item in favorites navigation path")
        
        // When
        coordinator.navigateBack()
        
        // Then
        XCTAssertEqual(coordinator.favouritesNavigationPath.count, 0, "Should remove last item from favorites navigation path")
    }
    
    func testNavigateBackFromAboutTab() {
        // Given
        coordinator.selectedTab = .about
        coordinator.navigate(to: .pokemonList)
        XCTAssertEqual(coordinator.aboutNavigationPath.count, 1, "Should have 1 item in about navigation path")
        
        // When
        coordinator.navigateBack()
        
        // Then
        XCTAssertEqual(coordinator.aboutNavigationPath.count, 0, "Should remove last item from about navigation path")
    }
    
    func testNavigateBackWhenPathIsEmpty() {
        // Given
        coordinator.selectedTab = .home
        XCTAssertEqual(coordinator.navigationPath.count, 0, "Navigation path should be empty")
        
        // When
        coordinator.navigateBack()
        
        // Then
        XCTAssertEqual(coordinator.navigationPath.count, 0, "Navigation path should remain empty")
    }
    
    // MARK: - Navigate to Root Tests
    
    func testNavigateToRootFromHomeTab() {
        // Given
        coordinator.selectedTab = .home
        coordinator.navigate(to: .pokemonList)
        coordinator.navigate(to: .pokemonDetail(pokemonId: 25, pokemonName: "Pikachu"))
        coordinator.navigate(to: .favouritePokemon)
        XCTAssertEqual(coordinator.navigationPath.count, 3, "Should have 3 items in navigation path")
        
        // When
        coordinator.navigateToRoot()
        
        // Then
        XCTAssertEqual(coordinator.navigationPath.count, 0, "Should clear all items from home navigation path")
    }
    
    func testNavigateToRootFromFavoritesTab() {
        // Given
        coordinator.selectedTab = .favourites
        coordinator.navigate(to: .pokemonDetail(pokemonId: 1, pokemonName: "Bulbasaur"))
        coordinator.navigate(to: .aboutDev)
        XCTAssertEqual(coordinator.favouritesNavigationPath.count, 2, "Should have 2 items in favorites navigation path")
        
        // When
        coordinator.navigateToRoot()
        
        // Then
        XCTAssertEqual(coordinator.favouritesNavigationPath.count, 0, "Should clear all items from favorites navigation path")
    }
    
    func testNavigateToRootFromAboutTab() {
        // Given
        coordinator.selectedTab = .about
        coordinator.navigate(to: .pokemonList)
        coordinator.navigate(to: .favouritePokemon)
        XCTAssertEqual(coordinator.aboutNavigationPath.count, 2, "Should have 2 items in about navigation path")
        
        // When
        coordinator.navigateToRoot()
        
        // Then
        XCTAssertEqual(coordinator.aboutNavigationPath.count, 0, "Should clear all items from about navigation path")
    }
    
    func testNavigateToRootWhenPathIsEmpty() {
        // Given
        coordinator.selectedTab = .home
        XCTAssertEqual(coordinator.navigationPath.count, 0, "Navigation path should be empty")
        
        // When
        coordinator.navigateToRoot()
        
        // Then
        XCTAssertEqual(coordinator.navigationPath.count, 0, "Navigation path should remain empty")
    }
    
    // MARK: - Mixed Navigation Tests
    
    func testNavigationPathsAreIndependent() {
        // Given & When
        coordinator.selectedTab = .home
        coordinator.navigate(to: .pokemonList)
        
        coordinator.selectedTab = .favourites
        coordinator.navigate(to: .pokemonDetail(pokemonId: 25, pokemonName: "Pikachu"))
        coordinator.navigate(to: .aboutDev)
        
        coordinator.selectedTab = .about
        coordinator.navigate(to: .favouritePokemon)
        
        // Then
        XCTAssertEqual(coordinator.navigationPath.count, 1, "Home navigation path should have 1 item")
        XCTAssertEqual(coordinator.favouritesNavigationPath.count, 2, "Favorites navigation path should have 2 items")
        XCTAssertEqual(coordinator.aboutNavigationPath.count, 1, "About navigation path should have 1 item")
    }
}

// MARK: - AppTab Tests

final class AppTabTests: XCTestCase {
    
    func testAppTabTitles() {
        XCTAssertEqual(AppTab.home.title, "Pokémon", "Home tab should have correct title")
        XCTAssertEqual(AppTab.favourites.title, "Favourites", "Favorites tab should have correct title")
        XCTAssertEqual(AppTab.about.title, "About", "About tab should have correct title")
    }
    
    func testAppTabIcons() {
        XCTAssertEqual(AppTab.home.icon, "house", "Home tab should have correct icon")
        XCTAssertEqual(AppTab.favourites.icon, "heart", "Favorites tab should have correct icon")
        XCTAssertEqual(AppTab.about.icon, "info.circle", "About tab should have correct icon")
    }
    
    func testAppTabCaseIterable() {
        let allTabs = AppTab.allCases
        XCTAssertEqual(allTabs.count, 3, "Should have exactly 3 tabs")
        XCTAssertTrue(allTabs.contains(.home), "Should contain home tab")
        XCTAssertTrue(allTabs.contains(.favourites), "Should contain favorites tab")
        XCTAssertTrue(allTabs.contains(.about), "Should contain about tab")
    }
}

// MARK: - AppDestination Tests

final class AppDestinationTests: XCTestCase {
    
    func testAppDestinationEquality() {
        let destination1 = AppDestination.pokemonDetail(pokemonId: 25, pokemonName: "Pikachu")
        let destination2 = AppDestination.pokemonDetail(pokemonId: 25, pokemonName: "Pikachu")
        let destination3 = AppDestination.pokemonDetail(pokemonId: 150, pokemonName: "Mewtwo")
        
        XCTAssertEqual(destination1, destination2, "Same pokemon details should be equal")
        XCTAssertNotEqual(destination1, destination3, "Different pokemon details should not be equal")
    }
    
    func testAppDestinationSimpleCases() {
        let pokemonList = AppDestination.pokemonList
        let favouritePokemon = AppDestination.favouritePokemon
        let aboutDev = AppDestination.aboutDev
        
        XCTAssertEqual(pokemonList, AppDestination.pokemonList, "Pokemon list destinations should be equal")
        XCTAssertEqual(favouritePokemon, AppDestination.favouritePokemon, "Favorite pokemon destinations should be equal")
        XCTAssertEqual(aboutDev, AppDestination.aboutDev, "About dev destinations should be equal")
        
        XCTAssertNotEqual(pokemonList, favouritePokemon, "Different destination types should not be equal")
    }
}