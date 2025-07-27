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
        // Configure URLCache for better image caching
        let cache = URLCache(
            memoryCapacity: 50 * 1024 * 1024, // 50 MB memory
            diskCapacity: 200 * 1024 * 1024,  // 200 MB disk
            diskPath: "image_cache"
        )
        URLCache.shared = cache
    }
}
