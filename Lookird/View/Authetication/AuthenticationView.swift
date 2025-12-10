import SwiftUI

enum AuthenticationSheetView: String, Identifiable {
    case register
    case login
    
    var id: String {
        return rawValue
    }
}

struct AuthenticationView: View {
    
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @State private var authenticationSheetView: AuthenticationSheetView?
    
    let gradientBackground = LinearGradient(
        gradient: Gradient(colors: [.indigo, Color(red: 0, green: 0.77, blue: 0.48)]),
        startPoint: .top, endPoint: .bottom
    )
    
    var body: some View {
        ZStack {
            gradientBackground
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Image("SplashIcon")
                    .resizable()
                    .frame(width: 200, height: 200)
                VStack {
                    Text("LookbirdApp")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                }
                VStack {
                    Button {
                        authenticationSheetView = .login
                    } label: {
                        Label("Entrar con Email", systemImage: "envelope.fill")
                    }
                    .tint(.white)
                }
                .controlSize(.large)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .padding(.top, 60)
                Spacer()
                HStack {
                    Button {
                        authenticationSheetView = .register
                    } label: {
                        Text("No tienes Cuenta?")
                        Text("Registrate")
                            .underline()
                    }
                    .tint(.white)
                }
            }
            .sheet(item: $authenticationSheetView) { sheet in
                switch sheet {
                case .register:
                    RegisterEmailView(authenticationViewModel: authenticationViewModel)
                case .login:
                    LoginEmailView(authenticationViewModel: authenticationViewModel)
                }
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(authenticationViewModel: AuthenticationViewModel())
    }
}
