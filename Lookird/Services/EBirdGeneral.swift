import Foundation

struct EBirdGeneral: Codable, Identifiable {
    let comName: String
    let sciName: String
    let speciesCode: String
    
    var id: String { speciesCode }
}
