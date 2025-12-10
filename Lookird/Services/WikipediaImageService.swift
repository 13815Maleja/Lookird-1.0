import Foundation

class WikipediaImageService {
    
    func fetchBirdImage(scientificName: String) async -> String? {
        let query = scientificName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://es.wikipedia.org/w/api.php?action=query&titles=\(query)&prop=pageimages&format=json&pithumbsize=500"
        
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let queryDict = json["query"] as? [String: Any],
                  let pages = queryDict["pages"] as? [String: Any] else { return nil }
            
            if let firstPageKey = pages.keys.first,
               let pageData = pages[firstPageKey] as? [String: Any],
               let thumbnail = pageData["thumbnail"] as? [String: Any],
               let source = thumbnail["source"] as? String {
                return source
            }
        } catch {
            print("Error buscando imagen: \(error)")
        }
        return nil
    }
}
