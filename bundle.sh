#!/bin/bash
set -e

# Default to debug build
CONFIG="debug"
if [ "$1" == "release" ]; then
    CONFIG="release"
fi

echo "🚀 Building DynamicNotch ($CONFIG)..."
swift build -c $CONFIG

APP_DIR="build/DynamicNotch.app"
echo "📦 Bundling into $APP_DIR..."

rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

# Copy binary
cp ".build/$CONFIG/DynamicNotch" "$APP_DIR/Contents/MacOS/"

# Find and copy resources
BUNDLE_PATH=$(find ".build/$CONFIG" -name "DynamicNotch_DynamicNotch.bundle" | head -n 1)
if [ -d "$BUNDLE_PATH" ]; then
    cp -R "$BUNDLE_PATH/"* "$APP_DIR/Contents/Resources/"
fi

# Explicitly copy AppIcon.icns if it exists
if [ -f "DynamicNotch/Resources/AppIcon.icns" ]; then
    cp "DynamicNotch/Resources/AppIcon.icns" "$APP_DIR/Contents/Resources/"
fi


# Manually extract localization strings because SPM doesn't compile xcstrings to lproj folders properly
python3 extract_strings.py

# Basic Info.plist
cat <<EOF > "$APP_DIR/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>DynamicNotch</string>
    <key>CFBundleIdentifier</key>
    <string>com.DynamicNotch</string>
    <key>CFBundleName</key>
    <string>DynamicNotch</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSCameraUsageDescription</key>
    <string>We use the camera for previews</string>
    <key>NSCalendarsUsageDescription</key>
    <string>DynamicNotch needs access to your calendar to display upcoming events in the notch.</string>
    <key>NSCalendarsFullAccessUsageDescription</key>
    <string>DynamicNotch needs access to your calendar to display upcoming events in the notch.</string>
    <key>NSBluetoothAlwaysUsageDescription</key>
    <string>DynamicNotch uses Bluetooth to show battery status for your devices.</string>
    <key>NSLocalNetworkUsageDescription</key>
    <string>DynamicNotch uses the local network to detect connections.</string>
    <key>NSAppleEventsUsageDescription</key>
    <string>DynamicNotch needs to send AppleEvents to control your media players (Spotify, Music, etc.).</string>
    <key>NSDesktopFolderUsageDescription</key>
    <string>DynamicNotch needs access to your Desktop to allow you to drag and drop files from it.</string>
    <key>NSDocumentsFolderUsageDescription</key>
    <string>DynamicNotch needs access to your Documents to allow you to drag and drop files from it.</string>
    <key>NSDownloadsFolderUsageDescription</key>
    <string>DynamicNotch needs access to your Downloads to allow you to drag and drop files from it.</string>
    <key>NSRemovableVolumesUsageDescription</key>
    <string>DynamicNotch needs access to external drives to allow you to drag and drop files from them.</string>
    <key>NSNetworkVolumesUsageDescription</key>
    <string>DynamicNotch needs access to network drives to allow you to drag and drop files from them.</string>
</dict>
</plist>
EOF

# Generate Entitlements
cat <<EOF > "$APP_DIR/Contents/DynamicNotch.entitlements"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.automation.apple-events</key>
    <true/>
    <key>com.apple.security.personal-information.calendars</key>
    <true/>
    <key>com.apple.security.device.camera</key>
    <true/>
    <key>com.apple.security.device.bluetooth</key>
    <true/>
</dict>
</plist>
EOF

echo "🔐 Signing bundle..."
# Check for any valid developer certificate or a custom local certificate named "DynamicNotchLocal"
if security find-identity -v -p codesigning | grep -q "Apple Development"; then
    CERT=$(security find-identity -v -p codesigning | grep "Apple Development" | head -n 1 | awk -F'"' '{print $2}')
    echo "Found Apple Development certificate: $CERT"
    codesign --force --deep --sign "$CERT" --options runtime --entitlements "$APP_DIR/Contents/DynamicNotch.entitlements" "$APP_DIR"
elif security find-identity -v -p codesigning | grep -q "DynamicNotchLocal"; then
    echo "Found local self-signed certificate: DynamicNotchLocal"
    codesign --force --deep --sign "DynamicNotchLocal" --options runtime --entitlements "$APP_DIR/Contents/DynamicNotch.entitlements" "$APP_DIR"
else
    echo "No code signing certificate found. Using ad-hoc signature (-)."
    echo "⚠️  Note: Ad-hoc signatures change on every build, causing Accessibility permissions to reset."
    echo "   To prevent this, create a Self-Signed Code Signing Certificate named 'DynamicNotchLocal' in Keychain Access."
    codesign --force --deep --sign - --entitlements "$APP_DIR/Contents/DynamicNotch.entitlements" "$APP_DIR"
fi

echo "✅ Done! App is at $APP_DIR"
