//
//  DragAndDropDropZoneView.swift
//  DynamicNotch
//
//  Created by Евгений Петрукович on 4/25/26.
//

import SwiftUI

enum AirDropDropZoneMetrics {
    static let cornerRadius: CGFloat = 18
    static let width: CGFloat = .infinity
    static let height: CGFloat = 90
    static let horizontalPadding: CGFloat = 40
    static let verticalPadding: CGFloat = 16
    static let combinedSpacing: CGFloat = 12
}

struct DragAndDropDropZoneView: View {
    let target: DragAndDropTarget
    let isTargeted: Bool
    var targetColorStyle: DragAndDropTargetColorStyle = .original

    var body: some View {
        VStack {
            Spacer()

            DragAndDropDropZoneContent(
                target: target,
                isTargeted: isTargeted,
                targetColorStyle: targetColorStyle
            )
                .frame(maxWidth: .infinity, maxHeight: AirDropDropZoneMetrics.height)
        }
        .padding(.horizontal, AirDropDropZoneMetrics.horizontalPadding)
        .padding(.vertical, AirDropDropZoneMetrics.verticalPadding)
    }
}

struct DragAndDropDropZoneContent: View {
    let target: DragAndDropTarget
    let isTargeted: Bool
    var targetColorStyle: DragAndDropTargetColorStyle = .original

    private var targetColor: Color {
        target.color(for: targetColorStyle)
    }

    private var strokeColor: Color {
        targetColor.opacity(0.6)
    }

    var body: some View {
        RoundedRectangle(cornerRadius: AirDropDropZoneMetrics.cornerRadius)
            .fill(.ultraThinMaterial)
            .background(
                RoundedRectangle(cornerRadius: AirDropDropZoneMetrics.cornerRadius)
                    .fill(isTargeted ? targetColor.opacity(0.3) : .clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AirDropDropZoneMetrics.cornerRadius)
                    .strokeBorder(isTargeted ? targetColor : targetColor.opacity(0.3), lineWidth: isTargeted ? 2 : 1)
            )
            .shadow(color: isTargeted ? targetColor.opacity(0.5) : .clear, radius: isTargeted ? 12 : 0)
            .overlay {
                VStack(spacing: 6) {
                    target.icon(colorStyle: targetColorStyle)
                        .symbolEffect(.bounce, value: isTargeted)
                    target.titleIcon(colorStyle: targetColorStyle)
                }
                .foregroundStyle(isTargeted ? targetColor : .white.opacity(0.9))
                .scaleEffect(isTargeted ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isTargeted)
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isTargeted)
    }
}
