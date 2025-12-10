import Foundation

class BirdNetworkService {
    private let apiKey = "s62vr78abik8"
    
    func fetchColombiaSpecies() async throws -> [EBirdGeneral] {
        guard let url = URL(string: "https://api.ebird.org/v2/ref/taxonomy/ebird?fmt=json&loc=CO&locale=es") else {
            throw URLError(.badURL)
        }
        
        print("🌐 Pidiendo datos a: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "X-eBirdApiToken")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ No es una respuesta HTTP")
            throw URLError(.badServerResponse)
        }
        
        print("📊 Código de respuesta: \(httpResponse.statusCode)")
        
        return try JSONDecoder().decode([EBirdGeneral].self, from: data)
    }
}
