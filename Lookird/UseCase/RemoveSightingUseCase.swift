import Foundation

protocol RemoveSightingProtocol {
    func removeSightingWith(id: String) async throws
}

class RemoveSightingUseCase: RemoveSightingProtocol {
    private let database: SightingDataBaseProtocol
    
    init(database: SightingDataBaseProtocol = SightingDataBase.shared) {
        self.database = database
    }
    
    func removeSightingWith(id: String) async throws {
        try await database.remove(id: id)
    }
}
