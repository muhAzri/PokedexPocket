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
                                    coordinator.navigateToPokemonDetail(pokemonName: pokemon.name)
                                } onRemove: {
                                    removeFavourite(pokemon)
                                }
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
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            for pokemon in favouritePokemon {
                modelContext.delete(pokemon)
            }
            try? modelContext.save()
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

struct FavouritePokemonCard: View {
    let pokemon: FavouritePokemon
    let onTap: () -> Void
    let onRemove: () -> Void
    @State private var isRemoving = false
    
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [typeColor(for: pokemon.primaryType).opacity(0.1), typeColor(for: pokemon.primaryType).opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(typeColor(for: pokemon.primaryType).opacity(0.3), lineWidth: 1)
                    )
                
                VStack(spacing: 12) {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                isRemoving = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                onRemove()
                            }
                        }) {
                            Image(systemName: "heart.fill")
                                .font(.caption)
                                .foregroundColor(.red)
                                .scaleEffect(isRemoving ? 0.8 : 1.0)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 8)
                    
                    Spacer()
                    
                    AsyncImage(url: URL(string: pokemon.imageURL), transaction: Transaction(animation: .easeInOut(duration: 0.3))) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .transition(.opacity)
                        case .failure(_):
                            Circle()
                                .fill(typeColor(for: pokemon.primaryType).opacity(0.2))
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.secondary)
                                )
                        case .empty:
                            Circle()
                                .fill(typeColor(for: pokemon.primaryType).opacity(0.2))
                                .overlay(
                                    ProgressView()
                                        .scaleEffect(0.7)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 80, height: 80)
                    .id(pokemon.imageURL) // Force refresh when URL changes
                    
                    VStack(spacing: 6) {
                        Text("#\(String(format: "%03d", pokemon.pokemonId))")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Text(pokemon.name.capitalized)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        
                        Text(pokemon.primaryType.capitalized)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(typeColor(for: pokemon.primaryType).opacity(0.2))
                            .foregroundColor(typeColor(for: pokemon.primaryType))
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 16)
            }
            .aspectRatio(0.8, contentMode: .fit)
        }
        .onTapGesture {
            onTap()
        }
        .scaleEffect(isRemoving ? 0.95 : 1.0)
    }
    
    private func typeColor(for type: String) -> Color {
        switch type.lowercased() {
        case "grass":
            return Color(red: 0.48, green: 0.78, blue: 0.36)
        case "fire":
            return Color(red: 0.93, green: 0.41, blue: 0.26)
        case "water":
            return Color(red: 0.39, green: 0.56, blue: 0.89)
        case "electric":
            return Color(red: 0.98, green: 0.81, blue: 0.16)
        case "psychic":
            return Color(red: 0.98, green: 0.41, blue: 0.68)
        case "ice":
            return Color(red: 0.58, green: 0.89, blue: 0.89)
        case "dragon":
            return Color(red: 0.45, green: 0.31, blue: 0.97)
        case "dark":
            return Color(red: 0.43, green: 0.33, blue: 0.25)
        case "fairy":
            return Color(red: 0.84, green: 0.51, blue: 0.84)
        case "poison":
            return Color(red: 0.64, green: 0.35, blue: 0.68)
        case "ground":
            return Color(red: 0.89, green: 0.75, blue: 0.42)
        case "flying":
            return Color(red: 0.66, green: 0.73, blue: 0.89)
        case "bug":
            return Color(red: 0.64, green: 0.73, blue: 0.18)
        case "rock":
            return Color(red: 0.71, green: 0.63, blue: 0.42)
        case "ghost":
            return Color(red: 0.43, green: 0.35, blue: 0.60)
        case "steel":
            return Color(red: 0.69, green: 0.69, blue: 0.81)
        case "fighting":
            return Color(red: 0.75, green: 0.19, blue: 0.16)
        case "normal":
            return Color(red: 0.66, green: 0.66, blue: 0.47)
        default:
            return Color.gray
        }
    }
}


