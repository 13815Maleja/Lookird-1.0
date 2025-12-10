import Foundation
import FirebaseFirestore
import FirebaseAuth

enum DatabaseError: Error {
    case errorInsert
    case errorFetch
    case errorUpdate
    case errorRemove
    case noUserAuthenticated
    case userNotFound
}

protocol SightingDataBaseProtocol {
    func insert(note: Home) async throws
    func fetchAll() async throws -> [Home]
    func update(id: String, title: String, text: String?) async throws
    func remove(id: String) async throws
    func fetchUserProfile() async throws -> [String: Any]
    func updateUserProfile(data: [String: Any]) async throws
}

class SightingDataBase: SightingDataBaseProtocol {
    static let shared = SightingDataBase()
    private let db = Firestore.firestore()
    private let collectionName = "notes"
    private let usersCollection = "users"
    
    private init() {}
    
    func insert(note: Home) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { throw DatabaseError.noUserAuthenticated }
        
        var noteToSave = note
        noteToSave.userId = uid
        
        let docRef = db.collection(collectionName).document()
        noteToSave.id = docRef.documentID
        
        try docRef.setData(from: noteToSave)
    }
    
    func fetchAll() async throws -> [Home] {
        guard let uid = Auth.auth().currentUser?.uid else { throw DatabaseError.noUserAuthenticated }
        
        let snapshot = try await db.collection(collectionName)
            .whereField("userId", isEqualTo: uid)
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: Home.self) }
    }
    
    func update(id: String, title: String, text: String?) async throws {
        let docRef = db.collection(collectionName).document(id)
        try await docRef.updateData([
            "title": title,
            "text": text ?? "",
            "updatedAt": FieldValue.serverTimestamp()
        ])
    }
    
    func remove(id: String) async throws {
        try await db.collection(collectionName).document(id).delete()
    }
    
    func fetchUserProfile() async throws -> [String: Any] {
        guard let uid = Auth.auth().currentUser?.uid else { throw DatabaseError.noUserAuthenticated }
        let document = try await db.collection(usersCollection).document(uid).getDocument()
        return document.data() ?? [:]
    }
    
    func updateUserProfile(data: [String: Any]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { throw DatabaseError.noUserAuthenticated }
        try await db.collection(usersCollection).document(uid).setData(data, merge: true)
    }
}
