//
//  FavouritePokemonView.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import SwiftUI

struct FavouritePokemonView: View {
    @StateObject private var viewModel: FavoritePokemonViewModel
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var showClearAllAlert = false

    init(viewModel: FavoritePokemonViewModel? = nil) {
        if let viewModel = viewModel {
            self._viewModel = StateObject(wrappedValue: viewModel)
        } else {
            let factory = DIContainer.shared.resolve(ViewModelFactory.self)
            self._viewModel = StateObject(wrappedValue: factory.makeFavoritePokemonViewModel())
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading favorites...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.favorites.isEmpty {
                    EmptyFavouritesView(coordinator: coordinator)
                } else {
                    ScrollView {
                        LazyVGrid(columns: gridColumns, spacing: 16, pinnedViews: []) {
                            ForEach(viewModel.favorites, id: \.id) { pokemon in
                                FavouritePokemonCard(
                                    pokemon: pokemon,
                                    onTap: {
                                        coordinator.navigateToPokemonDetail(
                                            pokemonId: pokemon.id,
                                            pokemonName: pokemon.name
                                        )
                                    },
                                    onRemove: {
                                        viewModel.removeFavorite(pokemonId: pokemon.id)
                                    }
                                )
                                .scaleEffect(viewModel.isClearingAll ? 0.0 : 1.0)
                                .opacity(viewModel.isClearingAll ? 0.0 : 1.0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.isClearingAll)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .refreshable {
                        viewModel.loadFavorites()
                    }
                }
            }
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !viewModel.favorites.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear All") {
                            showClearAllAlert = true
                        }
                        .foregroundColor(.red)
                        .disabled(viewModel.isClearingAll)
                    }
                }
            }
            .alert("Clear All Favourites", isPresented: $showClearAllAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    viewModel.clearAllFavorites()
                }
            } message: {
                Text(
                    "Are you sure you want to remove all \(viewModel.favorites.count) favourite Pokémon? " +
                    "This action cannot be undone."
                )
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("Dismiss") {
                    viewModel.dismissError()
                }
                Button("Retry") {
                    viewModel.retry()
                }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
        }
        .onAppear {
            viewModel.loadFavorites()
        }
    }

    private let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
}

struct EmptyFavouritesView: View {
    let coordinator: AppCoordinator

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))

            VStack(spacing: 8) {
                Text("No Favourites Yet")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(
                    "Start exploring Pokémon and add your favorites by tapping the heart icon on " +
                    "any Pokémon detail page."
                )
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 24)
            }

            Button(
                action: {
                    coordinator.switchTab(to: .home)
                },
                label: {
                    Text("Explore Pokémon")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            )

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview("Favourite Pokemon View - Empty") {
    FavouritePokemonView()
        .environmentObject(AppCoordinator())
}
