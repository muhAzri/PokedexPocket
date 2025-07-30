//
//  PokemonList.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation

struct PokemonList: Codable, Equatable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonListItem]

    var hasNext: Bool {
        next != nil
    }

    var hasPrevious: Bool {
        previous != nil
    }
}

struct PokemonListItem: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let url: String

    init(name: String, url: String) {
        self.id = name
        self.name = name
        self.url = url
    }

    // Computed properties below will be ignored during encoding/decoding
    var pokemonId: Int {
        guard let urlComponents = URLComponents(string: url),
              let pathComponents = urlComponents.path.split(separator: "/").last,
              let id = Int(pathComponents) else {
            return 0
        }
        return id
    }

    var imageURL: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/" +
            "other/official-artwork/\(pokemonId).png"
    }

    var formattedName: String {
        name.capitalized
    }

    var pokemonNumber: String {
        String(format: "#%03d", pokemonId)
    }
}
