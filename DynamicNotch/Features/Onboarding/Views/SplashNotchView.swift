import SwiftUI

struct HelloSignatureShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        
        // Beautiful flowing 'hello' cursive path
        p.move(to: CGPoint(x: w*0.05, y: h*0.6))
        p.addCurve(to: CGPoint(x: w*0.12, y: h*0.1), control1: CGPoint(x: w*0.1, y: h*0.4), control2: CGPoint(x: w*0.15, y: h*0.2))
        p.addCurve(to: CGPoint(x: w*0.12, y: h*0.9), control1: CGPoint(x: w*0.05, y: h*0.0), control2: CGPoint(x: w*0.05, y: h*0.7))
        p.addCurve(to: CGPoint(x: w*0.22, y: h*0.4), control1: CGPoint(x: w*0.15, y: h*0.9), control2: CGPoint(x: w*0.15, y: h*0.5))
        p.addCurve(to: CGPoint(x: w*0.28, y: h*0.8), control1: CGPoint(x: w*0.25, y: h*0.3), control2: CGPoint(x: w*0.28, y: h*0.7))
        
        p.addCurve(to: CGPoint(x: w*0.38, y: h*0.55), control1: CGPoint(x: w*0.28, y: h*0.9), control2: CGPoint(x: w*0.38, y: h*0.8))
        p.addCurve(to: CGPoint(x: w*0.33, y: h*0.45), control1: CGPoint(x: w*0.38, y: h*0.35), control2: CGPoint(x: w*0.33, y: h*0.35))
        p.addCurve(to: CGPoint(x: w*0.45, y: h*0.8), control1: CGPoint(x: w*0.33, y: h*0.85), control2: CGPoint(x: w*0.38, y: h*0.9))
        
        p.addCurve(to: CGPoint(x: w*0.55, y: h*0.15), control1: CGPoint(x: w*0.5, y: h*0.7), control2: CGPoint(x: w*0.55, y: h*0.4))
        p.addCurve(to: CGPoint(x: w*0.55, y: h*0.8), control1: CGPoint(x: w*0.55, y: h*0.0), control2: CGPoint(x: w*0.5, y: h*0.6))
        
        p.addCurve(to: CGPoint(x: w*0.65, y: h*0.15), control1: CGPoint(x: w*0.6, y: h*0.9), control2: CGPoint(x: w*0.65, y: h*0.4))
        p.addCurve(to: CGPoint(x: w*0.65, y: h*0.8), control1: CGPoint(x: w*0.65, y: h*0.0), control2: CGPoint(x: w*0.6, y: h*0.6))
        
        p.addCurve(to: CGPoint(x: w*0.8, y: h*0.55), control1: CGPoint(x: w*0.7, y: h*0.9), control2: CGPoint(x: w*0.8, y: h*0.7))
        p.addCurve(to: CGPoint(x: w*0.75, y: h*0.45), control1: CGPoint(x: w*0.8, y: h*0.35), control2: CGPoint(x: w*0.75, y: h*0.35))
        p.addCurve(to: CGPoint(x: w*0.85, y: h*0.8), control1: CGPoint(x: w*0.75, y: h*0.85), control2: CGPoint(x: w*0.8, y: h*0.9))
        p.addCurve(to: CGPoint(x: w*0.95, y: h*0.4), control1: CGPoint(x: w*0.9, y: h*0.7), control2: CGPoint(x: w*0.92, y: h*0.5))
        
        return p
    }
}

struct SplashNotchView: View {
    @State private var drawAmount: CGFloat = 0
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Push the content down to avoid the physical notch (approx 32-38pt tall)
            Spacer()
                .frame(height: 35)
            
            HelloSignatureShape()
                .trim(from: 0, to: drawAmount)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round))
                .frame(width: 140, height: 45)
                .opacity(isVisible ? 1 : 0)
                
            Spacer()
        }
        .frame(width: 240, height: 120)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                isVisible = true
            }
            withAnimation(.easeInOut(duration: 1.5).delay(0.1)) {
                drawAmount = 1.0
            }
        }
    }
}
