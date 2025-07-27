//
//  FeatureRow.swift
//  PokedexPocket
//
//  Created by Azri on 27/07/25.
//

import SwiftUI

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview("Feature Row") {
    VStack {
        FeatureRow(icon: "list.bullet", title: "Browse Pokémon", description: "Explore a comprehensive list of Pokémon")
        FeatureRow(icon: "heart", title: "Favorites", description: "Save your favorite Pokémon")
    }
    .padding()
}