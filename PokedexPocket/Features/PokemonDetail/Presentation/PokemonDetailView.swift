import SwiftUI

struct PokemonDetailView: View {
    let pokemonId: Int
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var isFavourite = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 200)
                    .overlay(
                        VStack(spacing: 8) {
                            Text("Pokémon Image")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Text("#\(String(format: "%03d", pokemonId))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                    )
                    .padding(.horizontal)
                
                VStack(spacing: 20) {
                    HStack {
                        Text("Pokémon \(pokemonId)")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            isFavourite.toggle()
                        }) {
                            Image(systemName: isFavourite ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(isFavourite ? .red : .gray)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 12) {
                        TypeBadge(type: "Type 1", color: .green)
                        TypeBadge(type: "Type 2", color: .blue)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("About")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        
                        Text("This is a placeholder description for Pokémon #\(pokemonId). In a real app, this would contain detailed information about the Pokémon's abilities, habitat, and characteristics.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Stats")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        
                        VStack(spacing: 12) {
                            StatRow(name: "HP", value: 45, maxValue: 100)
                            StatRow(name: "Attack", value: 60, maxValue: 100)
                            StatRow(name: "Defense", value: 40, maxValue: 100)
                            StatRow(name: "Speed", value: 65, maxValue: 100)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer(minLength: 20)
            }
            .padding(.vertical)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TypeBadge: View {
    let type: String
    let color: Color
    
    var body: some View {
        Text(type)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(16)
    }
}

struct StatRow: View {
    let name: String
    let value: Int
    let maxValue: Int
    
    var body: some View {
        HStack {
            Text(name)
                .font(.body)
                .fontWeight(.medium)
                .frame(width: 80, alignment: .leading)
            
            Text("\(value)")
                .font(.body)
                .fontWeight(.semibold)
                .frame(width: 30, alignment: .trailing)
            
            ProgressView(value: Double(value), total: Double(maxValue))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .frame(height: 8)
        }
    }
}