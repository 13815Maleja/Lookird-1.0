import SwiftUI
import MapKit

struct RoadmapDetailView: View {
    let hotspot: EBirdHotspotDetail
    @Environment(\.dismiss) var dismiss
    
    @State private var region: MKCoordinateRegion
    
    init(hotspot: EBirdHotspotDetail) {
        self.hotspot = hotspot
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: hotspot.latitude, longitude: hotspot.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    let gradientBackground = LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.1, green: 0.15, blue: 0.45), Color(red: 0, green: 0.7, blue: 0.5)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ZStack(alignment: .top) {
            gradientBackground
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    mapSection
                    
                    VStack(spacing: 8) {
                        Text(hotspot.name)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Label("\(hotspot.numSpeciesAllTime ?? 0) Especies registradas", systemImage: "bird.fill")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                    }
                    
                    specificationsSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 130)
            }
            
            VStack(spacing: 0) {
                headerView
                    .padding(.top, 60)
                    .padding(.bottom, 15)
                    .background(
                        LinearGradient(colors: [.black.opacity(0.4), .clear],
                                       startPoint: .top,
                                       endPoint: .bottom)
                    )
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
            
            VStack {
                Spacer()
                fixedBottomButton
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var fixedBottomButton: some View {
        VStack(spacing: 0) {
            LinearGradient(
                gradient: Gradient(colors: [.clear, Color.black.opacity(0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 20)
            
            ZStack {
                Blur(style: .systemThinMaterialDark)
                    .ignoresSafeArea(edges: .bottom)
                
                openInMapsButton
                    .padding(.horizontal, 20)
                    .padding(.top, 15)
                    .padding(.bottom, 30)
            }
            .frame(height: 90)
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
            Text("Detalle de Ruta")
                .font(.headline).bold().foregroundColor(.white)
            Spacer()
            Color.clear.frame(width: 45, height: 45)
        }
        .padding(.horizontal).padding(.top, 10)
    }
    
    private var mapSection: some View {
        Map(initialPosition: .region(region)) {
            Annotation(hotspot.name, coordinate: CLLocationCoordinate2D(latitude: hotspot.latitude, longitude: hotspot.longitude)) {
                Image(systemName: "bird.circle.fill")
                    .font(.title)
                    .foregroundColor(.orange)
                    .background(Color.white.clipShape(Circle()))
            }
        }
        .mapStyle(.hybrid(elevation: .realistic))
        
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .padding(.top, 10)
    }
    
    private var specificationsSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Label("Especificaciones de Ruta", systemImage: "map.fill")
                .font(.headline)
                .foregroundColor(.white)
            
            Divider().background(Color.white.opacity(0.3))
            
            detailRow(label: "ID de Ubicación", value: hotspot.locId, icon: "mappin.and.ellipse")
            detailRow(label: "Latitud", value: String(format: "%.4f", hotspot.latitude), icon: "scope")
            detailRow(label: "Longitud", value: String(format: "%.4f", hotspot.longitude), icon: "scope")
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black.opacity(0.15))
                .background(Blur(style: .systemThinMaterialDark).cornerRadius(25))
        )
    }
    
    private func detailRow(label: String, value: String, icon: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 25)
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.caption).foregroundColor(.white.opacity(0.6))
                Text(value).font(.body).fontWeight(.medium).foregroundColor(.white)
            }
            Spacer()
        }
    }
    
    private var openInMapsButton: some View {
        Button(action: openInAppleMaps) {
            HStack {
                Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                Text("Cómo llegar")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.orange)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
    }
    
    private func openInAppleMaps() {
        let url = URL(string: "http://maps.apple.com/?daddr=\(hotspot.latitude),\(hotspot.longitude)")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

struct RoadmapDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockHotspot = EBirdHotspotDetail(
            locId: "L275204",
            name: "Reserva Natural Entre Nubes",
            latitude: 4.5458,
            longitude: -74.0156,
            countryCode: "CO",
            subnational1Code: "CO-DC",
            numSpeciesAllTime: 142
        )
        
        return Group {
            NavigationStack {
                RoadmapDetailView(hotspot: mockHotspot)
            }
            .previewDisplayName("Vista de Ruta - iPhone 15")
            
            NavigationStack {
                RoadmapDetailView(hotspot: mockHotspot)
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Vista de Ruta - Modo Oscuro")
        }
    }
}
