//
//  AppRouter.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import SwiftUI

struct AppRouter: View {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var viewModelFactory = DefaultViewModelFactory()

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack(path: $coordinator.navigationPath) {
                PokemonListView()
                    .navigationDestination(for: AppDestination.self) { destination in
                        destinationView(for: destination)
                            .toolbar(.hidden, for: .tabBar)
                    }
            }
            .tabItem {
                Image(systemName: AppTab.home.icon)
                Text(AppTab.home.title)
            }
            .tag(AppTab.home)

            NavigationStack(path: $coordinator.favouritesNavigationPath) {
                FavouritePokemonView()
                    .navigationDestination(for: AppDestination.self) { destination in
                        destinationView(for: destination)
                            .toolbar(.hidden, for: .tabBar)
                    }
            }
            .tabItem {
                Image(systemName: AppTab.favourites.icon)
                Text(AppTab.favourites.title)
            }
            .tag(AppTab.favourites)

            NavigationStack(path: $coordinator.aboutNavigationPath) {
                AboutDevView()
                    .navigationDestination(for: AppDestination.self) { destination in
                        destinationView(for: destination)
                            .toolbar(.hidden, for: .tabBar)
                    }
            }
            .tabItem {
                Image(systemName: AppTab.about.icon)
                Text(AppTab.about.title)
            }
            .tag(AppTab.about)
        }
        .environmentObject(coordinator)
        .environmentObject(viewModelFactory)
    }

    @ViewBuilder
    private func destinationView(for destination: AppDestination) -> some View {
        switch destination {
        case .pokemonList:
            PokemonListView()
        case .pokemonDetail(let pokemonId, let pokemonName):
            PokemonDetailView(
                pokemonId: pokemonId,
                pokemonName: pokemonName,
                viewModel: viewModelFactory.makePokemonDetailViewModel(pokemonId: pokemonId)
            )
        case .favouritePokemon:
            FavouritePokemonView()
        case .aboutDev:
            AboutDevView()
        }
    }
}
