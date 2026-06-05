import SwiftUI

struct ShortcutsNotchView: View {
    @ObservedObject var shortcutsViewModel: ShortcutsViewModel
    @ObservedObject var notchViewModel: NotchViewModel
    
    var body: some View {
        ZStack {
            if shortcutsViewModel.isFetching && shortcutsViewModel.shortcuts.isEmpty {
                loadingView
            } else if let error = shortcutsViewModel.errorMessage, shortcutsViewModel.shortcuts.isEmpty {
                errorView(error)
            } else if shortcutsViewModel.shortcuts.isEmpty {
                emptyView
            } else {
                shortcutsGrid
            }
        }
    }
    
    @ViewBuilder
    private var shortcutsGrid: some View {
        VStack {
            Spacer()
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(shortcutsViewModel.shortcuts, id: \.self) { shortcut in
                        Button(action: {
                            shortcutsViewModel.runShortcut(name: shortcut)
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "bolt.fill")
                                    .font(Font.system(.caption).weight(.bold))
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .background(
                                        LinearGradient(colors: [.purple, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .clipShape(Circle())
                                
                                Text(shortcut)
                                    .font(Font.system(.caption).weight(.medium))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .contentShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        .onHover { isHovering in
                            if isHovering {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
            }
            .frame(height: 115)
            .mask {
                ScrollFadeMask(cornerRadius: 20, maskType: .verticalFade)
            }
            .onHover { hovering in
                notchViewModel.isHoveringScrollableContent = hovering
            }
        }
        .padding(.horizontal, 5)
    }
    
    @ViewBuilder
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(0.8)
                .padding(.bottom, 40)
        }
    }
    
    @ViewBuilder
    private var emptyView: some View {
        VStack(spacing: 5) {
            Spacer()
            Image(systemName: "bolt.slash.fill")
                .font(Font.system(.title).weight(.semibold))
                .foregroundColor(.gray.opacity(0.8))
            
            Text("No Shortcuts Found")
                .font(Font.system(.callout).weight(.semibold))
                .foregroundColor(.white)
            
            Text("Create some in the Shortcuts app")
                .font(.system(.caption))
                .foregroundColor(.gray.opacity(0.6))
        }
        .padding(.bottom, 15)
    }
    
    @ViewBuilder
    private func errorView(_ error: String) -> some View {
        VStack(spacing: 5) {
            Spacer()
            Image(systemName: "exclamationmark.triangle.fill")
                .font(Font.system(.title).weight(.semibold))
                .foregroundColor(.red.opacity(0.8))
            
            Text("Error Loading Shortcuts")
                .font(Font.system(.subheadline).weight(.semibold))
                .foregroundColor(.white)
            
            Text(error)
                .font(.system(.caption2))
                .foregroundColor(.gray.opacity(0.6))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(.bottom, 15)
        .padding(.horizontal, 20)
    }
}
