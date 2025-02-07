//
//  WordBoxView.swift
//  WordScapeGameTest
//
//  Created by Michael Kan on 2/6/25.
//

import UIKit

protocol WordBoxViewDelegate: AnyObject {
    func wordBoxViewDidTap(_ wordBoxView: WordBoxView)
}

/// A custom UILabel that visually represents a single WordBoxViewModel.
final class WordBoxView: UILabel, WordBoxViewModelDelegate {
    
    private let vm: WordBoxViewModel
    
    weak var delegate: WordBoxViewDelegate?
    
    init(viewModel: WordBoxViewModel) {
        self.vm = viewModel
        super.init(frame: CGRect(x: 0, y: 0, width: WordBoxView.defaultWidth, height: 20))
        
        layer.cornerRadius = 6
        clipsToBounds = true
        textAlignment = .center
        textColor = .white
        font = UIFont.boldSystemFont(ofSize: 14)
        isUserInteractionEnabled = true
        
        // Assign self as the view model’s delegate
        vm.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSelf))
        addGestureRecognizer(tapGesture)
        
        // Initial UI
        text = vm.word
        refreshUI()
    }
    
    static let defaultWidth: CGFloat = 80
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Called whenever the WordBoxViewModel changes (position or state).
    func wordDidUpdate(_ viewModel: WordBoxViewModel) {
        refreshUI()
    }
    
    /// Apply the view model’s updated state/position to the UI.
    private func refreshUI() {
        // Position
        frame.origin.x = vm.xPosition
        
        // Background color
        switch vm.state {
        case .set: backgroundColor = .orange
        case .moving: backgroundColor = .green
        case .finished: backgroundColor = .blue
        case .captured: backgroundColor = .purple
        }
    }
    
    @objc private func didTapSelf() {
        delegate?.wordBoxViewDidTap(self)
    }
    
    // Accessor so the lane knows which model is tapped
    var viewModel: WordBoxViewModel {
        return vm
    }
}

