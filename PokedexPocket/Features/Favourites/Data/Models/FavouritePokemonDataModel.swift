//
//  FavouritePokemonDataModel.swift
//  PokedexPocket
//
//  Created by Azri on 29/07/25.
//

import SwiftData
import Foundation

@Model
final class FavouritePokemonDataModel {
    @Attribute(.unique) var pokemonId: Int
    var name: String
    var primaryType: String
    var imageURL: String
    var dateAdded: Date

    init(pokemonId: Int, name: String, primaryType: String, imageURL: String, dateAdded: Date = Date()) {
        self.pokemonId = pokemonId
        self.name = name
        self.primaryType = primaryType
        self.imageURL = imageURL
        self.dateAdded = dateAdded
    }
}
