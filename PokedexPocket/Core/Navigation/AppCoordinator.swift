//
//  AppCoordinator.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import SwiftUI
import Combine

enum AppDestination: Hashable {
    case pokemonList
    case pokemonDetail(pokemonId: Int, pokemonName: String)
    case favouritePokemon
    case aboutDev
}

@MainActor
class AppCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var favouritesNavigationPath = NavigationPath()
    @Published var aboutNavigationPath = NavigationPath()
    @Published var selectedTab: AppTab = .home

    private var currentNavigationPath: NavigationPath {
        get {
            switch selectedTab {
            case .home:
                return navigationPath
            case .favourites:
                return favouritesNavigationPath
            case .about:
                return aboutNavigationPath
            }
        }
        set {
            switch selectedTab {
            case .home:
                navigationPath = newValue
            case .favourites:
                favouritesNavigationPath = newValue
            case .about:
                aboutNavigationPath = newValue
            }
        }
    }

    func navigate(to destination: AppDestination) {
        switch selectedTab {
        case .home:
            navigationPath.append(destination)
        case .favourites:
            favouritesNavigationPath.append(destination)
        case .about:
            aboutNavigationPath.append(destination)
        }
    }

    func navigateBack() {
        switch selectedTab {
        case .home:
            if !navigationPath.isEmpty {
                navigationPath.removeLast()
            }
        case .favourites:
            if !favouritesNavigationPath.isEmpty {
                favouritesNavigationPath.removeLast()
            }
        case .about:
            if !aboutNavigationPath.isEmpty {
                aboutNavigationPath.removeLast()
            }
        }
    }

    func navigateToRoot() {
        switch selectedTab {
        case .home:
            navigationPath.removeLast(navigationPath.count)
        case .favourites:
            favouritesNavigationPath.removeLast(favouritesNavigationPath.count)
        case .about:
            aboutNavigationPath.removeLast(aboutNavigationPath.count)
        }
    }

    func switchTab(to tab: AppTab) {
        selectedTab = tab
    }

    func navigateToPokemonDetail(pokemonId: Int, pokemonName: String) {
        navigate(to: .pokemonDetail(pokemonId: pokemonId, pokemonName: pokemonName))
    }
}

enum AppTab: CaseIterable {
    case home
    case favourites
    case about

    var title: String {
        switch self {
        case .home:
            return "Pokémon"
        case .favourites:
            return "Favourites"
        case .about:
            return "About"
        }
    }

    var icon: String {
        switch self {
        case .home:
            return "house"
        case .favourites:
            return "heart"
        case .about:
            return "info.circle"
        }
    }
}
