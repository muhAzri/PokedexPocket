//
//  SkillBadge.swift
//  PokedexPocket
//
//  Created by Azri on 27/07/25.
//

import SwiftUI

struct SkillBadge: View {
    let skill: String
    let color: Color
    
    var body: some View {
        Text(skill)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(20)
    }
}

#Preview("Skill Badge") {
    VStack {
        SkillBadge(skill: "SwiftUI", color: .blue)
        SkillBadge(skill: "Kotlin", color: .orange)
        SkillBadge(skill: "Flutter", color: .cyan)
    }
    .padding()
}