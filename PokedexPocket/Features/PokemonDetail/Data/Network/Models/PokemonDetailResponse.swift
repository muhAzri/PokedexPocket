import Foundation

struct PokemonDetailResponse: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonTypeSlot]
    let stats: [PokemonStatResponse]
    let sprites: PokemonSprites
}

struct PokemonTypeSlot: Codable {
    let slot: Int
    let type: PokemonTypeInfo
}

struct PokemonTypeInfo: Codable {
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
    let frontDefault: String?
    let other: PokemonOtherSprites?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
    }
}

struct PokemonOtherSprites: Codable {
    let officialArtwork: PokemonOfficialArtwork?
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct PokemonOfficialArtwork: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

extension PokemonDetailResponse {
    func toDomain() -> PokemonDetail {
        let imageURL = sprites.other?.officialArtwork?.frontDefault ?? sprites.frontDefault ?? ""
        let pokemonTypes = types.map { PokemonType(name: $0.type.name) }
        let pokemonStats = stats.map { PokemonStat(name: $0.stat.name, value: $0.baseStat) }
        
        return PokemonDetail(
            id: id,
            name: name,
            height: height,
            weight: weight,
            baseExperience: 0,
            types: pokemonTypes,
            stats: pokemonStats,
            abilities: [],
            imageURL: imageURL
        )
    }
}