//
//  LaneView.swift
//  test
//
//  Created by Michael Kan on 2/5/25.
//

import UIKit

final class LaneView: UIView {
    private var vm: LaneViewModel
    private var wordBoxViews: [UUID : WordBoxView] = [:]
    
    /// Notifies the outside when a word is captured (so we can display it).
    var onCapturedWord: ((String) -> Void)?
    
    /// Vertical gap between consecutive word labels
    private let verticalGap: CGFloat = 8
    
    init(frame: CGRect, viewModel: LaneViewModel) {
        self.vm = viewModel
        super.init(frame: frame)
        backgroundColor = .clear
        
        buildWordBoxViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildWordBoxViews() {
        // For each WordViewModel, create (or re-use) a WordBoxView
        for (i, wvm) in vm.wordVMs.enumerated() {
            let boxView = WordBoxView(viewModel: wvm)
            // Stack them vertically
            let y = CGFloat(i) * (boxView.frame.height + verticalGap)
            boxView.frame.origin.y = y
            
            // When user taps this word, forward to the LaneViewModel
            boxView.tapped = { [weak self, weak wvm] in
                guard let self = self, let wvm = wvm else { return }
                if let captured = self.vm.didTapWordBox(wvm) {
                    self.onCapturedWord?(captured)
                    self.rebuild()
                }
            }
            
            addSubview(boxView)
            wordBoxViews[wvm.id] = boxView
        }
    }
    
    /// If the lane’s data changes (like removing the captured word),
    /// we tear down & rebuild subviews.
    private func rebuild() {
        for (_, view) in wordBoxViews {
            view.removeFromSuperview()
        }
        wordBoxViews.removeAll()
        
        buildWordBoxViews()
    }
}
