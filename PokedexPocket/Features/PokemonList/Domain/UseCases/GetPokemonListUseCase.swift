//
//  GetPokemonListUseCase.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
import RxSwift

protocol GetPokemonListUseCaseProtocol {
    func execute(offset: Int, limit: Int) -> Observable<PokemonList>
}

class GetPokemonListUseCase: GetPokemonListUseCaseProtocol {
    private let repository: PokemonListRepositoryProtocol

    init(repository: PokemonListRepositoryProtocol) {
        self.repository = repository
    }

    func execute(offset: Int = 0, limit: Int = 20) -> Observable<PokemonList> {
        return repository.getPokemonList(offset: offset, limit: limit)
    }
}
