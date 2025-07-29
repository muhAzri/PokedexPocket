//
//  RemoveFavoritePokemonUseCase.swift
//  PokedexPocket
//
//  Created by Azri on 29/07/25.
//

import Foundation
import RxSwift

protocol RemoveFavoritePokemonUseCaseProtocol {
    func execute(pokemonId: Int) -> Observable<Void>
}

class RemoveFavoritePokemonUseCase: RemoveFavoritePokemonUseCaseProtocol {
    private let repository: FavoritePokemonRepositoryProtocol

    init(repository: FavoritePokemonRepositoryProtocol) {
        self.repository = repository
    }

    func execute(pokemonId: Int) -> Observable<Void> {
        return repository.removeFavorite(pokemonId: pokemonId)
    }
}