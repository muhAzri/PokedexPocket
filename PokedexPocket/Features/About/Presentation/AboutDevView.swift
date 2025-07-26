import SwiftUI

struct AboutDevView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.blue, Color.purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text("AZ")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                    
                    VStack(spacing: 4) {
                        Text("Azri")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("iOS Developer")
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
                    
                    Text("Passionate iOS developer who loves creating beautiful and functional mobile applications. This Pokédex app showcases clean architecture principles and modern SwiftUI development practices.")
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
                        SkillBadge(skill: "UIKit", color: .orange)
                        SkillBadge(skill: "Combine", color: .green)
                        SkillBadge(skill: "Core Data", color: .purple)
                        SkillBadge(skill: "REST APIs", color: .red)
                        SkillBadge(skill: "MVVM", color: .cyan)
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
                        FeatureRow(icon: "list.bullet", title: "Browse Pokémon", description: "Explore a comprehensive list of Pokémon")
                        FeatureRow(icon: "info.circle", title: "Detailed Info", description: "View stats, types, and descriptions")
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

struct SocialButton: View {
    let icon: String
    let title: String
    let url: String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }) {
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
        .accessibilityLabel("\(title) - Opens \(title.lowercased()) app or website")
        .accessibilityHint("Double tap to open \(title.lowercased())")
        .accessibilityAddTraits(.isButton)
    }
}