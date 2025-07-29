//
//  ViewModelFactory.swift
//  PokedexPocket
//
//  Created by Azri on 28/07/25.
//

import Foundation

protocol ViewModelFactory {
    func makePokemonListViewModel() -> PokemonListViewModel
    func makePokemonDetailViewModel(pokemonId: Int) -> PokemonDetailViewModel
}

final class DefaultViewModelFactory: ViewModelFactory, ObservableObject {
    private let container: DIContainer

    init(container: DIContainer = DIContainer.shared) {
        self.container = container
    }

    func makePokemonListViewModel() -> PokemonListViewModel {
        let getPokemonListUseCase = container.resolve(GetPokemonListUseCaseProtocol.self)
        let searchPokemonUseCase = container.resolve(SearchPokemonUseCaseProtocol.self)

        return PokemonListViewModel(
            getPokemonListUseCase: getPokemonListUseCase,
            searchPokemonUseCase: searchPokemonUseCase
        )
    }

    func makePokemonDetailViewModel(pokemonId: Int) -> PokemonDetailViewModel {
        let getPokemonDetailUseCase = container.resolve(GetPokemonDetailUseCaseProtocol.self)

        return PokemonDetailViewModel(
            pokemonId: pokemonId,
            getPokemonDetailUseCase: getPokemonDetailUseCase
        )
    }
}
