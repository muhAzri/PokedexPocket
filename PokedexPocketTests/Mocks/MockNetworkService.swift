//
//  MockNetworkService.swift
//  PokedexPocketTests
//
//  Created by Azri on 30/07/25.
//

import Foundation
import RxSwift
@testable import PokedexPocket

class MockNetworkService: NetworkServiceProtocol {
    var shouldReturnError = false
    var errorToReturn: Error = NetworkError.unknown
    var responseToReturn: Any?
    var requestCallCount = 0
    var lastEndpoint: APIEndpoint?

    func request<T: Codable>(_ endpoint: APIEndpoint, responseType: T.Type) -> Observable<T> {
        requestCallCount += 1
        lastEndpoint = endpoint

        if shouldReturnError {
            return Observable.error(errorToReturn)
        }

        if let response = responseToReturn as? T {
            return Observable.just(response)
        }

        return Observable.error(NetworkError.noData)
    }

    func reset() {
        shouldReturnError = false
        errorToReturn = NetworkError.unknown
        responseToReturn = nil
        requestCallCount = 0
        lastEndpoint = nil
    }
}
