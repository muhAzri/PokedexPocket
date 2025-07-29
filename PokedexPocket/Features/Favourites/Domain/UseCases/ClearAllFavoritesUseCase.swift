//
//  ClearAllFavoritesUseCase.swift
//  PokedexPocket
//
//  Created by Azri on 29/07/25.
//

import Foundation
import RxSwift

protocol ClearAllFavoritesUseCaseProtocol {
    func execute() -> Observable<Void>
}

class ClearAllFavoritesUseCase: ClearAllFavoritesUseCaseProtocol {
    private let repository: FavoritePokemonRepositoryProtocol

    init(repository: FavoritePokemonRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> Observable<Void> {
        return repository.clearAllFavorites()
    }
}