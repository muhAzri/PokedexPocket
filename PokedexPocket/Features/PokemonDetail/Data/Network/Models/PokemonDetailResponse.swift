//
//  PokemonDetailResponse.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation

struct PokemonDetailResponse: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let baseExperience: Int?
    let order: Int?
    let types: [PokemonTypeSlot]
    let stats: [PokemonStatResponse]
    let abilities: [PokemonAbilitySlot]
    let sprites: PokemonSprites
    let moves: [PokemonMoveSlot]
    let cries: PokemonCries?
    let species: PokemonSpecies
    
    enum CodingKeys: String, CodingKey {
        case id, name, height, weight, types, stats, abilities, sprites, moves, species
        case baseExperience = "base_experience"
        case order
        case cries
    }
}

struct PokemonTypeSlot: Codable {
    let slot: Int
    let type: PokemonTypeInfo
}

struct PokemonTypeInfo: Codable {
    let name: String
    let url: String
}

struct PokemonAbilitySlot: Codable {
    let ability: PokemonAbilityInfo
    let isHidden: Bool
    let slot: Int
    
    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

struct PokemonAbilityInfo: Codable {
    let name: String
    let url: String
}

struct PokemonMoveSlot: Codable {
    let move: PokemonMoveInfo
    let versionGroupDetails: [PokemonMoveVersionGroup]
    
    enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
}

struct PokemonMoveInfo: Codable {
    let name: String
    let url: String
}

struct PokemonMoveVersionGroup: Codable {
    let levelLearnedAt: Int
    let moveLearnMethod: PokemonMoveLearnMethod
    let versionGroup: PokemonVersionGroup
    
    enum CodingKeys: String, CodingKey {
        case levelLearnedAt = "level_learned_at"
        case moveLearnMethod = "move_learn_method"
        case versionGroup = "version_group"
    }
}

struct PokemonMoveLearnMethod: Codable {
    let name: String
    let url: String
}

struct PokemonVersionGroup: Codable {
    let name: String
    let url: String
}

struct PokemonCries: Codable {
    let latest: String?
    let legacy: String?
}

struct PokemonSpecies: Codable {
    let name: String
    let url: String
}

struct PokemonStatResponse: Codable {
    let baseStat: Int
    let effort: Int
    let stat: PokemonStatInfo
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
    }
}

struct PokemonStatInfo: Codable {
    let name: String
    let url: String
}

struct PokemonSprites: Codable {
    let backDefault: String?
    let backFemale: String?
    let backShiny: String?
    let backShinyFemale: String?
    let frontDefault: String?
    let frontFemale: String?
    let frontShiny: String?
    let frontShinyFemale: String?
    let other: PokemonOtherSprites?
    let versions: PokemonVersionSprites?
    
    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
        case other, versions
    }
}

struct PokemonOtherSprites: Codable {
    let dreamWorld: PokemonDreamWorldSprites?
    let home: PokemonHomeSprites?
    let officialArtwork: PokemonOfficialArtwork?
    
    enum CodingKeys: String, CodingKey {
        case dreamWorld = "dream_world"
        case home
        case officialArtwork = "official-artwork"
    }
}

struct PokemonDreamWorldSprites: Codable {
    let frontDefault: String?
    let frontFemale: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontFemale = "front_female"
    }
}

struct PokemonHomeSprites: Codable {
    let frontDefault: String?
    let frontFemale: String?
    let frontShiny: String?
    let frontShinyFemale: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
    }
}

struct PokemonOfficialArtwork: Codable {
    let frontDefault: String?
    let frontShiny: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}


struct PokemonVersionSprites: Codable {
    // Version-specific sprites - can be empty for now
}

extension PokemonDetailResponse {
    func toDomain() -> PokemonDetail {
        let imageURL = sprites.other?.officialArtwork?.frontDefault ?? sprites.frontDefault ?? ""
        let pokemonTypes = types.map { PokemonType(name: $0.type.name) }
        let pokemonStats = stats.map { PokemonStat(name: $0.stat.name, value: $0.baseStat) }
        let pokemonAbilities = abilities.map { PokemonAbility(name: $0.ability.name, isHidden: $0.isHidden) }
        let pokemonMoves = moves.map { PokemonMove(name: $0.move.name, learnMethod: $0.versionGroupDetails.first?.moveLearnMethod.name ?? "unknown", level: $0.versionGroupDetails.first?.levelLearnedAt ?? 0) }
        
        return PokemonDetail(
            id: id,
            name: name,
            height: height,
            weight: weight,
            baseExperience: baseExperience ?? 0,
            order: order,
            types: pokemonTypes,
            stats: pokemonStats,
            abilities: pokemonAbilities,
            moves: pokemonMoves,
            imageURL: imageURL,
            sprites: PokemonDetailSprites(
                frontDefault: sprites.frontDefault,
                frontShiny: sprites.frontShiny,
                backDefault: sprites.backDefault,
                backShiny: sprites.backShiny,
                officialArtwork: sprites.other?.officialArtwork?.frontDefault,
                officialArtworkShiny: sprites.other?.officialArtwork?.frontShiny,
                dreamWorld: sprites.other?.dreamWorld?.frontDefault,
                home: sprites.other?.home?.frontDefault,
                homeShiny: sprites.other?.home?.frontShiny
            ),
            cries: cries != nil ? PokemonDetailCries(latest: cries?.latest, legacy: cries?.legacy) : nil,
            species: species.name
        )
    }
}