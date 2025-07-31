//
//  ViewModelFactory.swift
//  PokedexPocket
//
//  Created by Azri on 28/07/25.
//

import Foundation
import PokedexPocketPokemon

protocol ViewModelFactory {
    func makePokemonListViewModel() -> PokedexPocketPokemon.PokemonListViewModel
    func makePokemonDetailViewModel(pokemonId: Int) -> PokedexPocketPokemon.PokemonDetailViewModel
    func makeFavoritePokemonViewModel() -> FavoritePokemonViewModel
}

final class DefaultViewModelFactory: ViewModelFactory, ObservableObject {
    private let container: DIContainer

    init(container: DIContainer = DIContainer.shared) {
        self.container = container
    }

    func makePokemonListViewModel() -> PokedexPocketPokemon.PokemonListViewModel {
        let getPokemonListUseCase = container.resolve(GetPokemonListUseCaseProtocol.self)
        let searchPokemonUseCase = container.resolve(SearchPokemonUseCaseProtocol.self)

        return PokedexPocketPokemon.PokemonListViewModel(
            getPokemonListUseCase: getPokemonListUseCase,
            searchPokemonUseCase: searchPokemonUseCase
        )
    }

    func makePokemonDetailViewModel(pokemonId: Int) -> PokedexPocketPokemon.PokemonDetailViewModel {
        let getPokemonDetailUseCase = container.resolve(GetPokemonDetailUseCaseProtocol.self)

        return PokedexPocketPokemon.PokemonDetailViewModel(
            pokemonId: pokemonId,
            getPokemonDetailUseCase: getPokemonDetailUseCase
        )
    }

    func makeFavoritePokemonViewModel() -> FavoritePokemonViewModel {
        let getFavoritesUseCase = container.resolve(GetFavoritesPokemonUseCaseProtocol.self)
        let removeFavoriteUseCase = container.resolve(RemoveFavoritePokemonUseCaseProtocol.self)
        let clearAllFavoritesUseCase = container.resolve(ClearAllFavoritesUseCaseProtocol.self)

        return FavoritePokemonViewModel(
            getFavoritesUseCase: getFavoritesUseCase,
            removeFavoriteUseCase: removeFavoriteUseCase,
            clearAllFavoritesUseCase: clearAllFavoritesUseCase
        )
    }
}
