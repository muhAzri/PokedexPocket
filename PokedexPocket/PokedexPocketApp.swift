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
                .modelContainer(for: FavouritePokemon.self)
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
}
