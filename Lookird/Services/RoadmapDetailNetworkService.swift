import Foundation

class RoadmapDetailNetworkService {
    private let apiKey = "s62vr78abik8"
    
    func fetchHotspotDetails(for locationId: String) async throws -> EBirdHotspotDetail {
        let urlString = "https://api.ebird.org/v2/ref/hotspot/info/\(locationId)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-eBirdApiToken")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(EBirdHotspotDetail.self, from: data)
    }
}
