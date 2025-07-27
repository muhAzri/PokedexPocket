//
//  APIEndpoint.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
import Alamofire

protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }

    func url(baseURL: String) -> String
}

extension APIEndpoint {
    func url(baseURL: String) -> String {
        return baseURL + path
    }

    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }

    var headers: HTTPHeaders? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
