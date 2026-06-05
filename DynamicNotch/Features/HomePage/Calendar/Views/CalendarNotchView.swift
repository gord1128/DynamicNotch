import SwiftUI
internal import EventKit

struct CalendarNotchView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var notchViewModel: NotchViewModel
    
    var body: some View {
        ZStack {
            if calendarViewModel.authorizationStatus != .fullAccess {
                authorizationStatus
            } else if calendarViewModel.events.isEmpty {
                emptyEventsView
            } else {
                eventRow
            }
        }
    }
    
    @ViewBuilder
    private var eventRow: some View {
        VStack {
            Spacer()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    ForEach(calendarViewModel.events, id: \.eventIdentifier) { event in
                        CalendarEventRow(event: event)
                    }
                }
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
    private var emptyEventsView: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 5) {
                Image(systemName: "calendar.badge.checkmark")
                    .font(Font.system(.title).weight(.semibold))
                    .foregroundColor(.gray.opacity(0.8))
                
                Text("No events today")
                    .font(Font.system(.callout).weight(.semibold))
                    .foregroundColor(.white)
                
                Text("Enjoy your free time!")
                    .font(.system(.caption))
                    .foregroundColor(.gray.opacity(0.6))
            }
        }
        .padding(.bottom, 15)
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    private var authorizationStatus: some View {
        VStack {
            Spacer()
            
            switch calendarViewModel.authorizationStatus {
            case .notDetermined:
                permissionStatusView(
                    icon: "calendar.badge.exclamationmark",
                    title: "Access Required",
                    subtitle: "Please grant access to show events",
                    color: .orange
                )
                
            case .denied, .restricted:
                permissionStatusView(
                    icon: "calendar.badge.minus",
                    title: "Access Denied",
                    subtitle: "Please enable full access in System Settings",
                    color: .red
                )
                
            case .writeOnly:
                permissionStatusView(
                    icon: "calendar.badge.clock",
                    title: "Write-Only Access",
                    subtitle: "We need full access to read your events",
                    color: .yellow
                )
                
            default:
                EmptyView()
            }
        }
        .padding(.bottom, 15)
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    private func permissionStatusView<Content: View>(
        icon: String,
        title: String,
        subtitle: String,
        color: Color,
        @ViewBuilder extraContent: () -> Content = { EmptyView() }
    ) -> some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(Font.system(.title).weight(.semibold))
                .foregroundStyle(color.gradient)
            
            Text(title)
                .font(Font.system(.callout).weight(.semibold))
                .lineLimit(1)
                .foregroundColor(.white)
            
            Text(subtitle)
                .font(.system(.caption))
                .lineLimit(2)
                .foregroundColor(.gray.opacity(0.6))
                .multilineTextAlignment(.center)
            
            extraContent()
        }
    }
}
