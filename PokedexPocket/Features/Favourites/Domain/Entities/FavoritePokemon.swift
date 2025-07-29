//
//  FavoritePokemon.swift
//  PokedexPocket
//
//  Created by Azri on 29/07/25.
//

import Foundation

struct FavoritePokemon: Identifiable, Equatable {
    let id: Int
    let name: String
    let primaryType: String
    let imageURL: String
    let dateAdded: Date

    var formattedName: String {
        name.capitalized
    }

    var pokemonNumber: String {
        String(format: "#%03d", id)
    }

    init(
        id: Int,
        name: String,
        primaryType: String,
        imageURL: String,
        dateAdded: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.primaryType = primaryType
        self.imageURL = imageURL
        self.dateAdded = dateAdded
    }

    static func == (lhs: FavoritePokemon, rhs: FavoritePokemon) -> Bool {
        return lhs.id == rhs.id
    }
}