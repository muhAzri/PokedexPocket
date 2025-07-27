//
//  PokemonListRepository.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
import RxSwift

class PokemonListRepository: PokemonListRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let cacheManager: CacheManagerProtocol

    init(networkService: NetworkServiceProtocol, cacheManager: CacheManagerProtocol = CacheManager.shared) {
        self.networkService = networkService
        self.cacheManager = cacheManager
    }

    func getPokemonList(offset: Int, limit: Int) -> Observable<PokemonList> {
        if offset == 0 && limit >= 1302 {
            return getCachedOrFetchPokemonList()
        }

        let endpoint = PokemonEndpoint.pokemonList(offset: offset, limit: limit)
        return networkService
            .request(endpoint, responseType: PokemonListResponse.self)
            .map { $0.toDomain() }
    }

    private func getCachedOrFetchPokemonList() -> Observable<PokemonList> {
        if cacheManager.isCacheValid(
            forKey: CacheManager.CacheKey.pokemonList,
            maxAge: CacheManager.CacheMaxAge.pokemonList
        ),
           let cachedList = cacheManager.get(CacheManager.CacheKey.pokemonList, type: PokemonList.self) {
            return Observable.just(cachedList)
        }

        let endpoint = PokemonEndpoint.pokemonList(offset: 0, limit: 1302)
        return networkService
            .request(endpoint, responseType: PokemonListResponse.self)
            .map { $0.toDomain() }
            .do(onNext: { [weak self] pokemonList in
                self?.cacheManager.set(pokemonList, forKey: CacheManager.CacheKey.pokemonList)
            })
    }

    func searchPokemon(query: String) -> Observable<[PokemonListItem]> {
        return getPokemonList(offset: 0, limit: 1302)
            .map { pokemonList in
                pokemonList.results.filter { pokemon in
                    pokemon.name.lowercased().contains(query.lowercased())
                }
            }
    }
}
