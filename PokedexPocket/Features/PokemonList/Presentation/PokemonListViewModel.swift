//
//  PokemonListViewModel.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
import RxSwift
import RxCocoa

class PokemonListViewModel: ObservableObject {
    @Published var pokemonList: [PokemonListItem] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var isSearching = false
    private let searchTextSubject = BehaviorSubject<String>(value: "")
    var searchText: String = "" {
        didSet {
            searchTextSubject.onNext(searchText)
        }
    }

    private let getPokemonListUseCase: GetPokemonListUseCaseProtocol
    private let searchPokemonUseCase: SearchPokemonUseCaseProtocol
    private let disposeBag = DisposeBag()

    private var currentOffset = 0
    private let pageSize = 1302
    private var hasMoreData = true
    private var allPokemon: [PokemonListItem] = []

    init(
        getPokemonListUseCase: GetPokemonListUseCaseProtocol,
        searchPokemonUseCase: SearchPokemonUseCaseProtocol
    ) {
        self.getPokemonListUseCase = getPokemonListUseCase
        self.searchPokemonUseCase = searchPokemonUseCase

        setupSearchBinding()
        loadInitialData()
    }

    private func setupSearchBinding() {
        searchTextSubject
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.searchPokemon(query: query)
            })
            .disposed(by: disposeBag)
    }

    func loadInitialData() {
        currentOffset = 0
        hasMoreData = false
        loadPokemonList()
    }

    func refreshData() {
        currentOffset = 0
        hasMoreData = false
        allPokemon.removeAll()
        pokemonList.removeAll()
        loadPokemonList()
    }

    func loadMoreIfNeeded(currentItem: PokemonListItem) {
        // No pagination needed since we load all Pokemon at once
        return
    }

    private func loadPokemonList() {
        guard !isLoading else { return }

        isLoading = true
        error = nil

        getPokemonListUseCase
            .execute(offset: currentOffset, limit: pageSize)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] pokemonListResponse in
                    guard let self = self else { return }

                    self.allPokemon = pokemonListResponse.results
                    self.pokemonList = pokemonListResponse.results
                    self.hasMoreData = false
                    self.isLoading = false
                },
                onError: { [weak self] error in
                    self?.error = error
                    self?.isLoading = false
                }
            )
            .disposed(by: disposeBag)
    }

    private func searchPokemon(query: String) {
        if query.isEmpty {
            pokemonList = allPokemon
            isSearching = false
            return
        }

        isSearching = true

        let filteredResults = allPokemon.filter { pokemon in
            pokemon.name.lowercased().contains(query.lowercased())
        }

        pokemonList = filteredResults
        isSearching = false
    }

    func retry() {
        error = nil
        if searchText.isEmpty {
            loadInitialData()
        } else {
            searchPokemon(query: searchText)
        }
    }
}
