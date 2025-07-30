//
//  TestData.swift
//  PokedexPocketTests
//
//  Created by Azri on 30/07/25.
//

import Foundation
@testable import PokedexPocket

struct TestData {
    // MARK: - Constants
    private static let baseSpritesURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon"
    private static let officialArtworkURL = "\(baseSpritesURL)/other/official-artwork"
    private static let criesURL = "https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon"
    private static let apiBaseURL = "https://pokeapi.co/api/v2"
    // MARK: - Pokemon Detail Test Data
    static let pikachu = PokemonDetail(
        id: 25,
        name: "pikachu",
        height: 4,
        weight: 60,
        baseExperience: 112,
        order: 35,
        types: [
            PokemonType(name: "electric")
        ],
        stats: [
            PokemonStat(name: "hp", value: 35),
            PokemonStat(name: "attack", value: 55),
            PokemonStat(name: "defense", value: 40),
            PokemonStat(name: "special-attack", value: 50),
            PokemonStat(name: "special-defense", value: 50),
            PokemonStat(name: "speed", value: 90)
        ],
        abilities: [
            PokemonAbility(name: "static", isHidden: false),
            PokemonAbility(name: "lightning-rod", isHidden: true)
        ],
        moves: [
            PokemonMove(name: "thunder-shock", learnMethod: "level-up", level: 1),
            PokemonMove(name: "thunder-bolt", learnMethod: "machine", level: 0)
        ],
        imageURL: "\(officialArtworkURL)/25.png",
        sprites: PokemonDetailSprites(
            frontDefault: "\(baseSpritesURL)/25.png",
            frontShiny: "\(baseSpritesURL)/shiny/25.png",
            backDefault: "\(baseSpritesURL)/back/25.png",
            backShiny: "\(baseSpritesURL)/back/shiny/25.png",
            officialArtwork: "\(officialArtworkURL)/25.png",
            officialArtworkShiny: "\(officialArtworkURL)/shiny/25.png",
            dreamWorld: "\(baseSpritesURL)/other/dream-world/25.svg",
            home: "\(baseSpritesURL)/other/home/25.png",
            homeShiny: "\(baseSpritesURL)/other/home/shiny/25.png"
        ),
        cries: PokemonDetailCries(
            latest: "\(criesURL)/latest/25.ogg",
            legacy: "\(criesURL)/legacy/25.ogg"
        ),
        species: "mouse"
    )

    static let charizard = PokemonDetail(
        id: 6,
        name: "charizard",
        height: 17,
        weight: 905,
        baseExperience: 267,
        order: 7,
        types: [
            PokemonType(name: "fire"),
            PokemonType(name: "flying")
        ],
        stats: [
            PokemonStat(name: "hp", value: 78),
            PokemonStat(name: "attack", value: 84),
            PokemonStat(name: "defense", value: 78),
            PokemonStat(name: "special-attack", value: 109),
            PokemonStat(name: "special-defense", value: 85),
            PokemonStat(name: "speed", value: 100)
        ],
        abilities: [
            PokemonAbility(name: "blaze", isHidden: false),
            PokemonAbility(name: "solar-power", isHidden: true)
        ],
        moves: [],
        imageURL: "\(officialArtworkURL)/6.png",
        sprites: PokemonDetailSprites(
            frontDefault: "\(baseSpritesURL)/6.png",
            frontShiny: nil,
            backDefault: nil,
            backShiny: nil,
            officialArtwork: "\(officialArtworkURL)/6.png",
            officialArtworkShiny: nil,
            dreamWorld: nil,
            home: nil,
            homeShiny: nil
        ),
        cries: nil,
        species: "lizard"
    )

    // Edge case - minimal data
    static let minimumPokemon = PokemonDetail(
        id: 1,
        name: "",
        height: 0,
        weight: 0,
        baseExperience: 0,
        order: nil,
        types: [],
        stats: [],
        abilities: [],
        moves: [],
        imageURL: "",
        sprites: PokemonDetailSprites(
            frontDefault: nil,
            frontShiny: nil,
            backDefault: nil,
            backShiny: nil,
            officialArtwork: nil,
            officialArtworkShiny: nil,
            dreamWorld: nil,
            home: nil,
            homeShiny: nil
        ),
        cries: nil,
        species: ""
    )

    // MARK: - Pokemon List Test Data
    static let pokemonBulbasaur = Pokemon(
        id: 1,
        name: "bulbasaur",
        url: "https://pokeapi.co/api/v2/pokemon/1/",
        imageURL: "\(officialArtworkURL)/1.png",
        types: [PokemonType(name: "grass"), PokemonType(name: "poison")],
        height: 7,
        weight: 69,
        stats: [PokemonStat(name: "hp", value: 45)]
    )

