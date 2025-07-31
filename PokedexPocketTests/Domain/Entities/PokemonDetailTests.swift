//
//  PokemonDetailTests.swift
//  PokedexPocketTests
//
//  Created by Azri on 30/07/25.
//

import XCTest
@testable import PokedexPocket

final class PokemonDetailTests: XCTestCase {

    // MARK: - Test Properties
    func testPokemonDetailIdentifiable() {
        let pokemon = TestData.pikachu
        XCTAssertEqual(pokemon.id, 25)
    }

    func testPokemonDetailEquality() {
        let pokemon1 = TestData.pikachu
        let pokemon2 = TestData.pikachu
        let pokemon3 = TestData.charizard

        XCTAssertEqual(pokemon1, pokemon2)
        XCTAssertNotEqual(pokemon1, pokemon3)
    }

    func testFormattedName() {
        let pokemon = TestData.pikachu
        XCTAssertEqual(pokemon.formattedName, "Pikachu")

        let emptyNamePokemon = TestData.minimumPokemon
        XCTAssertEqual(emptyNamePokemon.formattedName, "")
    }

    func testPokemonNumber() {
        let pokemon = TestData.pikachu
        XCTAssertEqual(pokemon.pokemonNumber, "#025")

        let pokemon6 = TestData.charizard
        XCTAssertEqual(pokemon6.pokemonNumber, "#006")

        let pokemon1 = TestData.minimumPokemon
        XCTAssertEqual(pokemon1.pokemonNumber, "#001")
    }

    func testHeightInMeters() {
        let pokemon = TestData.pikachu
        XCTAssertEqual(pokemon.heightInMeters, 0.4, accuracy: 0.01)

        let charizard = TestData.charizard
        XCTAssertEqual(charizard.heightInMeters, 1.7, accuracy: 0.01)

        let zeroPokemon = TestData.minimumPokemon
        XCTAssertEqual(zeroPokemon.heightInMeters, 0.0, accuracy: 0.01)
    }

    func testWeightInKilograms() {
        let pokemon = TestData.pikachu
        XCTAssertEqual(pokemon.weightInKilograms, 6.0, accuracy: 0.01)

        let charizard = TestData.charizard
        XCTAssertEqual(charizard.weightInKilograms, 90.5, accuracy: 0.01)

        let zeroPokemon = TestData.minimumPokemon
        XCTAssertEqual(zeroPokemon.weightInKilograms, 0.0, accuracy: 0.01)
    }

    // MARK: - Test Initialization
    func testInitialization() {
        let pokemon = PokemonDetail(
            id: 150,
            name: "mewtwo",
            height: 20,
            weight: 1220,
            baseExperience: 306,
            order: 151,
            types: [PokemonType(name: "psychic")],
            stats: [PokemonStat(name: "hp", value: 106)],
            abilities: [PokemonAbility(name: "pressure", isHidden: false)],
            moves: [PokemonMove(name: "confusion", learnMethod: "level-up", level: 1)],
            imageURL: "https://example.com/mewtwo.png",
            sprites: PokemonDetailSprites(
                frontDefault: "front.png",
                frontShiny: "shiny.png",
                backDefault: "back.png",
                backShiny: "back_shiny.png",
                officialArtwork: "artwork.png",
                officialArtworkShiny: "artwork_shiny.png",
                dreamWorld: "dream.png",
                home: "home.png",
                homeShiny: "home_shiny.png"
            ),
            cries: PokemonDetailCries(latest: "cry.ogg", legacy: "old_cry.ogg"),
            species: "genetic"
        )

        XCTAssertEqual(pokemon.id, 150)
        XCTAssertEqual(pokemon.name, "mewtwo")
        XCTAssertEqual(pokemon.height, 20)
        XCTAssertEqual(pokemon.weight, 1220)
        XCTAssertEqual(pokemon.baseExperience, 306)
        XCTAssertEqual(pokemon.order, 151)
        XCTAssertEqual(pokemon.types.count, 1)
        XCTAssertEqual(pokemon.stats.count, 1)
        XCTAssertEqual(pokemon.abilities.count, 1)
        XCTAssertEqual(pokemon.moves.count, 1)
        XCTAssertEqual(pokemon.imageURL, "https://example.com/mewtwo.png")
        XCTAssertEqual(pokemon.species, "genetic")
    }

