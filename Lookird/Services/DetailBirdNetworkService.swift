import Foundation

class DetailBirdNetworkService {
    private let apiKey = "s62vr78abik8"
    
    func fetchSpeciesDetail(code: String) async throws -> EBirdSpeciesDetail {
        
        let urlString = "https://api.ebird.org/v2/ref/taxonomy/ebird?fmt=json&species=\(code)&locale=es"
        
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-eBirdApiToken")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let details = try JSONDecoder().decode([EBirdSpeciesDetail].self, from: data)
        
        guard let detail = details.first else { throw URLError(.fileDoesNotExist) }
        return detail
    }
}
