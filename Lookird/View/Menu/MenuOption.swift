import Foundation

enum MenuOption: String, CaseIterable {
    case perfil = "Perfil"
    case rutas = "Rutas"
    case aves = "Aves"
    case eventos = "Eventos"
    case bitacoras = "Bitácoras"
    
    var icon: String {
        switch self {
        case .perfil: return "person.crop.circle"
        case .rutas: return "map"
        case .aves: return "bird"
        case .eventos: return "calendar"
        case .bitacoras: return "book"
        }
    }
}

