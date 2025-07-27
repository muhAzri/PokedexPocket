//
//  PokemonListView.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

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
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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
        .background(Color(.systemBackground))
        .onAppear {
            if viewModel.pokemonList.isEmpty && !viewModel.isLoading {
                viewModel.loadInitialData()
            }
        }
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
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.separator), lineWidth: 0.5)
            )
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }
    
    private var pokemonGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                if viewModel.pokemonList.isEmpty && viewModel.isLoading {
                    // Initial loading state - show skeleton grid
                    ForEach(0..<12, id: \.self) { _ in
                        PokemonLoadingCard()
                    }
                } else {
                    // Show actual Pokemon cards
                    ForEach(viewModel.pokemonList) { pokemon in
                        PokemonCard(pokemon: pokemon) {
                            coordinator.navigate(to: .pokemonDetail(pokemonId: pokemon.pokemonId, pokemonName: pokemon.name))
                        }
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: pokemon)
                        }
                    }
                    
                    // Pagination loading - show additional skeleton cards
                    if viewModel.isLoading && !viewModel.pokemonList.isEmpty {
                        ForEach(0..<6, id: \.self) { _ in
                            PokemonLoadingCard()
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .refreshable {
            viewModel.refreshData()
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

#Preview("Pokemon List View") {
    NavigationView {
        PokemonListView()
            .environmentObject(AppCoordinator())
    }
}