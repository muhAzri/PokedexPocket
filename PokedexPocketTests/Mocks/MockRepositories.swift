//
//  MockRepositories.swift
//  PokedexPocketTests
//
//  Created by Azri on 30/07/25.
//

import Foundation
import RxSwift
import PokedexPocketCore
@testable import PokedexPocket

// MARK: - Mock Pokemon Detail Repository
class MockPokemonDetailRepository: PokemonDetailRepositoryProtocol {
    var shouldReturnError = false
    var errorToReturn: Error = NetworkError.unknown
    var pokemonDetailToReturn: PokemonDetail?
    var getDetailByIdCallCount = 0
    var getDetailByUrlCallCount = 0
    var lastRequestedId: Int?
    var lastRequestedUrl: String?

    func getPokemonDetail(id: Int) -> Observable<PokemonDetail> {
        getDetailByIdCallCount += 1
        lastRequestedId = id

        if shouldReturnError {
            return Observable.error(errorToReturn)
        }

        if let pokemon = pokemonDetailToReturn {
            return Observable.just(pokemon)
        }

        return Observable.error(NetworkError.noData)
    }

    func getPokemonDetail(url: String) -> Observable<PokemonDetail> {
        getDetailByUrlCallCount += 1
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
        getDetailByIdCallCount = 0
        getDetailByUrlCallCount = 0
        lastRequestedId = nil
        lastRequestedUrl = nil
    }
}

// MARK: - Mock Pokemon List Repository
class MockPokemonListRepository: PokemonListRepositoryProtocol {
    var shouldReturnError = false
    var errorToReturn: Error = NetworkError.unknown
    var pokemonListToReturn: PokemonList?
    var pokemonListToSearch: [PokemonListItem] = []
    var getPokemonListCallCount = 0
    var searchPokemonCallCount = 0
    var lastOffsetRequested: Int?
    var lastLimitRequested: Int?
    var lastSearchQuery: String?

    func getPokemonList(offset: Int, limit: Int) -> Observable<PokemonList> {
        getPokemonListCallCount += 1
        lastOffsetRequested = offset
        lastLimitRequested = limit

        if shouldReturnError {
            return Observable.error(errorToReturn)
        }

        if let pokemonList = pokemonListToReturn {
            return Observable.just(pokemonList)
        }

        return Observable.error(NetworkError.noData)
    }

    func searchPokemon(query: String) -> Observable<[PokemonListItem]> {
        searchPokemonCallCount += 1
        lastSearchQuery = query

        if shouldReturnError {
            return Observable.error(errorToReturn)
        }

        let filteredPokemon = pokemonListToSearch.filter { pokemonItem in
            pokemonItem.name.lowercased().contains(query.lowercased())
        }

        return Observable.just(filteredPokemon)
    }

    func reset() {
        shouldReturnError = false
        errorToReturn = NetworkError.unknown
        pokemonListToReturn = nil
        pokemonListToSearch = []
        getPokemonListCallCount = 0
        searchPokemonCallCount = 0
        lastOffsetRequested = nil
        lastLimitRequested = nil
        lastSearchQuery = nil
    }
}

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
