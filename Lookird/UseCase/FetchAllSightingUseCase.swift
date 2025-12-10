import Foundation

protocol FetchAllSightingProtocol {
    func fechAll() async throws -> [Home]
}

class FetchAllSightingUseCase: FetchAllSightingProtocol {
    private let database: SightingDataBaseProtocol
    
    init(database: SightingDataBaseProtocol = SightingDataBase.shared) {
        self.database = database
    }
    
    func fechAll() async throws -> [Home] {
        return try await database.fetchAll()
    }
}