    func testInitializationWithDefaults() {
        let pokemon = PokemonDetail(
            id: 1,
            name: "test",
            height: 10,
            weight: 100,
            baseExperience: 50,
            types: [],
            stats: [],
            abilities: [],
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
            species: ""
        )

        XCTAssertEqual(pokemon.id, 1)
        XCTAssertEqual(pokemon.name, "test")
        XCTAssertEqual(pokemon.order, nil)
        XCTAssertEqual(pokemon.moves.count, 0)
        XCTAssertEqual(pokemon.cries, nil)
    }
}

// MARK: - PokemonAbility Tests
final class PokemonAbilityTests: XCTestCase {

    func testAbilityInitialization() {
        let ability = PokemonAbility(name: "static", isHidden: false)

        XCTAssertEqual(ability.id, "static")
        XCTAssertEqual(ability.name, "static")
        XCTAssertFalse(ability.isHidden)
    }

    func testAbilityDefaultHidden() {
        let ability = PokemonAbility(name: "lightning-rod")

        XCTAssertEqual(ability.id, "lightning-rod")
        XCTAssertEqual(ability.name, "lightning-rod")
        XCTAssertFalse(ability.isHidden)
    }

    func testFormattedName() {
        let ability = PokemonAbility(name: "lightning-rod")
        XCTAssertEqual(ability.formattedName, "Lightning Rod")

        let singleWordAbility = PokemonAbility(name: "static")
        XCTAssertEqual(singleWordAbility.formattedName, "Static")

        let multipleHyphensAbility = PokemonAbility(name: "compound-eyes-ability")
        XCTAssertEqual(multipleHyphensAbility.formattedName, "Compound Eyes Ability")

        let emptyAbility = PokemonAbility(name: "")
        XCTAssertEqual(emptyAbility.formattedName, "")
    }

    func testAbilityEquality() {
        let ability1 = PokemonAbility(name: "static", isHidden: false)
        let ability2 = PokemonAbility(name: "static", isHidden: false)
        let ability3 = PokemonAbility(name: "static", isHidden: true)
        let ability4 = PokemonAbility(name: "pressure", isHidden: false)

        XCTAssertEqual(ability1, ability2)
        XCTAssertNotEqual(ability1, ability3)
        XCTAssertNotEqual(ability1, ability4)
    }

    func testAbilityCodable() throws {
        let ability = PokemonAbility(name: "lightning-rod", isHidden: true)

        let encodedData = try JSONEncoder().encode(ability)
        let decodedAbility = try JSONDecoder().decode(PokemonAbility.self, from: encodedData)

        XCTAssertEqual(ability, decodedAbility)
    }
}

// MARK: - PokemonMove Tests
final class PokemonMoveTests: XCTestCase {

    func testMoveInitialization() {
        let move = PokemonMove(name: "thunder-shock", learnMethod: "level-up", level: 5)

        XCTAssertEqual(move.id, "thunder-shock")
        XCTAssertEqual(move.name, "thunder-shock")
        XCTAssertEqual(move.learnMethod, "level-up")
        XCTAssertEqual(move.level, 5)
    }

    func testFormattedName() {
        let move = PokemonMove(name: "thunder-shock", learnMethod: "level-up", level: 1)
        XCTAssertEqual(move.formattedName, "Thunder Shock")

        let singleWordMove = PokemonMove(name: "tackle", learnMethod: "level-up", level: 1)
        XCTAssertEqual(singleWordMove.formattedName, "Tackle")

        let multipleHyphensMove = PokemonMove(name: "high-jump-kick", learnMethod: "level-up", level: 1)
        XCTAssertEqual(multipleHyphensMove.formattedName, "High Jump Kick")

        let emptyMove = PokemonMove(name: "", learnMethod: "level-up", level: 0)
        XCTAssertEqual(emptyMove.formattedName, "")
    }

