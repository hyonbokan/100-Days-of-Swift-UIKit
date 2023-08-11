//
//  ViewController.swift
//  MilestoneProject28-30-CardPairs
//
//  Created by dnlab on 2023/08/11.
//

import UIKit

class ViewController: UIViewController {

    var allCards = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        let width = 99
        let height = 145
        
        let numRows = 3
        let numColumns = 3
        let cardBackImage = UIImage(named: "card_back")
        for row in 0..<numRows {
            for column in 0..<numColumns {
                let cardButton = UIButton(type: .custom)
                cardButton.setImage(cardBackImage, for: .normal)
                
                let x = column * (width + 10) // Add some spacing between cards (adjust 10 as needed)
                let y = row * (height + 10) // Add some spacing between rows (adjust 10 as needed)
                let frame = CGRect(x: x, y: y, width: width, height: height)
                cardButton.frame = frame
                
                cardButton.layer.borderColor = UIColor.lightGray.cgColor
                cardButton.layer.borderWidth = 0.5
                
                buttonsView.addSubview(cardButton)
                allCards.append(cardButton)
            }
        }
        
    }


}

