import AppKit

if #available(macOS 12.0, *) {
    for screen in NSScreen.screens {
        print("Screen: \(screen.frame.width)x\(screen.frame.height)")
        if let left = screen.auxiliaryTopLeftArea, let right = screen.auxiliaryTopRightArea {
            print("Left Area: \(left)")
            print("Right Area: \(right)")
            let physicalNotchWidth = screen.frame.width - (left.width + right.width)
            print("Physical Notch Width: \(physicalNotchWidth)")
        } else {
            print("No notch.")
        }
    }
}
