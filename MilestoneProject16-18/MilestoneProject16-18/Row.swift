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
    
        charNode = SKSpriteNode(imageNamed: "monster")
        charNode.position = postion
        charNode.name = "character"
        charNode.setScale(0.2)
        
        addChild(charNode)
    }
    
    func run(xAxis: CGFloat, duration: Double){
        if isHit { return }
        isHit = false
        let moveAction = SKAction.moveBy(x: xAxis, y: 0, duration: duration)
        let remove = SKAction.removeFromParent()
        // in the completion block of the moveAction, remove the charNode from its parent node.
        
        
//        charNode.run(moveAction)
        if Int.random(in: 0...2) == 0{
            charNode.texture = SKTexture(imageNamed: "hero")
            charNode.name = "hero"
            charNode.setScale(CGFloat.random(in: 0.15...0.2))
        } else {
            charNode.texture = SKTexture(imageNamed: "monster")
            charNode.name = "monster"
            charNode.setScale(CGFloat.random(in: 0.05...0.2))
        }
        
        charNode.run(moveAction){
            self.charNode.run(remove)
        }
    }
    
    
    func hit(){
        isHit = true
        charNode.removeFromParent()
    }
    
}
