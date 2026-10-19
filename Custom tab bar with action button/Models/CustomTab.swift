//
//  CustomTab.swift
//  Custom tab bar with action button
//
//  Created by Nurtore on 25.08.2026.
//

import SwiftUI

enum CustomTab: String, CaseIterable {
    case home = "Home"
    case notifications = "Notifications"
    case settings = "Settings"
    case profile = "Profile"
    
    var symbol: String {
        switch self {
        case .home: return "house"
        case .notifications: return "bell"
        case .settings: return "gearshape"
        case .profile: return "person"
        }
    }
    
    var actionSymbol: String {
        "plus"
    }

    var showsActionButton: Bool {
        self == .home
    }

    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
    
    static var homeTabs: [CustomTab] {
        [.home, .notifications, .settings]
    }
}
