//
//  FavoritePokemonMapper.swift
//  PokedexPocket
//
//  Created by Azri on 29/07/25.
//

import Foundation
import PokedexPocketPokemon

struct FavoritePokemonMapper {
    static func toDomain(_ dataModel: FavouritePokemonDataModel) -> FavoritePokemon {
        return FavoritePokemon(
            id: dataModel.pokemonId,
            name: dataModel.name,
            primaryType: dataModel.primaryType,
            imageURL: dataModel.imageURL,
            dateAdded: dataModel.dateAdded
        )
    }

    static func toDataModel(_ domainEntity: FavoritePokemon) -> FavouritePokemonDataModel {
        return FavouritePokemonDataModel(
            pokemonId: domainEntity.id,
            name: domainEntity.name,
            primaryType: domainEntity.primaryType,
            imageURL: domainEntity.imageURL,
            dateAdded: domainEntity.dateAdded
        )
    }

    static func toDataModel(from pokemon: PokemonDetail) -> FavouritePokemonDataModel {
        return FavouritePokemonDataModel(
            pokemonId: pokemon.id,
            name: pokemon.name,
            primaryType: pokemon.types.first?.name ?? "Unknown",
            imageURL: pokemon.sprites.bestQualityImage,
            dateAdded: Date()
        )
    }
}
