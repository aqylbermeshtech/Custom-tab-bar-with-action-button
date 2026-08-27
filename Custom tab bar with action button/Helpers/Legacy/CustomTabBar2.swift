//
//  CustomTabBar2.swift
//  Custom tab bar with action button
//
//  Created by Nurtore on 25.08.2026.
//
//  ARCHIVED — kept for reference only, not compiled into ContentView.
//  This was "Method 2" (SwiftUI overlay for labels on top of an
//  empty-titled UISegmentedControl). The project now uses CustomTabBar
//  ("Method 1", ../CustomTabBar.swift), which renders each segment's
//  icon/label to a UIImage via ImageRenderer. See the README's
//  "Implementation" section for why.
//

import SwiftUI

struct CustomTabBar2: UIViewRepresentable {
    var size: CGSize
    var barTint: Color = .gray.opacity(0.15)
    @Binding var activeTab: CustomTab
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UISegmentedControl {
        let items = CustomTab.allCases.compactMap({ _ in "" })
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
    
        
        DispatchQueue.main.async {
            for subview in control.subviews {
                if subview is UIImageView && subview != control.subviews.last {
                    subview.alpha = 0
                }
            }
        }
        control.selectedSegmentTintColor = UIColor(barTint)


        
        control.addTarget(context.coordinator, action: #selector(context.coordinator.tabSelected(_:)), for: .valueChanged)
        return control
    }
        
    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UISegmentedControl, context: Context) -> CGSize? {
        return size
    }
    
    class Coordinator: NSObject {
        var parent: CustomTabBar2
        init(parent: CustomTabBar2) {
            self.parent = parent
        }
        
        @objc func tabSelected(_ control: UISegmentedControl) {
            parent.activeTab = CustomTab.allCases[control.selectedSegmentIndex]
        }
    }
}
