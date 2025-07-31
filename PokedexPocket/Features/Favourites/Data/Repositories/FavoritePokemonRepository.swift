//
//  FavoritePokemonRepository.swift
//  PokedexPocket
//
//  Created by Azri on 29/07/25.
//

import Foundation
import SwiftData
import RxSwift
import PokedexPocketPokemon

class FavoritePokemonRepository: FavoritePokemonRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func addFavorite(pokemon: PokemonDetail) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(FavoritePokemonError.addFailed)
                return Disposables.create()
            }

            do {
                let dataModel = FavoritePokemonMapper.toDataModel(from: pokemon)
                self.modelContext.insert(dataModel)
                try self.modelContext.save()
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(FavoritePokemonError.addFailed)
            }

            return Disposables.create()
        }
    }

    func removeFavorite(pokemonId: Int) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(FavoritePokemonError.removeFailed)
                return Disposables.create()
            }

            do {
                let descriptor = FetchDescriptor<FavouritePokemonDataModel>(
                    predicate: #Predicate { $0.pokemonId == pokemonId }
                )

                let results = try self.modelContext.fetch(descriptor)

                guard let pokemonToDelete = results.first else {
                    observer.onError(FavoritePokemonError.pokemonNotFound)
                    return Disposables.create()
                }

                self.modelContext.delete(pokemonToDelete)
                try self.modelContext.save()
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(FavoritePokemonError.removeFailed)
            }

            return Disposables.create()
        }
    }

    func getFavorites() -> Observable<[FavoritePokemon]> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(FavoritePokemonError.fetchFailed)
                return Disposables.create()
            }

            do {
                let descriptor = FetchDescriptor<FavouritePokemonDataModel>(
                    sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
                )

                let results = try self.modelContext.fetch(descriptor)
                let favorites = results.map { FavoritePokemonMapper.toDomain($0) }
                observer.onNext(favorites)
                observer.onCompleted()
            } catch {
                observer.onError(FavoritePokemonError.fetchFailed)
            }

            return Disposables.create()
        }
    }

    func isFavorite(pokemonId: Int) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(FavoritePokemonError.fetchFailed)
                return Disposables.create()
            }

            do {
                let descriptor = FetchDescriptor<FavouritePokemonDataModel>(
                    predicate: #Predicate { $0.pokemonId == pokemonId }
                )

                let results = try self.modelContext.fetch(descriptor)
                observer.onNext(!results.isEmpty)
                observer.onCompleted()
            } catch {
                observer.onError(FavoritePokemonError.fetchFailed)
            }

            return Disposables.create()
        }
    }

    func clearAllFavorites() -> Observable<Void> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(FavoritePokemonError.clearAllFailed)
                return Disposables.create()
            }

            do {
                let descriptor = FetchDescriptor<FavouritePokemonDataModel>()
                let results = try self.modelContext.fetch(descriptor)

                for pokemon in results {
                    self.modelContext.delete(pokemon)
                }

                try self.modelContext.save()
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(FavoritePokemonError.clearAllFailed)
            }

            return Disposables.create()
        }
    }
}
