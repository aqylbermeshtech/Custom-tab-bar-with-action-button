# Custom Tab Bar with Action Button

A small SwiftUI experiment: a custom, capsule-shaped tab bar built on top of `UISegmentedControl` and wrapped in iOS 26's Liquid Glass (`glassEffect`), paired with a floating "action button" whose icon morphs to match the currently selected tab.

## What it demonstrates

- Wrapping `UISegmentedControl` in `UIViewRepresentable` to get a native, hardware-accelerated sliding selection indicator instead of hand-rolling one in SwiftUI
- Two different approaches to labeling the segments (see [Implementations](#implementations) below)
- Applying `GlassEffectContainer` / `.glassEffect(.regular.interactive(), in:)` (iOS 26 Liquid Glass API) to both the tab bar and the action button so they visually merge into one floating pill
- An action button that cross-fades/blurs between per-tab SF Symbols (`blurFade` view modifier) driven by the active tab, animated with `.smooth`

## Implementations

The project contains two versions of the tab bar, built up as separate commits ("First Method", "Second Method"):

- **[CustomTabBar.swift](Custom%20tab%20bar%20with%20action%20button/Helpers/CustomTabBar.swift)** — renders each tab's SwiftUI icon/label to a `UIImage` via `ImageRenderer` and sets it as the segment's image directly.
- **[CustomTabBar2.swift](Custom%20tab%20bar%20with%20action%20button/Helpers/CustomTabBar2.swift)** — creates the `UISegmentedControl` with empty segment titles and lets SwiftUI draw the icons/labels in an `.overlay` on top, which is what [ContentView.swift](Custom%20tab%20bar%20with%20action%20button/ContentView.swift) currently uses (the `CustomTabBar` call site is commented out).

Both hide the control's built-in divider images and only tint the selected-segment background, so visually it reads as a plain glass capsule rather than a stock segmented control.

## Project Structure

```
Custom tab bar with action button/
├── Custom_tab_bar_with_action_buttonApp.swift   # App entry point
├── ContentView.swift                             # Tab bar + action button layout, CustomTab enum
├── Helpers/
│   ├── CustomTabBar.swift                        # Segmented control, image-rendered segments
│   └── CustomTabBar2.swift                        # Segmented control, SwiftUI overlay segments
└── Assets.xcassets/
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
- This is a UI experiment/reference implementation, not a full app — there's no navigation behind the tabs yet, just the selector and action button.
