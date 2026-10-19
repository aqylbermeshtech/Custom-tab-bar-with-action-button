<div align="center">

# Custom Tab Bar with Action Button

### 1. Expanding 4th Tab Variant
<img width="458" height="290" alt="Expanding Profile Tab Bar Demo" src="https://github.com/user-attachments/assets/85fde5ed-0171-49bd-a770-673739ea75ea" />

### 2. Persistent Morphing Action Button Variant
<img width="460" height="416" alt="Morphing Action Button Tab Bar Demo" src="https://github.com/user-attachments/assets/dfebf9e7-fcd7-48b1-9c15-a85f8a781d98" />

</div>

A small SwiftUI experiment exploring two variations of a custom, capsule-shaped tab bar built on top of `UISegmentedControl` and wrapped in iOS 26's Liquid Glass (`glassEffect`):

1. **Expanding 4th Tab Variant:** Shows a 3-tab bar paired with a standalone `+` action button on the **Home** tab. Switching to **Notifications** or **Settings** pushes the action button out and expands the tab bar to reveal a 4th **Profile** tab.
2. **Persistent Action Button Variant:** Keeps a 3-tab bar alongside a floating action button whose icon cross-fades/blurs (`blurFade`) to match the currently selected tab, switching between a single tap action and a contextual popover menu.

## What it demonstrates

- Wrapping `UISegmentedControl` in `UIViewRepresentable` to get a native, hardware-accelerated sliding selection indicator instead of hand-rolling one in SwiftUI
- Dynamically inserting and removing segments (`insertSegment` / `removeSegment`) at runtime while preserving the active selection pill and hiding default segment background dividers
- Rendering each segment's SwiftUI icon/label to a `UIImage` via `ImageRenderer` and setting it as the segment's image directly (see [Implementation](#implementation) below)
- Applying `GlassEffectContainer` / `.glassEffect(.regular.interactive(), in: .capsule)` (iOS 26 Liquid Glass API) to both the tab bar and the action button so they smoothly merge and split
- Two action button behaviors:
  - **Dynamic Tab Expansion:** Conditional action button visibility (`showsActionButton`) that transitions out as the 4th `.profile` tab slides into the segmented control
  - **Contextual Icon Morphing:** Cross-fading/blurring between per-tab SF Symbols (`blurFade` view modifier) and presenting a `.popover` menu on the Settings tab

## Implementation

**[MorphingTabBar.swift](Custom%20tab%20bar%20with%20action%20button/Views/Components/MorphingTabBar.swift)** is the tab bar used by [ContentView.swift](Custom%20tab%20bar%20with%20action%20button/Views/ContentView.swift). It renders each tab's SwiftUI icon/label to a `UIImage` via `ImageRenderer` and sets it as the segment's image, hides the control's built-in background/divider `UIImageView`s while tagging the selection pill to keep it visible, and dynamically inserts or removes the 4th **Profile** segment with fluid animations.

Earlier prototype implementations and variants are kept for reference under [Legacy/](Custom%20tab%20bar%20with%20action%20button/Legacy/):
- **[LegacyCustomTabBar.swift](Custom%20tab%20bar%20with%20action%20button/Legacy/LegacyCustomTabBar.swift)**: Earlier 3-tab image-rendered prototype with the persistent morphing action button.
- **[LegacyOverlayTabBar.swift](Custom%20tab%20bar%20with%20action%20button/Legacy/LegacyOverlayTabBar.swift)**: Segmented control with SwiftUI overlay labels.

## Project Structure

```text
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
│   ├── LegacyCustomTabBar.swift          # Archived 3-tab persistent action button prototype
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
