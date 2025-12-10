import SwiftUI

struct MainView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @State private var sightingViewModel = ViewModel()
    @State var showMenu = false
    @State private var selectedOption: MenuOption = .perfil
    
    var body: some View {
        ZStack {
            SideMenuView(isShowing: $showMenu, selectedOption: $selectedOption)
            
            Group {
                switch selectedOption {
                case .perfil:
                    ProfileView(showMenu: $showMenu,
                                authenticationViewModel: authenticationViewModel)
                case .rutas:
                    RoadmapView(viewModel: sightingViewModel,
                                showMenu: $showMenu)
                case .aves:
                    BirdView(showMenu: $showMenu,
                             viewModel: sightingViewModel)
                case .bitacoras:
                    ContentView(
                        viewModel: $sightingViewModel,
                        authenticationViewModel: authenticationViewModel,
                        showMenu: $showMenu
                    )
                case .eventos:
                    ZStack {
                        Color.indigo.ignoresSafeArea()
                        Text("Próximamente: Eventos").foregroundColor(.white)
                    }
                }
            }
            .mask(RoundedRectangle(cornerRadius: showMenu ? 30 : 0))
            .scaleEffect(showMenu ? 0.82 : 1)
            .offset(x: showMenu ? 260 : 0)
            .shadow(color: .black.opacity(showMenu ? 0.3 : 0), radius: 20)
            .ignoresSafeArea(edges: showMenu ? [] : .all)
            .disabled(showMenu)
        }
        .background(Color.indigo)
        .onAppear {
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0), value: showMenu)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(authenticationViewModel: AuthenticationViewModel())
    }
}
