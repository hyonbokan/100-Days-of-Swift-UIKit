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

// MARK: - WordBoxView (the UILabel that binds to a WordBoxViewModel)

final class WordBoxView: UILabel {
    private var vm: WordBoxViewModel
    
    /// Called when the user taps this label.
    var tapped: (() -> Void)?
    
    init(viewModel: WordBoxViewModel) {
        self.vm = viewModel
        // Frame: 100x40 for simplicity
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        
        layer.cornerRadius = 8
        clipsToBounds = true
        textAlignment = .center
        textColor = .white
        
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
