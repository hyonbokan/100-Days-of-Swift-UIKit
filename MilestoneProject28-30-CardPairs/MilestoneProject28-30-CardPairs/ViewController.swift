//
//  ViewController.swift
//  MilestoneProject28-30-CardPairs
//
//  Created by dnlab on 2023/08/11.
//

import UIKit

class ViewController: UIViewController {
    let wordDict = [
        "France": "Paris",
        "The UK": "London",
        "South Korea": "Seoul",
    ]
    var wordsArr = ["France", "Paris", "The UK", "London", "South Korea", "Seoul"]
    var firstTappedCard: UIButton?
    var secondTappedCard: UIButton?
    var allCards = [UIButton]()
    
    var firstView: UIView!
    var secondView: UIView!
    let cardBackImage = UIImage(named: "card_back")
    // loadView to restart the game
    override func loadView() {
        view = UIView()
        view.backgroundColor = .black

        //The area for buttons
        let cardsView = UIView()
        cardsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardsView)

//        cardsView.layer.borderWidth = 5
//        cardsView.layer.borderColor = UIColor.red.cgColor

        let width = 100
        let height = 145
        

//        var index = 0

        let numRows = 2
        let numColumns = 3
        
        for row in 0..<numRows {
            for column in 0..<numColumns {
                let cardButton = UIButton(type: .custom)
                cardButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                cardButton.backgroundColor = .white
                cardButton.setTitle("None", for: .normal)
                cardButton.setTitleColor(.systemBlue, for: .normal)
                cardButton.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
                cardButton.setImage(cardBackImage, for: .normal)
                allCards.append(cardButton)

                let x = column * (width + 23)
                let y = row * (height + 50)
                let frame = CGRect(x: x, y: y, width: width, height: height)
                cardButton.frame = frame
                cardButton.layer.borderColor = UIColor.lightGray.cgColor
                cardButton.layer.borderWidth = 0.5
                
                cardsView.addSubview(cardButton)
            }
        }
        
        NSLayoutConstraint.activate([
            cardsView.widthAnchor.constraint(equalToConstant: 350),
//            cardsView.heightAnchor.constraint(equalToConstant: 150),
            cardsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            cardsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardsView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            cardsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGame()
    }
    

    @objc func cardTapped(_ sender: UIButton) {
        if firstTappedCard == nil {
            // If no card is tapped yet, mark the current card as the first tapped card
            firstTappedCard = sender
            flipCard(sender, withDelay: 2.0)
        } else if firstTappedCard !== sender { // Ensure it's a different card than the first one
            // Compare the titles of the first tapped card and the current card
            secondTappedCard = sender
            flipCard(sender, withDelay: 2.0)
            checkForMatch()
            
            // Reset the tapped cards
            firstTappedCard = nil
            secondTappedCard = nil
        }
        
        if wordsArr.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.gameOver()
            }
        }
    }
    
    func flipCard(_ card: UIButton, withDelay delay: TimeInterval) {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        card.setImage(nil, for: .normal)

        UIView.transition(with: card, duration: 1.0, options: transitionOptions, animations: {
            // Apply any animations or changes you want during the flip animation
        }) { _ in
            // This completion block will be executed when the flip animation is completed
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                card.setImage(self.cardBackImage, for: .normal)
                UIView.transition(with: card, duration: 1.0, options: transitionOptions, animations: {
                    // Apply any animations or changes to revert the card's state
                })
            }
        }
    }

    func checkForMatch() {
        guard let firstCard = firstTappedCard, let secondCard = secondTappedCard,
              let firstTitle = firstCard.title(for: .normal), let secondTitle = secondCard.title(for: .normal) else {
            return
        }
        
        print("first card: \(firstTitle)")
        print("second card: \(secondTitle)")
        
        
        if let capital = wordDict[firstTitle], capital == secondTitle {
            print("Match 1: \(firstTitle) - \(secondTitle)")
            hideMatchedCards(firstCard, secondCard)
            removeMatchedWordsFromArr()
            
        } else if let capital = wordDict.first(where: { $0.key == secondTitle })?.value, capital == firstTitle {
            print("Match 2: \(capital) - \(secondTitle)")
            hideMatchedCards(firstCard, secondCard)
            removeMatchedWordsFromArr()
        } else {
            print("No match")
        }
    }

    func hideMatchedCards(_ card1: UIButton, _ card2: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            card1.isHidden = true
            card2.isHidden = true
        }
    }
    
    func removeMatchedWordsFromArr() {
        // Remove matched words from the array
        guard let firstTitle = firstTappedCard?.title(for: .normal), let secondTitle = secondTappedCard?.title(for: .normal) else {
            return
        }
        
        if let index1 = wordsArr.firstIndex(of: firstTitle) {
            wordsArr.remove(at: index1)
        }
        
        if let index2 = wordsArr.firstIndex(of: secondTitle) {
            wordsArr.remove(at: index2)
        }
        print("Words array: \(wordsArr)")
    }
    
    
    func gameOver(){
        let ac = UIAlertController(title: "Game Over", message: "Congradulations!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: loadNewGame))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func loadNewGame(_ sender: UIAlertAction){
        loadGame()
    }
    
    func loadGame() {
        print("new game")
        
        wordsArr = ["France", "Paris", "The UK", "London", "South Korea", "Seoul"]
        wordsArr.shuffle()
        
        for (index, button) in allCards.enumerated() {
            let currentPair = wordsArr[index]
            button.isHidden = false
            button.setTitle(currentPair, for: .normal)
        }
    }
}

