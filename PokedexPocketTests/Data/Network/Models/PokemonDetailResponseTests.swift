//
//  PokemonDetailResponseTests.swift
//  PokedexPocketTests
//
//  Created by Azri on 30/07/25.
//

import XCTest
@testable import PokedexPocket

final class PokemonDetailResponseTests: XCTestCase {

    // MARK: - Codable Tests
    func testPokemonDetailResponseCodable() throws {
        let response = TestData.pokemonDetailResponse

        let encodedData = try JSONEncoder().encode(response)
        let decodedResponse = try JSONDecoder().decode(PokemonDetailResponse.self, from: encodedData)

        XCTAssertEqual(response.id, decodedResponse.id)
        XCTAssertEqual(response.name, decodedResponse.name)
        XCTAssertEqual(response.height, decodedResponse.height)
        XCTAssertEqual(response.weight, decodedResponse.weight)
        XCTAssertEqual(response.baseExperience, decodedResponse.baseExperience)
        XCTAssertEqual(response.order, decodedResponse.order)
    }

    func testPokemonDetailResponseToDomain() {
        let response = TestData.pokemonDetailResponse
        let domainModel = response.toDomain()

        XCTAssertEqual(domainModel.id, response.id)
        XCTAssertEqual(domainModel.name, response.name)
        XCTAssertEqual(domainModel.height, response.height)
        XCTAssertEqual(domainModel.weight, response.weight)
        XCTAssertEqual(domainModel.baseExperience, response.baseExperience ?? 0)
        XCTAssertEqual(domainModel.order, response.order)
        XCTAssertEqual(domainModel.species, response.species.name)
    }

    func testPokemonDetailResponseToDomainWithNilBaseExperience() {
        let responseWithNilBaseExperience = PokemonDetailResponse(
            id: 1,
            name: "test",
            height: 10,
            weight: 100,
            baseExperience: nil,
            order: nil,
            types: [],
            stats: [],
            abilities: [],
            sprites: PokemonSprites(
                backDefault: nil,
                backFemale: nil,
                backShiny: nil,
                backShinyFemale: nil,
                frontDefault: nil,
                frontFemale: nil,
                frontShiny: nil,
                frontShinyFemale: nil,
                other: nil,
                versions: nil
            ),
            moves: [],
            cries: nil,
            species: PokemonSpecies(name: "test", url: "test")
        )

        let domainModel = responseWithNilBaseExperience.toDomain()
        XCTAssertEqual(domainModel.baseExperience, 0)
    }

    func testToDomainImageURLOfficialArtworkPriority() {
        let responseWithOfficialArtwork = PokemonDetailResponse(
            id: 1,
            name: "test",
            height: 10,
            weight: 100,
            baseExperience: 50,
            order: 1,
            types: [],
            stats: [],
            abilities: [],
            sprites: PokemonSprites(
                backDefault: nil,
                backFemale: nil,
                backShiny: nil,
                backShinyFemale: nil,
                frontDefault: "front.png",
                frontFemale: nil,
                frontShiny: nil,
                frontShinyFemale: nil,
                other: PokemonOtherSprites(
                    dreamWorld: nil,
                    home: nil,
                    officialArtwork: PokemonOfficialArtwork(
                        frontDefault: "official.png",
                        frontShiny: nil
                    )
                ),
                versions: nil
            ),
            moves: [],
            cries: nil,
            species: PokemonSpecies(name: "test", url: "test")
        )

        let domainModel = responseWithOfficialArtwork.toDomain()
        XCTAssertEqual(domainModel.imageURL, "official.png")
    }

