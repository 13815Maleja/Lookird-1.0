import Foundation

class RoadmapNetworkService {
    private let apiKey = "s62vr78abik8"
    
    func fetchColombiaRoutes() async throws -> [EBirdRoadmap] {
        
        let urlString = "https://api.ebird.org/v2/ref/hotspot/CO?fmt=json&locale=es"
        
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-eBirdApiToken")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let allHotspots = try JSONDecoder().decode([EBirdRoadmap].self, from: data)
        
        return allHotspots
            .compactMap { $0 }
            .sorted { ($0.numSpeciesAllTime ?? 0) > ($1.numSpeciesAllTime ?? 0) }
            .prefix(20)
            .map { $0 }
    }
}
