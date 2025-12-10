import Foundation
import SwiftUI
import Observation
import SwiftData
import FirebaseFirestore
import FirebaseAuth
internal import Combine

@Observable
class ViewModel {
    
    var notes: [Home] = []
    var databaseErorr: DatabaseError?
    
    var createSightingUseCase: CreateSightingProtocol
    var fetchAllSightingUseCase: FetchAllSightingProtocol
    var updateSightingUseCase: UpdateSightingProtocol
    var removeSightingUseCase: RemoveSightingProtocol
    
    var publicSightings: [EBirdSighting] = []
    var roadmapRoutes: [EBirdRoadmap] = []
    var colombiaSpecies: [EBirdGeneral] = []
    var selectedBirdDetail: EBirdSpeciesDetail?
    var currentBirdImageUrl: String? = nil
    var selectedRouteDetail: EBirdHotspotDetail?
    
    var userName: String = ""
    var userPhone: String = ""
    var userBio: String = ""
    var isUpdatingProfile: Bool = false
    
    let networkService = SightingBirdNetworkService()
    let roadmapService = RoadmapNetworkService()
    let birdService = BirdNetworkService()
    let detaiBlirdService = DetailBirdNetworkService()
    let wikiService = WikipediaImageService()
    
    var isLoading: Bool = false
    
    init(notes: [Home] = [],
         createSightingUseCase: CreateSightingProtocol = CreateSightingUseCase(),
         fetchAllSightingUseCase: FetchAllSightingProtocol = FetchAllSightingUseCase(),
         updateSightingUseCase: UpdateSightingProtocol = UpdateSightingUseCase(),
         removeSightingUseCase: RemoveSightingProtocol = RemoveSightingUseCase()) {
        
        self.notes = notes
        self.createSightingUseCase = createSightingUseCase
        self.fetchAllSightingUseCase = fetchAllSightingUseCase
        self.updateSightingUseCase = updateSightingUseCase
        self.removeSightingUseCase = removeSightingUseCase
        
        fetchNotes()
        loadUserProfile()
    }
    
    
    func fetchNotes() {
        Task {
            do {
                print("🔄 Iniciando descarga de notas...")
                let fetchedNotes = try await fetchAllSightingUseCase.fechAll()
                
                await MainActor.run {
                    self.notes = fetchedNotes
                    print("✅ Notas cargadas con éxito: \(self.notes.count)")
                }
            } catch {
                print("❌ Error al cargar notas en ViewModel: \(error.localizedDescription)")
            }
        }
    }
    
    func createNoteWith(title: String, text: String, userId: String) {
        Task {
            do {
                try await createSightingUseCase.crateSightingWith(title: title, text: text, userId: userId)
                fetchNotes()
            } catch {
                print("❌ Error al crear: \(error.localizedDescription)")
            }
        }
    }
    
    func updateNotesWith(id: String, title: String, text: String) {
        Task {
            do {
                try await updateSightingUseCase.updateSightingWith(id: id, title: title, text: text)
                // Refrescar datos
                await fetchNotes()
            } catch {
                print("❌ Error al actualizar: \(error.localizedDescription)")
            }
        }
    }
    
    func removeNote(id: String) {
        Task {
            do {
                try await removeSightingUseCase.removeSightingWith(id: id)
                // Actualizamos la lista local después de borrar
                await MainActor.run {
                    self.notes.removeAll { $0.id == id }
                }
            } catch {
                print("❌ Error al eliminar: \(error.localizedDescription)")
            }
        }
    }
    
    
    func loadUserProfile() {
        Task {
            do {
                let profileData = try await SightingDataBase.shared.fetchUserProfile()
                print("Datos recibidos: \(profileData)")
                await MainActor.run {
                    self.userName = profileData["name"] as? String ?? ""
                    self.userPhone = profileData["phone"] as? String ?? ""
                    self.userBio = profileData["bio"] as? String ?? ""
                }
            } catch {
                print("❌ Error al cargar perfil: \(error.localizedDescription)")
            }
        }
    }
    
    func updateProfile() {
        self.isUpdatingProfile = true
        
        let updatedData: [String: Any] = [
            "name": userName,
            "phone": userPhone,
            "bio": userBio,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        Task {
            do {
                try await SightingDataBase.shared.updateUserProfile(data: updatedData)
                await MainActor.run {
                    self.isUpdatingProfile = false
                    print("✅ Perfil actualizado")
                }
            } catch {
                await MainActor.run {
                    self.isUpdatingProfile = false
                    print("❌ Error al actualizar perfil: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    func loadPublicSightings() {
        Task {
            do {
                let sightings = try await networkService.fetchRecentSightings(regionCode: "CO")
                await MainActor.run { self.publicSightings = sightings }
            } catch { print("Error API eBird: \(error)") }
        }
    }
    
    func loadRoadmap() {
        self.isLoading = true
        Task {
            do {
                let routes = try await roadmapService.fetchColombiaRoutes()
                await MainActor.run {
                    self.roadmapRoutes = routes
                }
            } catch {
                print("Error Roadmap: \(error)")
            }
            
            await MainActor.run {
                withAnimation {
                    self.isLoading = false
                }
            }
            
        }
    }
    
    func loadColombiaSpecies() {
        self.isLoading = true
        
        Task {
            do {
                let species = try await birdService.fetchColombiaSpecies()
                
                await MainActor.run {
                    self.colombiaSpecies = species
                }
            } catch {
                print("❌ Error al cargar especies: \(error.localizedDescription)")
            }
            await MainActor.run {
                withAnimation {
                    self.isLoading = false
                }
            }
        }
    }
    
    func loadBirdDetail(for code: String) {
        Task {
            do {
                let detail = try await detaiBlirdService.fetchSpeciesDetail(code: code)
                let imageUrl = await wikiService.fetchBirdImage(scientificName: detail.sciName)
                await MainActor.run {
                    self.selectedBirdDetail = detail
                    self.currentBirdImageUrl = imageUrl
                }
            } catch { print("Error Detalle Ave: \(error)") }
        }
    }
    
    func loadRouteDetail(for locId: String) {
        Task {
            do {
                let routeService = RoadmapDetailNetworkService()
                let detail = try await routeService.fetchHotspotDetails(for: locId)
                await MainActor.run { self.selectedRouteDetail = detail }
            } catch { print("Error Ruta Detail: \(error)") }
        }
    }
}
