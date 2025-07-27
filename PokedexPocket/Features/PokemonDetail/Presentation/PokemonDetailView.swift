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
    let pokemonId: Int
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

    init(pokemonId: Int, pokemonName: String, getPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol) {
        self.pokemonId = pokemonId
        self.pokemonName = pokemonName
        self._viewModel = StateObject(
            wrappedValue: PokemonDetailViewModel(
                pokemonId: pokemonId,
                getPokemonDetailUseCase: getPokemonDetailUseCase
            )
        )
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

    // MARK: - Header Section Components

    private func headerSection(pokemon: PokemonDetail, geometry: GeometryProxy) -> some View {
        PokemonDetailHeaderSection(
            pokemon: pokemon,
            geometry: geometry,
            selectedSpriteStyle: $selectedSpriteStyle,
            isShinyVariant: $isShinyVariant,
            isFrontView: $isFrontView,
            rotationAngle: $rotationAngle,
            spriteScale: $spriteScale,
            isFavourite: $isFavourite,
            heartScale: $heartScale,
            heartRotation: $heartRotation,
            showHeartBurst: $showHeartBurst,
            onToggleFavourite: { toggleFavourite(pokemon: pokemon) },
            onSpriteAppear: {
                spriteScale = 1.05
                startSpriteAnimation()
            },
            onSpriteDisappear: {
                stopSpriteAnimation()
            }
        )
    }

    private func contentSection(pokemon: PokemonDetail) -> some View {
        PokemonDetailContentSection(pokemon: pokemon, selectedTab: $selectedTab)
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
            pokemonId: 25,
            pokemonName: "pikachu",
            getPokemonDetailUseCase: DIContainer.shared.resolve(GetPokemonDetailUseCaseProtocol.self)
        )
        .environmentObject(AppCoordinator())
        .modelContainer(for: FavouritePokemon.self, inMemory: true)
    }
}
