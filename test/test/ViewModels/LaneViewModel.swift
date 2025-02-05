import UIKit

final class LaneViewModel {
    var wordVMs: [WordBoxViewModel]
    var activeIndex: Int = 0  // which word is currently moving
    
    init(words: [String]) {
        // Create one WordBoxViewModel per string, randomizing speed.
        self.wordVMs = words.map { word in
            let sp = CGFloat.random(in: 60...300)
            return WordBoxViewModel(word: word, speed: sp)
        }
        // Make the first word (if any) start moving
//        if !wordVMs.isEmpty {
//            wordVMs[0].state = .moving
//        }
    }
    
    /// Updates the active word’s position. If it reaches the right edge, mark it finished and move on.
    func update(deltaTime: CGFloat, laneWidth: CGFloat) {
        guard activeIndex < wordVMs.count else { return }
        
        let activeWord = wordVMs[activeIndex]
        activeWord.move(deltaTime: deltaTime)
        
        // Suppose each WordBox is 100 points wide:
        let maxX = laneWidth - 100
        if activeWord.xPosition >= maxX {
            activeWord.xPosition = maxX
            activeWord.state = .finished
            
            activeIndex += 1
            if activeIndex < wordVMs.count {
                wordVMs[activeIndex].state = .moving
            }
        }
    }
    
    /// Called when the user taps a word. If it’s the active word and is moving, capture it.
    /// Returns the captured word’s string if successful.
    func didTapWordBox(_ tappedVM: WordBoxViewModel) -> String? {
        // Must tap the active word, which must be .moving
        guard activeIndex < wordVMs.count else { return nil }
        let activeWord = wordVMs[activeIndex]
        
        if tappedVM.id == activeWord.id, activeWord.state == .moving {
            activeWord.state = .captured
            let captured = activeWord.word
            
            // Remove it from the array
            wordVMs.remove(at: activeIndex)
            // Next word (if any) becomes active:
            if activeIndex < wordVMs.count {
                wordVMs[activeIndex].state = .moving
            }
            return captured
        }
        return nil
    }
}
