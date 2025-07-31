//
//  PokemonDetailViewModelTests.swift
//  PokedexPocketTests
//
//  Created by Azri on 30/07/25.
//

import XCTest
import RxSwift
import Combine
import PokedexPocketCore
@testable import PokedexPocket

final class PokemonDetailViewModelTests: XCTestCase {

    private var sut: PokemonDetailViewModel!
    private var mockGetPokemonDetailUseCase: MockGetPokemonDetailUseCase!
    private var mockAddFavoriteUseCase: MockAddFavoritePokemonUseCase!
    private var mockRemoveFavoriteUseCase: MockRemoveFavoritePokemonUseCase!
    private var mockCheckIsFavoriteUseCase: MockCheckIsFavoritePokemonUseCase!
    private var disposeBag: DisposeBag!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockGetPokemonDetailUseCase = MockGetPokemonDetailUseCase()
        mockAddFavoriteUseCase = MockAddFavoritePokemonUseCase()
        mockRemoveFavoriteUseCase = MockRemoveFavoritePokemonUseCase()
        mockCheckIsFavoriteUseCase = MockCheckIsFavoritePokemonUseCase()
        disposeBag = DisposeBag()
        cancellables = Set<AnyCancellable>()

        sut = PokemonDetailViewModel(
            pokemonId: 25,
            getPokemonDetailUseCase: mockGetPokemonDetailUseCase,
            addFavoriteUseCase: mockAddFavoriteUseCase,
            removeFavoriteUseCase: mockRemoveFavoriteUseCase,
            checkIsFavoriteUseCase: mockCheckIsFavoriteUseCase
        )
    }

    override func tearDown() {
        sut = nil
        mockGetPokemonDetailUseCase = nil
        mockAddFavoriteUseCase = nil
        mockRemoveFavoriteUseCase = nil
        mockCheckIsFavoriteUseCase = nil
        disposeBag = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests
    func testInitialization() {
        XCTAssertNil(sut.pokemon)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isFavorite)
        XCTAssertFalse(sut.favoriteOperationInProgress)
        XCTAssertEqual(mockCheckIsFavoriteUseCase.executeCallCount, 1)
        XCTAssertEqual(mockCheckIsFavoriteUseCase.lastCheckedId, 25)
    }

    func testInitializationWithDifferentPokemonId() {
        _ = PokemonDetailViewModel(
            pokemonId: 150,
            getPokemonDetailUseCase: mockGetPokemonDetailUseCase,
            addFavoriteUseCase: mockAddFavoriteUseCase,
            removeFavoriteUseCase: mockRemoveFavoriteUseCase,
            checkIsFavoriteUseCase: mockCheckIsFavoriteUseCase
        )

        // Called once in setUp and once here
        XCTAssertEqual(mockCheckIsFavoriteUseCase.executeCallCount, 2)
        XCTAssertEqual(mockCheckIsFavoriteUseCase.lastCheckedId, 150)
    }

    // MARK: - Load Pokemon Detail Tests
    func testLoadPokemonDetail_Success() {
        let expectedPokemon = TestData.pikachu
        mockGetPokemonDetailUseCase.pokemonDetailToReturn = expectedPokemon

        let expectation = XCTestExpectation(description: "Pokemon loaded")

        sut.$pokemon
            .dropFirst() // Skip initial nil value
            .sink { pokemon in
                if pokemon != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.loadPokemonDetail()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockGetPokemonDetailUseCase.executeWithIdCallCount, 1)
        XCTAssertEqual(mockGetPokemonDetailUseCase.lastRequestedId, 25)
        XCTAssertEqual(sut.pokemon, expectedPokemon)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
    }

    func testLoadPokemonDetail_Error() {
        mockGetPokemonDetailUseCase.shouldReturnError = true
        mockGetPokemonDetailUseCase.errorToReturn = NetworkError.serverError(404)

        let expectation = XCTestExpectation(description: "Error handled")

        sut.$error
            .dropFirst() // Skip initial nil value
            .sink { error in
                if error != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.loadPokemonDetail()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockGetPokemonDetailUseCase.executeWithIdCallCount, 1)
        XCTAssertEqual(mockGetPokemonDetailUseCase.lastRequestedId, 25)
        XCTAssertNil(sut.pokemon)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.error is NetworkError)
    }

    func testLoadPokemonDetail_NetworkError() {
        mockGetPokemonDetailUseCase.shouldReturnError = true
        mockGetPokemonDetailUseCase.errorToReturn = NetworkError.networkError(TestError.networkFailed)

        let expectation = XCTestExpectation(description: "Network error handled")

        sut.$error
            .dropFirst()
            .sink { error in
                if error != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.loadPokemonDetail()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertNotNil(sut.error)
        if case NetworkError.networkError = sut.error! {
            // Success
        } else {
            XCTFail("Expected network error")
        }
    }

    func testLoadPokemonDetail_DecodingError() {
        mockGetPokemonDetailUseCase.shouldReturnError = true
        mockGetPokemonDetailUseCase.errorToReturn = NetworkError.decodingError(TestError.decodingFailed)

        let expectation = XCTestExpectation(description: "Decoding error handled")

        sut.$error
            .dropFirst()
            .sink { error in
                if error != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.loadPokemonDetail()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertNotNil(sut.error)
        if case NetworkError.decodingError = sut.error! {
            // Success
        } else {
            XCTFail("Expected decoding error")
        }
    }

    func testLoadPokemonDetail_PreventMultipleCalls() {
        let expectedPokemon = TestData.pikachu
        mockGetPokemonDetailUseCase.pokemonDetailToReturn = expectedPokemon

        // Set loading to true to simulate ongoing request
        sut.isLoading = true

        sut.loadPokemonDetail()

        // Should not make a call since isLoading is true
        XCTAssertEqual(mockGetPokemonDetailUseCase.executeWithIdCallCount, 0)
    }

    func testLoadPokemonDetail_LoadingState() {
        let expectedPokemon = TestData.pikachu
        mockGetPokemonDetailUseCase.pokemonDetailToReturn = expectedPokemon

        let loadingExpectation = XCTestExpectation(description: "Loading state set")
        let completedExpectation = XCTestExpectation(description: "Loading state cleared")

        var loadingStates: [Bool] = []

        sut.$isLoading
            .sink { isLoading in
                loadingStates.append(isLoading)
                if isLoading && loadingStates.count == 2 { // Skip initial false
                    loadingExpectation.fulfill()
                } else if !isLoading && loadingStates.count > 2 {
                    completedExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.loadPokemonDetail()

        wait(for: [loadingExpectation, completedExpectation], timeout: 1.0)

        XCTAssertFalse(sut.isLoading)
    }

    func testLoadPokemonDetail_ClearsError() {
        // Set initial error
        sut.error = TestError.networkFailed

        let expectedPokemon = TestData.pikachu
        mockGetPokemonDetailUseCase.pokemonDetailToReturn = expectedPokemon

        let expectation = XCTestExpectation(description: "Error cleared")

        sut.$error
            .dropFirst() // Skip initial error
            .sink { error in
                if error == nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.loadPokemonDetail()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertNil(sut.error)
    }

    // MARK: - Check Favorite Status Tests
    func testCheckFavoriteStatus_IsFavorite() {
        mockCheckIsFavoriteUseCase.isFavoriteToReturn = true

        let expectation = XCTestExpectation(description: "Favorite status checked")

        sut.$isFavorite
            .dropFirst() // Skip initial false value
            .sink { isFavorite in
                if isFavorite {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.checkFavoriteStatus()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockCheckIsFavoriteUseCase.executeCallCount, 2) // Once in init, once manually
        XCTAssertEqual(mockCheckIsFavoriteUseCase.lastCheckedId, 25)
        XCTAssertTrue(sut.isFavorite)
    }

    func testCheckFavoriteStatus_IsNotFavorite() {
        mockCheckIsFavoriteUseCase.isFavoriteToReturn = false

        let expectation = XCTestExpectation(description: "Check favorite status completed")
        
        // Since isFavorite starts as false and remains false, we need to wait for the operation to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }

        sut.checkFavoriteStatus()

        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(mockCheckIsFavoriteUseCase.executeCallCount, 2)
        XCTAssertFalse(sut.isFavorite)
    }

    func testCheckFavoriteStatus_Error() {
        mockCheckIsFavoriteUseCase.shouldReturnError = true
        mockCheckIsFavoriteUseCase.errorToReturn = TestError.repositoryError

        let expectation = XCTestExpectation(description: "Check favorite error")

        sut.$error
            .dropFirst()
            .sink { error in
                if error != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.checkFavoriteStatus()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertNotNil(sut.error)
    }

    // MARK: - Toggle Favorite Tests
    func testToggleFavorite_AddToFavorites() {
        let pokemon = TestData.pikachu
        sut.pokemon = pokemon
        sut.isFavorite = false

        let expectation = XCTestExpectation(description: "Add to favorites")

        sut.$isFavorite
            .dropFirst()
            .sink { isFavorite in
                if isFavorite {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.toggleFavorite()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockAddFavoriteUseCase.executeCallCount, 1)
        XCTAssertEqual(mockAddFavoriteUseCase.lastAddedPokemon, pokemon)
        XCTAssertTrue(sut.isFavorite)
        XCTAssertFalse(sut.favoriteOperationInProgress)
    }

    func testToggleFavorite_RemoveFromFavorites() {
        let pokemon = TestData.pikachu
        sut.pokemon = pokemon
        sut.isFavorite = true

        let expectation = XCTestExpectation(description: "Remove from favorites")

        sut.$isFavorite
            .dropFirst()
            .sink { isFavorite in
                if !isFavorite {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.toggleFavorite()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRemoveFavoriteUseCase.executeCallCount, 1)
        XCTAssertEqual(mockRemoveFavoriteUseCase.lastRemovedId, pokemon.id)
        XCTAssertFalse(sut.isFavorite)
        XCTAssertFalse(sut.favoriteOperationInProgress)
    }

    func testToggleFavorite_NoPokemon() {
        sut.pokemon = nil
        sut.isFavorite = false

        sut.toggleFavorite()

        XCTAssertEqual(mockAddFavoriteUseCase.executeCallCount, 0)
        XCTAssertEqual(mockRemoveFavoriteUseCase.executeCallCount, 0)
    }

    func testToggleFavorite_OperationInProgress() {
        let pokemon = TestData.pikachu
        sut.pokemon = pokemon
        sut.isFavorite = false
        sut.favoriteOperationInProgress = true

        sut.toggleFavorite()

        XCTAssertEqual(mockAddFavoriteUseCase.executeCallCount, 0)
        XCTAssertEqual(mockRemoveFavoriteUseCase.executeCallCount, 0)
    }

    func testToggleFavorite_AddError() {
        let pokemon = TestData.pikachu
        sut.pokemon = pokemon
        sut.isFavorite = false

        mockAddFavoriteUseCase.shouldReturnError = true
        mockAddFavoriteUseCase.errorToReturn = TestError.repositoryError

        let errorExpectation = XCTestExpectation(description: "Add favorite error")
        let favoriteRevertExpectation = XCTestExpectation(description: "Favorite reverted")

        sut.$error
            .dropFirst()
            .sink { error in
                if error != nil {
                    errorExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.$isFavorite
            .dropFirst(2) // Skip initial false and optimistic true
            .sink { isFavorite in
                if !isFavorite {
                    favoriteRevertExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.toggleFavorite()

        wait(
            for: [errorExpectation, favoriteRevertExpectation],
            timeout: 1.0,
            enforceOrder: false
        )

        XCTAssertEqual(mockAddFavoriteUseCase.executeCallCount, 1)
        XCTAssertFalse(sut.isFavorite) // Should be reverted
        XCTAssertFalse(sut.favoriteOperationInProgress)
        XCTAssertNotNil(sut.error)
    }

    func testToggleFavorite_RemoveError() {
        let pokemon = TestData.pikachu
        sut.pokemon = pokemon
        sut.isFavorite = true

        mockRemoveFavoriteUseCase.shouldReturnError = true
        mockRemoveFavoriteUseCase.errorToReturn = TestError.repositoryError

        let errorExpectation = XCTestExpectation(description: "Remove favorite error")
        let favoriteRevertExpectation = XCTestExpectation(description: "Favorite reverted")

        sut.$error
            .dropFirst()
            .sink { error in
                if error != nil {
                    errorExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.$isFavorite
            .dropFirst(2) // Skip initial true and optimistic false
            .sink { isFavorite in
                if isFavorite {
                    favoriteRevertExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.toggleFavorite()

        wait(
            for: [errorExpectation, favoriteRevertExpectation],
            timeout: 1.0,
            enforceOrder: false
        )

        XCTAssertEqual(mockRemoveFavoriteUseCase.executeCallCount, 1)
        XCTAssertTrue(sut.isFavorite) // Should be reverted
        XCTAssertFalse(sut.favoriteOperationInProgress)
        XCTAssertNotNil(sut.error)
    }

    func testToggleFavorite_OptimisticUpdate() {
        let pokemon = TestData.pikachu
        sut.pokemon = pokemon
        sut.isFavorite = false

        let expectation = XCTestExpectation(description: "Optimistic update")

        var favoriteStates: [Bool] = []

        sut.$isFavorite
            .sink { isFavorite in
                favoriteStates.append(isFavorite)
                // Initial false, then optimistic true
                if favoriteStates.count == 2 && isFavorite {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.toggleFavorite()

        wait(for: [expectation], timeout: 1.0)

        // Should immediately update to true (optimistic update)
        XCTAssertTrue(sut.isFavorite)
    }

    // MARK: - Edge Cases
    func testInitializationWithZeroId() {
        _ = PokemonDetailViewModel(
            pokemonId: 0,
            getPokemonDetailUseCase: mockGetPokemonDetailUseCase,
            addFavoriteUseCase: mockAddFavoriteUseCase,
            removeFavoriteUseCase: mockRemoveFavoriteUseCase,
            checkIsFavoriteUseCase: mockCheckIsFavoriteUseCase
        )

        XCTAssertEqual(mockCheckIsFavoriteUseCase.lastCheckedId, 0)
    }

    func testInitializationWithNegativeId() {
        _ = PokemonDetailViewModel(
            pokemonId: -1,
            getPokemonDetailUseCase: mockGetPokemonDetailUseCase,
            addFavoriteUseCase: mockAddFavoriteUseCase,
            removeFavoriteUseCase: mockRemoveFavoriteUseCase,
            checkIsFavoriteUseCase: mockCheckIsFavoriteUseCase
        )

        XCTAssertEqual(mockCheckIsFavoriteUseCase.lastCheckedId, -1)
    }

    func testMultipleToggleFavorite() {
        let pokemon = TestData.pikachu
        sut.pokemon = pokemon
        sut.isFavorite = false

        let firstToggleExpectation = XCTestExpectation(description: "First toggle completed")
        let secondToggleExpectation = XCTestExpectation(description: "Second toggle completed")

        // First toggle (add)
        sut.toggleFavorite()

        // Wait for first operation to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.sut.favoriteOperationInProgress = false
            firstToggleExpectation.fulfill()

            // Second toggle (remove)
            self.sut.toggleFavorite()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                secondToggleExpectation.fulfill()
            }
        }

        wait(for: [firstToggleExpectation, secondToggleExpectation], timeout: 1.0)
        
        XCTAssertEqual(mockAddFavoriteUseCase.executeCallCount, 1)
        XCTAssertEqual(mockRemoveFavoriteUseCase.executeCallCount, 1)
    }
}
