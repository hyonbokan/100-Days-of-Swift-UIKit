//
//  WordBoxView.swift
//  test
//
//  Created by Michael Kan on 2/5/25.
//

import UIKit

final class WordBoxView: UILabel {
    private var vm: WordBoxViewModel
    
    /// Called when the user taps this label.
    var tapped: (() -> Void)?
    
    init(viewModel: WordBoxViewModel) {
        self.vm = viewModel
        super.init(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        
        layer.cornerRadius = 5
        clipsToBounds = true
        textAlignment = .center
        textColor = .white
        font = UIFont(name: "Arial-BoldMT", size: 14)
        
        // Enable user interaction so taps register
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGesture)
        
        // Bind the view model to update UI when it changes
        vm.onChange = { [weak self] in
            self?.refreshUI()
        }
        
        // Initial setup
        text = vm.word
        refreshUI()
    }
    
    @objc private func didTap() {
        tapped?()  // Let the containing lane know
    }
    
    /// Refresh this label's appearance (position, color) from the ViewModel.
    private func refreshUI() {
        // Position:
        frame.origin.x = vm.xPosition
        
        // Color:
        switch vm.state {
        case .set:
            backgroundColor = .orange
        case .moving:
            backgroundColor = .green
        case .finished:
            backgroundColor = .blue
        case .captured:
            backgroundColor = .purple
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

