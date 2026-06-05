import SwiftUI
import AppKit

@MainActor
func generateAppIcon() {
    let view = ZStack {
        // Background squircle for macOS
        RoundedRectangle(cornerRadius: 228, style: .continuous)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.15, green: 0.15, blue: 0.16), Color(red: 0.08, green: 0.08, blue: 0.09)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        
        // Inner glowing border
        RoundedRectangle(cornerRadius: 228, style: .continuous)
            .stroke(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white.opacity(0.2), Color.clear]),
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: 4
            )
        
        // SF Symbol
        Image(systemName: "rectangle.topthird.inset.filled")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 600, height: 600)
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
    }
    .frame(width: 1024, height: 1024)

    let renderer = ImageRenderer(content: view)
    renderer.scale = 1.0

    if let nsImage = renderer.nsImage,
       let tiffData = nsImage.tiffRepresentation,
       let bitmap = NSBitmapImageRep(data: tiffData),
       let pngData = bitmap.representation(using: .png, properties: [:]) {
        let url = URL(fileURLWithPath: "appicon.png")
        try? pngData.write(to: url)
        print("Saved appicon.png")
    } else {
        print("Failed to save")
    }
}

// Run the main actor function
DispatchQueue.main.sync {
    generateAppIcon()
}
