//
//  ContentView.swift
//  Custom tab bar with action button
//
//  Created by Nurtore on 25.08.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var activeTab: CustomTab = .home

    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        TabView(selection: $activeTab) {
            TabSampleView(tab: .home)
                .tag(CustomTab.home)
                .toolbar(.hidden, for: .tabBar)
                .toolbarVisibility(.hidden, for: .tabBar)

            TabSampleView(tab: .notifications)
                .tag(CustomTab.notifications)
                .toolbar(.hidden, for: .tabBar)
                .toolbarVisibility(.hidden, for: .tabBar)

            TabSampleView(tab: .settings)
                .tag(CustomTab.settings)
                .toolbar(.hidden, for: .tabBar)
                .toolbarVisibility(.hidden, for: .tabBar)

            TabSampleView(tab: .profile)
                .tag(CustomTab.profile)
                .toolbar(.hidden, for: .tabBar)
                .toolbarVisibility(.hidden, for: .tabBar)
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbarVisibility(.hidden, for: .tabBar)
        .overlay(alignment: .bottom) {
            customTabBar
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    private var customTabBar: some View {
        GlassEffectContainer(spacing: 10) {
            HStack(spacing: 10) {
                MorphingTabBar(activeTab: $activeTab)
                    .zIndex(0)

                if activeTab.showsActionButton {
                    Button {

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
                    .zIndex(1)
                }
            }
            .frame(height: 55)
            .animation(.smooth(duration: 0.45, extraBounce: 0), value: activeTab)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }
}

// MARK: - Tab Sample Screen

private struct TabSampleView: View {
    let tab: CustomTab

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header Card
                    VStack(alignment: .leading, spacing: 8) {
                        Label(tab.rawValue, systemImage: tab.symbol)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        Text(welcomeMessage)
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color.primary.opacity(0.05), in: RoundedRectangle(cornerRadius: 20, style: .continuous))

                    ForEach(1...8, id: \.self) { index in
                        HStack(spacing: 14) {
                            Circle()
                                .fill(Color.primary.opacity(0.1))
                                .frame(width: 44, height: 44)
                                .overlay {
                                    Image(systemName: tab.symbol)
                                        .foregroundStyle(.primary)
                                }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(tab.rawValue) item #\(index)")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text("Sample description text for item \(index)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(14)
                        .background(Color.primary.opacity(0.03), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 90) 
            }
            .navigationTitle(tab.rawValue)
            .toolbar(.hidden, for: .tabBar)
            .toolbarVisibility(.hidden, for: .tabBar)
        }
    }

    private var welcomeMessage: String {
        switch tab {
        case .home:
            return "Welcome back! The action button is visible on this tab."
        case .notifications:
            return "You have 3 unread updates waiting."
        case .settings:
            return "Customize your experience and preferences."
        case .profile:
            return "Manage your profile and account settings."
        }
    }
}

#Preview {
    ContentView()
}
