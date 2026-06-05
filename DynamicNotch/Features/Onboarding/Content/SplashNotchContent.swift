import SwiftUI

struct SplashNotchContent: NotchContentProtocol, DynamicIslandCustomizable {
    let id = NotchContentRegistry.General.splash.id
    var priority: Int { NotchContentRegistry.Onboarding.priority }
    
    func size(baseWidth: CGFloat, baseHeight: CGFloat) -> CGSize {
        return CGSize(width: 240, height: 120)
    }
    
    func cornerRadius(baseRadius: CGFloat) -> (top: CGFloat, bottom: CGFloat) {
        return (top: 20, bottom: 20)
    }
    
    func dynamicIslandCornerRadius(baseHeight: CGFloat) -> CGFloat {
        return 20
    }
    
    func dynamicIslandSize(baseWidth: CGFloat, baseHeight: CGFloat) -> CGSize {
        return CGSize(width: 240, height: 120)
    }
    
    @MainActor
    func makeView() -> AnyView {
        AnyView(SplashNotchView())
    }
}
