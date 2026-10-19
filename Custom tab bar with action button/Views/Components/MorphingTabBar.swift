//
//  MorphingTabBar.swift
//  Morphing Tab bar
//
//  Created by Nurtore on 25.08.2026.
//

import SwiftUI

struct MorphingTabBar<TabItemView: View>: UIViewRepresentable {
    var size: CGSize
    var activeTint: Color = .blue
    var barTint: Color = .gray.opacity(0.15)
    @Binding var activeTab: CustomTab
    @ViewBuilder var tabItemView: (CustomTab) -> TabItemView
    
    private let selectionViewTag = 999
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UISegmentedControl {
        let initialTabs = activeTab.showsActionButton ? CustomTab.homeTabs : CustomTab.allCases
        let items = initialTabs.map(\.rawValue)
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = min(activeTab.index, initialTabs.count - 1)
        
        for (index, tab) in initialTabs.enumerated() {
            control.setImage(renderImage(for: tab), forSegmentAt: index)
        }
        
        DispatchQueue.main.async {
            control.subviews.last?.tag = selectionViewTag
            hideBackgroundImageViews(in: control)
        }
        
        control.selectedSegmentTintColor = UIColor(barTint)
        control.setTitleTextAttributes([.foregroundColor: UIColor(activeTint)], for: .selected)
        
        control.addTarget(
            context.coordinator,
            action: #selector(context.coordinator.tabSelected(_:)),
            for: .valueChanged
        )
        return control
    }
    
    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        context.coordinator.parent = self
        
        if activeTab.showsActionButton {
            if uiView.selectedSegmentIndex != activeTab.index {
                uiView.selectedSegmentIndex = activeTab.index
            }
            if uiView.numberOfSegments == 4 {
                uiView.removeSegment(at: 3, animated: true)
                DispatchQueue.main.async {
                    hideBackgroundImageViews(in: uiView)
                }
            }
        } else {
            if uiView.numberOfSegments == 3 {
                let profileImage = renderImage(for: .profile)
                uiView.insertSegment(with: profileImage, at: 3, animated: true)
                DispatchQueue.main.async {
                    hideBackgroundImageViews(in: uiView)
                }
            }
            if uiView.selectedSegmentIndex != activeTab.index {
                uiView.selectedSegmentIndex = activeTab.index
            }
        }
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UISegmentedControl, context: Context) -> CGSize? {
        return size
    }
    
    private func renderImage(for tab: CustomTab) -> UIImage? {
        let renderer = ImageRenderer(content: tabItemView(tab))
        renderer.scale = 2
        return renderer.uiImage
    }
    
    private func hideBackgroundImageViews(in control: UISegmentedControl) {
        if !control.subviews.contains(where: { $0.tag == selectionViewTag }) {
            control.subviews.last?.tag = selectionViewTag
        }
        for subview in control.subviews {
            if subview is UIImageView && subview.tag != selectionViewTag {
                subview.alpha = 0
                subview.isHidden = true
            }
        }
    }
    
    class Coordinator: NSObject {
        var parent: MorphingTabBar
        init(parent: MorphingTabBar) {
            self.parent = parent
        }
        
        @objc func tabSelected(_ control: UISegmentedControl) {
            let index = control.selectedSegmentIndex
            guard CustomTab.allCases.indices.contains(index) else { return }
            withAnimation(.smooth(duration: 0.55, extraBounce: 0)) {
                parent.activeTab = CustomTab.allCases[index]
            }
        }
    }
}
