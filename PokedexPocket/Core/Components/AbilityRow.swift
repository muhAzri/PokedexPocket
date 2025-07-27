//
//  AbilityRow.swift
//  PokedexPocket
//
//  Created by Azri on 27/07/25.
//

import SwiftUI

struct AbilityRow: View {
    let ability: PokemonAbility
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(ability.formattedName)
                    .font(.body)
                    .fontWeight(.medium)
                
                if ability.isHidden {
                    Text("Hidden Ability")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

#Preview("Ability Row") {
    let sampleAbility = PokemonAbility(
        name: "static",
        isHidden: false
    )
    
    let hiddenAbility = PokemonAbility(
        name: "lightning-rod",
        isHidden: true
    )
    
    VStack {
        AbilityRow(ability: sampleAbility)
        AbilityRow(ability: hiddenAbility)
    }
    .padding()
}