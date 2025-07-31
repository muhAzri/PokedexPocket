//
//  AppRouter.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import SwiftUI
import PokedexPocketPokemon

struct AppRouter: View {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var viewModelFactory = DefaultViewModelFactory()

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack(path: $coordinator.navigationPath) {
                PokedexPocketPokemon.PokemonListView(
                    viewModel: viewModelFactory.makePokemonListViewModel(),
                    onPokemonTap: { pokemonId, pokemonName in
                        coordinator.navigateToPokemonDetail(pokemonId: pokemonId, pokemonName: pokemonName)
                    }
                )
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
        .environment(\.navigationHandler, coordinator)
    }

    @ViewBuilder
    private func destinationView(for destination: AppDestination) -> some View {
        switch destination {
        case .pokemonList:
            PokedexPocketPokemon.PokemonListView(
                viewModel: viewModelFactory.makePokemonListViewModel(),
                onPokemonTap: { pokemonId, pokemonName in
                    coordinator.navigateToPokemonDetail(pokemonId: pokemonId, pokemonName: pokemonName)
                }
            )
        case .pokemonDetail(let pokemonId, let pokemonName):
            PokedexPocketPokemon.PokemonDetailView(
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