    static let pokemonIvysaur = Pokemon(
        id: 2,
        name: "ivysaur",
        url: "https://pokeapi.co/api/v2/pokemon/2/",
        imageURL: "\(officialArtworkURL)/2.png",
        types: [PokemonType(name: "grass"), PokemonType(name: "poison")],
        height: 10,
        weight: 130,
        stats: [PokemonStat(name: "hp", value: 60)]
    )

    static let pokemonListItemBulbasaur = PokemonListItem(
        name: "bulbasaur",
        url: "https://pokeapi.co/api/v2/pokemon/1/"
    )

    static let pokemonListItemIvysaur = PokemonListItem(
        name: "ivysaur",
        url: "https://pokeapi.co/api/v2/pokemon/2/"
    )

    static let pokemonList = PokemonList(
        count: 1302,
        next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
        previous: nil,
        results: [pokemonListItemBulbasaur, pokemonListItemIvysaur]
    )

    // MARK: - Favorite Pokemon Test Data
    static let favoritePikachu = FavoritePokemon(
        id: 25,
        name: "pikachu",
        primaryType: "electric",
        imageURL: "\(officialArtworkURL)/25.png",
        dateAdded: Date(timeIntervalSince1970: 1627689600) // Fixed date for testing
    )

    static let favoriteCharizard = FavoritePokemon(
        id: 6,
        name: "charizard",
        primaryType: "fire",
        imageURL: "\(officialArtworkURL)/6.png",
        dateAdded: Date(timeIntervalSince1970: 1627776000) // Fixed date for testing
    )

    // MARK: - Network Response Test Data
    static let pokemonDetailResponse = PokemonDetailResponse(
        id: 25,
        name: "pikachu",
        height: 4,
        weight: 60,
        baseExperience: 112,
        order: 35,
        types: [
            PokemonTypeSlot(
                slot: 1,
                type: PokemonTypeInfo(name: "electric", url: "https://pokeapi.co/api/v2/type/13/")
            )
        ],
        stats: [
            PokemonStatResponse(
                baseStat: 35,
                effort: 0,
                stat: PokemonStatInfo(name: "hp", url: "https://pokeapi.co/api/v2/stat/1/")
            )
        ],
        abilities: [
            PokemonAbilitySlot(
                ability: PokemonAbilityInfo(name: "static", url: "https://pokeapi.co/api/v2/ability/9/"),
                isHidden: false,
                slot: 1
            )
        ],
        sprites: PokemonSprites(
            backDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/25.png",
            backFemale: nil,
            backShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/25.png",
            backShinyFemale: nil,
            frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png",
            frontFemale: nil,
            frontShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/25.png",
            frontShinyFemale: nil,
            other: PokemonOtherSprites(
                dreamWorld: PokemonDreamWorldSprites(frontDefault: "dream.svg", frontFemale: nil),
                home: PokemonHomeSprites(frontDefault: "home.png", frontFemale: nil,
                                         frontShiny: "home_shiny.png", frontShinyFemale: nil),
                officialArtwork: PokemonOfficialArtwork(frontDefault: "artwork.png",
                                                        frontShiny: "artwork_shiny.png")
            ),
            versions: PokemonVersionSprites()
        ),
        moves: [
            PokemonMoveSlot(
                move: PokemonMoveInfo(name: "thunder-shock", url: "\(apiBaseURL)/move/84/"),
                versionGroupDetails: [
                    PokemonMoveVersionGroup(
                        levelLearnedAt: 1,
                        moveLearnMethod: PokemonMoveLearnMethod(name: "level-up",
                                                                url: "\(apiBaseURL)/move-learn-method/1/"),
                        versionGroup: PokemonVersionGroup(name: "red-blue", url: "\(apiBaseURL)/version-group/1/")
                    )
                ]
            )
        ],
        cries: PokemonCries(
            latest: "\(criesURL)/latest/25.ogg",
            legacy: "\(criesURL)/legacy/25.ogg"
        ),
        species: PokemonSpecies(name: "pikachu", url: "\(apiBaseURL)/pokemon-species/25/")
    )

    // MARK: - Network Errors
    static let networkErrors: [NetworkError] = [
        .invalidURL,
        .noData,
        .decodingError(TestError.decodingFailed),
        .networkError(TestError.networkFailed),
        .serverError(404),
        .serverError(500),
        .unknown
    ]
}

// MARK: - Test Error Types
enum TestError: Error, LocalizedError {
    case decodingFailed
    case networkFailed
    case repositoryError
    case useCaseError

    var errorDescription: String? {
        switch self {
        case .decodingFailed:
            return "Decoding failed"
        case .networkFailed:
            return "Network failed"
        case .repositoryError:
            return "Repository error"
        case .useCaseError:
            return "Use case error"
        }
    }
}