    func testToDomainImageURLFrontDefaultFallback() {
        let responseWithoutOfficialArtwork = PokemonDetailResponse(
            id: 1,
            name: "test",
            height: 10,
            weight: 100,
            baseExperience: 50,
            order: 1,
            types: [],
            stats: [],
            abilities: [],
            sprites: PokemonSprites(
                backDefault: nil,
                backFemale: nil,
                backShiny: nil,
                backShinyFemale: nil,
                frontDefault: "front.png",
                frontFemale: nil,
                frontShiny: nil,
                frontShinyFemale: nil,
                other: nil,
                versions: nil
            ),
            moves: [],
            cries: nil,
            species: PokemonSpecies(name: "test", url: "test")
        )

        let domainModel = responseWithoutOfficialArtwork.toDomain()
        XCTAssertEqual(domainModel.imageURL, "front.png")
    }

    func testToDomainImageURLEmptyFallback() {
        let responseWithoutImages = PokemonDetailResponse(
            id: 1,
            name: "test",
            height: 10,
            weight: 100,
            baseExperience: 50,
            order: 1,
            types: [],
            stats: [],
            abilities: [],
            sprites: PokemonSprites(
                backDefault: nil,
                backFemale: nil,
                backShiny: nil,
                backShinyFemale: nil,
                frontDefault: nil,
                frontFemale: nil,
                frontShiny: nil,
                frontShinyFemale: nil,
                other: nil,
                versions: nil
            ),
            moves: [],
            cries: nil,
            species: PokemonSpecies(name: "test", url: "test")
        )

        let domainModel = responseWithoutImages.toDomain()
        XCTAssertEqual(domainModel.imageURL, "")
    }

    func testToDomainMovesMapping() {
        let response = TestData.pokemonDetailResponse
        let domainModel = response.toDomain()

        XCTAssertEqual(domainModel.moves.count, 1)
        XCTAssertEqual(domainModel.moves.first?.name, "thunder-shock")
        XCTAssertEqual(domainModel.moves.first?.learnMethod, "level-up")
        XCTAssertEqual(domainModel.moves.first?.level, 1)
    }

    func testToDomainMovesWithEmptyVersionGroupDetails() {
        let moveSlotWithoutDetails = PokemonMoveSlot(
            move: PokemonMoveInfo(name: "test-move", url: "test"),
            versionGroupDetails: []
        )

        let response = PokemonDetailResponse(
            id: 1,
            name: "test",
            height: 10,
            weight: 100,
            baseExperience: 50,
            order: 1,
            types: [],
            stats: [],
            abilities: [],
            sprites: PokemonSprites(
                backDefault: nil,
                backFemale: nil,
                backShiny: nil,
                backShinyFemale: nil,
                frontDefault: nil,
                frontFemale: nil,
                frontShiny: nil,
                frontShinyFemale: nil,
                other: nil,
                versions: nil
            ),
            moves: [moveSlotWithoutDetails],
            cries: nil,
            species: PokemonSpecies(name: "test", url: "test")
        )

        let domainModel = response.toDomain()
        XCTAssertEqual(domainModel.moves.first?.learnMethod, "unknown")
        XCTAssertEqual(domainModel.moves.first?.level, 0)
    }

    func testToDomainCriesMapping() {
        let response = TestData.pokemonDetailResponse
        let domainModel = response.toDomain()

        XCTAssertNotNil(domainModel.cries)
        XCTAssertEqual(domainModel.cries?.latest, response.cries?.latest)
        XCTAssertEqual(domainModel.cries?.legacy, response.cries?.legacy)

        // Test nil cries
        let responseWithoutCries = PokemonDetailResponse(
            id: 1,
            name: "test",
            height: 10,
            weight: 100,
            baseExperience: 50,
            order: 1,
            types: [],
            stats: [],
            abilities: [],
            sprites: PokemonSprites(
                backDefault: nil,
                backFemale: nil,
                backShiny: nil,
                backShinyFemale: nil,
                frontDefault: nil,
                frontFemale: nil,
                frontShiny: nil,
                frontShinyFemale: nil,
                other: nil,
                versions: nil
            ),
            moves: [],
            cries: nil,
            species: PokemonSpecies(name: "test", url: "test")
        )

        let domainModel2 = responseWithoutCries.toDomain()
        XCTAssertNil(domainModel2.cries)
    }

