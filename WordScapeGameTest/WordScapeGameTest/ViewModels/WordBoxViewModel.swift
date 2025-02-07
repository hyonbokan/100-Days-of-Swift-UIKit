//
//  WordBoxViewModel.swift
//  WordScapeGameTest
//
//  Created by Michael Kan on 2/6/25.
//

import UIKit

/// A simple protocol for the WordBoxViewModel to notify its delegate of changes.
protocol WordBoxViewModelDelegate: AnyObject {
    func wordDidUpdate(_ viewModel: WordBoxViewModel)
}

/// The data & logic for a single moving word.
final class WordBoxViewModel {
    let id = UUID()
    
    let word: String
    let speed: CGFloat
    
    // Observed properties that trigger UI updates.
    var state: WordState {
        didSet { delegate?.wordDidUpdate(self) }
    }
    var xPosition: CGFloat {
        didSet { delegate?.wordDidUpdate(self) }
    }
    
    weak var delegate: WordBoxViewModelDelegate?
    
    init(word: String, speed: CGFloat) {
        self.word = word
        self.speed = speed
        self.state = .set
        self.xPosition = 0
    }
    
    /// Moves horizontally if the word is in `.moving` state.
    /// - Parameter deltaTime: The time elapsed (in seconds) since last frame.
    func move(deltaTime: CGFloat) {
        guard state == .moving else { return }
        xPosition += speed * deltaTime
    }
}
