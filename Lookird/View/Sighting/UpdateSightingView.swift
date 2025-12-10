import SwiftUI

struct UpdateSightingView: View {
    var viewModel: ViewModel
    let identifier: String
    
    @State var title: String = ""
    @State var text: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    let gradientBackground = LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.1, green: 0.15, blue: 0.45), Color(red: 0, green: 0.7, blue: 0.5)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ZStack {
            gradientBackground
                .ignoresSafeArea()
            
            VStack {
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
                    }
                    .listRowBackground(Color.white.opacity(0.85))
                }
                .scrollContentBackground(.hidden)
                
                Button(action: {
                    
                    viewModel.removeNote(id: identifier)
                    dismiss()
                }, label: {
                    Text("Eliminar avistamiento")
                        .foregroundStyle(.white)
                        .bold()
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.red.opacity(0.7))
                        .cornerRadius(10)
                })
                .padding(.bottom, 20)
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Modificar")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button {
                    
                    viewModel.updateNotesWith(id: identifier, title: title, text: text)
                    dismiss()
                } label: {
                    Text("Guardar")
                        .bold()
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        
        UpdateSightingView(
            viewModel: ViewModel(),
            identifier: "FIREBASE_DOC_ID_123",
            title: "Colibrí",
            text: "Parque Nacional, 2026"
        )
    }
}
