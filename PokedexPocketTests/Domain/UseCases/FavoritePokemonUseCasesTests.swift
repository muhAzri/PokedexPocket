//
//  FavoritePokemonUseCasesTests.swift
//  PokedexPocketTests
//
//  Created by Azri on 30/07/25.
//

import XCTest
import RxSwift
@testable import PokedexPocket

// MARK: - AddFavoritePokemonUseCase Tests
final class AddFavoritePokemonUseCaseTests: XCTestCase {

    private var sut: AddFavoritePokemonUseCase!
    private var mockRepository: MockFavoritePokemonRepository!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockRepository = MockFavoritePokemonRepository()
        sut = AddFavoritePokemonUseCase(repository: mockRepository)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        disposeBag = nil
        super.tearDown()
    }

    func testExecute_Success() {
        let pokemon = TestData.pikachu
        let expectation = XCTestExpectation(description: "Add favorite success")

        sut.execute(pokemon: pokemon)
            .subscribe(
                onNext: { _ in
                    // Success
                },
                onError: { _ in
                    XCTFail("Expected success")
                },
                onCompleted: {
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.addFavoriteCallCount, 1)
        XCTAssertEqual(mockRepository.lastAddedPokemon?.id, pokemon.id)
    }

    func testExecute_RepositoryError() {
        let pokemon = TestData.pikachu
        mockRepository.shouldReturnError = true
        mockRepository.errorToReturn = TestError.repositoryError

        let expectation = XCTestExpectation(description: "Add favorite error")

        sut.execute(pokemon: pokemon)
            .subscribe(
                onNext: { _ in
                    XCTFail("Expected error")
                },
                onError: { error in
                    XCTAssertTrue(error is TestError)
                    expectation.fulfill()
                },
                onCompleted: {
                    XCTFail("Expected error")
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.addFavoriteCallCount, 1)
    }

    func testExecute_MultiplePokemon() {
        let pokemon1 = TestData.pikachu
        let pokemon2 = TestData.charizard

        let expectation1 = XCTestExpectation(description: "Add first pokemon")
        let expectation2 = XCTestExpectation(description: "Add second pokemon")

        sut.execute(pokemon: pokemon1)
            .subscribe(onCompleted: { expectation1.fulfill() })
            .disposed(by: disposeBag)

        sut.execute(pokemon: pokemon2)
            .subscribe(onCompleted: { expectation2.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectation1, expectation2], timeout: 1.0)

        XCTAssertEqual(mockRepository.addFavoriteCallCount, 2)
    }
}

// MARK: - RemoveFavoritePokemonUseCase Tests
final class RemoveFavoritePokemonUseCaseTests: XCTestCase {

    private var sut: RemoveFavoritePokemonUseCase!
    private var mockRepository: MockFavoritePokemonRepository!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockRepository = MockFavoritePokemonRepository()
        sut = RemoveFavoritePokemonUseCase(repository: mockRepository)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        disposeBag = nil
        super.tearDown()
    }

    func testExecute_Success() {
        let pokemonId = 25
        let expectation = XCTestExpectation(description: "Remove favorite success")

        sut.execute(pokemonId: pokemonId)
            .subscribe(onCompleted: { expectation.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.removeFavoriteCallCount, 1)
        XCTAssertEqual(mockRepository.lastRemovedId, pokemonId)
    }

    func testExecute_RepositoryError() {
        let pokemonId = 999
        mockRepository.shouldReturnError = true
        mockRepository.errorToReturn = TestError.repositoryError

        let expectation = XCTestExpectation(description: "Remove favorite error")

        sut.execute(pokemonId: pokemonId)
            .subscribe(
                onNext: { _ in XCTFail("Expected error") },
                onError: { error in
                    XCTAssertTrue(error is TestError)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.removeFavoriteCallCount, 1)
    }

    func testExecute_EdgeCases() {
        let testCases = [0, -1, Int.max, Int.min]
        let expectation = XCTestExpectation(description: "Edge cases")
        expectation.expectedFulfillmentCount = testCases.count

        for pokemonId in testCases {
            sut.execute(pokemonId: pokemonId)
                .subscribe(onCompleted: { expectation.fulfill() })
                .disposed(by: disposeBag)
        }

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.removeFavoriteCallCount, testCases.count)
    }
}

// MARK: - GetFavoritesPokemonUseCase Tests
final class GetFavoritesPokemonUseCaseTests: XCTestCase {

    private var sut: GetFavoritesPokemonUseCase!
    private var mockRepository: MockFavoritePokemonRepository!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockRepository = MockFavoritePokemonRepository()
        sut = GetFavoritesPokemonUseCase(repository: mockRepository)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        disposeBag = nil
        super.tearDown()
    }

    func testExecute_Success_WithFavorites() {
        let favorites = [TestData.favoritePikachu, TestData.favoriteCharizard]
        mockRepository.favoritePokemon = favorites

        let expectation = XCTestExpectation(description: "Get favorites success")

        sut.execute()
            .subscribe(
                onNext: { retrievedFavorites in
                    XCTAssertEqual(retrievedFavorites.count, 2)
                    XCTAssertEqual(retrievedFavorites[0].id, favorites[0].id)
                    XCTAssertEqual(retrievedFavorites[1].id, favorites[1].id)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.getFavoritesCallCount, 1)
    }

    func testExecute_Success_EmptyFavorites() {
        mockRepository.favoritePokemon = []

        let expectation = XCTestExpectation(description: "Get empty favorites")

        sut.execute()
            .subscribe(
                onNext: { retrievedFavorites in
                    XCTAssertEqual(retrievedFavorites.count, 0)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.getFavoritesCallCount, 1)
    }

    func testExecute_RepositoryError() {
        mockRepository.shouldReturnError = true
        mockRepository.errorToReturn = TestError.repositoryError

        let expectation = XCTestExpectation(description: "Get favorites error")

        sut.execute()
            .subscribe(
                onNext: { _ in XCTFail("Expected error") },
                onError: { error in
                    XCTAssertTrue(error is TestError)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.getFavoritesCallCount, 1)
    }
}

// MARK: - CheckIsFavoritePokemonUseCase Tests
final class CheckIsFavoritePokemonUseCaseTests: XCTestCase {

    private var sut: CheckIsFavoritePokemonUseCase!
    private var mockRepository: MockFavoritePokemonRepository!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockRepository = MockFavoritePokemonRepository()
        sut = CheckIsFavoritePokemonUseCase(repository: mockRepository)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        disposeBag = nil
        super.tearDown()
    }

    func testExecute_IsFavorite() {
        let pokemonId = 25
        mockRepository.favoritePokemon = [TestData.favoritePikachu]

        let expectation = XCTestExpectation(description: "Check is favorite")

        sut.execute(pokemonId: pokemonId)
            .subscribe(
                onNext: { isFavorite in
                    XCTAssertTrue(isFavorite)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.checkIsFavoriteCallCount, 1)
        XCTAssertEqual(mockRepository.lastCheckedId, pokemonId)
    }

    func testExecute_IsNotFavorite() {
        let pokemonId = 999
        mockRepository.favoritePokemon = [TestData.favoritePikachu]

        let expectation = XCTestExpectation(description: "Check is not favorite")

        sut.execute(pokemonId: pokemonId)
            .subscribe(
                onNext: { isFavorite in
                    XCTAssertFalse(isFavorite)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.checkIsFavoriteCallCount, 1)
        XCTAssertEqual(mockRepository.lastCheckedId, pokemonId)
    }

    func testExecute_EmptyFavorites() {
        let pokemonId = 25
        mockRepository.favoritePokemon = []

        let expectation = XCTestExpectation(description: "Check empty favorites")

        sut.execute(pokemonId: pokemonId)
            .subscribe(
                onNext: { isFavorite in
                    XCTAssertFalse(isFavorite)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    func testExecute_RepositoryError() {
        let pokemonId = 25
        mockRepository.shouldReturnError = true
        mockRepository.errorToReturn = TestError.repositoryError

        let expectation = XCTestExpectation(description: "Check favorite error")

        sut.execute(pokemonId: pokemonId)
            .subscribe(
                onNext: { _ in XCTFail("Expected error") },
                onError: { error in
                    XCTAssertTrue(error is TestError)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.checkIsFavoriteCallCount, 1)
    }
}

// MARK: - ClearAllFavoritesUseCase Tests
final class ClearAllFavoritesUseCaseTests: XCTestCase {

    private var sut: ClearAllFavoritesUseCase!
    private var mockRepository: MockFavoritePokemonRepository!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockRepository = MockFavoritePokemonRepository()
        sut = ClearAllFavoritesUseCase(repository: mockRepository)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        disposeBag = nil
        super.tearDown()
    }

    func testExecute_Success() {
        mockRepository.favoritePokemon = [TestData.favoritePikachu, TestData.favoriteCharizard]

        let expectation = XCTestExpectation(description: "Clear favorites success")

        sut.execute()
            .subscribe(onCompleted: { expectation.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.clearAllCallCount, 1)
        XCTAssertTrue(mockRepository.favoritePokemon.isEmpty)
    }

    func testExecute_EmptyFavorites() {
        mockRepository.favoritePokemon = []

        let expectation = XCTestExpectation(description: "Clear empty favorites")

        sut.execute()
            .subscribe(onCompleted: { expectation.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.clearAllCallCount, 1)
    }

    func testExecute_RepositoryError() {
        mockRepository.shouldReturnError = true
        mockRepository.errorToReturn = TestError.repositoryError

        let expectation = XCTestExpectation(description: "Clear favorites error")

        sut.execute()
            .subscribe(
                onNext: { _ in XCTFail("Expected error") },
                onError: { error in
                    XCTAssertTrue(error is TestError)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.clearAllCallCount, 1)
    }

    func testExecute_MultipleCalls() {
        mockRepository.favoritePokemon = [TestData.favoritePikachu]

        let expectation = XCTestExpectation(description: "Multiple clear calls")
        expectation.expectedFulfillmentCount = 2

        sut.execute()
            .subscribe(onCompleted: { expectation.fulfill() })
            .disposed(by: disposeBag)

        sut.execute()
            .subscribe(onCompleted: { expectation.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.clearAllCallCount, 2)
    }
}
