import SwiftUI

struct PokemonListView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: PokemonListViewModel
    
    init() {
        let container = DIContainer.shared
        let getPokemonListUseCase = container.resolve(GetPokemonListUseCaseProtocol.self)
        let searchPokemonUseCase = container.resolve(SearchPokemonUseCaseProtocol.self)
        
        _viewModel = StateObject(wrappedValue: PokemonListViewModel(
            getPokemonListUseCase: getPokemonListUseCase,
            searchPokemonUseCase: searchPokemonUseCase
        ))
    }
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        VStack(spacing: 0) {
            searchBar
            
            if viewModel.error != nil {
                errorContent
            } else {
                pokemonGrid
            }
        }
        .navigationTitle("Pokédex")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemGroupedBackground))
    }
    
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search Pokémon", text: $viewModel.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }
    
    private var pokemonGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.pokemonList) { pokemon in
                    PokemonCard(pokemon: pokemon) {
                        coordinator.navigate(to: .pokemonDetail(pokemonId: pokemon.pokemonId))
                    }
                    .onAppear {
                        viewModel.loadMoreIfNeeded(currentItem: pokemon)
                    }
                }
                
                if viewModel.isLoading {
                    ForEach(0..<6, id: \.self) { _ in
                        PokemonLoadingCard()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .refreshable {
            viewModel.loadInitialData()
        }
    }
    
    private var errorContent: some View {
        VStack {
            Spacer()
            
            if let error = viewModel.error {
                ErrorView(error: error) {
                    viewModel.retry()
                }
            }
            
            Spacer()
        }
    }
}