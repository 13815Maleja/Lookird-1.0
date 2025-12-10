import SwiftUI
import FirebaseAuth

struct CreateSightingView: View {
    
    var viewModel: ViewModel
    @State var title: String = ""
    @State var text: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    let gradientBackground = LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.1, green: 0.15, blue: 0.45), Color(red: 0, green: 0.7, blue: 0.5)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        NavigationStack {
            ZStack {
                gradientBackground
                    .ignoresSafeArea()
                Form {
                    Section {
                        HStack {
                            Image(systemName: "bird.fill")
                                .foregroundColor(.orange)
                            TextField("Ave*", text: $title)
                        }
                        
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.orange)
                            TextField("¿Dónde la viste?*", text: $text)
                        }
                    } footer: {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("*Campos obligatorios")
                                .foregroundColor(.orange)
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.9))
                }
                .scrollContentBackground(.hidden)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Nuevo Avistamiento")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if let currentUserId = Auth.auth().currentUser?.uid {
                            print("📝 Intentando guardar para el usuario: \(currentUserId)")
                            viewModel.createNoteWith(title: title, text: text, userId: currentUserId)
                            dismiss()
                        } else {
                            print("🚨 Error: No hay usuario en Firebase")
                        }
                    } label: {
                        Text("Guardar")
                            .bold()
                    }
                    .foregroundColor(.white)
                    .disabled(title.isEmpty || text.isEmpty)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}
