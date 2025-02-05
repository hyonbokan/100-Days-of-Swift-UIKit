import UIKit

// MARK: - Shared Model (State)

/// The possible states for each moving word.
enum WordState {
    case set       // Word is stacked at left, not yet moving (orange)
    case moving    // Word is currently moving (green)
    case finished  // Word reached the right edge (blue)
    case captured  // Word was tapped (purple)
}

// MARK: - WordBoxViewModel

/// Each word's data & logic: text, speed, position, etc.
final class WordBoxViewModel {
    let id = UUID()
    let word: String
    let speed: CGFloat
    
    /// Observables: changing these triggers onChange callback, so the view can update.
    var state: WordState {
        didSet { onChange?() }
    }
    var xPosition: CGFloat {
        didSet { onChange?() }
    }
    
    /// Called every time state or position changes, so the bound view can refresh.
    var onChange: (() -> Void)?
    
    init(word: String, speed: CGFloat) {
        self.word = word
        self.speed = speed
        self.state = .set
        self.xPosition = 0
    }
    
    /// Moves horizontally if the word is in .moving state.
    func move(deltaTime: CGFloat) {
        guard state == .moving else { return }
        xPosition += speed * deltaTime
    }
}
