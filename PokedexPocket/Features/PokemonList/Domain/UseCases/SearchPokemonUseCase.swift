import Foundation
import RxSwift

protocol SearchPokemonUseCaseProtocol {
    func execute(query: String) -> Observable<[PokemonListItem]>
}

class SearchPokemonUseCase: SearchPokemonUseCaseProtocol {
    private let repository: PokemonListRepositoryProtocol
    
    init(repository: PokemonListRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(query: String) -> Observable<[PokemonListItem]> {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return Observable.just([])
        }
        
        return repository.searchPokemon(query: query)
    }
}