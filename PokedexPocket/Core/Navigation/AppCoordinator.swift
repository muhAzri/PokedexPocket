import SwiftUI
import Combine

enum AppDestination: Hashable {
    case pokemonList
    case pokemonDetail(pokemonId: Int)
    case favouritePokemon
    case aboutDev
}

@MainActor
class AppCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var selectedTab: AppTab = .home
    
    func navigate(to destination: AppDestination) {
        navigationPath.append(destination)
    }
    
    func navigateBack() {
        navigationPath.removeLast()
    }
    
    func navigateToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    func switchTab(to tab: AppTab) {
        selectedTab = tab
        navigateToRoot()
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