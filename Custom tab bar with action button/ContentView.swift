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
        case .settings: return "cloud.moon.fill"
        }
    }
    
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}


struct ContentView: View {
    @State private var activeTab: CustomTab = .home
    var body: some View {
        VStack {
            GlassEffectContainer(spacing: 10) {
                HStack(spacing: 10) {
                    GeometryReader {
                        CustomTabBar(size: $0.size, activeTab: $activeTab) { tab in
                            VStack(spacing: 3) {
                                Image(systemName: tab.symbol)
                                    .font(.title)
                                
                                Text(tab.rawValue)
                                    .font(.system(size: 10))
                                    .fontWeight(.medium)
                            }
                            .symbolVariant(.fill)
                            .frame(maxWidth: .infinity)
                        }
                        .glassEffect(.regular.interactive(), in:.capsule)
                    }
                    ZStack {
                        ForEach(CustomTab.allCases, id: \.rawValue) { tab in
                            Image(systemName: tab.actionSymbol)
                                .font(.system(size: 22, weight: .medium))
                                .blurFade(activeTab == tab)
                        }
                    }
                    .frame(width: 55, height: 55)
                    .glassEffect(.regular.interactive(), in: .capsule)
                    .animation(.smooth(duration: 0.55, extraBounce: 0), value: activeTab)
                    
                }
            }
            .frame(height: 55)
        }
        .padding(.horizontal, 20)
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
