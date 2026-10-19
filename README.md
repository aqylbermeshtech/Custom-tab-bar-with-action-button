<div align="center">

# Custom Tab Bar with Action Button

### 1. Expanding 4th Tab Variant
<img width="458" height="290" alt="Expanding Profile Tab Bar Demo" src="https://github.com/user-attachments/assets/85fde5ed-0171-49bd-a770-673739ea75ea" />

### 2. Persistent Morphing Action Button Variant
<img width="460" height="416" alt="Morphing Action Button Tab Bar Demo" src="https://github.com/user-attachments/assets/dfebf9e7-fcd7-48b1-9c15-a85f8a781d98" />

</div>

A modern, fluid SwiftUI tab bar: a custom capsule-shaped bar built in **pure SwiftUI** with `@Namespace` and `.matchedGeometryEffect` driving a native **`TabView`**, styled with iOS 26 Liquid Glass (`glassEffect`), and paired with an interactive morphing action button.

---

## Highlights

- **Native `TabView` Foundation:** Real view lifecycle management, view preservation, and independent `NavigationStack` per tab with the system tab bar cleanly hidden.
- **Hardware-Accelerated Sliding Indicator:** Pure SwiftUI `@Namespace` and `.matchedGeometryEffect` replicate the native sliding pill feel without UIKit bridging.
- **Fluid Morphing Layout:** The tab bar dynamically expands and contracts between 3 and 4 tabs (`.profile` entering/exiting smoothly), while the floating action button slides in and out alongside it.
- **Vector Crispness & Micro-Animations:** Native SF Symbols with bouncing micro-animations (`.symbolEffect(.bounce)`), adaptive tinting, and full Dynamic Type scaling on 2x/3x Super Retina displays.
- **Liquid Glass Integration:** Leverages iOS 26 `GlassEffectContainer` and `.glassEffect(.regular.interactive(), in: .capsule)` so the tab bar and action button merge visually into unified floating glass elements.
- **VoiceOver & Accessibility:** Emits proper tab accessibility traits (`.tabBar`, `.isSelected`) and combined accessibility elements.

---

## Transition: From `UISegmentedControl` to Native `TabView`

Earlier versions of this project used a bridged `UISegmentedControl` inside a `UIViewRepresentable` to mimic a tab bar. While it provided UIKit's built-in sliding indicator, it introduced critical limitations that this pure SwiftUI implementation solves:

| Limitation in `UISegmentedControl` | How Current `TabView` Implementation Solves It |
| :--- | :--- |
| **Not a Real Navigation Container:** It was an input selector, not a container. It lacked view lifecycle handling, page state preservation, and navigation hierarchies. | **Real `TabView` Architecture:** Uses standard SwiftUI `TabView(selection: $activeTab)` with child navigation stacks and scrollable views. |
| **Fragile UIKit Subview Hacking:** Relied on tagging `control.subviews.last` and hiding internal `UIImageView`s — undocumented hierarchy that breaks across iOS versions. | **100% Pure SwiftUI:** Powered entirely by declarative SwiftUI (`HStack`, `@Namespace`, `.matchedGeometryEffect`), with zero private UIKit view inspection. |
| **Rasterized Bitmaps (`ImageRenderer`):** Rendered tab icons into static `UIImage`s at hardcoded `scale = 2`, causing softness on 3x screens and breaking Dynamic Type and dark mode updates. | **Crisp Vector SF Symbols:** Pure SwiftUI `Image(systemName:)` and `Text` that render natively at any screen scale and automatically adapt to system appearances and font settings. |
| **Accessibility Semantics:** VoiceOver announced the bar as *"Segmented Control, 3 options"* instead of a tab bar. | **Standard Tab Bar Semantics:** Elements are announced with proper tab roles, combined labels, and `.isSelected` traits. |
| **Hardcoded Segment Mutations:** Adding or removing segments relied on manual UIKit index manipulation (`removeSegment(at: 3, animated: true)`). | **Declarative Tab Set:** Driven by reactive state (`displayedTabs` from `CustomTab`), animating smoothly with SwiftUI springs. |

*(Earlier prototypes are archived for reference in [`Legacy/`](Custom%20tab%20bar%20with%20action%20button/Legacy/)).*

---

## Architecture & Implementation

### 1. [MorphingTabBar.swift](Custom%20tab%20bar%20with%20action%20button/Views/Components/MorphingTabBar.swift)
The core tab bar component. It renders an `HStack` of tab buttons inside a capsule mask:
- Displays `CustomTab.homeTabs` (3 tabs) when the action button is visible, and all cases (4 tabs including `.profile`) when the action button is hidden.
- Tracks `activeTab` with a shared matched geometry capsule (`ACTIVE_TAB_PILL`) that smoothly slides across segments.
- Uses directional removal transitions and `.clipShape(Capsule())` to ensure exiting tabs collapse cleanly without ghosting into the action button space.

### 2. [ContentView.swift](Custom%20tab%20bar%20with%20action%20button/Views/ContentView.swift)
The root coordinator:
- Binds `TabView(selection: $activeTab)` to each tab screen (`Home`, `Notifications`, `Settings`, `Profile`).
- Hides the native tab bar cleanly on all child views via `.toolbarVisibility(.hidden, for: .tabBar)`.
- Overlays the floating `customTabBar` wrapped in `GlassEffectContainer`.
- Slides the action button in/out with trailing edge spring transitions when `activeTab.showsActionButton` changes.

### 3. [CustomTab.swift](Custom%20tab%20bar%20with%20action%20button/Models/CustomTab.swift)
Defines tab configurations:
- Tab enumeration (`home`, `notifications`, `settings`, `profile`).
- Associated SF Symbols (`symbol`) and action button symbols (`actionSymbol`).
- `showsActionButton` rule (enabled on `.home`).

---

## Project Structure

```text
Custom tab bar with action button/
├── App/
│   └── CustomTabBarApp.swift             # App entry point (@main)
├── Models/
│   └── CustomTab.swift                   # Tab items, icons, and action button configuration
├── Views/
│   ├── ContentView.swift                 # TabView navigation container & floating bar overlay
│   └── Components/
│       └── MorphingTabBar.swift          # Pure SwiftUI morphing tab bar with matchedGeometryEffect
├── Legacy/
│   ├── LegacyMorphingTabBar.swift        # Archived UISegmentedControl dynamic prototype
│   ├── LegacyCustomTabBar.swift          # Archived image-rendered tab bar prototype
│   └── LegacyOverlayTabBar.swift         # Archived SwiftUI-overlay tab bar prototype
└── Assets.xcassets/                      # App asset catalog
```

---

## Requirements

- macOS with **Xcode 26** or newer
- **iOS 26.1+** deployment target (for Liquid Glass APIs — `GlassEffectContainer`, `.glassEffect`)
- Swift 5 toolchain (bundled with Xcode)
- Zero external package dependencies (pure native SwiftUI)

---

## Getting Started

1. Open the project in Xcode:
   ```bash
   open "Custom tab bar with action button.xcodeproj"
   ```
2. Select an iOS Simulator running iOS 26.1+ and hit **Run (`Cmd+R`)**, or open Canvas Preview in **[ContentView.swift](Custom%20tab%20bar%20with%20action%20button/Views/ContentView.swift)**.
