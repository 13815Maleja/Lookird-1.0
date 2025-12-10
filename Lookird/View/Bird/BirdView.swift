import SwiftUI

struct BirdView: View {
    @State private var searchText = ""
    @Binding var showMenu: Bool
    var viewModel: ViewModel
    
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
                
                VStack(spacing: 0) {
                    searchField
                    
                    if viewModel.isLoading {
                        loadingState
                    } else if filteredBirds.isEmpty && !searchText.isEmpty {
                        loadingState
                    } else {
                        List {
                            ForEach(filteredBirds) { bird in
                                BirdViewCustomTableCell(bird: bird, viewModel: viewModel)
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { withAnimation(.spring()) { showMenu.toggle() } }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "bird.fill")
                        Text("Explorar Aves")
                            .font(.system(.headline, design: .rounded))
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .cornerRadius(showMenu ? 35 : 0)
        .shadow(color: .black.opacity(showMenu ? 0.3 : 0), radius: 20)
        .offset(x: showMenu ? 260 : 0)
        .scaleEffect(showMenu ? 0.85 : 1)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: showMenu)
        .onAppear { viewModel.loadColombiaSpecies() }
    }
    
    private var loadingState: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
            Text("Consultando base de datos eBird...")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxHeight: .infinity)
    }
    
    private var filteredBirds: [EBirdGeneral] {
        if searchText.isEmpty {
            return viewModel.colombiaSpecies
        } else {
            return viewModel.colombiaSpecies.filter { $0.comName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.8))
            
            TextField("", text: $searchText, prompt:
                        Text("¿Qué ave buscas?")
                .foregroundColor(.white.opacity(0.6))
            )
            .foregroundColor(.white)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .padding(.top, 15)
        .padding(.bottom, 10)
    }
}

struct BirdView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ViewModel()
        vm.colombiaSpecies = [
            EBirdGeneral(comName: "Colibrí Esmeralda", sciName: "Amazilia tzacatl", speciesCode: "1"),
            EBirdGeneral(comName: "Cóndor de los Andes", sciName: "Vultur gryphus", speciesCode: "2")
        ]
        return BirdView(showMenu: .constant(false), viewModel: vm)
    }
}
