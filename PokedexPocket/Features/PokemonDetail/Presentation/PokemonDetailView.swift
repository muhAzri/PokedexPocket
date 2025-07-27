//
//  PokemonDetailView.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import SwiftUI
import SwiftData
import RxSwift
import Combine

struct PokemonDetailView: View {
    let pokemonName: String
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: PokemonDetailViewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var favourites: [FavouritePokemon]
    @State private var isFavourite = false
    @State private var selectedSpriteStyle: SpriteStyle = .officialArtwork
    @State private var isShinyVariant = false
    @State private var selectedTab: DetailTab = .about
    @State private var currentSpriteIndex = 0
    @State private var isRotating = false
    @State private var rotationAngle: Double = 0
    @State private var isFrontView = true
    @State private var spriteScale: CGFloat = 1.0
    @State private var animationTimer: Timer?
    @State private var heartScale: CGFloat = 1.0
    @State private var heartRotation: Double = 0
    @State private var showHeartBurst = false
    
    enum SpriteStyle: String, CaseIterable {
        case officialArtwork = "Official Artwork"
        case homeStyle = "Home Style"
        case gameSprites = "Game Sprites"
        
        var supportsBackView: Bool {
            return self == .gameSprites
        }
        
        var description: String {
            switch self {
            case .officialArtwork:
                return "High-quality official artwork"
            case .homeStyle:
                return "Pokemon Home style sprites"
            case .gameSprites:
                return "Classic pixelated game sprites"
            }
        }
    }
    
    enum DetailTab: String, CaseIterable {
        case about = "About"
        case stats = "Stats"
        case moves = "Moves"
        case abilities = "Abilities"
    }
    
    init(pokemonName: String, getPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol) {
        self.pokemonName = pokemonName
        self._viewModel = StateObject(wrappedValue: PokemonDetailViewModel(pokemonName: pokemonName, getPokemonDetailUseCase: getPokemonDetailUseCase))
    }
    
    var body: some View {
        ZStack {
            if let pokemon = viewModel.pokemon {
                GeometryReader { geometry in
                    ScrollView {
                        VStack(spacing: 0) {
                            headerSection(pokemon: pokemon, geometry: geometry)
                            contentSection(pokemon: pokemon)
                        }
                    }
                }
                .background(primaryTypeColor(pokemon: pokemon).opacity(0.1))
            } else if viewModel.isLoading {
                PokemonDetailSkeletonView()
            } else if let error = viewModel.error {
                errorView(error: error)
            }
        }
        .navigationTitle(pokemonName.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadPokemonDetail()
            updateFavouriteStatus()
        }
        .onChange(of: viewModel.pokemon) { _, newPokemon in
            if newPokemon != nil {
                updateFavouriteStatus()
            }
        }
    }
    
    private func headerSection(pokemon: PokemonDetail, geometry: GeometryProxy) -> some View {
        VStack(spacing: 16) {
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
                
                Button(action: {
                    toggleFavourite(pokemon: pokemon)
                }) {
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
                                    .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.05), value: showHeartBurst)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 12) {
                ForEach(pokemon.types) { type in
                    TypeBadge(type: type.name, color: Color(hex: type.color))
                }
                Spacer()
            }
            .padding(.horizontal)
            
            ZStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [primaryTypeColor(pokemon: pokemon).opacity(0.2 - Double(index) * 0.05), primaryTypeColor(pokemon: pokemon).opacity(0.05)],
                                center: .center,
                                startRadius: 50,
                                endRadius: 150
                            )
                        )
                        .frame(width: CGFloat(280 + index * 40), height: CGFloat(280 + index * 40))
                        .scaleEffect(spriteScale)
                        .rotationEffect(.degrees(Double(index) * 120 + rotationAngle * 0.1))
                        .animation(.easeInOut(duration: 2.0 + Double(index) * 0.5).repeatForever(autoreverses: true), value: spriteScale)
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
            .onAppear {
                spriteScale = 1.05
                startSpriteAnimation()
            }
            .onDisappear {
                stopSpriteAnimation()
            }
            
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
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                isFrontView.toggle()
                                rotationAngle += 180
                            }
                        }) {
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
                        .frame(maxWidth: .infinity)
                    }
                }
                
                Text(selectedSpriteStyle.description + (selectedSpriteStyle.supportsBackView ? " • Tap to flip" : ""))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
    
    private func contentSection(pokemon: PokemonDetail) -> some View {
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
                aboutSection(pokemon: pokemon)
            case .stats:
                statsSection(pokemon: pokemon)
            case .moves:
                movesSection(pokemon: pokemon)
            case .abilities:
                abilitiesSection(pokemon: pokemon)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(30, corners: [.topLeft, .topRight])
    }
    
    private func aboutSection(pokemon: PokemonDetail) -> some View {
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
    
    private func statsSection(pokemon: PokemonDetail) -> some View {
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
    
    private func movesSection(pokemon: PokemonDetail) -> some View {
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
    
    private func abilitiesSection(pokemon: PokemonDetail) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(pokemon.abilities) { ability in
                AbilityRow(ability: ability)
            }
            
            Spacer(minLength: 40)
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading \(pokemonName.capitalized)...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
    
    private func errorView(error: Error) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Oops! Something went wrong")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                viewModel.loadPokemonDetail()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func primaryTypeColor(pokemon: PokemonDetail) -> Color {
        guard let firstType = pokemon.types.first else { return Color.gray }
        return Color(hex: firstType.color)
    }
    
    private func startSpriteAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                if currentSpriteIndex < 3 {
                    currentSpriteIndex += 1
                } else {
                    currentSpriteIndex = 0
                }
            }
        }
    }
    
    private func stopSpriteAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    private func updateFavouriteStatus() {
        guard let pokemon = viewModel.pokemon else { return }
        isFavourite = favourites.contains { $0.pokemonId == pokemon.id }
    }
    
    private func toggleFavourite(pokemon: PokemonDetail) {
        if isFavourite {
            removeFavourite(pokemon: pokemon)
        } else {
            addFavourite(pokemon: pokemon)
        }
    }
    
    private func addFavourite(pokemon: PokemonDetail) {
        let favourite = FavouritePokemon(
            pokemonId: pokemon.id,
            name: pokemon.name,
            primaryType: pokemon.types.first?.name ?? "Unknown",
            imageURL: pokemon.sprites.bestQualityImage
        )
        
        modelContext.insert(favourite)
        
        do {
            try modelContext.save()
            
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                heartScale = 1.4
                heartRotation = 360
            }
            
            withAnimation(.easeOut(duration: 0.6)) {
                showHeartBurst = true
            }
            
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                isFavourite = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    heartScale = 1.2
                    heartRotation = 0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                showHeartBurst = false
            }
        } catch {
            print("Failed to save favourite: \(error)")
        }
    }
    
    private func removeFavourite(pokemon: PokemonDetail) {
        if let favouriteToRemove = favourites.first(where: { $0.pokemonId == pokemon.id }) {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            withAnimation(.easeInOut(duration: 0.2)) {
                heartScale = 0.8
                heartRotation = -15
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                modelContext.delete(favouriteToRemove)
                
                do {
                    try modelContext.save()
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        isFavourite = false
                        heartScale = 1.0
                        heartRotation = 0
                    }
                } catch {
                    print("Failed to remove favourite: \(error)")
                }
            }
        }
    }
}



#Preview("Pokemon Detail View") {
    NavigationView {
        PokemonDetailView(
            pokemonName: "pikachu",
            getPokemonDetailUseCase: DIContainer.shared.resolve(GetPokemonDetailUseCaseProtocol.self)
        )
        .environmentObject(AppCoordinator())
        .modelContainer(for: FavouritePokemon.self, inMemory: true)
    }
}
