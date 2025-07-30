//
//  PokemonDetailHeaderComponents.swift
//  PokedexPocket
//
//  Created by Azri on 27/07/25.
//

import SwiftUI

struct PokemonDetailHeaderSection: View {
    let pokemon: PokemonDetail
    let geometry: GeometryProxy
    @Binding var selectedSpriteStyle: SpriteStyle
    @Binding var isShinyVariant: Bool
    @Binding var isFrontView: Bool
    @Binding var rotationAngle: Double
    @Binding var spriteScale: CGFloat
    @Binding var isFavourite: Bool
    @Binding var heartScale: CGFloat
    @Binding var heartRotation: Double
    @Binding var showHeartBurst: Bool

    let onToggleFavourite: () -> Void
    let onSpriteAppear: () -> Void
    let onSpriteDisappear: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            PokemonHeaderTitle(
                pokemon: pokemon,
                isFavourite: $isFavourite,
                heartScale: $heartScale,
                heartRotation: $heartRotation,
                showHeartBurst: $showHeartBurst,
                onToggleFavourite: onToggleFavourite
            )
            PokemonTypesBadgeSection(pokemon: pokemon)
            PokemonAnimatedSpriteSection(
                pokemon: pokemon,
                selectedSpriteStyle: $selectedSpriteStyle,
                isShinyVariant: $isShinyVariant,
                isFrontView: $isFrontView,
                rotationAngle: $rotationAngle,
                spriteScale: $spriteScale,
                onSpriteAppear: onSpriteAppear,
                onSpriteDisappear: onSpriteDisappear
            )
            PokemonSpriteControlsSection(
                pokemon: pokemon,
                selectedSpriteStyle: $selectedSpriteStyle,
                isShinyVariant: $isShinyVariant,
                isFrontView: $isFrontView,
                rotationAngle: $rotationAngle
            )
        }
        .padding(.vertical)
    }
}

struct PokemonHeaderTitle: View {
    let pokemon: PokemonDetail
    @Binding var isFavourite: Bool
    @Binding var heartScale: CGFloat
    @Binding var heartRotation: Double
    @Binding var showHeartBurst: Bool
    let onToggleFavourite: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(pokemon.formattedName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text(pokemon.pokemonNumber)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: onToggleFavourite) {
                ZStack {
                    Image(systemName: isFavourite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(isFavourite ? .red : .gray)
                        .scaleEffect(heartScale)
                        .rotationEffect(.degrees(heartRotation))
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isFavourite)

                    if showHeartBurst {
                        ForEach(0..<8, id: \.self) { index in
                            Image(systemName: "heart.fill")
                                .font(.caption2)
                                .foregroundColor(.red)
                                .offset(
                                    x: cos(Double(index) * .pi / 4) * 30,
                                    y: sin(Double(index) * .pi / 4) * 30
                                )
                                .scaleEffect(showHeartBurst ? 0.3 : 1.0)
                                .opacity(showHeartBurst ? 0.0 : 1.0)
                                .animation(
                                    .easeOut(duration: 0.6).delay(Double(index) * 0.05),
                                    value: showHeartBurst
                                )
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct PokemonTypesBadgeSection: View {
    let pokemon: PokemonDetail

    var body: some View {
        HStack(spacing: 12) {
            ForEach(pokemon.types) { type in
                TypeBadge(type: type.name, color: Color(hex: type.color))
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct PokemonAnimatedSpriteSection: View {
    let pokemon: PokemonDetail
    @Binding var selectedSpriteStyle: SpriteStyle
    @Binding var isShinyVariant: Bool
    @Binding var isFrontView: Bool
    @Binding var rotationAngle: Double
    @Binding var spriteScale: CGFloat
    let onSpriteAppear: () -> Void
    let onSpriteDisappear: () -> Void

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                primaryTypeColor(pokemon: pokemon).opacity(0.2 - Double(index) * 0.05),
                                primaryTypeColor(pokemon: pokemon).opacity(0.05)
                            ],
                            center: .center,
                            startRadius: 50,
                            endRadius: 150
                        )
                    )
                    .frame(width: CGFloat(280 + index * 40), height: CGFloat(280 + index * 40))
                    .scaleEffect(spriteScale)
                    .rotationEffect(.degrees(Double(index) * 120 + rotationAngle * 0.1))
                    .animation(
                        .easeInOut(duration: 2.0 + Double(index) * 0.5).repeatForever(autoreverses: true),
                        value: spriteScale
                    )
                    .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: rotationAngle)
            }

            AnimatedSpriteView(
                pokemon: pokemon,
                selectedStyle: selectedSpriteStyle,
                isShiny: isShinyVariant,
                isFrontView: $isFrontView,
                rotationAngle: $rotationAngle,
                onTap: {
                    if selectedSpriteStyle.supportsBackView {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            isFrontView.toggle()
                            rotationAngle += 180
                        }
                    }
                }
            )
            .frame(width: 200, height: 200)
            .zIndex(10)
        }
        .onAppear(perform: onSpriteAppear)
        .onDisappear(perform: onSpriteDisappear)
    }

    private func primaryTypeColor(pokemon: PokemonDetail) -> Color {
        if let firstType = pokemon.types.first {
            return Color(hex: firstType.color)
        }
        return Color.blue
    }
}

struct PokemonSpriteControlsSection: View {
    let pokemon: PokemonDetail
    @Binding var selectedSpriteStyle: SpriteStyle
    @Binding var isShinyVariant: Bool
    @Binding var isFrontView: Bool
    @Binding var rotationAngle: Double

    var body: some View {
        VStack(spacing: 12) {
            Picker("Sprite Style", selection: $selectedSpriteStyle) {
                ForEach(SpriteStyle.allCases, id: \.self) { style in
                    Text(style.rawValue).tag(style)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedSpriteStyle) { _, newStyle in
                if !newStyle.supportsBackView && !isFrontView {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        isFrontView = true
                        rotationAngle = 0
                    }
                }
            }

            HStack {
                HStack(spacing: 8) {
                    Text("Shiny")
                        .font(.caption)
                        .foregroundColor(.primary)
                    Toggle("", isOn: $isShinyVariant)
                        .toggleStyle(SwitchToggleStyle(tint: primaryTypeColor(pokemon: pokemon)))
                        .labelsHidden()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .frame(maxWidth: .infinity)

                if selectedSpriteStyle.supportsBackView {
                    Button(
                        action: {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                isFrontView.toggle()
                                rotationAngle += 180
                            }
                        },
                        label: {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.caption)
                                Text(isFrontView ? "Back" : "Front")
                                    .font(.caption)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(primaryTypeColor(pokemon: pokemon).opacity(0.2))
                            .foregroundColor(primaryTypeColor(pokemon: pokemon))
                            .cornerRadius(12)
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
            }

            Text(
                selectedSpriteStyle.description +
                    (selectedSpriteStyle.supportsBackView ? " • Tap to flip" : "")
            )
            .font(.caption2)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }

    private func primaryTypeColor(pokemon: PokemonDetail) -> Color {
        if let firstType = pokemon.types.first {
            return Color(hex: firstType.color)
        }
        return Color.blue
    }
}
