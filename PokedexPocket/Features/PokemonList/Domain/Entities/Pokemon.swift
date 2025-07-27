import Foundation

struct Pokemon: Identifiable, Equatable {
    let id: Int
    let name: String
    let url: String
    let imageURL: String
    let types: [PokemonType]
    let height: Int
    let weight: Int
    let stats: [PokemonStat]
    
    init(id: Int, name: String, url: String, imageURL: String = "", types: [PokemonType] = [], height: Int = 0, weight: Int = 0, stats: [PokemonStat] = []) {
        self.id = id
        self.name = name
        self.url = url
        self.imageURL = imageURL
        self.types = types
        self.height = height
        self.weight = weight
        self.stats = stats
    }
    
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
}

struct PokemonType: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let color: String
    
    init(name: String) {
        self.id = name
        self.name = name
        self.color = PokemonType.colorForType(name)
    }
    
    static func colorForType(_ type: String) -> String {
        switch type.lowercased() {
        case "fire": return "#F08030"
        case "water": return "#6890F0"
        case "grass": return "#78C850"
        case "electric": return "#F8D030"
        case "psychic": return "#F85888"
        case "ice": return "#98D8D8"
        case "dragon": return "#7038F8"
        case "dark": return "#705848"
        case "fairy": return "#EE99AC"
        case "normal": return "#A8A878"
        case "fighting": return "#C03028"
        case "poison": return "#A040A0"
        case "ground": return "#E0C068"
        case "flying": return "#A890F0"
        case "bug": return "#A8B820"
        case "rock": return "#B8A038"
        case "ghost": return "#705898"
        case "steel": return "#B8B8D0"
        default: return "#68A090"
        }
    }
}

struct PokemonStat: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let value: Int
    
    init(name: String, value: Int) {
        self.id = name
        self.name = name
        self.value = value
    }
}