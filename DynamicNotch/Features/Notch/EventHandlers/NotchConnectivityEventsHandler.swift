import SwiftUI

@MainActor
final class NotchConnectivityEventsHandler {
    private let notchViewModel: NotchViewModel
    private let bluetoothViewModel: BluetoothViewModel
    private let networkViewModel: NetworkViewModel
    private let settingsViewModel: SettingsViewModel
    private let appLaunchTime = Date()

    init(
        notchViewModel: NotchViewModel,
        bluetoothViewModel: BluetoothViewModel,
        networkViewModel: NetworkViewModel,
        settingsViewModel: SettingsViewModel
    ) {
        self.notchViewModel = notchViewModel
        self.bluetoothViewModel = bluetoothViewModel
        self.networkViewModel = networkViewModel
        self.settingsViewModel = settingsViewModel
    }

    func handleBluetooth(_ event: BluetoothEvent) {
        // 스플래시(시그니처) 화면이 가려지지 않도록 앱 실행 후 3초간은 무시
        guard Date().timeIntervalSince(appLaunchTime) > 3.0 else { return }
        
        switch event {
        case .connected:
            guard settingsViewModel.isTemporaryActivityEnabled(.bluetooth) else { return }
            notchViewModel.send(
                .showTemporaryNotification(
                    BluetoothConnectedNotchContent(
                        bluetoothViewModel: bluetoothViewModel,
                        settings: settingsViewModel.connectivity,
                        applicationSettings: settingsViewModel.application
                    ),
                    duration: settingsViewModel.temporaryActivityDuration(for: .bluetooth)
                )
            )
        }
    }

    func handleNetwork(_ event: NetworkEvent) {
        // 스플래시(시그니처) 화면이 가려지지 않도록 앱 실행 후 3초간은 무시
        guard Date().timeIntervalSince(appLaunchTime) > 3.0 else { return }

        switch event {
        case .wifiConnected:
            guard settingsViewModel.isTemporaryActivityEnabled(.wifi) else { return }
            notchViewModel.send(
                .showTemporaryNotification(
                    WifiConnectedNotchContent(
                        networkViewModel: networkViewModel
                    ),
                    duration: settingsViewModel.temporaryActivityDuration(for: .wifi)
                )
            )

        case .vpnConnected:
            guard settingsViewModel.isTemporaryActivityEnabled(.vpn) else { return }
            notchViewModel.send(
                .showTemporaryNotification(
                    VpnConnectedNotchContent(
                        networkViewModel: networkViewModel,
                        settings: settingsViewModel.connectivity
                    ),
                    duration: settingsViewModel.temporaryActivityDuration(for: .vpn)
                )
            )

        case .noInternetConnection:
            guard settingsViewModel.connectivity.isNoInternetTemporaryActivityEnabled else { return }
            notchViewModel.send(
                .showTemporaryNotification(
                    NoInternetConnectionContent(
                        onDismiss: { [weak self] in
                            self?.notchViewModel.hideTemporaryNotification()
                        }
                    ),
                    duration: .infinity
                )
            )

        case .hotspotActive:
            guard settingsViewModel.isLiveActivityEnabled(.hotspot) else { return }
            notchViewModel.send(
                .showLiveActivity(
                    HotspotActiveContent(settingsViewModel: settingsViewModel)
                )
            )

        case .hotspotHide:
            notchViewModel.send(.hideLiveActivity(id: NotchContentRegistry.Network.hotspot.id))
        }
    }
}
