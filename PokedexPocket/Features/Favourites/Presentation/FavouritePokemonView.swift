//
//  FavouritePokemonView.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import SwiftUI
import SwiftData

struct FavouritePokemonView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\FavouritePokemon.dateAdded, order: .reverse)]) private var favouritePokemon: [FavouritePokemon]
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var showClearAllAlert = false
    @State private var isClearingAll = false

    var body: some View {
        NavigationView {
            Group {
                if favouritePokemon.isEmpty {
                    EmptyFavouritesView(coordinator: coordinator)
                } else {
                    ScrollView {
                        LazyVGrid(columns: gridColumns, spacing: 16, pinnedViews: []) {
                            ForEach(favouritePokemon, id: \.pokemonId) { pokemon in
                                FavouritePokemonCard(pokemon: pokemon) {
                                    coordinator.navigateToPokemonDetail(pokemonId: pokemon.pokemonId, pokemonName: pokemon.name)
                                } onRemove: {
                                    removeFavourite(pokemon)
                                }
                                .scaleEffect(isClearingAll ? 0.0 : 1.0)
                                .opacity(isClearingAll ? 0.0 : 1.0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isClearingAll)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !favouritePokemon.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear All") {
                            showClearAllAlert = true
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .alert("Clear All Favourites", isPresented: $showClearAllAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    clearAllFavourites()
                }
            } message: {
                Text("Are you sure you want to remove all \(favouritePokemon.count) favourite Pokémon? This action cannot be undone.")
            }
        }
    }

    private let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    private func removeFavourite(_ pokemon: FavouritePokemon) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            modelContext.delete(pokemon)
            try? modelContext.save()
        }
    }

    private func clearAllFavourites() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()

        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isClearingAll = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            for pokemon in favouritePokemon {
                modelContext.delete(pokemon)
            }
            try? modelContext.save()
            isClearingAll = false
        }
    }
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

                Text("Start exploring Pokémon and add your favorites by tapping the heart icon on any Pokémon detail page.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 24)
            }

            Button(action: {
                coordinator.switchTab(to: .home)
            }) {
                Text("Explore Pokémon")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview("Favourite Pokemon View - Empty") {
    FavouritePokemonView()
        .environmentObject(AppCoordinator())
        .modelContainer(for: FavouritePokemon.self, inMemory: true)
}
