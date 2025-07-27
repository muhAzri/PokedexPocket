//
//  PokemonDetail.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation

struct PokemonDetail: Identifiable, Equatable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let baseExperience: Int
    let order: Int?
    let types: [PokemonType]
    let stats: [PokemonStat]
    let abilities: [PokemonAbility]
    let moves: [PokemonMove]
    let imageURL: String
    let sprites: PokemonDetailSprites
    let cries: PokemonDetailCries?
    let species: String

    var formattedName: String {
        name.capitalized
    }

    var pokemonNumber: String {
        String(format: "#%03d", id)
    }

    var heightInMeters: Double {
        Double(height) / 10.0
    }

    var weightInKilograms: Double {
        Double(weight) / 10.0
    }

    init(id: Int, name: String, height: Int, weight: Int, baseExperience: Int, order: Int? = nil, types: [PokemonType], stats: [PokemonStat], abilities: [PokemonAbility], moves: [PokemonMove] = [], imageURL: String, sprites: PokemonDetailSprites, cries: PokemonDetailCries? = nil, species: String) {
        self.id = id
        self.name = name
        self.height = height
        self.weight = weight
        self.baseExperience = baseExperience
        self.order = order
        self.types = types
        self.stats = stats
        self.abilities = abilities
        self.moves = moves
        self.imageURL = imageURL
        self.sprites = sprites
        self.cries = cries
        self.species = species
    }

    static func == (lhs: PokemonDetail, rhs: PokemonDetail) -> Bool {
        return lhs.id == rhs.id
    }
}

struct PokemonAbility: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let isHidden: Bool

    init(name: String, isHidden: Bool = false) {
        self.id = name
        self.name = name
        self.isHidden = isHidden
    }

    var formattedName: String {
        name.replacingOccurrences(of: "-", with: " ").capitalized
    }
}

struct PokemonMove: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let learnMethod: String
    let level: Int

    init(name: String, learnMethod: String, level: Int) {
        self.id = name
        self.name = name
        self.learnMethod = learnMethod
        self.level = level
    }

    var formattedName: String {
        name.replacingOccurrences(of: "-", with: " ").capitalized
    }

    var formattedLearnMethod: String {
        switch learnMethod {
        case "level-up":
            return "Level \(level)"
        case "machine":
            return "TM/TR"
        case "egg":
            return "Egg Move"
        case "tutor":
            return "Move Tutor"
        default:
            return learnMethod.capitalized
        }
    }
}

struct PokemonDetailSprites: Equatable, Codable {
    let frontDefault: String?
    let frontShiny: String?
    let backDefault: String?
    let backShiny: String?
    let officialArtwork: String?
    let officialArtworkShiny: String?
    let dreamWorld: String?
    let home: String?
    let homeShiny: String?

    var bestQualityImage: String {
        return officialArtwork ?? home ?? dreamWorld ?? frontDefault ?? ""
    }

    var bestQualityShinyImage: String {
        return officialArtworkShiny ?? homeShiny ?? frontShiny ?? bestQualityImage
    }

    var bestQualityBackImage: String {
        return backDefault ?? frontDefault ?? ""
    }

    var bestQualityBackShinyImage: String {
        return backShiny ?? frontShiny ?? bestQualityBackImage
    }

    var allSprites: [String] {
        return [bestQualityImage, bestQualityShinyImage, bestQualityBackImage, bestQualityBackShinyImage]
            .compactMap { $0.isEmpty ? nil : $0 }
    }

    func getCurrentSprite(isShiny: Bool, isFront: Bool) -> String {
        switch (isShiny, isFront) {
        case (false, true):
            return bestQualityImage
        case (true, true):
            return bestQualityShinyImage
        case (false, false):
            return bestQualityBackImage
        case (true, false):
            return bestQualityBackShinyImage
        }
    }

    func getSpriteForStyle(_ style: String, isShiny: Bool, isFront: Bool) -> String {
        switch style {
        case "Official Artwork":
            if isShiny {
                return officialArtworkShiny ?? officialArtwork ?? bestQualityShinyImage
            } else {
                return officialArtwork ?? bestQualityImage
            }
        case "Home Style":
            if isShiny {
                return homeShiny ?? home ?? bestQualityShinyImage
            } else {
                return home ?? bestQualityImage
            }
        case "Game Sprites":
            switch (isShiny, isFront) {
            case (false, true):
                return frontDefault ?? bestQualityImage
            case (true, true):
                return frontShiny ?? frontDefault ?? bestQualityShinyImage
            case (false, false):
                return backDefault ?? frontDefault ?? bestQualityImage
            case (true, false):
                return backShiny ?? backDefault ?? frontShiny ?? bestQualityBackShinyImage
            }
        default:
            return bestQualityImage
        }
    }
}

struct PokemonDetailCries: Equatable, Codable {
    let latest: String?
    let legacy: String?

    var primaryCry: String? {
        return latest ?? legacy
    }
}
