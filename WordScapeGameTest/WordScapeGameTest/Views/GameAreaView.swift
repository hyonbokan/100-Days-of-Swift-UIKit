//
//  GameAreaView.swift
//  WordScapeGameTest
//
//  Created by Michael Kan on 2/6/25.
//

import UIKit

protocol GameAreaViewDelegate: AnyObject {
    func gameAreaView(_ gameAreaView: GameAreaView, didCaptureWord word: String)
}

/// A custom view that displays multiple lanes (LaneView) arranged vertically.
final class GameAreaView: UIView, LaneViewDelegate {
    
    private let gameVM: GameAreaViewModel
    weak var delegate: GameAreaViewDelegate?
    
    private var laneViews: [LaneView] = []
    
    init(frame: CGRect, viewModel: GameAreaViewModel) {
        self.gameVM = viewModel
        super.init(frame: frame)
        backgroundColor = .systemGray4
        
        setupLaneViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Create a LaneView for each LaneViewModel, stack them vertically.
    private func setupLaneViews() {
        laneViews.forEach { $0.removeFromSuperview() }
        laneViews.removeAll()
        
        let laneHeight = bounds.height / CGFloat(gameVM.laneViewModels.count)
        for (i, laneVM) in gameVM.laneViewModels.enumerated() {
            let laneView = LaneView(
                frame: CGRect(
                    x: 0,
                    y: CGFloat(i) * laneHeight,
                    width: bounds.width,
                    height: laneHeight
                ),
                laneViewModel: laneVM
            )
            laneView.delegate = self
            addSubview(laneView)
            laneViews.append(laneView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard laneViews.count == gameVM.laneViewModels.count else { return }
        
        let laneHeight = bounds.height / CGFloat(laneViews.count)
        for (i, laneView) in laneViews.enumerated() {
            laneView.frame = CGRect(
                x: 0,
                y: CGFloat(i) * laneHeight,
                width: bounds.width,
                height: laneHeight
            )
        }
    }
    
    /// LaneViewDelegate
    /// Called when a lane captures a word
    func laneView(_ laneView: LaneView, didCaptureWord word: String) {
        delegate?.gameAreaView(self, didCaptureWord: word)
    }
}
