import SwiftUI

struct DismissView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            Spacer()
            Button("Cerrar") {
                dismiss()
            }
            .tint(.white)
            .padding(.trailing, 12)
        }
        .buttonStyle(.bordered)
    }
}

struct DismissView_Previews: PreviewProvider {
    static var previews: some View {
        DismissView()
    }
}
