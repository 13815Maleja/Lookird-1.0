import Foundation
import SwiftUI
import FirebaseAuth

struct BirdViewCustomTableCell: View {
    let bird: EBirdGeneral
    var viewModel: ViewModel
    
    @State private var navigateToDetail = false
    @State private var showLogSheet = false
    @State private var locationText = ""
    
    let gradientBackground = LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.1, green: 0.15, blue: 0.45), Color(red: 0, green: 0.7, blue: 0.5)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(bird.comName)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.primary)
                Text(bird.sciName)
                    .font(.system(.subheadline, design: .rounded))
                    .italic()
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            HStack(spacing: 12) {
                Button(action: { showLogSheet = true }) {
                    Image(systemName: "eye.circle.fill")
                        .font(.title2)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.orange)
                }
                
                Button(action: { navigateToDetail = true }) {
                    Image(systemName: "info.circle.fill")
                        .font(.title2)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.indigo)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.9))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .navigationDestination(isPresented: $navigateToDetail) {
            DetailBirdView(speciesCode: bird.speciesCode, viewModel: viewModel)
        }
        .sheet(isPresented: $showLogSheet) {
            logSheetContent
        }
    }
    
    private var logSheetContent: some View {
        NavigationStack {
            ZStack {
                gradientBackground
                    .ignoresSafeArea()
                Form {
                    Section {
                        LabeledContent {
                            Text(bird.comName)
                                .fontWeight(.bold)
                        } label: {
                            Text("Ave").foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("UBICACIÓN")
                                .font(.caption2.bold())
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.orange)
                                TextField("¿Dónde la viste?", text: $locationText)
                            }
                        }
                        .padding(.vertical, 4)
                    } header: {
                        Text("Detalles del Avistamiento")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Crear Bitácora")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { showLogSheet = false }
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") { saveSighting() }
                        .fontWeight(.bold)
                        .foregroundColor(locationText.isEmpty ? .white.opacity(0.5) : .white)
                        .disabled(locationText.isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
    
    
    private func saveSighting() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        viewModel.createNoteWith(
            title: bird.comName,
            text: "Ubicación: \(locationText)", userId: "\(userId)"
        )
        showLogSheet = false
        locationText = ""
    }
    
}
