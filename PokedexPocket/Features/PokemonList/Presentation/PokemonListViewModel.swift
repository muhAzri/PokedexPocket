import Foundation
import RxSwift
import RxCocoa

class PokemonListViewModel: ObservableObject {
    @Published var pokemonList: [PokemonListItem] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var searchText = ""
    @Published var isSearching = false
    
    private let getPokemonListUseCase: GetPokemonListUseCaseProtocol
    private let searchPokemonUseCase: SearchPokemonUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    private var currentOffset = 0
    private let pageSize = 20
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
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.searchPokemon(query: query)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadInitialData() {
        currentOffset = 0
        hasMoreData = true
        loadPokemonList()
    }
    
    func loadMoreIfNeeded(currentItem: PokemonListItem) {
        guard !isLoading,
              hasMoreData,
              searchText.isEmpty,
              let lastItem = pokemonList.last,
              lastItem.id == currentItem.id else {
            return
        }
        
        loadPokemonList()
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
                    
                    if self.currentOffset == 0 {
                        self.allPokemon = pokemonListResponse.results
                        self.pokemonList = pokemonListResponse.results
                    } else {
                        self.allPokemon.append(contentsOf: pokemonListResponse.results)
                        self.pokemonList.append(contentsOf: pokemonListResponse.results)
                    }
                    
                    self.currentOffset += self.pageSize
                    self.hasMoreData = pokemonListResponse.hasNext
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

import Combine