    func testToDomainSpritesMapping() {
        let response = TestData.pokemonDetailResponse
        let domainModel = response.toDomain()

        XCTAssertEqual(domainModel.sprites.frontDefault, response.sprites.frontDefault)
        XCTAssertEqual(domainModel.sprites.frontShiny, response.sprites.frontShiny)
        XCTAssertEqual(domainModel.sprites.backDefault, response.sprites.backDefault)
        XCTAssertEqual(domainModel.sprites.backShiny, response.sprites.backShiny)
        XCTAssertEqual(domainModel.sprites.officialArtwork, response.sprites.other?.officialArtwork?.frontDefault)
        XCTAssertEqual(domainModel.sprites.officialArtworkShiny, response.sprites.other?.officialArtwork?.frontShiny)
        XCTAssertEqual(domainModel.sprites.dreamWorld, response.sprites.other?.dreamWorld?.frontDefault)
        XCTAssertEqual(domainModel.sprites.home, response.sprites.other?.home?.frontDefault)
        XCTAssertEqual(domainModel.sprites.homeShiny, response.sprites.other?.home?.frontShiny)
    }
}

// MARK: - Individual Component Tests
final class PokemonTypeSlotTests: XCTestCase {

    func testPokemonTypeSlotCodable() throws {
        let typeSlot = PokemonTypeSlot(
            slot: 1,
            type: PokemonTypeInfo(name: "electric", url: "https://pokeapi.co/api/v2/type/13/")
        )

        let encodedData = try JSONEncoder().encode(typeSlot)
        let decodedTypeSlot = try JSONDecoder().decode(PokemonTypeSlot.self, from: encodedData)

        XCTAssertEqual(typeSlot.slot, decodedTypeSlot.slot)
        XCTAssertEqual(typeSlot.type.name, decodedTypeSlot.type.name)
        XCTAssertEqual(typeSlot.type.url, decodedTypeSlot.type.url)
    }
}

final class PokemonAbilitySlotTests: XCTestCase {

    func testPokemonAbilitySlotCodable() throws {
        let abilitySlot = PokemonAbilitySlot(
            ability: PokemonAbilityInfo(
                name: "static",
                url: "https://pokeapi.co/api/v2/ability/9/"
            ),
            isHidden: false,
            slot: 1
        )

        let encodedData = try JSONEncoder().encode(abilitySlot)
        let decodedAbilitySlot = try JSONDecoder().decode(PokemonAbilitySlot.self, from: encodedData)

        XCTAssertEqual(abilitySlot.ability.name, decodedAbilitySlot.ability.name)
        XCTAssertEqual(abilitySlot.ability.url, decodedAbilitySlot.ability.url)
        XCTAssertEqual(abilitySlot.isHidden, decodedAbilitySlot.isHidden)
        XCTAssertEqual(abilitySlot.slot, decodedAbilitySlot.slot)
    }
}

final class PokemonMoveSlotTests: XCTestCase {

    func testPokemonMoveSlotCodable() throws {
        let moveSlot = PokemonMoveSlot(
            move: PokemonMoveInfo(
                name: "thunder-shock",
                url: "https://pokeapi.co/api/v2/move/84/"
            ),
            versionGroupDetails: [
                PokemonMoveVersionGroup(
                    levelLearnedAt: 1,
                    moveLearnMethod: PokemonMoveLearnMethod(
                        name: "level-up",
                        url: "https://pokeapi.co/api/v2/move-learn-method/1/"
                    ),
                    versionGroup: PokemonVersionGroup(
                        name: "red-blue",
                        url: "https://pokeapi.co/api/v2/version-group/1/"
                    )
                )
            ]
        )

        let encodedData = try JSONEncoder().encode(moveSlot)
        let decodedMoveSlot = try JSONDecoder().decode(PokemonMoveSlot.self, from: encodedData)

        XCTAssertEqual(moveSlot.move.name, decodedMoveSlot.move.name)
        XCTAssertEqual(moveSlot.move.url, decodedMoveSlot.move.url)
        XCTAssertEqual(moveSlot.versionGroupDetails.count, decodedMoveSlot.versionGroupDetails.count)
        XCTAssertEqual(
            moveSlot.versionGroupDetails.first?.levelLearnedAt,
            decodedMoveSlot.versionGroupDetails.first?.levelLearnedAt
        )
    }
}

