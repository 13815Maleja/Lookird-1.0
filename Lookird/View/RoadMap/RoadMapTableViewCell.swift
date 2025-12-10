import Foundation
import SwiftUI

struct RoadMapTableViewCell: View {
    let title: String
    let speciesCount: Int
    var showsChevron: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.indigo)
                    .lineLimit(2)
                
                Text("\(speciesCount) especies registradas")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.indigo.opacity(0.5))
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.9))
        )
    }
}
