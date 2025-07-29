//
//  PokedexPocketApp.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import SwiftUI
import SwiftData

@main
struct PokedexPocketApp: App {

    init() {
        configureImageCache()
    }

    var body: some Scene {
        WindowGroup {
            AppRouter()
                .modelContainer(for: FavouritePokemonDataModel.self)
                .onAppear {
                    setupModelContext()
                }
        }
    }

    private func configureImageCache() {
        let cache = URLCache(
            memoryCapacity: 50 * 1024 * 1024,
            diskCapacity: 200 * 1024 * 1024,
            diskPath: "image_cache"
        )
        URLCache.shared = cache
    }

    private func setupModelContext() {
        do {
            let container = try ModelContainer(for: FavouritePokemonDataModel.self)
            let context = ModelContext(container)
            DIContainer.shared.setModelContext(context)
        } catch {
            print("Failed to create ModelContext: \(error)")
        }
    }
}