    func testFormattedLearnMethod() {
        let levelUpMove = PokemonMove(name: "tackle", learnMethod: "level-up", level: 5)
        XCTAssertEqual(levelUpMove.formattedLearnMethod, "Level 5")

        let machineMove = PokemonMove(name: "thunderbolt", learnMethod: "machine", level: 0)
        XCTAssertEqual(machineMove.formattedLearnMethod, "TM/TR")

        let eggMove = PokemonMove(name: "wish", learnMethod: "egg", level: 0)
        XCTAssertEqual(eggMove.formattedLearnMethod, "Egg Move")

        let tutorMove = PokemonMove(name: "blast-burn", learnMethod: "tutor", level: 0)
        XCTAssertEqual(tutorMove.formattedLearnMethod, "Move Tutor")

        let unknownMove = PokemonMove(name: "custom", learnMethod: "unknown-method", level: 0)
        XCTAssertEqual(unknownMove.formattedLearnMethod, "Unknown-Method")

        let levelZeroMove = PokemonMove(name: "tackle", learnMethod: "level-up", level: 0)
        XCTAssertEqual(levelZeroMove.formattedLearnMethod, "Level 0")
    }

    func testMoveEquality() {
        let move1 = PokemonMove(name: "tackle", learnMethod: "level-up", level: 1)
        let move2 = PokemonMove(name: "tackle", learnMethod: "level-up", level: 1)
        let move3 = PokemonMove(name: "tackle", learnMethod: "level-up", level: 5)
        let move4 = PokemonMove(name: "scratch", learnMethod: "level-up", level: 1)

        XCTAssertEqual(move1, move2)
        XCTAssertNotEqual(move1, move3)
        XCTAssertNotEqual(move1, move4)
    }

    func testMoveCodable() throws {
        let move = PokemonMove(name: "thunder-shock", learnMethod: "level-up", level: 5)

        let encodedData = try JSONEncoder().encode(move)
        let decodedMove = try JSONDecoder().decode(PokemonMove.self, from: encodedData)

        XCTAssertEqual(move, decodedMove)
    }
}

// MARK: - PokemonDetailSprites Tests
final class PokemonDetailSpritesTests: XCTestCase {

    func testBestQualityImage() {
        let spritesWithOfficialArtwork = PokemonDetailSprites(
            frontDefault: "front.png",
            frontShiny: nil,
            backDefault: nil,
            backShiny: nil,
            officialArtwork: "artwork.png",
            officialArtworkShiny: nil,
            dreamWorld: nil,
            home: "home.png",
            homeShiny: nil
        )
        XCTAssertEqual(spritesWithOfficialArtwork.bestQualityImage, "artwork.png")

        let spritesWithHome = PokemonDetailSprites(
            frontDefault: "front.png",
            frontShiny: nil,
            backDefault: nil,
            backShiny: nil,
            officialArtwork: nil,
            officialArtworkShiny: nil,
            dreamWorld: nil,
            home: "home.png",
            homeShiny: nil
        )
        XCTAssertEqual(spritesWithHome.bestQualityImage, "home.png")

        let spritesWithDream = PokemonDetailSprites(
            frontDefault: "front.png",
            frontShiny: nil,
            backDefault: nil,
            backShiny: nil,
            officialArtwork: nil,
            officialArtworkShiny: nil,
            dreamWorld: "dream.png",
            home: nil,
            homeShiny: nil
        )
        XCTAssertEqual(spritesWithDream.bestQualityImage, "dream.png")

        let spritesOnlyFront = PokemonDetailSprites(
            frontDefault: "front.png",
            frontShiny: nil,
            backDefault: nil,
            backShiny: nil,
            officialArtwork: nil,
            officialArtworkShiny: nil,
            dreamWorld: nil,
            home: nil,
            homeShiny: nil
        )
        XCTAssertEqual(spritesOnlyFront.bestQualityImage, "front.png")

        let emptySprites = PokemonDetailSprites(
            frontDefault: nil,
            frontShiny: nil,
            backDefault: nil,
            backShiny: nil,
            officialArtwork: nil,
            officialArtworkShiny: nil,
            dreamWorld: nil,
            home: nil,
            homeShiny: nil
        )
        XCTAssertEqual(emptySprites.bestQualityImage, "")
    }

