//
//  PokemonDetailContentComponents.swift
//  PokedexPocket
//
//  Created by Azri on 27/07/25.
//

import SwiftUI

struct PokemonDetailContentSection: View {
    let pokemon: PokemonDetail
    @Binding var selectedTab: DetailTab

    var body: some View {
        VStack(spacing: 0) {
            Picker("Detail Tab", selection: $selectedTab) {
                ForEach(DetailTab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.bottom, 20)

            switch selectedTab {
            case .about:
                PokemonAboutSection(pokemon: pokemon)
            case .stats:
                PokemonStatsSection(pokemon: pokemon)
            case .moves:
                PokemonMovesSection(pokemon: pokemon)
            case .abilities:
                PokemonAbilitiesSection(pokemon: pokemon)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(30, corners: [.topLeft, .topRight])
    }
}

struct PokemonAboutSection: View {
    let pokemon: PokemonDetail

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 40) {
                VStack(spacing: 8) {
                    Text("Height")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Text("\(pokemon.heightInMeters, specifier: "%.1f") m")
                        .font(.body)
                        .fontWeight(.semibold)
                }

                VStack(spacing: 8) {
                    Text("Weight")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Text("\(pokemon.weightInKilograms, specifier: "%.1f") kg")
                        .font(.body)
                        .fontWeight(.semibold)
                }

                VStack(spacing: 8) {
                    Text("Base EXP")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Text("\(pokemon.baseExperience)")
                        .font(.body)
                        .fontWeight(.semibold)
                }

                Spacer()
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 12) {
                Text("Species")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(pokemon.species.capitalized)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            Spacer(minLength: 40)
        }
        .padding(.vertical)
    }
}

struct PokemonStatsSection: View {
    let pokemon: PokemonDetail

    private func primaryTypeColor(pokemon: PokemonDetail) -> Color {
        guard let firstType = pokemon.types.first else { return Color.gray }
        return Color(hex: firstType.color)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(pokemon.stats) { stat in
                StatRow(
                    name: stat.name.replacingOccurrences(of: "-", with: " ").capitalized,
                    value: stat.value,
                    maxValue: 200,
                    color: primaryTypeColor(pokemon: pokemon)
                )
            }

            Spacer(minLength: 40)
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
}

struct PokemonMovesSection: View {
    let pokemon: PokemonDetail

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 12) {
            ForEach(Array(pokemon.moves.prefix(20))) { move in
                MoveRow(move: move)
            }

            if pokemon.moves.count > 20 {
                Text("... and \(pokemon.moves.count - 20) more moves")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }

            Spacer(minLength: 40)
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
}

struct PokemonAbilitiesSection: View {
    let pokemon: PokemonDetail

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(pokemon.abilities) { ability in
                AbilityRow(ability: ability)
            }

            Spacer(minLength: 40)
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
}
