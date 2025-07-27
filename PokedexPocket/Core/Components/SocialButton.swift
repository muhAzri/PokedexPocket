//
//  SocialButton.swift
//  PokedexPocket
//
//  Created by Azri on 27/07/25.
//

import SwiftUI

struct SocialButton: View {
    let icon: String
    let title: String
    let url: String

    var body: some View {
        Button(
            action: {
                if let url = URL(string: url) {
                    UIApplication.shared.open(url)
                }
            },
            label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)

                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(12)
        }
    )
        .accessibilityLabel("\(title) - Opens \(title.lowercased()) app or website")
        .accessibilityHint("Double tap to open \(title.lowercased())")
        .accessibilityAddTraits(.isButton)
    }
}

#Preview("Social Button") {
    HStack {
        SocialButton(icon: "envelope.fill", title: "Email", url: "mailto:test@example.com")
        SocialButton(icon: "link", title: "GitHub", url: "https://github.com")
        SocialButton(icon: "person.crop.rectangle.fill", title: "LinkedIn", url: "https://linkedin.com")
    }
    .padding()
}
