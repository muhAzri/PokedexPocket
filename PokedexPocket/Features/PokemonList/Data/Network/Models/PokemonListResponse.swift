//
//  PokemonListResponse.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation

struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonListItemResponse]
}

struct PokemonListItemResponse: Codable {
    let name: String
    let url: String
}

extension PokemonListResponse {
    func toDomain() -> PokemonList {
        PokemonList(
            count: count,
            next: next,
            previous: previous,
            results: results.map { $0.toDomain() }
        )
    }
}

extension PokemonListItemResponse {
    func toDomain() -> PokemonListItem {
        PokemonListItem(name: name, url: url)
    }
}