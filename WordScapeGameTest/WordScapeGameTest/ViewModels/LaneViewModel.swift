//
//  LaneViewModel.swift
//  WordScapeGameTest
//
//  Created by Michael Kan on 2/6/25.
//

import UIKit

final class LaneViewModel {
    var wordVMs: [WordBoxViewModel]
    var activeIndex: Int = 0
    
    init(words: [String]) {
        // Create a WordBoxViewModel for each word, randomizing speed.
        self.wordVMs = words.map { str in
            let sp = CGFloat.random(in: 60...300) // Speed range for variety
            return WordBoxViewModel(word: str, speed: sp)
        }
    }
    
    /// Updates the active word’s position. If it hits the right edge, mark it finished and advance.
    func update(deltaTime: CGFloat, laneWidth: CGFloat, wordWidth: CGFloat) {
        guard activeIndex < wordVMs.count else { return }
        let activeWord = wordVMs[activeIndex]
        
        activeWord.move(deltaTime: deltaTime)
        
        let finishX = laneWidth - wordWidth
        if activeWord.xPosition >= finishX {
            activeWord.xPosition = finishX
            activeWord.state = .finished
            // Move to the next word
            activeIndex += 1
            if activeIndex < wordVMs.count {
                wordVMs[activeIndex].state = .moving
            }
        }
    }
    
    /// When the user taps a word that’s the active word (and is .moving),
    /// capture (remove) it from the array. Returns the captured word’s text.
    func captureActiveWordIfMoving(_ tappedVM: WordBoxViewModel) -> String? {
        guard activeIndex < wordVMs.count else { return nil }
        let activeVM = wordVMs[activeIndex]
        
        // Only capture if it’s the active word & moving.
        if tappedVM.id == activeVM.id, activeVM.state == .moving {
            activeVM.state = .captured
            let captured = activeVM.word
            wordVMs.remove(at: activeIndex)
            advanceActiveWord()
            return captured
        }
        return nil
    }
    
    /// Advances the active index so the next word (if any) becomes active.
    private func advanceActiveWord() {
        activeIndex = min(activeIndex, wordVMs.count) // keep in range
        if activeIndex < wordVMs.count {
            wordVMs[activeIndex].state = .moving
        }
    }
    
    /// Called if we want the lane to begin movement (for example at game start).
    func start() {
        if !wordVMs.isEmpty {
            wordVMs[0].state = .moving
        }
    }
}



