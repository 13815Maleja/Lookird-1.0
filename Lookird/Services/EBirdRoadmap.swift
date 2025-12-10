import Foundation

struct EBirdRoadmap: Codable, Identifiable {
    let locId: String
    let locName: String
    let latitude: Double
    let longitude: Double
    let numSpeciesAllTime: Int?
    
    var id: String { locId }
    
    enum CodingKeys: String, CodingKey {
        case locId, locName, numSpeciesAllTime
        case latitude = "lat"
        case longitude = "lng"
    }
}
