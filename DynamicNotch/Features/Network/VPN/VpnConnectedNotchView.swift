//
//  VpnConnectedNotchView.swift
//  DynamicNotch
//
//  Created by Евгений Петрукович on 4/14/26.
//

import SwiftUI
import Combine

struct VpnConnectedNotchView: View {
    @Environment(\.notchScale) private var scale
    @Environment(\.isDynamicIsland) private var isDynamicIsland
    @ObservedObject var networkViewModel: NetworkViewModel
    @ObservedObject var settings: ConnectivitySettingsStore
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeString: String = "00:00"
    
    private var resolvedVPNName: String {
        let trimmedText = networkViewModel.vpnName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedText.isEmpty ? "Secure Tunnel" : trimmedText
    }
    
    private var isShowingDetail: Bool {
        settings.isVPNDetailVisible
    }
    
    private func updateTimer() {
        guard let startDate = networkViewModel.vpnConnectedAt else {
            timeString = "00:00"
            return
        }
        
        let elapsed = Date().timeIntervalSince(startDate)
        timeString = elapsed.formattedDuration
    }
    
    var body: some View {
        HStack {
            if isShowingDetail {
                detailedView
            } else {
                compactView
            }
        }
        .font(.system(.subheadline))
    }
    
    @ViewBuilder
    private var compactView: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: isDynamicIsland ? 30 : 6)
                    .fill(Color.accentColor.gradient)
                    .frame(width: isDynamicIsland ? 40 : 24, height: isDynamicIsland ? 20 : 24)
                
                Image(systemName: "network.badge.shield.half.filled")
                    .font(Font.system(.subheadline).weight(.semibold))
                    .foregroundStyle(Color.white.gradient)
            }
            Spacer()
            
            Text(verbatim: "Active")
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding(.leading, isDynamicIsland ? 4.scaled(by: scale) : 14.scaled(by: scale))
        .padding(.trailing, isDynamicIsland ? 8.scaled(by: scale) : 16.scaled(by: scale))
        .padding(.vertical, isDynamicIsland ? 0 : 10)
    }
    
    @ViewBuilder
    private var detailedView: some View {
        VStack {
            Spacer()
            
            HStack {
                HStack(spacing: 16) {
                    Image(systemName: "network.badge.shield.half.filled")
                        .font(.system(.largeTitle))
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(verbatim: "Connected")
                            .lineLimit(1)
                            .font(.system(.footnote))
                            .foregroundStyle(.white.opacity(0.4))
                        
                        MarqueeText(
                            Binding.constant(resolvedVPNName),
                            font: .system(size: 15, weight: .regular),
                            nsFont: .body,
                            textColor: .white.opacity(0.8),
                            backgroundColor: .clear,
                            minDuration: 0.5,
                            frameWidth: 130
                        )
                    }
                }
                Spacer()
                
                Text(timeString)
                    .padding(.bottom, 10)
                    .font(Font.system(.title, design: .rounded).weight(.semibold))
                    .monospacedDigit()
                    .foregroundStyle(Color.orange)
                    .contentTransition(.numericText())
                    .onReceive(timer) { _ in
                        updateTimer()
                    }
                    .onAppear {
                        updateTimer()
                    }
            }
        }
        .padding(.horizontal, isDynamicIsland ? 20 : 36)
        .padding(.vertical, 10)
    }
}

