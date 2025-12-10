import Foundation

protocol UpdateSightingProtocol {
    func updateSightingWith(id: String, title: String, text: String?) async throws
}

class UpdateSightingUseCase: UpdateSightingProtocol {
    private let database: SightingDataBaseProtocol
    
    init(database: SightingDataBaseProtocol = SightingDataBase.shared) {
        self.database = database
    }
    
    func updateSightingWith(id: String, title: String, text: String?) async throws {
        try await database.update(id: id, title: title, text: text)
    }
}
