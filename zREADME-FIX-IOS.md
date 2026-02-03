rm -Rf Pods
rm -Rf .symlinks
rm -Rf Flutter/Flutter.framework
rm -Rf Flutter/Flutter.podspec
rm -f Runner.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings
rm -rf ios/Podfile.lock ios/Pods ios/Runner.xcworkspace
flutter clean && flutter pub get
rm -rf Flutter/App.framework && rm Podfile.lock && rm -rf Pods && pod deintegrate && pod install --repo-update && flutter pub get && pod install
