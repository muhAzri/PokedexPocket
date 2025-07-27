//
//  NetworkConfiguration.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation

struct NetworkConfiguration {
    let baseURL: String
    let timeout: TimeInterval
    let maxRetryAttempts: Int

    static func loadFromEnvironment() -> NetworkConfiguration {
        guard let path = Bundle.main.path(forResource: "Environment", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path) else {
            fatalError("Environment.plist not found")
        }

        let baseURL = plist["PokeAPIBaseURL"] as? String ?? "https://pokeapi.co/api/v2"
        let timeout = TimeInterval(plist["APITimeout"] as? Int ?? 30)
        let maxRetryAttempts = plist["MaxRetryAttempts"] as? Int ?? 3

        return NetworkConfiguration(
            baseURL: baseURL,
            timeout: timeout,
            maxRetryAttempts: maxRetryAttempts
        )
    }
}
