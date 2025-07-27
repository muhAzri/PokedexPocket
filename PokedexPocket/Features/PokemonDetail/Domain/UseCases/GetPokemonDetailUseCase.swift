//
//  GetPokemonDetailUseCase.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
import RxSwift

protocol GetPokemonDetailUseCaseProtocol {
    func execute(id: Int) -> Observable<PokemonDetail>
    func execute(url: String) -> Observable<PokemonDetail>
}

class GetPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol {
    private let repository: PokemonDetailRepositoryProtocol

    init(repository: PokemonDetailRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: Int) -> Observable<PokemonDetail> {
        return repository.getPokemonDetail(id: id)
    }

    func execute(url: String) -> Observable<PokemonDetail> {
        return repository.getPokemonDetail(url: url)
    }
}
