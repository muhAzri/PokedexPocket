//
//  FavouritePokemonCard.swift
//  PokedexPocket
//
//  Created by Azri on 27/07/25.
//

import SwiftUI

struct FavouritePokemonCard: View {
    let pokemon: FavouritePokemon
    let onTap: () -> Void
    let onRemove: () -> Void
    @State private var isRemoving = false
    @State private var heartBreakOffset: CGFloat = 0
    @State private var heartBreakRotation: Double = 0
    @State private var showHeartBreak = false
    @State private var cardOpacity: Double = 1.0
    @State private var cardOffset: CGFloat = 0
    
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
                            performRemovalAnimation()
                        }) {
                            ZStack {
                                Image(systemName: "heart.fill")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .scaleEffect(isRemoving ? 0.8 : 1.0)
                                    .opacity(showHeartBreak ? 0 : 1)
                                
                                if showHeartBreak {
                                    HStack(spacing: 1) {
                                        Image(systemName: "heart.slash")
                                            .font(.caption2)
                                            .foregroundColor(.red)
                                            .offset(x: -heartBreakOffset, y: heartBreakOffset)
                                            .rotationEffect(.degrees(-heartBreakRotation))
                                        
                                        Image(systemName: "heart.slash")
                                            .font(.caption2)
                                            .foregroundColor(.red)
                                            .offset(x: heartBreakOffset, y: -heartBreakOffset)
                                            .rotationEffect(.degrees(heartBreakRotation))
                                    }
                                }
                            }
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
                    .id(pokemon.imageURL)
                    
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
        .opacity(cardOpacity)
        .offset(x: cardOffset)
        .rotationEffect(.degrees(isRemoving ? 5 : 0))
    }
    
    private func performRemovalAnimation() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            isRemoving = true
        }
        
        withAnimation(.easeOut(duration: 0.3)) {
            showHeartBreak = true
            heartBreakOffset = 10
            heartBreakRotation = 30
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.4)) {
                cardOffset = -300
                cardOpacity = 0.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onRemove()
        }
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

#Preview("Favourite Pokemon Card") {
    let samplePokemon = FavouritePokemon(
        pokemonId: 25,
        name: "pikachu",
        primaryType: "electric",
        imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png"
    )
    
    FavouritePokemonCard(pokemon: samplePokemon, onTap: {
        print("Pokemon tapped")
    }, onRemove: {
        print("Remove tapped")
    })
    .frame(width: 160, height: 200)
    .padding()
}