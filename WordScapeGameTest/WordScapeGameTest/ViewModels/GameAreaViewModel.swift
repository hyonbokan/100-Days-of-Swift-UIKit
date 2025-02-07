//
//  GameAreaViewModel.swift
//  WordScapeGameTest
//
//  Created by Michael Kan on 2/6/25.
//

import UIKit

final class GameAreaViewModel {
    var laneViewModels: [LaneViewModel] = []
    
    /// Initialize with an array of lane word arrays.
    init(wordSets: [[String]]) {
        for words in wordSets {
            laneViewModels.append(LaneViewModel(words: words))
        }
    }
    
    /// Called when the user taps "Start".
    /// Each lane’s first word begins moving.
    func startGame() {
        for laneVM in laneViewModels {
            laneVM.start()
        }
    }
    
    /// Each frame, update all lanes’ active words.
    func update(deltaTime: CGFloat, gameAreaWidth: CGFloat, wordWidth: CGFloat) {
        for laneVM in laneViewModels {
            laneVM.update(deltaTime: deltaTime, laneWidth: gameAreaWidth, wordWidth: wordWidth)
        }
    }
}
