//
//  AlamofireManager.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
import Alamofire

final class AlamofireManager {
    static let shared = AlamofireManager()

    let session: Session

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        configuration.requestCachePolicy = .useProtocolCachePolicy

        let interceptor = NetworkInterceptor()

        self.session = Session(
            configuration: configuration,
            interceptor: interceptor
        )
    }
}

final class NetworkInterceptor: Interceptor, @unchecked Sendable {
    override func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var adaptedRequest = urlRequest

        adaptedRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        adaptedRequest.setValue("PokedexPocket/1.0", forHTTPHeaderField: "User-Agent")

        completion(.success(adaptedRequest))
    }

    override func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard request.retryCount < 3 else {
            completion(.doNotRetry)
            return
        }

        if let afError = error as? AFError {
            switch afError {
            case .sessionTaskFailed(let urlError as URLError):
                switch urlError.code {
                case .notConnectedToInternet, .networkConnectionLost, .timedOut:
                    completion(.retryWithDelay(1.0))
                default:
                    completion(.doNotRetry)
                }
            default:
                completion(.doNotRetry)
            }
        } else {
            completion(.doNotRetry)
        }
    }
}
