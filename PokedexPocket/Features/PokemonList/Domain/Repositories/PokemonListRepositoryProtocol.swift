import Foundation
import RxSwift

protocol PokemonListRepositoryProtocol {
    func getPokemonList(offset: Int, limit: Int) -> Observable<PokemonList>
    func searchPokemon(query: String) -> Observable<[PokemonListItem]>
}