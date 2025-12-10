import Foundation

struct EBirdHotspotDetail: Codable, Identifiable {
    
    var id: String { locId }
    
    let locId: String
    let name: String
    let latitude: Double
    let longitude: Double
    
    let countryCode: String
    let subnational1Code: String
    let numSpeciesAllTime: Int?
    
    enum CodingKeys: String, CodingKey {
        case locId, name, countryCode, subnational1Code, numSpeciesAllTime
        case latitude = "lat"
        case longitude = "lng"
    }
}
