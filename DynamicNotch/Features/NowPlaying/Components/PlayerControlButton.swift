//
//  PlayerControlButton.swift
//  DynamicNotch
//
//  Created by Евгений Петрукович on 4/14/26.
//

import SwiftUI

struct PlayerControlButton: View {
    enum FeedbackStyle {
        case neutral
        case backward
        case playPause
        case forward

        var iconTravel: CGFloat {
            switch self {
            case .neutral, .playPause: 0
            case .backward: -3.5
            case .forward: 3.5
            }
        }

        var iconPeakScale: CGFloat {
            switch self {
            case .playPause: 1.18
            case .neutral, .backward, .forward: 1.11
            }
        }

        var iconRotation: Double {
            0 // Removed custom rotation in favor of native SF Symbol bounce
        }

        var pulseOpacity: Double {
            switch self {
            case .playPause: 0.22
            case .neutral, .backward, .forward: 0.14
            }
        }

        var pulseTint: Color {
            switch self {
            case .playPause:
                return Color.white
            case .neutral, .backward, .forward:
                return Color.white.opacity(0.9)
            }
        }

        var pulseScale: CGFloat {
            switch self {
            case .playPause: 1.34
            case .neutral, .backward, .forward: 1.24
            }
        }
    }

    @Environment(\.notchScale) var scale

    let systemImage: String
    let fontSize: CGFloat
    let width: CGFloat
    let height: CGFloat
    let feedbackStyle: FeedbackStyle
    let action: () -> Void

    @State private var pulseScale: CGFloat = 0.74
    @State private var pulseOpacity: Double = 0
    @State private var iconOffsetX: CGFloat = 0
    @State private var bounceTrigger: Int = 0

    init(
        systemImage: String,
        fontSize: CGFloat,
        width: CGFloat,
        height: CGFloat,
        feedbackStyle: FeedbackStyle = .neutral,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.fontSize = fontSize
        self.width = width
        self.height = height
        self.feedbackStyle = feedbackStyle
        self.action = action
    }

    var body: some View {
        Button(action: triggerAction) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .overlay(Circle().strokeBorder(.white.opacity(0.15), lineWidth: 0.5))

                RoundedRectangle(cornerRadius: min(width, height) * 0.5, style: .continuous)
                    .fill(feedbackStyle.pulseTint)
                    .opacity(pulseOpacity)
                    .scaleEffect(pulseScale)
                    .blur(radius: 4)

                Image(systemName: systemImage)
                    .font(.system(size: fontSize, weight: .semibold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
                    .offset(x: iconOffsetX)
                    .contentTransition(.symbolEffect(.replace))
                    .symbolEffect(.bounce, options: .speed(1.2), value: bounceTrigger)
                    .animation(.spring(response: 0.26, dampingFraction: 0.76), value: systemImage)
            }
        }
        .buttonStyle(
            PressedButtonStyle(
                width: width,
                height: height,
                cornerRadius: min(width, height) * 0.5,
                hoverBackground: .white.opacity(0.09)
            )
        )
    }

    private func triggerAction() {
        startFeedback()
        action()
    }

    private func startFeedback() {
        pulseScale = 0.74
        pulseOpacity = feedbackStyle.pulseOpacity
        iconOffsetX = 0
        bounceTrigger += 1 // Native SF Symbol bounce trigger

        withAnimation(.easeOut(duration: 0.22)) {
            pulseScale = feedbackStyle.pulseScale
            pulseOpacity = 0
        }

        withAnimation(.spring(response: 0.18, dampingFraction: 0.55)) {
            iconOffsetX = feedbackStyle.iconTravel
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.74)) {
                iconOffsetX = 0
            }
        }
    }
}
