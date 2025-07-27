//
//  FavouritePokemon.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import SwiftData
import Foundation

@Model
final class FavouritePokemon {
    @Attribute(.unique) var pokemonId: Int
    var name: String
    var primaryType: String
    var imageURL: String
    var dateAdded: Date
    
    init(pokemonId: Int, name: String, primaryType: String, imageURL: String) {
        self.pokemonId = pokemonId
        self.name = name
        self.primaryType = primaryType
        self.imageURL = imageURL
        self.dateAdded = Date()
    }
}