//
//  DIContainer.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
import Swinject

class DIContainer {
    static let shared = DIContainer()
    private let container = Container()
    
    private init() {
        registerDependencies()
    }
    
    private func registerDependencies() {
        registerConfiguration()
        registerNetworking()
        registerRepositories()
        registerUseCases()
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
    
    private func registerRepositories() {
        container.register(PokemonListRepositoryProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            return PokemonListRepository(networkService: networkService)
        }.inObjectScope(.container)
        
        container.register(PokemonDetailRepositoryProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            return PokemonDetailRepository(networkService: networkService)
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
    }
    
    func resolve<T>(_ serviceType: T.Type) -> T {
        guard let service = container.resolve(serviceType) else {
            fatalError("Unable to resolve \(serviceType)")
        }
        return service
    }
}