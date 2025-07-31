//
//  PokemonDetailRepositoryTests.swift
//  PokedexPocketTests
//
//  Created by Azri on 30/07/25.
//

import XCTest
import RxSwift
import PokedexPocketCore
@testable import PokedexPocket

final class PokemonDetailRepositoryTests: XCTestCase {

    private var sut: PokemonDetailRepository!
    private var mockNetworkService: MockNetworkService!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = PokemonDetailRepository(networkService: mockNetworkService)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - Get Pokemon Detail by ID Tests
    func testGetPokemonDetailById_Success() {
        let response = TestData.pokemonDetailResponse
        let expectedPokemon = response.toDomain()
        mockNetworkService.responseToReturn = response

        let expectation = XCTestExpectation(description: "Get pokemon detail by ID success")

        sut.getPokemonDetail(id: 25)
            .subscribe(
                onNext: { pokemon in
                    XCTAssertEqual(pokemon.id, expectedPokemon.id)
                    XCTAssertEqual(pokemon.name, expectedPokemon.name)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
        XCTAssertNotNil(mockNetworkService.lastEndpoint)
    }

    func testGetPokemonDetailById_NetworkError() {
        mockNetworkService.shouldReturnError = true
        mockNetworkService.errorToReturn = NetworkError.networkError(TestError.networkFailed)

        let expectation = XCTestExpectation(description: "Network error handled")

        sut.getPokemonDetail(id: 999)
            .subscribe(
                onNext: { _ in XCTFail("Expected error") },
                onError: { error in
                    XCTAssertTrue(error is NetworkError)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
    }

    func testGetPokemonDetailById_ServerError404() {
        mockNetworkService.shouldReturnError = true
        mockNetworkService.errorToReturn = NetworkError.serverError(404)

        let expectation = XCTestExpectation(description: "Server 404 error handled")

        sut.getPokemonDetail(id: 9999)
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

        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
    }

    func testGetPokemonDetailById_ServerError500() {
        mockNetworkService.shouldReturnError = true
        mockNetworkService.errorToReturn = NetworkError.serverError(500)

        let expectation = XCTestExpectation(description: "Server 500 error handled")

        sut.getPokemonDetail(id: 1)
            .subscribe(
                onNext: { _ in XCTFail("Expected error") },
                onError: { error in
                    if case NetworkError.serverError(let code) = error {
                        XCTAssertEqual(code, 500)
                        expectation.fulfill()
                    } else {
                        XCTFail("Expected server error with code 500")
                    }
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
    }

    func testGetPokemonDetailById_DecodingError() {
        mockNetworkService.shouldReturnError = true
        mockNetworkService.errorToReturn = NetworkError.decodingError(TestError.decodingFailed)

        let expectation = XCTestExpectation(description: "Decoding error handled")

        sut.getPokemonDetail(id: 25)
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

        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
    }

    func testGetPokemonDetailById_NoData() {
        mockNetworkService.shouldReturnError = true
        mockNetworkService.errorToReturn = NetworkError.noData

        let expectation = XCTestExpectation(description: "No data error handled")

        sut.getPokemonDetail(id: 0)
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

        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
    }

    // MARK: - Get Pokemon Detail by URL Tests
    func testGetPokemonDetailByUrl_Success() {
        let response = TestData.pokemonDetailResponse
        let expectedPokemon = response.toDomain()
        mockNetworkService.responseToReturn = response
        let testUrl = "https://pokeapi.co/api/v2/pokemon/25/"

        let expectation = XCTestExpectation(description: "Get pokemon detail by URL success")

        sut.getPokemonDetail(url: testUrl)
            .subscribe(
                onNext: { pokemon in
                    XCTAssertEqual(pokemon.id, expectedPokemon.id)
                    XCTAssertEqual(pokemon.name, expectedPokemon.name)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
        XCTAssertNotNil(mockNetworkService.lastEndpoint)
    }

    func testGetPokemonDetailByUrl_InvalidUrl() {
        mockNetworkService.shouldReturnError = true
        mockNetworkService.errorToReturn = NetworkError.invalidURL
        let invalidUrl = "invalid-url"

        let expectation = XCTestExpectation(description: "Invalid URL error handled")

        sut.getPokemonDetail(url: invalidUrl)
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

        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
    }

    func testGetPokemonDetailByUrl_EmptyUrl() {
        let response = TestData.pokemonDetailResponse
        mockNetworkService.responseToReturn = response
        let emptyUrl = ""

        let expectation = XCTestExpectation(description: "Empty URL handled")

        sut.getPokemonDetail(url: emptyUrl)
            .subscribe(onNext: { _ in expectation.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
    }

    func testGetPokemonDetailByUrl_NetworkError() {
        mockNetworkService.shouldReturnError = true
        mockNetworkService.errorToReturn = NetworkError.networkError(TestError.networkFailed)
        let testUrl = "https://pokeapi.co/api/v2/pokemon/999/"

        let expectation = XCTestExpectation(description: "Network error handled")

        sut.getPokemonDetail(url: testUrl)
            .subscribe(
                onNext: { _ in XCTFail("Expected error") },
                onError: { error in
                    XCTAssertTrue(error is NetworkError)
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
    }

    // MARK: - Multiple Calls Tests
    func testMultipleGetPokemonDetailByIdCalls() {
        let response1 = TestData.pokemonDetailResponse
        let response2 = TestData.pokemonDetailResponse

        mockNetworkService.responseToReturn = response1

        let expectation1 = XCTestExpectation(description: "First call")
        let expectation2 = XCTestExpectation(description: "Second call")

        sut.getPokemonDetail(id: 25)
            .subscribe(onNext: { _ in expectation1.fulfill() })
            .disposed(by: disposeBag)

        mockNetworkService.responseToReturn = response2
        sut.getPokemonDetail(id: 6)
            .subscribe(onNext: { _ in expectation2.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectation1, expectation2], timeout: 1.0)

        XCTAssertEqual(mockNetworkService.requestCallCount, 2)
    }

    func testMixedGetPokemonDetailCalls() {
        let response = TestData.pokemonDetailResponse
        mockNetworkService.responseToReturn = response

        let expectationId = XCTestExpectation(description: "ID call")
        let expectationUrl = XCTestExpectation(description: "URL call")

        sut.getPokemonDetail(id: 25)
            .subscribe(onNext: { _ in expectationId.fulfill() })
            .disposed(by: disposeBag)

        sut.getPokemonDetail(url: "https://pokeapi.co/api/v2/pokemon/25/")
            .subscribe(onNext: { _ in expectationUrl.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectationId, expectationUrl], timeout: 1.0)

        XCTAssertEqual(mockNetworkService.requestCallCount, 2)
    }

    // MARK: - Edge Cases
    func testGetPokemonDetailWithMaxIntId() {
        let response = TestData.pokemonDetailResponse
        mockNetworkService.responseToReturn = response

        let expectation = XCTestExpectation(description: "Max int ID")

        sut.getPokemonDetail(id: Int.max)
            .subscribe(onNext: { _ in expectation.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
    }

    func testGetPokemonDetailWithMinIntId() {
        let response = TestData.pokemonDetailResponse
        mockNetworkService.responseToReturn = response

        let expectation = XCTestExpectation(description: "Min int ID")

        sut.getPokemonDetail(id: Int.min)
            .subscribe(onNext: { _ in expectation.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
    }

    func testGetPokemonDetailWithLongUrl() {
        let response = TestData.pokemonDetailResponse
        mockNetworkService.responseToReturn = response
        let longUrl = "https://very-long-domain-name-for-testing-purposes.example.com" +
            "/api/v2/pokemon/with/very/long/path/that/might/be/used/in/some/edge/cases/25/"

        let expectation = XCTestExpectation(description: "Long URL")

        sut.getPokemonDetail(url: longUrl)
            .subscribe(onNext: { _ in expectation.fulfill() })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
    }

    // MARK: - Response Mapping Tests
    func testResponseMappingWithMinimalData() {
        let minimalResponse = PokemonDetailResponse(
            id: 1,
            name: "test",
            height: 0,
            weight: 0,
            baseExperience: nil,
            order: nil,
            types: [],
            stats: [],
            abilities: [],
            sprites: PokemonSprites(
                backDefault: nil,
                backFemale: nil,
                backShiny: nil,
                backShinyFemale: nil,
                frontDefault: nil,
                frontFemale: nil,
                frontShiny: nil,
                frontShinyFemale: nil,
                other: nil,
                versions: nil
            ),
            moves: [],
            cries: nil,
            species: PokemonSpecies(name: "test", url: "test")
        )

        mockNetworkService.responseToReturn = minimalResponse

        let expectation = XCTestExpectation(description: "Minimal data mapping")

        sut.getPokemonDetail(id: 1)
            .subscribe(
                onNext: { pokemon in
                    XCTAssertEqual(pokemon.id, 1)
                    XCTAssertEqual(pokemon.name, "test")
                    XCTAssertEqual(pokemon.baseExperience, 0) // nil mapped to 0
                    XCTAssertNil(pokemon.order)
                    XCTAssertTrue(pokemon.types.isEmpty)
                    XCTAssertTrue(pokemon.stats.isEmpty)
                    XCTAssertTrue(pokemon.abilities.isEmpty)
                    XCTAssertTrue(pokemon.moves.isEmpty)
                    XCTAssertNil(pokemon.cries)
                    XCTAssertEqual(pokemon.imageURL, "")
                    expectation.fulfill()
                }
            )
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
    }
}
