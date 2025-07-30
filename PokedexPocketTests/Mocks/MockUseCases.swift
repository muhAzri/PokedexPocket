//
//  MockUseCases.swift
//  PokedexPocketTests
//
//  Created by Azri on 30/07/25.
//

import Foundation
import RxSwift
@testable import PokedexPocket

// MARK: - Mock Get Pokemon Detail Use Case
class MockGetPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol {
    var shouldReturnError = false
    var errorToReturn: Error = NetworkError.unknown
    var pokemonDetailToReturn: PokemonDetail?
    var executeWithIdCallCount = 0
    var executeWithUrlCallCount = 0
    var lastRequestedId: Int?
    var lastRequestedUrl: String?

    func execute(id: Int) -> Observable<PokemonDetail> {
        executeWithIdCallCount += 1
        lastRequestedId = id

        if shouldReturnError {
            return Observable.error(errorToReturn)
        }

        if let pokemon = pokemonDetailToReturn {
            return Observable.just(pokemon)
        }

        return Observable.error(NetworkError.noData)
    }

    func execute(url: String) -> Observable<PokemonDetail> {
        executeWithUrlCallCount += 1
        lastRequestedUrl = url

        if shouldReturnError {
            return Observable.error(errorToReturn)
        }

        if let pokemon = pokemonDetailToReturn {
            return Observable.just(pokemon)
        }

        return Observable.error(NetworkError.noData)
    }

    func reset() {
        shouldReturnError = false
        errorToReturn = NetworkError.unknown
        pokemonDetailToReturn = nil
        executeWithIdCallCount = 0
        executeWithUrlCallCount = 0
        lastRequestedId = nil
        lastRequestedUrl = nil
    }
}

// MARK: - Mock Add Favorite Pokemon Use Case
class MockAddFavoritePokemonUseCase: AddFavoritePokemonUseCaseProtocol {
    var shouldReturnError = false
    var errorToReturn: Error = NetworkError.unknown
    var executeCallCount = 0
    var lastAddedPokemon: PokemonDetail?

    func execute(pokemon: PokemonDetail) -> Observable<Void> {
        executeCallCount += 1
        lastAddedPokemon = pokemon

        if shouldReturnError {
            return Observable.error(errorToReturn)
        }

        return Observable.just(())
    }

    func reset() {
        shouldReturnError = false
        errorToReturn = NetworkError.unknown
        executeCallCount = 0
        lastAddedPokemon = nil
    }
}

// MARK: - Mock Remove Favorite Pokemon Use Case
class MockRemoveFavoritePokemonUseCase: RemoveFavoritePokemonUseCaseProtocol {
    var shouldReturnError = false
    var errorToReturn: Error = NetworkError.unknown
    var executeCallCount = 0
    var lastRemovedId: Int?

    func execute(pokemonId: Int) -> Observable<Void> {
        executeCallCount += 1
        lastRemovedId = pokemonId

        if shouldReturnError {
            return Observable.error(errorToReturn)
        }

        return Observable.just(())
    }

    func reset() {
        shouldReturnError = false
        errorToReturn = NetworkError.unknown
        executeCallCount = 0
        lastRemovedId = nil
    }
}

// MARK: - Mock Check Is Favorite Pokemon Use Case
class MockCheckIsFavoritePokemonUseCase: CheckIsFavoritePokemonUseCaseProtocol {
    var shouldReturnError = false
    var errorToReturn: Error = NetworkError.unknown
    var isFavoriteToReturn = false
    var executeCallCount = 0
    var lastCheckedId: Int?

    func execute(pokemonId: Int) -> Observable<Bool> {
        executeCallCount += 1
        lastCheckedId = pokemonId

        if shouldReturnError {
            return Observable.error(errorToReturn)
        }

        return Observable.just(isFavoriteToReturn)
    }

    func reset() {
        shouldReturnError = false
        errorToReturn = NetworkError.unknown
        isFavoriteToReturn = false
        executeCallCount = 0
        lastCheckedId = nil
    }
}

// MARK: - Mock Get Favorites Pokemon Use Case
class MockGetFavoritesPokemonUseCase: GetFavoritesPokemonUseCaseProtocol {
    var shouldReturnError = false
    var errorToReturn: Error = NetworkError.unknown
    var favoritesToReturn: [FavoritePokemon] = []
    var executeCallCount = 0

    func execute() -> Observable<[FavoritePokemon]> {
        executeCallCount += 1

        if shouldReturnError {
            return Observable.error(errorToReturn)
        }

        return Observable.just(favoritesToReturn)
    }

    func reset() {
        shouldReturnError = false
        errorToReturn = NetworkError.unknown
        favoritesToReturn = []
        executeCallCount = 0
    }
}

// MARK: - Mock Clear All Favorites Use Case
class MockClearAllFavoritesUseCase: ClearAllFavoritesUseCaseProtocol {
    var shouldReturnError = false
    var errorToReturn: Error = NetworkError.unknown
    var executeCallCount = 0

    func execute() -> Observable<Void> {
        executeCallCount += 1

        if shouldReturnError {
            return Observable.error(errorToReturn)
        }

        return Observable.just(())
    }

    func reset() {
        shouldReturnError = false
        errorToReturn = NetworkError.unknown
        executeCallCount = 0
    }
}
