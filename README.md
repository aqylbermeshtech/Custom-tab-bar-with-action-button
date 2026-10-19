
<div align="center">

# Custom Tab Bar with Action Button

<img width="460" height="416" alt="Screen Recording 2026-08-27 at 17 23 42" src="https://github.com/user-attachments/assets/dfebf9e7-fcd7-48b1-9c15-a85f8a781d98" />

</div>



A small SwiftUI experiment: a custom, capsule-shaped tab bar built on top of `UISegmentedControl` and wrapped in iOS 26's Liquid Glass (`glassEffect`), paired with a floating "action button" whose icon morphs to match the currently selected tab.

## What it demonstrates

- Wrapping `UISegmentedControl` in `UIViewRepresentable` to get a native, hardware-accelerated sliding selection indicator instead of hand-rolling one in SwiftUI
- Rendering each segment's SwiftUI icon/label to a `UIImage` and setting it as the segment's image directly (see [Implementation](#implementation) below)
- Applying `GlassEffectContainer` / `.glassEffect(.regular.interactive(), in:)` (iOS 26 Liquid Glass API) to both the tab bar and the action button so they visually merge into one floating pill
- An action button that cross-fades/blurs between per-tab SF Symbols (`blurFade` view modifier) driven by the active tab, animated with `.smooth`
- Tabs can configure their symbols, icons, and action button visibility in [CustomTab.swift](Custom%20tab%20bar%20with%20action%20button/Models/CustomTab.swift).

## Implementation

**[MorphingTabBar.swift](Custom%20tab%20bar%20with%20action%20button/Views/Components/MorphingTabBar.swift)** is the tab bar used by [ContentView.swift](Custom%20tab%20bar%20with%20action%20button/Views/ContentView.swift). It renders each tab's SwiftUI icon/label to a `UIImage` via `ImageRenderer` and sets it as the segment's image, hides the control's built-in divider images, and tints the selected-segment background — dynamically inserting or removing tabs with fluid animations.

Earlier prototype implementations are kept for reference under [Legacy/](Custom%20tab%20bar%20with%20action%20button/Legacy/):
- **[LegacyCustomTabBar.swift](Custom%20tab%20bar%20with%20action%20button/Legacy/LegacyCustomTabBar.swift)**: Earlier image-rendered prototype.
- **[LegacyOverlayTabBar.swift](Custom%20tab%20bar%20with%20action%20button/Legacy/LegacyOverlayTabBar.swift)**: Segmented control with SwiftUI overlay labels.

## Project Structure

```
Custom tab bar with action button/
├── App/
│   └── CustomTabBarApp.swift             # App entry point (@main)
├── Models/
│   └── CustomTab.swift                   # Tab items, icons, and action button configuration
├── Views/
│   ├── ContentView.swift                 # Main view with glass container & action button
│   └── Components/
│       └── MorphingTabBar.swift          # Dynamic UIViewRepresentable segmented control
├── Legacy/
│   ├── LegacyCustomTabBar.swift          # Archived image-rendered tab bar prototype
│   └── LegacyOverlayTabBar.swift         # Archived SwiftUI-overlay tab bar prototype
└── Assets.xcassets/                      # App asset catalog
```

## Requirements

- macOS with **Xcode 26** or newer (required for the Liquid Glass APIs used here — `GlassEffectContainer`, `.glassEffect`)
- iOS **26.1**+ deployment target (simulator or device)
- Swift 5 toolchain (bundled with Xcode)
- No external dependencies — pure SwiftUI/UIKit, no Swift Package dependencies

## Getting Started

```bash
open "Custom tab bar with action button.xcodeproj"
```

Select a simulator or device running iOS 26.1+ and run (`Cmd+R`), or use the `#Preview` in `ContentView.swift`.

## Notes

- `CustomTab` currently defines three tabs (Home, Notifications, Settings), each with its own bar icon (`symbol`) and action-button icon (`actionSymbol`); add/remove cases there to change the tab set.
- `CustomTab.hasSingleAction` decides `Button` vs. `Menu` for the action button; the menu items in `ContentView` (Appearance, Notifications, Privacy, About) are placeholders — swap in real actions per tab.
- Home and Notifications' `Button` action is a `print` placeholder — wire in real behavior there too.
- This is a UI experiment/reference implementation, not a full app — there's no navigation behind the tabs yet, just the selector and action button.
