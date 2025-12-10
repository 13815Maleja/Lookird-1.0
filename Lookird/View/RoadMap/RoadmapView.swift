import SwiftUI

struct RoadmapView: View {
    @State private var searchText = ""
    @Binding var showMenu: Bool
    var viewModel: ViewModel
    
    let gradientBackground = LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.1, green: 0.15, blue: 0.45), Color(red: 0, green: 0.7, blue: 0.5)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    init(viewModel: ViewModel, showMenu: Binding<Bool>) {
        self.viewModel = viewModel
        self._showMenu = showMenu
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    gradientBackground
                        .ignoresSafeArea()
                    
                    if viewModel.isLoading {
                        loadingState
                    } else {
                        VStack(spacing: 0) {
                            searchBar
                                .padding(.top, 5)
                            
                            List(viewModel.roadmapRoutes.filter({
                                searchText.isEmpty ? true : $0.locName.localizedCaseInsensitiveContains(searchText)
                            })) { site in
                                ZStack {
                                    NavigationLink {
                                        RoadmapDetailView(hotspot: EBirdHotspotDetail(
                                            locId: site.locId,
                                            name: site.locName,
                                            latitude: site.latitude,
                                            longitude: site.longitude,
                                            countryCode: "CO",
                                            subnational1Code: "",
                                            numSpeciesAllTime: site.numSpeciesAllTime
                                        ))
                                    } label: {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                    RoadMapTableViewCell(
                                        title: site.locName,
                                        speciesCount: site.numSpeciesAllTime ?? 0,
                                        showsChevron: true
                                    )
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                                .listRowBackground(Color.clear)
                            }
                            .environment(\.editMode, .constant(.inactive))
                            .listStyle(.plain)
                            .scrollContentBackground(.hidden)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                showMenu.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(.white)
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        HStack(spacing: 8) {
                            Image(systemName: "map.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Rutas")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .cornerRadius(showMenu ? 30 : 0)
            .shadow(color: .black.opacity(showMenu ? 0.3 : 0), radius: 20, x: -10, y: 0)
            .offset(x: showMenu ? UIScreen.main.bounds.width * 0.5 : 0)
            .scaleEffect(showMenu ? 0.85 : 1)
            .ignoresSafeArea(edges: showMenu ? [] : .all)
            .onAppear {
                viewModel.loadRoadmap()
            }
        }
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
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.white)
            TextField("Buscar ruta en Colombia...", text: $searchText)
                .foregroundColor(.black)
        }
        .padding(10)
        .background(Color(.systemGray6).opacity(0.8))
        .cornerRadius(10)
        .padding(.horizontal, 16)
    }
}

struct RoadmapView_Previews: PreviewProvider {
    static var previews: some View {
        RoadmapView(viewModel: ViewModel(),
                    showMenu: .constant(false))
    }
}

