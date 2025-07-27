import SwiftUI

struct AppRouter: View {
    @StateObject private var coordinator = AppCoordinator()
    
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
    }
    
    @ViewBuilder
    private func destinationView(for destination: AppDestination) -> some View {
        switch destination {
        case .pokemonList:
            PokemonListView()
        case .pokemonDetail(let pokemonId):
            PokemonDetailView(pokemonId: pokemonId)
        case .favouritePokemon:
            FavouritePokemonView()
        case .aboutDev:
            AboutDevView()
        }
    }
}