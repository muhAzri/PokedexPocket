//
//  AddFavoritePokemonUseCase.swift
//  PokedexPocket
//
//  Created by Azri on 29/07/25.
//

import Foundation
import RxSwift
import PokedexPocketPokemon

protocol AddFavoritePokemonUseCaseProtocol {
    func execute(pokemon: PokemonDetail) -> Observable<Void>
}

class AddFavoritePokemonUseCase: AddFavoritePokemonUseCaseProtocol {
    private let repository: FavoritePokemonRepositoryProtocol

    init(repository: FavoritePokemonRepositoryProtocol) {
        self.repository = repository
    }

    func execute(pokemon: PokemonDetail) -> Observable<Void> {
        return repository.addFavorite(pokemon: pokemon)
    }
}
