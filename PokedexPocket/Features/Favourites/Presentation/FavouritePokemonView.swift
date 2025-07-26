import SwiftUI

struct FavouritePokemonView: View {
    @State private var favouritePokemon: [FavouritePokemon] = [
        FavouritePokemon(id: 1, name: "Bulbasaur", type: "Grass"),
        FavouritePokemon(id: 25, name: "Pikachu", type: "Electric"),
        FavouritePokemon(id: 6, name: "Charizard", type: "Fire"),
    ]
    
    var body: some View {
        NavigationView {
            Group {
                if favouritePokemon.isEmpty {
                    EmptyFavouritesView()
                } else {
                    List {
                        ForEach(favouritePokemon) { pokemon in
                            FavouritePokemonRow(pokemon: pokemon) {
                                removeFavourite(pokemon)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !favouritePokemon.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear All") {
                            favouritePokemon.removeAll()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }
    
    private func removeFavourite(_ pokemon: FavouritePokemon) {
        withAnimation {
            favouritePokemon.removeAll { $0.id == pokemon.id }
        }
    }
}

struct EmptyFavouritesView: View {
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
                // This would navigate to Pokemon list in a real app
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

struct FavouritePokemonRow: View {
    let pokemon: FavouritePokemon
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(typeColor(for: pokemon.type).opacity(0.3))
                .frame(width: 60, height: 60)
                .overlay(
                    Text("#\(String(format: "%03d", pokemon.id))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(typeColor(for: pokemon.type))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(pokemon.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(pokemon.type)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(typeColor(for: pokemon.type).opacity(0.2))
                    .foregroundColor(typeColor(for: pokemon.type))
                    .cornerRadius(8)
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
    
    private func typeColor(for type: String) -> Color {
        switch type.lowercased() {
        case "grass":
            return .green
        case "fire":
            return .red
        case "water":
            return .blue
        case "electric":
            return .yellow
        case "psychic":
            return .purple
        case "ice":
            return .cyan
        case "dragon":
            return .indigo
        case "dark":
            return .black
        case "fairy":
            return .pink
        default:
            return .gray
        }
    }
}

struct FavouritePokemon: Identifiable {
    let id: Int
    let name: String
    let type: String
}