import Foundation
import SwiftData

class RoadmapDetail: Identifiable {
    let id = UUID()
    let locName: String = ""
    let description: String = ""
    let services: [String] = []
    let species: [EBirdGeneral] = []
}
