//
//  MainViewController.swift
//  WordScapeGameTest
//
//  Created by Michael Kan on 2/6/25.
//

import UIKit

final class MainViewController: UIViewController, GameAreaViewDelegate {
    
    private var gameVM: GameAreaViewModel!
    private var gameAreaView: GameAreaView!
    
    private let capturedLabel: UILabel = {
        let label = UILabel()
        label.text = "Captured Words:\n"
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
    
    // Timer-like object that calls gameLoop() in sync with display refresh
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
        
        // Create the game area view model & game area view
        gameVM = GameAreaViewModel(wordSets: wordSets)
        gameAreaView = GameAreaView(frame: .zero, viewModel: gameVM)
        gameAreaView.delegate = self
        
        // Add subviews
        view.addSubview(capturedLabel)
        view.addSubview(gameAreaView)
        view.addSubview(startButton)
        view.addSubview(resetButton)
        
        // Button actions
        startButton.addTarget(self, action: #selector(didTouchStartButton), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(didTouchResetButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topInset = view.safeAreaInsets.top
        let bottomInset = view.safeAreaInsets.bottom
        let padding: CGFloat = 20
        
        // Layout the game area at the top
        let gameAreaHeight = view.bounds.height * 0.6
        gameAreaView.frame = CGRect(
            x: padding,
            y: topInset + padding,
            width: view.bounds.width - padding * 2,
            height: gameAreaHeight
        )
        
        // Layout captured label below the game area
        capturedLabel.frame = CGRect(
            x: padding,
            y: gameAreaView.frame.maxY + padding,
            width: view.bounds.width - padding * 2,
            height: 80
        )
        
        // Buttons at the bottom
        let buttonWidth: CGFloat = 80
        let buttonHeight: CGFloat = 44
        startButton.frame = CGRect(
            x: padding,
            y: view.bounds.height - bottomInset - padding - buttonHeight,
            width: buttonWidth,
            height: buttonHeight
        )
        resetButton.frame = CGRect(
            x: view.bounds.width - padding - buttonWidth,
            y: startButton.frame.minY,
            width: buttonWidth,
            height: buttonHeight
        )
    }
    
    // MARK: - Button Actions
    
    @objc private func didTouchStartButton() {
        // Create and start the display link if it doesn’t exist
        if displayLink == nil {
            lastTime = CACurrentMediaTime()
            displayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
            displayLink?.add(to: .main, forMode: .common)
        }
        // Let the game VM handle “start” logic
        gameVM.startGame()
    }
    
    @objc private func didTouchResetButton() {
        // Stop the display link
        displayLink?.invalidate()
        displayLink = nil
        
        // Clear captured label
        capturedLabel.text = "Captured Words:"
        
        // Re-initialize the game area
        let wordSets = [
            ["apple", "banana", "cherry", "date"],
            ["fig", "elderberry", "grape", "honeydew"],
            ["kiwi", "lemon", "mango", "nectarine"],
            ["papaya", "resberry", "orange", "quince"],
        ]
        gameVM = GameAreaViewModel(wordSets: wordSets)
        
        // Rebuild the gameAreaView
        gameAreaView.removeFromSuperview()
        let newGameArea = GameAreaView(frame: gameAreaView.frame, viewModel: gameVM)
        newGameArea.delegate = self
        view.addSubview(newGameArea)
        gameAreaView = newGameArea
    }
    
    // MARK: - Game Loop
    
    @objc private func gameLoop() {
        guard let dl = displayLink else { return }
        let now = dl.timestamp
        let dt = CGFloat(now - lastTime)
        lastTime = now
        
        // Update the game view model
        gameVM.update(deltaTime: dt,
                      gameAreaWidth: gameAreaView.bounds.width,
                      wordWidth: WordBoxView.defaultWidth)
    }
    
    // MARK: - GameAreaViewDelegate
    
    func gameAreaView(_ gameAreaView: GameAreaView, didCaptureWord word: String) {
        // Append the captured word to the label
        capturedLabel.text = (capturedLabel.text ?? "") + " " + word
    }
}
