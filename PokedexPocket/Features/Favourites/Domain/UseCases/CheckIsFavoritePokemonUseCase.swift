//
//  CheckIsFavoritePokemonUseCase.swift
//  PokedexPocket
//
//  Created by Azri on 29/07/25.
//

import Foundation
import RxSwift

protocol CheckIsFavoritePokemonUseCaseProtocol {
    func execute(pokemonId: Int) -> Observable<Bool>
}

class CheckIsFavoritePokemonUseCase: CheckIsFavoritePokemonUseCaseProtocol {
    private let repository: FavoritePokemonRepositoryProtocol

    init(repository: FavoritePokemonRepositoryProtocol) {
        self.repository = repository
    }

    func execute(pokemonId: Int) -> Observable<Bool> {
        return repository.isFavorite(pokemonId: pokemonId)
    }
}
