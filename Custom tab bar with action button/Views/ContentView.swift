//
//  ContentView.swift
//  Custom tab bar with action button
//
//  Created by Nurtore on 25.08.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var activeTab: CustomTab = .home

    var body: some View {
        VStack {
            GlassEffectContainer(spacing: 10) {
                HStack(spacing: 10) {
                    GeometryReader {
                        MorphingTabBar(size: $0.size, activeTab: $activeTab) { tab in
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
                        .glassEffect(.regular.interactive(), in: .capsule)
                    }

                    if activeTab.showsActionButton {
                        Button {
                            print("Primary action tapped for \(activeTab.rawValue)")
                        } label: {
                            Image(systemName: activeTab.actionSymbol)
                                .font(.system(size: 22, weight: .medium))
                                .foregroundStyle(.primary)
                                .frame(width: 55, height: 55)
                                .contentShape(.capsule)
                        }
                        .tint(.primary)
                        .glassEffect(.regular.interactive(), in: .capsule)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
                .animation(.smooth(duration: 0.55, extraBounce: 0), value: activeTab)
            }
            .frame(height: 55)
        }
        .padding(.horizontal, 20)
    }
}
