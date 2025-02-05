import UIKit

/// The main view controller that hosts the game area and the captured-words display.
class MainViewController: UIViewController {
    
    private var gameVM: GameAreaViewModel!
    private var gameAreaView: GameAreaView!
    
    private let capturedLabel: UILabel = {
        let label = UILabel()
        label.text = "Captured Words:"
        label.numberOfLines = 0
        label.backgroundColor = UIColor.systemGray6
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        return button
    }()
    
    private var displayLink: CADisplayLink?
    private var lastTime: CFTimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Example word sets for each lane
        let wordSets = [
            ["apple", "banana", "cherry", "date"],
            ["fig", "elderberry", "grape", "honeydew"],
            ["kiwi", "lemon", "mango", "nectarine"],
            ["papaya", "resberry", "orange", "quince"],
        ]
        
        // Initialize ViewModel & game area
        gameVM = GameAreaViewModel(wordSets: wordSets)
        gameAreaView = GameAreaView(frame: .zero, viewModel: gameVM)
        gameAreaView.onCapturedWord = { [weak self] word in
            guard let self = self else { return }
            self.capturedLabel.text = (self.capturedLabel.text ?? "") + " " + word
        }
        
        // Add subviews
        view.addSubview(capturedLabel)
        view.addSubview(gameAreaView)
        view.addSubview(startButton)
        view.addSubview(resetButton)
        
        // Button actions
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topInset = view.safeAreaInsets.top
        let bottomInset = view.safeAreaInsets.bottom
        let margin: CGFloat = 20
        
        // Layout the captured label at the top
        capturedLabel.frame = CGRect(
            x: margin,
            y: topInset + margin,
            width: view.bounds.width - margin*2,
            height: 60
        )
        
        // Buttons at the bottom
        let buttonWidth: CGFloat = 80
        let buttonHeight: CGFloat = 44
        
        startButton.frame = CGRect(
            x: margin,
            y: view.bounds.height - bottomInset - margin - buttonHeight,
            width: buttonWidth,
            height: buttonHeight
        )
        
        resetButton.frame = CGRect(
            x: view.bounds.width - margin - buttonWidth,
            y: startButton.frame.origin.y,
            width: buttonWidth,
            height: buttonHeight
        )
        
        // Game area in between
        let gameAreaY = capturedLabel.frame.maxY + margin
        let gameAreaHeight = startButton.frame.minY - margin - gameAreaY
        gameAreaView.frame = CGRect(
            x: margin,
            y: gameAreaY,
            width: view.bounds.width - margin*2,
            height: gameAreaHeight
        )
    }
    
    @objc private func startGame() {
        // Start the CADisplayLink if not already
        if displayLink == nil {
            lastTime = CACurrentMediaTime()
            let dl = CADisplayLink(target: self, selector: #selector(gameLoop))
            dl.add(to: .main, forMode: .common)
            displayLink = dl
        }
        for laneVM in gameVM.laneViewModels {
            if !laneVM.wordVMs.isEmpty {
                laneVM.wordVMs[0].state = .moving
            }
        }
    }
    
    @objc private func resetGame() {
        // Stop the display link
        displayLink?.invalidate()
        displayLink = nil
        
        // Clear captured label
        capturedLabel.text = "Captured Words:"
        
        // Re-instantiate the view model & game area
        let wordSets = [
            ["apple", "banana", "cherry", "date"],
            ["fig", "elderberry", "grape", "honeydew"],
            ["kiwi", "lemon", "mango", "nectarine"],
            ["papaya", "resberry", "orange", "quince"],
        ]
        gameVM = GameAreaViewModel(wordSets: wordSets)
        gameAreaView.removeFromSuperview()
        
        let newGameArea = GameAreaView(frame: gameAreaView.frame, viewModel: gameVM)
        newGameArea.onCapturedWord = { [weak self] word in
            self?.capturedLabel.text?.append(" \(word)")
        }
        view.addSubview(newGameArea)
        gameAreaView = newGameArea
    }
    
    @objc private func gameLoop() {
        guard let dl = displayLink else { return }
        let now = dl.timestamp
        let dt = CGFloat(now - lastTime)
        lastTime = now
        
        // Update the ViewModel
        gameVM.update(deltaTime: dt, gameAreaWidth: gameAreaView.bounds.width)
        // No direct "redraw" needed. Each WordBoxView is bound to its ViewModel,
        // so when `xPosition` or `state` changes, the label updates automatically.
    }
}
