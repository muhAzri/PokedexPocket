import SwiftUI

struct PokemonListView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(1...20, id: \.self) { index in
                    Button(action: {
                        coordinator.navigate(to: .pokemonDetail(pokemonId: index))
                    }) {
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 100)
                                .overlay(
                                    Text("Pokémon #\(index)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                )
                            
                            Text("Pokémon \(index)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                        }
                        .padding(12)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .navigationTitle("Pokédex")
        .navigationBarTitleDisplayMode(.large)
    }
}