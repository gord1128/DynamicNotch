//
//  NowPlayingMinimalNotchView.swift
//  DynamicNotch
//
//  Created by Евгений Петрукович on 4/14/26.
//

import SwiftUI

struct NowPlayingMinimalNotchView: View {
    @Environment(\.notchScale) var scale
    @Environment(\.isDynamicIsland) var isDynamicIsland
    @Environment(\.isActivityPresentationHidden) var isActivityPresentationHidden
    
    @ObservedObject var nowPlayingViewModel: NowPlayingViewModel
    @ObservedObject var settings: MediaAndFilesSettingsStore
    
    private var resolvedSnapshot: NowPlayingSnapshot {
        nowPlayingViewModel.snapshot ?? NowPlayingSnapshot(
            title: "Nothing Playing",
            artist: "Nothing artists",
            album: "",
            duration: 0,
            elapsedTime: 0,
            playbackRate: 0,
            artworkData: nil,
            refreshedAt: .now
        )
    }
    
    var body: some View {
        let snapshot = resolvedSnapshot

        timelineContent(snapshot: snapshot)
    }

    private func timelineContent(snapshot: NowPlayingSnapshot) -> some View {
        HStack {
            ArtworkView(
                nowPlayingViewModel: nowPlayingViewModel,
                width: isDynamicIsland ? 18 : 24,
                height: isDynamicIsland ? 18 : 24,
                cornerRadius: isDynamicIsland ? 3 : 5,
                usesFlipAnimation: settings.isNowPlayingArtwork3DEffectEnabled
            )
            Spacer()
            
            Image(systemName: "waveform")
                .symbolEffect(.variableColor.iterative.reversing, isActive: snapshot.isPlaying && !isActivityPresentationHidden)
                .font(.system(size: isDynamicIsland ? 12 : 16, weight: .bold))
                .foregroundStyle(Color(nsColor: nowPlayingViewModel.artworkPalette.equalizerBaseColor))
        }
        .padding(.horizontal, isDynamicIsland ? 10.scaled(by: scale) : 14.scaled(by: scale))
    }
}
