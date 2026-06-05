//
//  TrayActiveNotchView.swift
//  DynamicNotch
//
//  Created by Евгений Петрукович on 4/26/26.
//

import SwiftUI

struct TrayActiveNotchView: View {
    @Environment(\.notchScale) private var scale
    @Environment(\.isDynamicIsland) private var isDynamicIsland
    @ObservedObject var fileTrayViewModel: FileTrayViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "folder.fill.badge.plus")
                .font(.system(size: isDynamicIsland ? 16 : 18, weight: .semibold))
                .foregroundStyle(.white)
                .symbolRenderingMode(.hierarchical)
            
            Spacer()
            
            Text("\(fileTrayViewModel.count)")
                .font(Font.system(.subheadline, design: .rounded).weight(.bold))
                .foregroundStyle(.black)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.white.gradient)
                        .shadow(color: .white.opacity(0.3), radius: 4)
                )
        }
        .padding(.horizontal, isDynamicIsland ? 8.scaled(by: scale) : 16.scaled(by: scale))
    }
}
