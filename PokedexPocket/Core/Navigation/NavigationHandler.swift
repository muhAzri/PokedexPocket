//
//  NavigationHandler.swift
//  PokedexPocket
//
//  Created by Azri on 29/07/25.
//

import SwiftUI

@MainActor
protocol NavigationHandler: AnyObject {
    func navigateToPokemonDetail(pokemonId: Int, pokemonName: String)
    func navigateBack()
    func navigateToRoot()
}

struct NavigationHandlerKey: EnvironmentKey {
    static let defaultValue: NavigationHandler? = nil
}

extension EnvironmentValues {
    var navigationHandler: NavigationHandler? {
        get { self[NavigationHandlerKey.self] }
        set { self[NavigationHandlerKey.self] = newValue }
    }
}
