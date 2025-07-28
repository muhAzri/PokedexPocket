//
//  PokemonListView.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import SwiftUI

struct PokemonListView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var viewModelFactory: DefaultViewModelFactory
    @State private var viewModel: PokemonListViewModel?

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        Group {
            if let viewModel = viewModel {
                VStack(spacing: 0) {
                    searchBar(viewModel: viewModel)

                    if viewModel.error != nil {
                        errorContent(viewModel: viewModel)
                    } else {
                        pokemonGrid(viewModel: viewModel)
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
            } else {
                ProgressView()
                    .onAppear {
                        self.viewModel = viewModelFactory.makePokemonListViewModel()
                    }
            }
        }
    }

    private func searchBar(viewModel: PokemonListViewModel) -> some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)

                TextField("Search Pokémon", text: Binding(
                    get: { viewModel.searchText },
                    set: { viewModel.searchText = $0 }
                ))
                    .textFieldStyle(PlainTextFieldStyle())

                if !viewModel.searchText.isEmpty {
                    Button(
                        action: { viewModel.searchText = "" },
                        label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    )
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

    private func pokemonGrid(viewModel: PokemonListViewModel) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                if viewModel.pokemonList.isEmpty && viewModel.isLoading {
                    ForEach(0..<12, id: \.self) { _ in
                        PokemonLoadingCard()
                    }
                } else {
                    ForEach(viewModel.pokemonList) { pokemon in
                        PokemonCard(
                            pokemon: pokemon,
                            onTap: {
                                coordinator.navigate(
                                    to: .pokemonDetail(
                                        pokemonId: pokemon.pokemonId,
                                        pokemonName: pokemon.name
                                    )
                                )
                            }
                        )
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: pokemon)
                        }
                    }

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

    private func errorContent(viewModel: PokemonListViewModel) -> some View {
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
            .environmentObject(DefaultViewModelFactory())
    }
}
