//
//  PokemonCard.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import SwiftUI

struct PokemonCard: View {
    let pokemon: PokemonListItem
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [primaryTypeColor.opacity(0.1), primaryTypeColor.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(primaryTypeColor.opacity(0.3), lineWidth: 1)
                    )

                VStack(spacing: 12) {
                    HStack {
                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 8)

                    Spacer()

                    AsyncImage(
                        url: URL(string: pokemon.imageURL),
                        transaction: Transaction(animation: .easeInOut(duration: 0.3))
                    ) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .transition(.opacity)
                        case .failure:
                            Circle()
                                .fill(primaryTypeColor.opacity(0.2))
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.secondary)
                                )
                        case .empty:
                            Circle()
                                .fill(primaryTypeColor.opacity(0.2))
                                .overlay(
                                    ProgressView()
                                        .scaleEffect(0.7)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 80, height: 80)
                    .id(pokemon.imageURL)

                    VStack(spacing: 6) {
                        Text(pokemon.pokemonNumber)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)

                        Text(pokemon.formattedName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)

                        Text("Pokémon")
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(primaryTypeColor.opacity(0.2))
                            .foregroundColor(primaryTypeColor)
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
    }

    private var primaryTypeColor: Color {
        return Color.gray
    }
}

struct PokemonCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview("Pokemon Card") {
    let samplePokemon = PokemonListItem(
        name: "pikachu",
        url: "https://pokeapi.co/api/v2/pokemon/25/"
    )

    PokemonCard(pokemon: samplePokemon) {
    }
    .frame(width: 160, height: 200)
    .padding()
}
