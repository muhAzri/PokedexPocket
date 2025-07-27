import Foundation
import RxSwift

class PokemonListRepository: PokemonListRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getPokemonList(offset: Int, limit: Int) -> Observable<PokemonList> {
        let endpoint = PokemonEndpoint.pokemonList(offset: offset, limit: limit)
        return networkService
            .request(endpoint, responseType: PokemonListResponse.self)
            .map { $0.toDomain() }
    }
    
    func searchPokemon(query: String) -> Observable<[PokemonListItem]> {
        return getPokemonList(offset: 0, limit: 1000)
            .map { pokemonList in
                pokemonList.results.filter { pokemon in
                    pokemon.name.lowercased().contains(query.lowercased())
                }
            }
    }
}