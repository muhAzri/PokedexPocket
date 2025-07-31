//
//  AboutDevView.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import SwiftUI
import PokedexPocketCore

struct AboutDevView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    Image("About")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.primary.opacity(0.1), lineWidth: 2)
                        )

                    VStack(spacing: 4) {
                        Text("Muhammad Azri Fatihah Susanto")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Mobile App Developer")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("About Me")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                    }

                    Text(
                        """
                        Passionate mobile app developer with expertise in cross-platform development. \
                        Specialized in Android Native (Kotlin & Jetpack Compose), iOS (Swift & SwiftUI), \
                        and Flutter. This Pokédex app showcases clean architecture principles and modern \
                        mobile development practices.
                        """
                    )
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal)

                VStack(spacing: 12) {
                    HStack {
                        Text("Skills & Technologies")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                    }

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                        SkillBadge(skill: "SwiftUI", color: .blue)
                        SkillBadge(skill: "Kotlin", color: .orange)
                        SkillBadge(skill: "Jetpack Compose", color: .green)
                        SkillBadge(skill: "Flutter", color: .cyan)
                        SkillBadge(skill: "REST APIs", color: .red)
                        SkillBadge(skill: "Clean Architecture", color: .purple)
                    }
                }
                .padding(.horizontal)

                VStack(spacing: 12) {
                    HStack {
                        Text("App Features")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                    }

                    VStack(spacing: 8) {
                        FeatureRow(
                            icon: "list.bullet",
                            title: "Browse Pokémon",
                            description: "Explore a comprehensive list of Pokémon"
                        )
                        FeatureRow(
                            icon: "info.circle",
                            title: "Detailed Info",
                            description: "View stats, types, and descriptions"
                        )
                        FeatureRow(icon: "heart", title: "Favorites", description: "Save your favorite Pokémon")
                        FeatureRow(icon: "paintbrush", title: "Clean UI", description: "Modern and intuitive design")
                    }
                }
                .padding(.horizontal)

                VStack(spacing: 12) {
                    Text("Connect With Me")
                        .font(.title3)
                        .fontWeight(.semibold)

                    HStack(spacing: 16) {
                        SocialButton(
                            icon: "envelope.fill",
                            title: "Email",
                            url: "mailto:muhammad.azri.f.s@gmail.com"
                        )
                        SocialButton(
                            icon: "link",
                            title: "GitHub",
                            url: "https://github.com/muhAzri"
                        )
                        SocialButton(
                            icon: "person.crop.rectangle.fill",
                            title: "LinkedIn",
                            url: "https://www.linkedin.com/in/muh-azri/"
                        )
                    }
                }
                .padding(.horizontal)

                Text("Made with ❤️ using SwiftUI")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)

                Spacer(minLength: 20)
            }
            .padding(.vertical)
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview("About Dev View") {
    NavigationView {
        AboutDevView()
    }
}
