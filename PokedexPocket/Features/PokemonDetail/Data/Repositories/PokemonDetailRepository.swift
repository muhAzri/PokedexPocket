import Foundation
import RxSwift

class PokemonDetailRepository: PokemonDetailRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getPokemonDetail(id: Int) -> Observable<PokemonDetail> {
        let endpoint = PokemonEndpoint.pokemonDetail(id: id)
        return networkService
            .request(endpoint, responseType: PokemonDetailResponse.self)
            .map { $0.toDomain() }
    }
    
    func getPokemonDetail(url: String) -> Observable<PokemonDetail> {
        let endpoint = PokemonEndpoint.pokemonDetailByURL(url: url)
        return networkService
            .request(endpoint, responseType: PokemonDetailResponse.self)
            .map { $0.toDomain() }
    }
}