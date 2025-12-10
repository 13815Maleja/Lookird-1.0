import Foundation
import FirebaseFirestore

struct Home: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var title: String
    var text: String?
    var userId: String
    @ServerTimestamp var createdAt: Date?
    
    var getText: String {
        text ?? ""
    }
    
    init(id: String? = nil, userId: String, title: String, text: String?, createdAt: Date? = nil) {
        self.id = id
        self.userId = userId
        self.title = title
        self.text = text
        self.createdAt = createdAt
    }
}