final class PokemonStatResponseTests: XCTestCase {

    func testPokemonStatResponseCodable() throws {
        let statResponse = PokemonStatResponse(
            baseStat: 35,
            effort: 0,
            stat: PokemonStatInfo(name: "hp", url: "https://pokeapi.co/api/v2/stat/1/")
        )

        let encodedData = try JSONEncoder().encode(statResponse)
        let decodedStatResponse = try JSONDecoder().decode(PokemonStatResponse.self, from: encodedData)

        XCTAssertEqual(statResponse.baseStat, decodedStatResponse.baseStat)
        XCTAssertEqual(statResponse.effort, decodedStatResponse.effort)
        XCTAssertEqual(statResponse.stat.name, decodedStatResponse.stat.name)
        XCTAssertEqual(statResponse.stat.url, decodedStatResponse.stat.url)
    }
}

final class PokemonSpritesTests: XCTestCase {

    func testPokemonSpritesCodable() throws {
        let sprites = PokemonSprites(
            backDefault: "back.png",
            backFemale: nil,
            backShiny: "back_shiny.png",
            backShinyFemale: nil,
            frontDefault: "front.png",
            frontFemale: nil,
            frontShiny: "front_shiny.png",
            frontShinyFemale: nil,
            other: PokemonOtherSprites(
                dreamWorld: PokemonDreamWorldSprites(frontDefault: "dream.svg", frontFemale: nil),
                home: PokemonHomeSprites(
                    frontDefault: "home.png",
                    frontFemale: nil,
                    frontShiny: "home_shiny.png",
                    frontShinyFemale: nil
                ),
                officialArtwork: PokemonOfficialArtwork(frontDefault: "artwork.png", frontShiny: "artwork_shiny.png")
            ),
            versions: PokemonVersionSprites()
        )

        let encodedData = try JSONEncoder().encode(sprites)
        let decodedSprites = try JSONDecoder().decode(PokemonSprites.self, from: encodedData)

        XCTAssertEqual(sprites.frontDefault, decodedSprites.frontDefault)
        XCTAssertEqual(sprites.frontShiny, decodedSprites.frontShiny)
        XCTAssertEqual(sprites.backDefault, decodedSprites.backDefault)
        XCTAssertEqual(sprites.backShiny, decodedSprites.backShiny)
        XCTAssertEqual(
            sprites.other?.officialArtwork?.frontDefault,
            decodedSprites.other?.officialArtwork?.frontDefault
        )
    }
}

final class PokemonCriesTests: XCTestCase {

    func testPokemonCriesCodable() throws {
        let cries = PokemonCries(
            latest: "latest.ogg",
            legacy: "legacy.ogg"
        )

        let encodedData = try JSONEncoder().encode(cries)
        let decodedCries = try JSONDecoder().decode(PokemonCries.self, from: encodedData)

        XCTAssertEqual(cries.latest, decodedCries.latest)
        XCTAssertEqual(cries.legacy, decodedCries.legacy)
    }

    func testPokemonCriesWithNilValues() throws {
        let cries = PokemonCries(latest: nil, legacy: nil)

        let encodedData = try JSONEncoder().encode(cries)
        let decodedCries = try JSONDecoder().decode(PokemonCries.self, from: encodedData)

        XCTAssertNil(decodedCries.latest)
        XCTAssertNil(decodedCries.legacy)
    }
}
