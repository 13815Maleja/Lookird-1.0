import Foundation

protocol CreateSightingProtocol {
    func crateSightingWith(title: String, text: String, userId: String) async throws
}

class CreateSightingUseCase: CreateSightingProtocol {
    private let database: SightingDataBaseProtocol
    
    init(database: SightingDataBaseProtocol = SightingDataBase.shared) {
        self.database = database
    }
    
    func crateSightingWith(title: String, text: String, userId: String) async throws {
        print("DEBUG: Intentando guardar nota para user: \(userId)") 
        let newNote = Home(userId: userId, title: title, text: text)
        try await database.insert(note: newNote)
    }
}
