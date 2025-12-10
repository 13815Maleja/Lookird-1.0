import Foundation

struct EBirdSighting: Codable, Identifiable {
    let id = UUID()
    let comName: String
    let locName: String
    let obsDt: String
    let howMany: Int?
    let speciesCode: String
    
    enum CodingKeys: String, CodingKey {
        case comName, locName, obsDt, howMany, speciesCode
    }
}
