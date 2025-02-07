//
//  LaneView.swift
//  test
//
//  Created by Michael Kan on 2/5/25.
//

import UIKit

protocol LaneViewDelegate: AnyObject {
    func laneView(_ laneView: LaneView, didCaptureWord word: String)
}

/// A custom view representing a single lane (row).
/// It stacks WordBoxViews vertically. Only the top (active) word moves.
final class LaneView: UIView, WordBoxViewDelegate {
    
    private let laneVM: LaneViewModel
    weak var delegate: LaneViewDelegate?
    
    private var boxViews: [WordBoxView] = []
    
    let verticalGap: CGFloat = 8
    
    init(frame: CGRect, laneViewModel: LaneViewModel) {
        self.laneVM = laneViewModel
        super.init(frame: frame)
        backgroundColor = .clear
        buildViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Create a WordBoxView for each WordBoxViewModel in the lane,
    /// stacking them vertically.
    private func buildViews() {
        for (i, wordVM) in laneVM.wordVMs.enumerated() {
            let boxView = WordBoxView(viewModel: wordVM)
            boxView.delegate = self
            let yPos = CGFloat(i) * (boxView.frame.height + verticalGap)
            boxView.frame.origin.y = yPos
            addSubview(boxView)
            boxViews.append(boxView)
        }
    }
    
    /// Rebuild the lane if the lane VM changes (e.g. a word was removed).
    private func rebuildViews() {
        // Remove old subviews
        for boxView in boxViews {
            boxView.removeFromSuperview()
        }
        boxViews.removeAll()
        
        buildViews()
    }
    
    /// WordBoxViewDelegate
    /// Called when a box is tapped.
    func wordBoxViewDidTap(_ wordBoxView: WordBoxView) {
        let tappedVM = wordBoxView.viewModel
        if let capturedWord = laneVM.captureActiveWordIfMoving(tappedVM) {
            // The lane VM removed the active word. Rebuild subviews
            rebuildViews()
            // Notify the LaneView’s delegate
            delegate?.laneView(self, didCaptureWord: capturedWord)
        }
    }
}
