import Foundation

struct PokemonDetail: Identifiable, Equatable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let baseExperience: Int
    let types: [PokemonType]
    let stats: [PokemonStat]
    let abilities: [PokemonAbility]
    let imageURL: String
    
    var formattedName: String {
        name.capitalized
    }
    
    var pokemonNumber: String {
        String(format: "#%03d", id)
    }
    
    var heightInMeters: Double {
        Double(height) / 10.0
    }
    
    var weightInKilograms: Double {
        Double(weight) / 10.0
    }
    
    static func == (lhs: PokemonDetail, rhs: PokemonDetail) -> Bool {
        return lhs.id == rhs.id
    }
}

struct PokemonAbility: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let isHidden: Bool
    
    init(name: String, isHidden: Bool = false) {
        self.id = name
        self.name = name
        self.isHidden = isHidden
    }
}