//
//  DIContainer.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
import Swinject
import SwiftData

class DIContainer {
    static let shared = DIContainer()
    private let container = Container()
    private var modelContext: ModelContext?

    private init() {
        registerDependencies()
    }

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    private func registerDependencies() {
        registerConfiguration()
        registerNetworking()
        registerCaching()
        registerRepositories()
        registerUseCases()
        registerViewModelFactory()
    }

    private func registerConfiguration() {
        container.register(NetworkConfiguration.self) { _ in
            NetworkConfiguration.loadFromEnvironment()
        }.inObjectScope(.container)
    }

    private func registerNetworking() {
        container.register(NetworkServiceProtocol.self) { resolver in
            let configuration = resolver.resolve(NetworkConfiguration.self)!
            return NetworkService(configuration: configuration)
        }.inObjectScope(.container)
    }

    private func registerCaching() {
        container.register(CacheManagerProtocol.self) { _ in
            CacheManager.shared
        }.inObjectScope(.container)
    }

    private func registerRepositories() {
        container.register(PokemonListRepositoryProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            let cacheManager = resolver.resolve(CacheManagerProtocol.self)!
            return PokemonListRepository(networkService: networkService, cacheManager: cacheManager)
        }.inObjectScope(.container)

        container.register(PokemonDetailRepositoryProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            return PokemonDetailRepository(networkService: networkService)
        }.inObjectScope(.container)

        container.register(FavoritePokemonRepositoryProtocol.self) { [weak self] _ in
            guard let modelContext = self?.modelContext else {
                fatalError("ModelContext not set. Call setModelContext() before resolving FavoritePokemonRepository")
            }
            return FavoritePokemonRepository(modelContext: modelContext)
        }.inObjectScope(.container)
    }

    private func registerUseCases() {
        container.register(GetPokemonListUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(PokemonListRepositoryProtocol.self)!
            return GetPokemonListUseCase(repository: repository)
        }

        container.register(GetPokemonDetailUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(PokemonDetailRepositoryProtocol.self)!
            return GetPokemonDetailUseCase(repository: repository)
        }

        container.register(SearchPokemonUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(PokemonListRepositoryProtocol.self)!
            return SearchPokemonUseCase(repository: repository)
        }

        // Favorite Pokemon Use Cases
        container.register(AddFavoritePokemonUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(FavoritePokemonRepositoryProtocol.self)!
            return AddFavoritePokemonUseCase(repository: repository)
        }

        container.register(RemoveFavoritePokemonUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(FavoritePokemonRepositoryProtocol.self)!
            return RemoveFavoritePokemonUseCase(repository: repository)
        }

        container.register(GetFavoritesPokemonUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(FavoritePokemonRepositoryProtocol.self)!
            return GetFavoritesPokemonUseCase(repository: repository)
        }

        container.register(CheckIsFavoritePokemonUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(FavoritePokemonRepositoryProtocol.self)!
            return CheckIsFavoritePokemonUseCase(repository: repository)
        }

        container.register(ClearAllFavoritesUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(FavoritePokemonRepositoryProtocol.self)!
            return ClearAllFavoritesUseCase(repository: repository)
        }
    }

    private func registerViewModelFactory() {
        container.register(ViewModelFactory.self) { _ in
            return DefaultViewModelFactory()
        }.inObjectScope(.container)
    }

    func resolve<T>(_ serviceType: T.Type) -> T {
        guard let service = container.resolve(serviceType) else {
            fatalError("Unable to resolve \(serviceType)")
        }
        return service
    }
}
