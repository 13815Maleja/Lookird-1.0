import SwiftUI

struct LoginEmailView: View {
    
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @State var textFieldEmail: String = ""
    @State var textFieldPassword: String = ""
    
    let gradientBackground = LinearGradient(
        gradient: Gradient(colors: [.indigo, .purple]), startPoint: .top, endPoint: .bottom
    )
    
    var body: some View {
        ZStack {
            gradientBackground
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                DismissView()
                    .padding(.top, 8)
                Group {
                    Text("👋Bienvenido de nuevo a")
                    Text("LookirdApp 🪶")
                        .bold()
                        .underline()
                }
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .foregroundColor(.white)
                
                VStack {
                    Text("Loguéate para descubrir el mundo de las aves.")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    
                    TextField("Añade tu correo electrónico", text: $textFieldEmail)
                        .textFieldStyle(.roundedBorder)
                        .padding(.bottom, 10)
                    
                    SecureField("Escribe tu contraseña", text: $textFieldPassword)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Aceptar") {
                        authenticationViewModel.login(email: textFieldEmail,
                                                      password: textFieldPassword)
                    }
                    .padding(.top, 20)
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    .foregroundColor(.purple)
                    if let messageError = authenticationViewModel.messageError {
                        Text(messageError)
                            .bold()
                            .font(.body)
                            .foregroundColor(.red)
                            .padding(.top, 20)
                    }
                }
                .padding(.horizontal, 40)
                Spacer()
            }
        }
    }
}

struct LoginEmailView_Previews: PreviewProvider {
    static var previews: some View {
        LoginEmailView(authenticationViewModel: AuthenticationViewModel())
    }
}
