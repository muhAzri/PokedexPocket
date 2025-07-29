//
//  FavoritePokemonViewModel.swift
//  PokedexPocket
//
//  Created by Azri on 29/07/25.
//

import Foundation
import RxSwift
import RxCocoa

@MainActor
class FavoritePokemonViewModel: ObservableObject {
    @Published var favorites: [FavoritePokemon] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isClearingAll = false
    
    private let getFavoritesUseCase: GetFavoritesPokemonUseCaseProtocol
    private let removeFavoriteUseCase: RemoveFavoritePokemonUseCaseProtocol
    private let clearAllFavoritesUseCase: ClearAllFavoritesUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    init(
        getFavoritesUseCase: GetFavoritesPokemonUseCaseProtocol,
        removeFavoriteUseCase: RemoveFavoritePokemonUseCaseProtocol,
        clearAllFavoritesUseCase: ClearAllFavoritesUseCaseProtocol
    ) {
        self.getFavoritesUseCase = getFavoritesUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
        self.clearAllFavoritesUseCase = clearAllFavoritesUseCase
        
        loadFavorites()
    }
    
    func loadFavorites() {
        isLoading = true
        errorMessage = nil
        
        getFavoritesUseCase
            .execute()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] favorites in
                    self?.favorites = favorites
                    self?.isLoading = false
                },
                onError: { [weak self] error in
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                }
            )
            .disposed(by: disposeBag)
    }
    
    func removeFavorite(pokemonId: Int) {
        guard let favoriteIndex = favorites.firstIndex(where: { $0.id == pokemonId }) else {
            return
        }
        
        let favoriteToRemove = favorites[favoriteIndex]
        
        // Optimistic update - remove from UI immediately
        favorites.remove(at: favoriteIndex)
        
        removeFavoriteUseCase
            .execute(pokemonId: pokemonId)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] _ in
                    // Successfully removed - no need to update UI as it's already done
                    self?.errorMessage = nil
                },
                onError: { [weak self] error in
                    // Revert optimistic update on error
                    self?.favorites.insert(favoriteToRemove, at: favoriteIndex)
                    self?.errorMessage = error.localizedDescription
                }
            )
            .disposed(by: disposeBag)
    }
    
    func clearAllFavorites() {
        guard !favorites.isEmpty else { return }
        
        isClearingAll = true
        let originalFavorites = favorites
        
        // Optimistic update - clear UI immediately
        favorites.removeAll()
        
        clearAllFavoritesUseCase
            .execute()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] _ in
                    self?.isClearingAll = false
                    self?.errorMessage = nil
                },
                onError: { [weak self] error in
                    // Revert optimistic update on error
                    self?.favorites = originalFavorites
                    self?.isClearingAll = false
                    self?.errorMessage = error.localizedDescription
                }
            )
            .disposed(by: disposeBag)
    }
    
    func retry() {
        loadFavorites()
    }
    
    func dismissError() {
        errorMessage = nil
    }
}