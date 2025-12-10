import SwiftUI

struct RegisterEmailView: View {
    
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
                    Text("👋Bienvenido a")
                    Text("LookirdApp 🪶")
                        .bold()
                        .underline()
                }
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .foregroundColor(.white)
                
                VStack {
                    Text("Regístrate para descubrir el mundo de las aves al alcance de tu mano.")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    
                    TextField("Añade tu correo electrónico", text: $textFieldEmail)
                        .textFieldStyle(.roundedBorder)
                        .padding(.bottom, 10)
                    
                    SecureField("Escribe tu contraseña", text: $textFieldPassword)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Aceptar") {
                        authenticationViewModel.createNewUser(email: textFieldEmail,
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

struct RegisterEmailView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterEmailView(authenticationViewModel: AuthenticationViewModel())
    }
}
