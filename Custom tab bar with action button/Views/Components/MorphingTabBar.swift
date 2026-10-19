//
//  MorphingTabBar.swift
//  Custom tab bar with action button
//
//  Created by Nurtore on 25.08.2026.
//

import SwiftUI

struct MorphingTabBar: View {
    @Binding var activeTab: CustomTab
    var barTint: Color = .primary.opacity(0.12)
    @Namespace private var tabAnimation
    
    private var displayedTabs: [CustomTab] {
        activeTab.showsActionButton ? CustomTab.homeTabs : CustomTab.allCases
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(displayedTabs, id: \.self) { tab in
                Button {
                    guard activeTab != tab else { return }
                    withAnimation(.smooth(duration: 0.45, extraBounce: 0)) {
                        activeTab = tab
                    }
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: tab.symbol)
                            .font(.system(size: 19, weight: .medium))
                            .symbolEffect(.bounce, value: activeTab == tab)
                        
                        Text(tab.rawValue)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .symbolVariant(activeTab == tab ? .fill : .none)
                    .foregroundStyle(activeTab == tab ? .primary : .secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.capsule)
                    .background {
                        if activeTab == tab {
                            Capsule()
                                .fill(barTint)
                                .matchedGeometryEffect(id: "ACTIVE_TAB_PILL", in: tabAnimation)
                        }
                    }
                }
                .buttonStyle(.plain)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.85)),
                    removal: .scale(scale: 0.01, anchor: .leading).combined(with: .opacity)
                ))
                .accessibilityElement(children: .combine)
                .accessibilityLabel(tab.rawValue)
                .accessibilityAddTraits(activeTab == tab ? [.isButton, .isSelected] : [.isButton])
            }
        }
        .padding(4)
        .clipShape(Capsule())
        .glassEffect(.regular.interactive(), in: .capsule)
    }
}
