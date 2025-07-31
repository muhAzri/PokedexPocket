//
//  MockRepositories.swift
//  PokedexPocketTests
//
//  Created by Azri on 30/07/25.
//

import Foundation
import RxSwift
import PokedexPocketCore
import PokedexPocketPokemon
@testable import PokedexPocket

// MARK: - Mock Favorite Pokemon Repository
class MockFavoritePokemonRepository: FavoritePokemonRepositoryProtocol {
    var shouldReturnError = false
    var errorToReturn: Error = NetworkError.unknown
    var favoritePokemon: [FavoritePokemon] = []
    var addFavoriteCallCount = 0
    var removeFavoriteCallCount = 0
    var getFavoritesCallCount = 0
    var checkIsFavoriteCallCount = 0
    var clearAllCallCount = 0
    var lastAddedPokemon: PokemonDetail?
    var lastRemovedId: Int?
    var lastCheckedId: Int?

    func addFavorite(pokemon: PokemonDetail) -> Observable<Void> {
        addFavoriteCallCount += 1
        lastAddedPokemon = pokemon

        if shouldReturnError {
            return Observable.error(errorToReturn)
        }

        let favorite = FavoritePokemon(
            id: pokemon.id,
            name: pokemon.name,
            primaryType: pokemon.types.first?.name ?? "unknown",
            imageURL: pokemon.imageURL,
            dateAdded: Date()
        )
        favoritePokemon.append(favorite)
        return Observable.just(())
    }

    func removeFavorite(pokemonId: Int) -> Observable<Void> {
        removeFavoriteCallCount += 1
        lastRemovedId = pokemonId

        if shouldReturnError {
            return Observable.error(errorToReturn)
        }

        favoritePokemon.removeAll { $0.id == pokemonId }
        return Observable.just(())
    }

    func getFavorites() -> Observable<[FavoritePokemon]> {
        getFavoritesCallCount += 1

        if shouldReturnError {
            return Observable.error(errorToReturn)
        }

        return Observable.just(favoritePokemon)
    }

    func isFavorite(pokemonId: Int) -> Observable<Bool> {
        checkIsFavoriteCallCount += 1
        lastCheckedId = pokemonId

        if shouldReturnError {
            return Observable.error(errorToReturn)
        }

        let isFavorite = favoritePokemon.contains { $0.id == pokemonId }
        return Observable.just(isFavorite)
    }

    func clearAllFavorites() -> Observable<Void> {
        clearAllCallCount += 1

        if shouldReturnError {
            return Observable.error(errorToReturn)
        }

        favoritePokemon.removeAll()
        return Observable.just(())
    }

    func reset() {
        shouldReturnError = false
        errorToReturn = NetworkError.unknown
        favoritePokemon = []
        addFavoriteCallCount = 0
        removeFavoriteCallCount = 0
        getFavoritesCallCount = 0
        checkIsFavoriteCallCount = 0
        clearAllCallCount = 0
        lastAddedPokemon = nil
        lastRemovedId = nil
        lastCheckedId = nil
    }
}
