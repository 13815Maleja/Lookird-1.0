import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileView: View {
    
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @Binding var showMenu: Bool
    
    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var bio: String = ""
    
    @State private var isSaving: Bool = false
    @State private var isExistingUser: Bool = false
    @State private var isLoadingData: Bool = true
    
    @State private var showLogoutConfirmationView: Bool = false
    
    let gradientBackground = LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.1, green: 0.15, blue: 0.45), Color(red: 0, green: 0.7, blue: 0.5)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    init(showMenu: Binding<Bool>, authenticationViewModel: AuthenticationViewModel) {
        self._showMenu = showMenu
        self.authenticationViewModel = authenticationViewModel
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                gradientBackground
                    .ignoresSafeArea()
                
                if isLoadingData {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 25) {
                            headerSection
                            
                            formSection
                        }
                    }
                    .blur(radius: showLogoutConfirmationView ? 4 : 0)
                    .disabled(showLogoutConfirmationView)
                }
                
                if showLogoutConfirmationView {
                    LogoutConfirmationView(isShowing: $showLogoutConfirmationView) {
                        authenticationViewModel.logout()
                    }
                    .zIndex(100)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { withAnimation(.spring()) { showMenu.toggle() } }) {
                        Image(systemName: "line.3.horizontal").foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.spring()) {
                            showLogoutConfirmationView = true
                        }
                    }) {
                        Image(systemName: "door.right.hand.open").foregroundColor(.white)
                    }
                }
            }
            .onAppear(perform: fetchUserData)
        }
        .mask(RoundedRectangle(cornerRadius: showMenu ? 30 : 0))
        .shadow(color: .black.opacity(showMenu ? 0.3 : 0), radius: 20, x: -10, y: 0)
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle().fill(.white.opacity(0.15)).frame(width: 120, height: 120).blur(radius: 10)
                Image(systemName: "person.circle.fill").resizable().aspectRatio(contentMode: .fit).frame(width: 100, height: 100).foregroundColor(.white).shadow(radius: 10)
            }
            .padding(.top, 20)
            
            Text(isExistingUser ? "Hola, \(name.components(separatedBy: " ").first ?? "Usuario")" : "Completa tu Perfil")
                .font(.system(size: 24, weight: .bold, design: .rounded)).foregroundColor(.white)
            
            Text(authenticationViewModel.user?.email ?? "").font(.subheadline).foregroundColor(.white.opacity(0.7))
        }
    }
    
    private var formSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Label("Información Personal", systemImage: "person.text.rectangle").font(.headline).foregroundColor(.white.opacity(0.9))
            CustomTextField(icon: "person.fill", placeholder: "Nombre Completo", text: $name)
            CustomTextField(icon: "phone.fill", placeholder: "Teléfono", text: $phone)
            CustomTextField(icon: "text.alignleft", placeholder: "Biografía corta", text: $bio)
            
            Button(action: saveUserData) {
                HStack {
                    if isSaving { ProgressView().tint(isExistingUser ? .white : .blue) }
                    else {
                        Image(systemName: isExistingUser ? "arrow.triangle.2.circlepath" : "sparkles")
                        Text(isExistingUser ? "Actualizar datos" : "Guardar Perfil").fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity).padding().background(isExistingUser ? Color.white.opacity(0.2) : Color.white)
                .foregroundColor(isExistingUser ? .white : Color(red: 0.1, green: 0.15, blue: 0.45)).cornerRadius(15)
            }
            .disabled(isSaving)
        }
        .padding(25).background(.ultraThinMaterial).cornerRadius(30).padding(.horizontal)
    }
    
    func fetchUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { snapshot, error in
            DispatchQueue.main.async {
                self.isLoadingData = false
                if let data = snapshot?.data(), snapshot?.exists == true {
                    self.name = data["name"] as? String ?? ""
                    self.phone = data["phone"] as? String ?? ""
                    self.bio = data["bio"] as? String ?? ""
                    self.isExistingUser = true
                    print("✅ Datos cargados: \(self.name)")
                } else {
                    self.isExistingUser = false
                    print("ℹ️ El usuario no tiene datos previos.")
                }
            }
        }
    }
    
    func saveUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        isSaving = true
        
        let data: [String: Any] = [
            "name": name,
            "phone": phone,
            "bio": bio,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        Firestore.firestore().collection("users").document(userId).setData(data, merge: true) { error in
            DispatchQueue.main.async {
                isSaving = false
                if let error = error {
                    print("❌ Error al guardar: \(error.localizedDescription)")
                } else {
                    withAnimation {
                        isExistingUser = true
                    }
                    print("✅ Perfil actualizado exitosamente")
                }
            }
        }
    }
}

struct CustomTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white.opacity(0.6))
                    .frame(width: 25)
                
                TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.white.opacity(0.4)))
                    .foregroundColor(.white)
                    .autocorrectionDisabled()
            }
            Divider().background(Color.white.opacity(0.3))
        }
    }
}
