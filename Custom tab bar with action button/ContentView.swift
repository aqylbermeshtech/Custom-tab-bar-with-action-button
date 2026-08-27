//
//  ContentView.swift
//  Custom tab bar with action button
//
//  Created by Nurtore on 25.08.2026.
//

import SwiftUI

enum CustomTab: String, CaseIterable {
    case home = "Home"
    case notifications = "Notifications"
    case settings = "Settings"
    
    var symbol: String {
        switch self {
        case .home: return "house"
        case .notifications: return "bell"
        case .settings: return "gearshape"
        }
    }
    
    var actionSymbol: String {
        switch self {
        case .home: return "plus"
        case .notifications: return "tray.full.fill"
        case .settings: return "ellipsis"
        }
    }

    var hasSingleAction: Bool {
        self != .settings
    }

    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}


struct ContentView: View {
    @State private var activeTab: CustomTab = .home
    @State private var isSettingsMenuPresented = false

    var body: some View {
        VStack {
            GlassEffectContainer(spacing: 10) {
                HStack(spacing: 10) {
                    GeometryReader {
                        CustomTabBar(size: $0.size, activeTab: $activeTab) { tab in
                            VStack(spacing: 3) {
                                Image(systemName: tab.symbol)
                                    .font(.title3)

                                Text(tab.rawValue)
                                    .font(.system(size: 10))
                                    .fontWeight(.medium)
                            }
                            .symbolVariant(.fill)
                            .frame(maxWidth: .infinity)
                        }
                        .glassEffect(.regular.interactive(), in:.capsule)
                    }
                    Group {
                        if activeTab.hasSingleAction {
                            Button {
                                // TODO: hook up this tab's real primary action.
                                print("Primary action tapped for \(activeTab.rawValue)")
                            } label: {
                                actionIcon
                            }
                        } else {
                            Button {
                                isSettingsMenuPresented = true
                            } label: {
                                actionIcon
                            }
                        }
                    }
                    .tint(.primary)
                    .frame(width: 55, height: 55)
                    .contentShape(.capsule)
                    .glassEffect(.regular.interactive(), in: .capsule)
                    .animation(.smooth(duration: 0.55, extraBounce: 0), value: activeTab)
                    .popover(isPresented: $isSettingsMenuPresented, arrowEdge: .bottom) {
                        settingsMenuContent
                            .presentationCompactAdaptation(.popover)
                    }
                }
            }
            .frame(height: 55)
        }
        .padding(.horizontal, 20)
    }

    private var settingsMenuContent: some View {
        VStack(spacing: 0) {
            settingsMenuRow(title: "Appearance", systemImage: "paintbrush")
            settingsMenuRow(title: "Notifications", systemImage: "bell.badge")
            settingsMenuRow(title: "Privacy", systemImage: "lock")
            Divider()
            settingsMenuRow(title: "About", systemImage: "info.circle")
        }
        .frame(width: 220)
        .padding(.vertical, 4)
    }

    private func settingsMenuRow(title: String, systemImage: String) -> some View {
        Button {
            // TODO: hook up this menu item's real action.
            isSettingsMenuPresented = false
        } label: {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: systemImage)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }

    private var actionIcon: some View {
        ZStack {
            ForEach(CustomTab.allCases, id: \.rawValue) { tab in
                Image(systemName: tab.actionSymbol)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(.primary)
                    .blurFade(activeTab == tab)
            }
        }
    }
}

extension View {
    @ViewBuilder
    func blurFade(_ status: Bool) -> some View {
        self
            .compositingGroup()
            .blur(radius: status ? 0 : 10)
            .opacity(status ? 1 : 0)
    }
}

#Preview {
    ContentView()
}