    func testGetCurrentSprite() {
        let sprites = TestData.pikachu.sprites

        XCTAssertEqual(sprites.getCurrentSprite(isShiny: false, isFront: true), sprites.bestQualityImage)
        XCTAssertEqual(sprites.getCurrentSprite(isShiny: true, isFront: true), sprites.bestQualityShinyImage)
        XCTAssertEqual(sprites.getCurrentSprite(isShiny: false, isFront: false), sprites.bestQualityBackImage)
        XCTAssertEqual(sprites.getCurrentSprite(isShiny: true, isFront: false), sprites.bestQualityBackShinyImage)
    }

    func testGetSpriteForStyle() {
        let sprites = TestData.pikachu.sprites

        let officialArtworkNormal = sprites.getSpriteForStyle("Official Artwork", isShiny: false, isFront: true)
        XCTAssertEqual(officialArtworkNormal, sprites.officialArtwork ?? sprites.bestQualityImage)

        let officialArtworkShiny = sprites.getSpriteForStyle("Official Artwork", isShiny: true, isFront: true)
        let expectedOfficialArtworkShiny = sprites.officialArtworkShiny ??
            sprites.officialArtwork ?? sprites.bestQualityShinyImage
        XCTAssertEqual(officialArtworkShiny, expectedOfficialArtworkShiny)

        let homeStyleNormal = sprites.getSpriteForStyle("Home Style", isShiny: false, isFront: true)
        XCTAssertEqual(homeStyleNormal, sprites.home ?? sprites.bestQualityImage)

        let gameSpriteFront = sprites.getSpriteForStyle("Game Sprites", isShiny: false, isFront: true)
        XCTAssertEqual(gameSpriteFront, sprites.frontDefault ?? sprites.bestQualityImage)

        let gameSpriteFrontShiny = sprites.getSpriteForStyle("Game Sprites", isShiny: true, isFront: true)
        let expectedGameSpriteFrontShiny = sprites.frontShiny ??
            sprites.frontDefault ?? sprites.bestQualityShinyImage
        XCTAssertEqual(gameSpriteFrontShiny, expectedGameSpriteFrontShiny)

        let gameSpriteBack = sprites.getSpriteForStyle("Game Sprites", isShiny: false, isFront: false)
        XCTAssertEqual(gameSpriteBack, sprites.backDefault ?? sprites.frontDefault ?? sprites.bestQualityImage)

        let unknownStyle = sprites.getSpriteForStyle("Unknown Style", isShiny: false, isFront: true)
        XCTAssertEqual(unknownStyle, sprites.bestQualityImage)
    }

    func testAllSprites() {
        let sprites = TestData.pikachu.sprites
        let allSprites = sprites.allSprites

        XCTAssertTrue(allSprites.count > 0)
        XCTAssertFalse(allSprites.contains(""))

        let emptySprites = TestData.minimumPokemon.sprites
        let emptyAllSprites = emptySprites.allSprites
        XCTAssertEqual(emptyAllSprites.count, 0)
    }
}

// MARK: - PokemonDetailCries Tests
final class PokemonDetailCriesTests: XCTestCase {

    func testPrimaryCry() {
        let criesWithLatest = PokemonDetailCries(latest: "latest.ogg", legacy: "legacy.ogg")
        XCTAssertEqual(criesWithLatest.primaryCry, "latest.ogg")

        let criesOnlyLegacy = PokemonDetailCries(latest: nil, legacy: "legacy.ogg")
        XCTAssertEqual(criesOnlyLegacy.primaryCry, "legacy.ogg")

        let emptyCries = PokemonDetailCries(latest: nil, legacy: nil)
        XCTAssertNil(emptyCries.primaryCry)
    }

    func testCriesEquality() {
        let cries1 = PokemonDetailCries(latest: "latest.ogg", legacy: "legacy.ogg")
        let cries2 = PokemonDetailCries(latest: "latest.ogg", legacy: "legacy.ogg")
        let cries3 = PokemonDetailCries(latest: "different.ogg", legacy: "legacy.ogg")

        XCTAssertEqual(cries1, cries2)
        XCTAssertNotEqual(cries1, cries3)
    }

    func testCriesCodable() throws {
        let cries = PokemonDetailCries(latest: "latest.ogg", legacy: "legacy.ogg")

        let encodedData = try JSONEncoder().encode(cries)
        let decodedCries = try JSONDecoder().decode(PokemonDetailCries.self, from: encodedData)

        XCTAssertEqual(cries, decodedCries)
    }
}
