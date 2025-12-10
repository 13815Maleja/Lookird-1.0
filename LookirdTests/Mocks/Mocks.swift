import Foundation
@testable import Lookird

var mockDatabase: [Home] = []

struct CreateSightingMock: CreateSightingProtocol {
    
    func crateSightingWith(title: String, text: String, userId: String) throws {
        let sighting = Home(userId: userId, title: title, text: text, createdAt: .now)
        mockDatabase.append(sighting)
    }
    
}

struct FetchAllSightingUseCaseMock: FetchAllSightingProtocol {
    func fechAll() throws -> [Home] {
        return mockDatabase
    }
}

struct UpdateSightingUseCaseMock: UpdateSightingProtocol {
    func UpdateSightingWith(identifier: UUID, title: String, text: String?) throws {
        if let index = mockDatabase.firstIndex(where: { $0.identifier == identifier }) {
            mockDatabase[index].title = title
            mockDatabase[index].text = text
        }
    }

}

struct RemoveSightinUseCaseMock: RemoveSightingProtocol {
    func RemoveSightingWith(identifier: UUID) throws {
        if let index = mockDatabase.firstIndex(where: {$0.identifier == identifier}) {
            mockDatabase.remove(at: index)
        }
    }
}


