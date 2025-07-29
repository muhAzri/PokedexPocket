//
//  GetFavoritesPokemonUseCase.swift
//  PokedexPocket
//
//  Created by Azri on 29/07/25.
//

import Foundation
import RxSwift

protocol GetFavoritesPokemonUseCaseProtocol {
    func execute() -> Observable<[FavoritePokemon]>
}

class GetFavoritesPokemonUseCase: GetFavoritesPokemonUseCaseProtocol {
    private let repository: FavoritePokemonRepositoryProtocol

    init(repository: FavoritePokemonRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> Observable<[FavoritePokemon]> {
        return repository.getFavorites()
    }
}