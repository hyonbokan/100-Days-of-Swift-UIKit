//
//  ViewController.swift
//  Project8-wordGame
//
//  Created by dnlab on 2023/06/19.
//

import UIKit

class ViewController: UIViewController {

    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    // Adding userAnswers var. If userAnswer.count == 7, trigger lvl up
    var userAnswers = [String]()
    var score = 0 {
        // Property observer
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        scoreLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "Clues"
        cluesLabel.numberOfLines = 0
        // important!!!
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "Answers"
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("Submit", for: .normal)
        submit.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("Clear", for: .normal)
        clear.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        // Adding border and color
        buttonsView.layer.borderWidth = 5
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        
        // Positioning and layout of each label
        NSLayoutConstraint.activate([
            // This line says that the top edge of the scoreLabel should be positioned equal to the top edge of the safe area of the screen. It ensures that the scoreLabel starts at the top of the screen.
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            
            //This line says that the right edge of the scoreLabel should be positioned equal to the right edge of the safe area of the screen. It ensures that the scoreLabel stays aligned with the right side of the screen.
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            // This line says that the top edge of the cluesLabel should be positioned right below the bottom edge of the scoreLabel. It ensures that the cluesLabel appears just below the scoreLabel.
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            
            //This line says that the left edge of the cluesLabel should be positioned equal to the left edge of the safe area of the screen, but with an additional offset of 100 points. It ensures that the cluesLabel is indented from the left side of the screen.
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            
            //This line says that the width of the cluesLabel should be equal to 60% of the width of the safe area of the screen, minus an additional 100 points. It ensures that the cluesLabel is not too wide and fits well within the screen.
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            // it makes sure that the answersLabel is as tall as the cluesLabel, so they align nicely together.
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])

        
        
        
        let width = 150
        let height = 80
        
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                // Adding borders for each button
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                letterButton.layer.borderWidth = 0.5
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
        // By having the background color, we can see how big each label is
//        cluesLabel.backgroundColor = .red
//        answersLabel.backgroundColor = .blue
//        buttonsView.backgroundColor = .green
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // need to be async
        loadLevel()
        
    }
    
    @objc func letterTapped(_ sender: UIButton){
        // Have safe access to tapped buttons
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
//        print(currentAnswer.text!)
        activatedButtons.append(sender)
        sender.isHidden = true
        
    }
    
    @objc func submitTapped(_ sender: UIButton){
        guard let answerText = currentAnswer.text else { return }
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            print("splitAnswers: \(splitAnswers!)")
            print("answerText: \(answerText)")

            splitAnswers?[solutionPosition] = answerText
            print("splitAnswers: \(splitAnswers!)")
            // The line below changes "N letters" into "Answer" in the answerLabel column
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            print(answersLabel.text!)
            currentAnswer.text = ""
            score += 1
            
            userAnswers.append(answerText)
            print("Answers text: \(userAnswers)")
        

//            if score % 7 == 0 {
//                let ac = UIAlertController(title: "Well done!", message: "You have cleared the level", preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: levelUp))
//                present(ac, animated: true)
            
//            }
            if userAnswers.count == 7 {
                let ac = UIAlertController(title: "Well done!", message: "You have cleared the level", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else{
            let ac = UIAlertController(title: "Incorrect", message: "The word you've submitted is incorrect! Please check your answer.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            currentAnswer.text = ""
            for button in activatedButtons {
                button.isHidden = false
            }
            activatedButtons.removeAll()
            score -= 1
            present(ac, animated: true)
            
        }
    }
    
    func levelUp(action: UIAlertAction){
        level += 1
        
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        
        for button in letterButtons{
            button.isHidden = false
        }
    }
    
    @objc func clearTapped(_ sender: UIButton){
        currentAnswer.text = ""
        
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
        }
    
    func loadLevel() {
        var clueString = ""
        var solutionsString = ""
        var letterBits = [String]()
        
        if let fielsURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let fileContents = try? String(contentsOf: fielsURL){
                var lines = fileContents.components(separatedBy: "\n")
                lines.shuffle()
                // lines: array of strings
//                print(lines)
                
                for (index, line) in lines.enumerated(){
//                    print(index)
//                    print(line)
                    let parts = line.components(separatedBy: ": ")
//                    print(parts)
//                    ["OLI|VER", "Has a Dickensian twist"]
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
//                    print("\(answer) turns into \(solutionWord)")
                    //LE|PRO|SY turns into LEPROSY
                    solutionsString += "\(solutionWord.count) letters \n"
                    //example - 7 letter
                    solutions.append(solutionWord)
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                    
                }
//                print("Solution Strings: \(solutionsString)")
                //Solution Strings: 7 letter
//                9 letter
//                6 letter
//                6 letter
//                8 letter
//                7 letter
//                7 letter
//                print("These are letter bits: \(letterBits)")
//                These are letter bits: ["LE", "PRO", "SY", "ELI", "ZAB", "ETH", "OLI", "VER", "SA", "FA", "RI", "POR", "TL", "AND", "TW", "ITT", "ER", "HA", "UNT", "ED"]
            
            }
        }
        // The method "trimmingCharacters" is often used to sanitize or clean up user input, removing any unnecessary whitespace or newline characters before further processing or validation of the string.
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)
        // Clues label:
//        1. Short but sweet online chirping
//        2. Has a Dickensian twist
//        3. A Biblical skin disease
//        4. The zoological web
//        5. Ghosts in residence
//        6. Hipster heartland
//        7. Head of state, British style
        
        //Answer label:
//        7 letters
//        6 letters
//        7 letters
//        6 letters
//        7 letters
//        8 letters
//        9 letters
        letterButtons.shuffle()
        if letterButtons.count == letterBits.count {
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    

}

