//
//  Row.swift
//  MilestoneProject16-18
//
//  Created by dnlab on 2023/07/13.
//

import SpriteKit
import UIKit

class Row: SKNode {
    var charNode: SKSpriteNode!
    var isHit = false
    func configure(at postion: CGPoint){
        self.position = postion
        // We can add row here use grass image to beautify the game
    }

}
