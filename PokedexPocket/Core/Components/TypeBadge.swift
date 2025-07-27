//
//  TypeBadge.swift
//  PokedexPocket
//
//  Created by Azri on 27/07/25.
//

import SwiftUI

struct TypeBadge: View {
    let type: String
    let color: Color
    
    var body: some View {
        Text(type.capitalized)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.5), lineWidth: 1)
            )
    }
}

#Preview("Type Badge") {
    VStack {
        TypeBadge(type: "fire", color: .red)
        TypeBadge(type: "water", color: .blue)
        TypeBadge(type: "grass", color: .green)
    }
    .padding()
}