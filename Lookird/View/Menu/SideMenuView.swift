import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @Binding var selectedOption: MenuOption
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            LinearGradient(gradient: Gradient(colors: [.indigo, .purple]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 4) {
                    Image(systemName: "bird.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.white)
                    
                    Text("Lookird App")
                        .font(.title2).bold()
                        .foregroundStyle(.white)
                }
                .padding(.top, 50)
                .padding(.bottom, 20)
                VStack(alignment: .leading, spacing: 32) {
                    
                    MenuOptionRow(icon: "person.crop.circle", title: "Perfil") {
                        selectedOption = .perfil
                        withAnimation(.spring()) { isShowing = false }
                    }
                    MenuOptionRow(icon: "map", title: "Rutas") {
                        selectedOption = .rutas
                        withAnimation(.spring()) { isShowing = false }
                    }
                    
                    MenuOptionRow(icon: "bird", title: "Aves") {
                        selectedOption = .aves
                        withAnimation(.spring()) { isShowing = false }
                    }
                    
                    MenuOptionRow(icon: "book", title: "Bitácoras") {
                        selectedOption = .bitacoras
                        withAnimation(.spring()) { isShowing = false }
                    }
                    
                    MenuOptionRow(icon: "calendar", title: "Eventos") {
                        selectedOption = .eventos
                        withAnimation(.spring()) { isShowing = false }
                    }
                }
                
                Spacer()
            }
            .padding(.leading, 20)
        }
    }
}

struct MenuOptionRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.headline)
                    .frame(width: 25)
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundStyle(.white)
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(
            isShowing: .constant(true),
            selectedOption: .constant(.rutas)
        )
    }
}
