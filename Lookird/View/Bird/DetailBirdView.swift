import SwiftUI
import UIKit

struct DetailBirdView: View {
    let speciesCode: String
    var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var isShowingFullScreenImage = false
    
    let gradientBackground = LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.1, green: 0.15, blue: 0.45), Color(red: 0, green: 0.7, blue: 0.5)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ZStack {
            gradientBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if let detail = viewModel.selectedBirdDetail {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 25) {
                            imagePlaceholder
                            
                            mainInfoSection(detail: detail)
                            
                            technicalDataSection(detail: detail)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                } else {
                    loadingState
                }
            }
        }
        .onAppear {
            viewModel.loadBirdDetail(for: speciesCode)
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $isShowingFullScreenImage) {
            BirdImageViewer(imageUrl: viewModel.currentBirdImageUrl)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
            Spacer()
            Text("Ficha Técnica")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            Color.clear.frame(width: 45, height: 45)
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    private var imagePlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.15))
                .frame(height: 250)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            
            if let imageUrlString = viewModel.currentBirdImageUrl, let url = URL(string: imageUrlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView().tint(.white)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .onTapGesture {
                                isShowingFullScreenImage = true
                            }
                    case .failure:
                        Image(systemName: "bird.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                            .foregroundColor(.white.opacity(0.8))
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "bird.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                    .foregroundColor(.white.opacity(0.8))
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
            }
        }
        .padding(.top, 10)
    }
    
    private func mainInfoSection(detail: EBirdSpeciesDetail) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Text(detail.comName)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(detail.sciName)
                .font(.title3)
                .italic()
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.vertical, 10)
    }
    
    private func technicalDataSection(detail: EBirdSpeciesDetail) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Label("Detalles Taxonómicos", systemImage: "info.circle.fill")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            Group {
                detailRow(label: "Familia", value: detail.familyComName, icon: "tree.fill")
                detailRow(label: "Orden", value: detail.order, icon: "leaf.fill")
                detailRow(label: "Categoría", value: detail.category, icon: "tag.fill")
                detailRow(label: "Cód. Especie", value: detail.speciesCode, icon: "number")
            }
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black.opacity(0.15))
                .background(Blur(style: .systemThinMaterialDark).cornerRadius(25))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
    
    private func detailRow(label: String, value: String, icon: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 25)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            Spacer()
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
}

struct BirdImageViewer: View {
    let imageUrl: String?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white.opacity(0.7))
                            .padding()
                    }
                }
                
                Spacer()
                
                if let urlString = imageUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .padding(10)
                    } placeholder: {
                        ProgressView().tint(.white)
                    }
                }
                
                Spacer()
            }
        }
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.height > 100 {
                    dismiss()
                }
            }
        )
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct DetailBirdView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ViewModel()
        vm.selectedBirdDetail = EBirdSpeciesDetail(
            sciName: "Vultur gryphus",
            comName: "Cóndor de los Andes",
            speciesCode: "condor",
            category: "Species",
            order: "Cathartiformes",
            familyComName: "Catártidos",
            familySciName: "Cathartidae"
        )
        vm.currentBirdImageUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Vultur_gryphus_1_Luc_Viatour.jpg/500px-Vultur_gryphus_1_Luc_Viatour.jpg"
        
        return NavigationStack {
            DetailBirdView(speciesCode: "condor", viewModel: vm)
        }
    }
}

