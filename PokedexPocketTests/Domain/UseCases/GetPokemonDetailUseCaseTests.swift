//
//  GetPokemonDetailUseCaseTests.swift
//  PokedexPocketTests
//
//  Created by Azri on 30/07/25.
//

import XCTest
import RxSwift
import PokedexPocketCore
@testable import PokedexPocket

final class GetPokemonDetailUseCaseTests: XCTestCase {

    private var sut: GetPokemonDetailUseCase!
    private var mockRepository: MockPokemonDetailRepository!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockRepository = MockPokemonDetailRepository()
        sut = GetPokemonDetailUseCase(repository: mockRepository)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - Execute with ID Tests
    func testExecuteWithId_Success() {
        let expectedPokemon = TestData.pikachu
        mockRepository.pokemonDetailToReturn = expectedPokemon

        let expectation = XCTestExpectation(description: "Get pokemon detail success")

        sut.execute(id: 25)
            .subscribe(
                onNext: { pokemon in
                    XCTAssertEqual(pokemon, expectedPokemon)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.getDetailByIdCallCount, 1)
        XCTAssertEqual(mockRepository.lastRequestedId, 25)
    }

    func testExecuteWithId_NetworkError() {
        mockRepository.shouldReturnError = true
        mockRepository.errorToReturn = NetworkError.networkError(TestError.networkFailed)

        let expectation = XCTestExpectation(description: "Network error handled")

        sut.execute(id: 999)
            .subscribe(
                onNext: { _ in XCTFail("Expected error") },
                onError: { error in
                    XCTAssertTrue(error is NetworkError)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.getDetailByIdCallCount, 1)
        XCTAssertEqual(mockRepository.lastRequestedId, 999)
    }

    func testExecuteWithId_ServerError() {
        mockRepository.shouldReturnError = true
        mockRepository.errorToReturn = NetworkError.serverError(404)

        let expectation = XCTestExpectation(description: "Server error handled")

        sut.execute(id: 9999)
            .subscribe(
                onNext: { _ in XCTFail("Expected error") },
                onError: { error in
                    if case NetworkError.serverError(let code) = error {
                        XCTAssertEqual(code, 404)
                        expectation.fulfill()
                    } else {
                        XCTFail("Expected server error with code 404")
                    }
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.getDetailByIdCallCount, 1)
        XCTAssertEqual(mockRepository.lastRequestedId, 9999)
    }

    func testExecuteWithId_NoData() {
        mockRepository.shouldReturnError = true
        mockRepository.errorToReturn = NetworkError.noData

        let expectation = XCTestExpectation(description: "No data error handled")

        sut.execute(id: 0)
            .subscribe(
                onNext: { _ in XCTFail("Expected error") },
                onError: { error in
                    if case NetworkError.noData = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Expected no data error")
                    }
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.getDetailByIdCallCount, 1)
        XCTAssertEqual(mockRepository.lastRequestedId, 0)
    }

    func testExecuteWithId_NegativeId() {
        let expectedPokemon = TestData.pikachu
        mockRepository.pokemonDetailToReturn = expectedPokemon

        let expectation = XCTestExpectation(description: "Negative ID handled")

        sut.execute(id: -1)
            .subscribe(
                onNext: { _ in expectation.fulfill() }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.getDetailByIdCallCount, 1)
        XCTAssertEqual(mockRepository.lastRequestedId, -1)
    }

    // MARK: - Execute with URL Tests
    func testExecuteWithUrl_Success() {
        let expectedPokemon = TestData.charizard
        mockRepository.pokemonDetailToReturn = expectedPokemon
        let testUrl = "https://pokeapi.co/api/v2/pokemon/6/"

        let expectation = XCTestExpectation(description: "Get pokemon by URL success")

        sut.execute(url: testUrl)
            .subscribe(
                onNext: { pokemon in
                    XCTAssertEqual(pokemon, expectedPokemon)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.getDetailByUrlCallCount, 1)
        XCTAssertEqual(mockRepository.lastRequestedUrl, testUrl)
    }

    func testExecuteWithUrl_InvalidUrl() {
        mockRepository.shouldReturnError = true
        mockRepository.errorToReturn = NetworkError.invalidURL
        let invalidUrl = "invalid-url"

        let expectation = XCTestExpectation(description: "Invalid URL error handled")

        sut.execute(url: invalidUrl)
            .subscribe(
                onNext: { _ in XCTFail("Expected error") },
                onError: { error in
                    if case NetworkError.invalidURL = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Expected invalid URL error")
                    }
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.getDetailByUrlCallCount, 1)
        XCTAssertEqual(mockRepository.lastRequestedUrl, invalidUrl)
    }

    func testExecuteWithUrl_EmptyUrl() {
        let expectedPokemon = TestData.minimumPokemon
        mockRepository.pokemonDetailToReturn = expectedPokemon
        let emptyUrl = ""

        let expectation = XCTestExpectation(description: "Empty URL handled")

        sut.execute(url: emptyUrl)
            .subscribe(
                onNext: { _ in expectation.fulfill() }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.getDetailByUrlCallCount, 1)
        XCTAssertEqual(mockRepository.lastRequestedUrl, emptyUrl)
    }

    func testExecuteWithUrl_DecodingError() {
        mockRepository.shouldReturnError = true
        mockRepository.errorToReturn = NetworkError.decodingError(TestError.decodingFailed)
        let testUrl = "https://pokeapi.co/api/v2/pokemon/malformed/"

        let expectation = XCTestExpectation(description: "Decoding error handled")

        sut.execute(url: testUrl)
            .subscribe(
                onNext: { _ in XCTFail("Expected error") },
                onError: { error in
                    if case NetworkError.decodingError = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Expected decoding error")
                    }
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.getDetailByUrlCallCount, 1)
        XCTAssertEqual(mockRepository.lastRequestedUrl, testUrl)
    }

    // MARK: - Multiple Calls Tests
    func testMultipleExecuteWithIdCalls() {
        let pokemon1 = TestData.pikachu
        let pokemon2 = TestData.charizard

        mockRepository.pokemonDetailToReturn = pokemon1

        let expectation1 = XCTestExpectation(description: "First call")
        let expectation2 = XCTestExpectation(description: "Second call")

        sut.execute(id: 25)
            .subscribe(onNext: { _ in expectation1.fulfill() })
            .disposed(by: disposeBag)

        mockRepository.pokemonDetailToReturn = pokemon2
        sut.execute(id: 6)
            .subscribe(onNext: { _ in expectation2.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectation1, expectation2], timeout: 1.0)

        XCTAssertEqual(mockRepository.getDetailByIdCallCount, 2)
    }

    func testMixedExecuteCalls() {
        let expectedPokemon = TestData.pikachu
        mockRepository.pokemonDetailToReturn = expectedPokemon

        let expectationId = XCTestExpectation(description: "ID call")
        let expectationUrl = XCTestExpectation(description: "URL call")

        sut.execute(id: 25)
            .subscribe(onNext: { _ in expectationId.fulfill() })
            .disposed(by: disposeBag)

        sut.execute(url: "https://pokeapi.co/api/v2/pokemon/25/")
            .subscribe(onNext: { _ in expectationUrl.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectationId, expectationUrl], timeout: 1.0)

        XCTAssertEqual(mockRepository.getDetailByIdCallCount, 1)
        XCTAssertEqual(mockRepository.getDetailByUrlCallCount, 1)
    }

    // MARK: - Edge Cases
    func testExecuteWithMaxIntId() {
        let expectedPokemon = TestData.minimumPokemon
        mockRepository.pokemonDetailToReturn = expectedPokemon

        let expectation = XCTestExpectation(description: "Max int ID")

        sut.execute(id: Int.max)
            .subscribe(onNext: { _ in expectation.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.getDetailByIdCallCount, 1)
        XCTAssertEqual(mockRepository.lastRequestedId, Int.max)
    }

    func testExecuteWithMinIntId() {
        let expectedPokemon = TestData.minimumPokemon
        mockRepository.pokemonDetailToReturn = expectedPokemon

        let expectation = XCTestExpectation(description: "Min int ID")

        sut.execute(id: Int.min)
            .subscribe(onNext: { _ in expectation.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockRepository.getDetailByIdCallCount, 1)
        XCTAssertEqual(mockRepository.lastRequestedId, Int.min)
    }
}
