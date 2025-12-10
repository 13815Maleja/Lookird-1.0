
import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @Binding var viewModel: ViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @Binding var showMenu: Bool
    @State private var showCreateSighthing: Bool = false
    @State private var animateItems: Bool = false
    
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
                
                VStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 0) {
                        headerLabel(title: "Mis Notas", systemImage: "pencil.and.outline")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                        
                        let currentUserID = Auth.auth().currentUser?.uid ?? ""
                        let userNotes = viewModel.notes.filter { $0.userId == currentUserID }
                        
                        ScrollView(showsIndicators: false) {
                            if userNotes.isEmpty {
                                emptyStatePersonalView
                            } else {
                                VStack(spacing: 12) {
                                    ForEach(Array(userNotes.enumerated()), id: \.element.id) { index, note in
                                        personalNoteCell(note: note)
                                            .opacity(animateItems ? 1 : 0)
                                            .offset(y: animateItems ? 0 : 20)
                                            .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.1), value: animateItems)
                                    }
                                }
                                .padding(.bottom, 15)
                            }
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        headerLabel(title: "Comunidad eBird", systemImage: "network")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                        
                        ScrollView(showsIndicators: false) {
                            if viewModel.publicSightings.isEmpty {
                                loadingPlaceholder()
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 40)
                            } else {
                                VStack(spacing: 12) {
                                    ForEach(Array(viewModel.publicSightings.prefix(10).enumerated()), id: \.element.id) { index, bird in
                                        communityBirdCell(bird: bird)
                                            .opacity(animateItems ? 1 : 0)
                                            .scaleEffect(animateItems ? 1 : 0.95)
                                            .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(index) * 0.1), value: animateItems)
                                    }
                                }
                                .padding(.bottom, 15)
                            }
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
                .padding(.top, 10)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        floatingActionButton
                            .padding(.trailing, 25)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { mainToolbar }
            .fullScreenCover(isPresented: $showCreateSighthing) {
                CreateSightingView(viewModel: viewModel)
            }
        }
        .onAppear {
            withAnimation { animateItems = true }
            viewModel.fetchNotes()
            viewModel.loadPublicSightings()
        }
    }
    
    private func personalNoteCell(note: Home) -> some View {
        NavigationLink(destination: UpdateSightingView(
            viewModel: viewModel,
            identifier: note.id ?? "",
            title: note.title,
            text: note.text ?? ""
        )) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "bird.fill")
                            .font(.caption)
                        Text(note.title)
                            .font(.headline)
                    }
                    .foregroundColor(.indigo)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.caption2)
                        Text(formatLocation(note.text ?? ""))
                            .font(.subheadline)
                    }
                    .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white.opacity(0.95))
            .cornerRadius(15)
            .padding(.horizontal)
        }
    }
    
    private func communityBirdCell(bird: EBirdSighting) -> some View {
        NavigationLink(destination: DetailBirdView(speciesCode: bird.speciesCode, viewModel: viewModel)) {
            HStack {
                VStack(alignment: .leading) {
                    Text(bird.comName)
                        .bold()
                        .foregroundColor(.primary)
                    Text(bird.locName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                Spacer()
                Image(systemName: "binoculars.fill")
                    .foregroundColor(.orange.opacity(0.8))
            }
            .padding()
            .background(Color.white.opacity(0.85))
            .cornerRadius(15)
            .padding(.horizontal)
        }
    }
    
    private var mainToolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { withAnimation(.spring()) { showMenu.toggle() } }) {
                    Image(systemName: "line.3.horizontal")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    Image(systemName: "bird.fill")
                        .foregroundColor(.white)
                    Text("Bitácora")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func headerLabel(title: String, systemImage: String) -> some View {
        Label(title, systemImage: systemImage)
            .font(.system(.subheadline, design: .rounded).bold())
            .foregroundColor(.white)
    }
    
    private var floatingActionButton: some View {
        Button(action: { showCreateSighthing.toggle() }) {
            Image(systemName: "plus")
                .font(.title.bold())
                .foregroundColor(.white)
                .padding(20)
                .background(Circle().fill(LinearGradient(colors: [.indigo, .blue], startPoint: .top, endPoint: .bottom)))
                .shadow(radius: 10)
        }
    }
    
    private func formatLocation(_ text: String) -> String {
        text.isEmpty ? "Ubicación desconocida" : text
    }
    
    private var emptyStatePersonalView: some View {
        VStack(spacing: 15) {
            Image(systemName: "bird")
                .font(.system(size: 40))
                .foregroundStyle(.white.opacity(0.4))
            Text("No hay notas aún").foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }
    
    private func loadingPlaceholder() -> some View {
        ProgressView().tint(.white)
    }
}
