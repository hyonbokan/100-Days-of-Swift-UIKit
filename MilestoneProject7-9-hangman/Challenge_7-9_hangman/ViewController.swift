//
//  ViewController.swift
//  Challenge_7-9_hangman
//
//  Created by dnlab on 2023/06/22.
//

import UIKit

class ViewController: UIViewController {

    var currentAnswer: UITextField!
    var hangMan: UILabel!
    var wordToGuessLabel: UILabel!
    var lettersButtons = [UIButton]()
    var activatedButtonText = [String]()
    var lettersToGuess = [String]()
    var allWord = [String]()
    var wordToGuess = ""
    let hangmanParts = [
        """
            _______
           |/      |
           |
           |
           |
           |
           |
        """,
        """
            _______
           |/      |
           |      (_)
           |
           |
           |
           |
        """,
        """
            _______
           |/      |
           |      (_)
           |       |
           |
           |
           |
        """,
        """
            _______
           |/      |
           |      (_)
           |      \\|
           |
           |
           |
        """,
        """
            _______
           |/      |
           |      (_)
           |      \\|/
           |
           |
           |
        """,
        """
            _______
           |/      |
           |      (_)
           |      \\|/
           |       |
           |
           |
        """,
        """
            _______
           |/      |
           |      (_)
           |      \\|/
           |       |
           |      /
           |
        """,
        """
            _______
           |/      |
           |      (_)
           |      \\|/
           |       |
           |      / \\
           |
        """
    ]

    let alphabet = Array("abcdefghijklmnopqrstuvwxyz")
    var strike = 0
    
    // loadView to show the UI elements and layout
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        hangMan = UILabel()
        hangMan.translatesAutoresizingMaskIntoConstraints = false
        hangMan.font = UIFont.systemFont(ofSize: 50)
        hangMan.numberOfLines = 0
        hangMan.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(hangMan)
        
        wordToGuessLabel = UILabel()
        wordToGuessLabel.translatesAutoresizingMaskIntoConstraints = false
        wordToGuessLabel.font = UIFont.systemFont(ofSize: 50)
        wordToGuessLabel.text = "Guess the word"
        wordToGuessLabel.numberOfLines = 0
        wordToGuessLabel.textAlignment = .right
        //By setting a lower content hugging priority for a view, you allow it to be stretched or expanded more easily to accommodate additional space. Conversely, setting a higher content hugging priority makes the view more resistant to stretching.
        wordToGuessLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(wordToGuessLabel)
        
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        // why the color is not changing
        currentAnswer.textColor = UIColor.lightGray
        currentAnswer.placeholder = "?????"
        currentAnswer.isUserInteractionEnabled = false
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        view.addSubview(currentAnswer)
    
        
        //The area for buttons
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        // Adding buttons
        let width = 80
        let height = 80
        
        let numRows = 5
        let numColumns = 7

        for row in 0..<numRows {
            for column in 0..<numColumns {
                let index = row * numColumns + column
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 26)
                if index < alphabet.count {
                    let letter = alphabet[index]
                    letterButton.setTitle(String(letter), for: .normal)
                    letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                    // check here to fix the grid!!!!!
                    let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                    letterButton.frame = frame
                    letterButton.layer.borderColor = UIColor.lightGray.cgColor
                    letterButton.layer.borderWidth = 0.5
                    buttonsView.addSubview(letterButton)
                    lettersButtons.append(letterButton)
                }
            }
        }
        
        
        // NSlayout
        NSLayoutConstraint.activate([
            wordToGuessLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 200),
            wordToGuessLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 30),
            //This line says that the width of the cluesLabel should be equal to 60% of the width of the safe area of the screen, minus an additional 100 points. It ensures that the cluesLabel is not too wide and fits well within the screen.
            wordToGuessLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5, constant: -100),
            
            hangMan.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 200),
            hangMan.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -30),
            hangMan.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5, constant: -100),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: wordToGuessLabel.bottomAnchor, constant: 20),
    
            
            buttonsView.widthAnchor.constraint(equalToConstant: 560),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -70)
        
        ])
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGame()
    }
    
    
    @objc func letterTapped(_ sender: UIButton){
        var promptWord = ""
        var strikeCount = 0
        guard let buttonTitle = sender.titleLabel?.text else { return }
        activatedButtonText.append(buttonTitle)
        print(activatedButtonText)
        for letter in wordToGuess {
            let strLetter = String(letter)
            if activatedButtonText.contains(strLetter) {
                promptWord += strLetter
//                activatedButtonText.removeAll()
            }else {
                promptWord += "?"
            }
        }
        for letter in activatedButtonText{
            if !lettersToGuess.contains(letter){
                strikeCount += 1
            }
        }

        print(promptWord)
        print(strikeCount)
        hangMan.text = hangmanParts[strikeCount]
        currentAnswer.text = promptWord
        if strikeCount == 7 {
            let alertLose = UIAlertController(title: "You lose", message: "You failed to guess the word.", preferredStyle: .alert)
            let newGameButton = UIAlertAction(title: "New Game", style: .default){
                [weak self] _ in
                self?.loadGame()
            }
            alertLose.addAction(newGameButton)
            present(alertLose, animated: true)
        }
        if currentAnswer.text == wordToGuess {
            print("You guessed right!")
            let ac = UIAlertController(title: "You win!", message: "You guessed right! Congrants!", preferredStyle: .alert)
            let newGameButton = UIAlertAction(title: "New Game", style: .default) {
                [weak self] _ in
                self?.loadGame()
            }
            ac.addAction(newGameButton)
            present(ac, animated: true)
        }
//
    }

    func loadGame(){
        var randomAnswer = ""
        var displayString = ""
        var numLetters = 0
        lettersButtons = []
        activatedButtonText.removeAll()
        lettersToGuess.removeAll()
        hangMan.text = hangmanParts[0]
        if let filesURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let fileContent = try? String(contentsOf: filesURL){
                let lines = fileContent.components(separatedBy: "\n")
                allWord = lines
                print(lines)
                randomAnswer = lines.randomElement() ?? "None"
//                print(randomAnswer)
                numLetters = randomAnswer.count
//                print(numLetters)
                for _ in 0..<numLetters{
                    displayString += "?"
                }
                for letter in randomAnswer{
                    lettersToGuess.append(String(letter).lowercased())
                }
            }
        }
        currentAnswer.text = displayString
        wordToGuess = randomAnswer
        wordToGuessLabel.text = "\(numLetters) letters"
        print(wordToGuess)
        print(lettersToGuess)
    }

}

