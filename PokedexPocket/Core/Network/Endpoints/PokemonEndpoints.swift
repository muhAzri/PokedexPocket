import Foundation
import Alamofire

enum PokemonEndpoint: APIEndpoint {
    case pokemonList(offset: Int, limit: Int)
    case pokemonDetail(id: Int)
    case pokemonDetailByURL(url: String)
    
    var path: String {
        switch self {
        case .pokemonList:
            return "/pokemon"
        case .pokemonDetail(let id):
            return "/pokemon/\(id)"
        case .pokemonDetailByURL:
            return ""
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        switch self {
        case .pokemonList(let offset, let limit):
            return [
                "offset": offset,
                "limit": limit
            ]
        case .pokemonDetail, .pokemonDetailByURL:
            return nil
        }
    }
    
    func url(baseURL: String) -> String {
        switch self {
        case .pokemonDetailByURL(let url):
            return url
        default:
            return baseURL + path
        }
    }
}