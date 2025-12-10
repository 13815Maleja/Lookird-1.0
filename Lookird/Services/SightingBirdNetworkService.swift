import Foundation

class SightingBirdNetworkService {
    private let apiKey = "s62vr78abik8"
    
    func fetchRecentSightings(regionCode: String = "CO") async throws -> [EBirdSighting] {
        let urlString = "https://api.ebird.org/v2/data/obs/\(regionCode)/recent?locale=es"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-eBirdApiToken")
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([EBirdSighting].self, from: data)
    }
}
