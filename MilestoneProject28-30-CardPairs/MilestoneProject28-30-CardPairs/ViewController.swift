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
        "The United Kingdom": "London",
        "South Korea": "Seoul",
    ]
    var wordsArr = ["France", "Paris", "The UK", "London", "South Korea", "Seoul"]
    var firstTappedCard: UIButton?
    
    // loadView to restart the game
    override func loadView() {
        view = UIView()
        view.backgroundColor = .black

        //The area for buttons
        let cardsView = UIView()
        cardsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardsView)

        cardsView.layer.borderWidth = 5
        cardsView.layer.borderColor = UIColor.red.cgColor

        let width = 100
        let height = 145
        

        var index = 0

        let numRows = 2
        let numColumns = 3
        let cardBackImage = UIImage(named: "card_back")
        
        for row in 0..<numRows {
            for column in 0..<numColumns {
                let cardButton = UIButton(type: .custom)
                cardButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                // Get the key-value pair at the current index
                let currentPair = wordsArr[index]
                // Set the title of the cardButton to the key (country name)
                cardButton.setTitle(currentPair, for: .normal)
                cardButton.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
//                cardButton.setImage(cardBackImage, for: .normal)
                index += 1

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
        wordsArr.shuffle()
        
    }
    

    @objc func cardTapped(_ sender: UIButton){
        if firstTappedCard == nil {
            // If no card is tapped yet, mark the current card as the first tapped card
            firstTappedCard = sender
        } else {
            // Compare the titles of the first tapped card and the current card
            if let firstTitle = firstTappedCard?.title(for: .normal), let secondTitle = sender.title(for: .normal) {
                print("first card: \(firstTitle)")
                print("second card: \(secondTitle)")
                
                // Check if the first card's title is a country and the second card's title is its capital
                if let capital = wordDict[firstTitle], capital == secondTitle {
                    print("Match: \(firstTitle) - \(secondTitle)")
                } else if let country = wordDict.first(where: { $0.value == secondTitle })?.key, country == firstTitle {
                    print("Match: \(country) - \(secondTitle)")
                } else {
                    print("No match")
                }
            }

            // Reset the first tapped card
            firstTappedCard = nil
        }
    }
}

