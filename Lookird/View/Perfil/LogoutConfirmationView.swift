import SwiftUI

struct LogoutConfirmationView: View {
    @Binding var isShowing: Bool
    var onConfirmLogout: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.001)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        isShowing = false
                    }
                }
            
            VStack(spacing: 24) {
                iconHeader
                textSection
                HStack(spacing: 15) {
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isShowing = false
                        }
                    }) {
                        Text("Cancelar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        onConfirmLogout()
                    }) {
                        Text("Salir")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 30)
            .contentShape(Rectangle())
            .transition(.asymmetric(
                insertion: .scale(scale: 0.9).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            ))
        }
        .zIndex(100)
    }
    
    private var iconHeader: some View {
        ZStack {
            Circle().fill(Color.red.opacity(0.1)).frame(width: 80, height: 80)
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.red)
        }.padding(.top, 10)
    }
    
    private var textSection: some View {
        VStack(spacing: 10) {
            Text("¿Cerrar sesión?").font(.title3.bold()).foregroundColor(.white)
            Text("Tendrás que introducir tus datos de nuevo para entrar a tu perfil.")
                .font(.subheadline).foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center).padding(.horizontal, 20)
        }
    }
}
