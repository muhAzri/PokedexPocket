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
    func makeFavoritePokemonViewModel() -> FavoritePokemonViewModel
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
        let addFavoriteUseCase = container.resolve(AddFavoritePokemonUseCaseProtocol.self)
        let removeFavoriteUseCase = container.resolve(RemoveFavoritePokemonUseCaseProtocol.self)
        let checkIsFavoriteUseCase = container.resolve(CheckIsFavoritePokemonUseCaseProtocol.self)

        return PokemonDetailViewModel(
            pokemonId: pokemonId,
            getPokemonDetailUseCase: getPokemonDetailUseCase,
            addFavoriteUseCase: addFavoriteUseCase,
            removeFavoriteUseCase: removeFavoriteUseCase,
            checkIsFavoriteUseCase: checkIsFavoriteUseCase
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
