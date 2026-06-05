import SwiftUI
internal import AppKit

struct AnimateImage: View {
    let name: String

    var body: some View {
        Image(systemName: systemIconName)
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .foregroundColor(.primary)
    }
    
    private var systemIconName: String {
        switch name {
        case "welcome": return "hand.wave.fill"
        case "confirm": return "checkmark.circle.fill"
        case "star": return "star.fill"
        case "telegram": return "paperplane.fill"
        default: return "sparkles"
        }
    }
}
