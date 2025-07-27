//
//  PokemonDetailViewModel.swift
//  PokedexPocket
//
//  Created by Azri on 27/07/25.
//

import Foundation
import RxSwift
import RxCocoa

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemon: PokemonDetail?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let pokemonId: Int
    private let getPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    init(pokemonId: Int, getPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol) {
        self.pokemonId = pokemonId
        self.getPokemonDetailUseCase = getPokemonDetailUseCase
    }
    
    func loadPokemonDetail() {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        getPokemonDetailUseCase
            .execute(id: pokemonId)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] pokemon in
                    self?.pokemon = pokemon
                    self?.isLoading = false
                },
                onError: { [weak self] error in
                    self?.error = error
                    self?.isLoading = false
                }
            )
            .disposed(by: disposeBag)
    }
}