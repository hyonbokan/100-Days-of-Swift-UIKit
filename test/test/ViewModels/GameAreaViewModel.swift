import UIKit

final class GameAreaViewModel {
    var laneViewModels: [LaneViewModel] = []
    
    init(wordSets: [[String]]) {
        // Each sub-array is one lane
        for words in wordSets {
            let laneVM = LaneViewModel(words: words)
            laneViewModels.append(laneVM)
        }
    }
    
    /// Updates all lanes in this “game area.”
    func update(deltaTime: CGFloat, gameAreaWidth: CGFloat) {
        for laneVM in laneViewModels {
            laneVM.update(deltaTime: deltaTime, laneWidth: gameAreaWidth)
        }
    }
}
