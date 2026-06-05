//
//  CustomButton.swift
//  DynamicNotch
//
//  Created by Евгений Петрукович on 2/20/26.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var width: CGFloat = .infinity
    var height: CGFloat = 30
    var backgroundColor: Color = .blue
    var foregroundColor: Color = .white
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: width, maxHeight: height)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(Capsule().fill(backgroundColor))
                    .overlay(Capsule().strokeBorder(.white.opacity(0.15), lineWidth: 0.5))
            )
            .foregroundColor(foregroundColor)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
