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
        // For full list requests (1302 Pokemon), use caching
        if offset == 0 && limit >= 1302 {
            return getCachedOrFetchPokemonList()
        }
        
        // For partial requests, fetch directly
        let endpoint = PokemonEndpoint.pokemonList(offset: offset, limit: limit)
        return networkService
            .request(endpoint, responseType: PokemonListResponse.self)
            .map { $0.toDomain() }
    }
    
    private func getCachedOrFetchPokemonList() -> Observable<PokemonList> {
        // Check if we have valid cached data
        if cacheManager.isCacheValid(forKey: CacheManager.CacheKey.pokemonList, maxAge: CacheManager.CacheMaxAge.pokemonList),
           let cachedList = cacheManager.get(CacheManager.CacheKey.pokemonList, type: PokemonList.self) {
            return Observable.just(cachedList)
        }
        
        // Fetch from network and cache the result
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