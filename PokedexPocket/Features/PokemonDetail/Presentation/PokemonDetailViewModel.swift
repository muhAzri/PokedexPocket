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
    
    private let pokemonName: String
    private let getPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    init(pokemonName: String, getPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol) {
        self.pokemonName = pokemonName
        self.getPokemonDetailUseCase = getPokemonDetailUseCase
    }
    
    func loadPokemonDetail() {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        let pokemonId = extractIdFromName(pokemonName)
        
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
    
    private func extractIdFromName(_ name: String) -> Int {
        let lowercasedName = name.lowercased()
        let pokemonNameToIdMap: [String: Int] = [
            "bulbasaur": 1, "ivysaur": 2, "venusaur": 3,
            "charmander": 4, "charmeleon": 5, "charizard": 6,
            "squirtle": 7, "wartortle": 8, "blastoise": 9,
            "caterpie": 10, "metapod": 11, "butterfree": 12,
            "weedle": 13, "kakuna": 14, "beedrill": 15,
            "pidgey": 16, "pidgeotto": 17, "pidgeot": 18,
            "rattata": 19, "raticate": 20, "spearow": 21,
            "fearow": 22, "ekans": 23, "arbok": 24,
            "pikachu": 25, "raichu": 26, "sandshrew": 27,
            "sandslash": 28, "nidoran-f": 29, "nidorina": 30,
            "nidoqueen": 31, "nidoran-m": 32, "nidorino": 33,
            "nidoking": 34, "clefairy": 35, "clefable": 36,
            "vulpix": 37, "ninetales": 38, "jigglypuff": 39,
            "wigglytuff": 40, "zubat": 41, "golbat": 42,
            "oddish": 43, "gloom": 44, "vileplume": 45,
            "paras": 46, "parasect": 47, "venonat": 48,
            "venomoth": 49, "diglett": 50
        ]
        
        return pokemonNameToIdMap[lowercasedName] ?? 1
    }
}