//
//  GameScene.swift
//  MilestoneProject16-18
//
//  Created by dnlab on 2023/07/13.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var rows = [Row]()
    var isGameOver = false
    var gameScore: SKLabelNode!
    var gameTimer: Timer?
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "forest")
            background.position = CGPoint(x: 512, y: 384)
            background.blendMode = .replace
            background.zPosition = -1
            addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "AmericanTypewriter")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 830, y: 700)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 38
        addChild(gameScore)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createMonstersRow1), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createMonstersRow2), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createMonstersRow3), userInfo: nil, repeats: true)

    }
    
    @objc func createMonstersRow1(){
            let monster = SKSpriteNode(imageNamed: "monster")
            monster.setScale(CGFloat.random(in: 0.05...0.2))
            monster.position = CGPoint(x: 1000, y: 100)
            addChild(monster)
            
            monster.run(SKAction.moveBy(x: -1000, y: 0, duration: 1))

    }
    
    @objc func createMonstersRow2(){
            let monster = SKSpriteNode(imageNamed: "monster")
            monster.setScale(CGFloat.random(in: 0.05...0.2))
            monster.position = CGPoint(x: 1000, y: 300)
            addChild(monster)
            
            monster.run(SKAction.moveBy(x: -1000, y: 0, duration: 2))
    }
    
    @objc func createMonstersRow3(){
            let monster = SKSpriteNode(imageNamed: "monster")
            monster.setScale(CGFloat.random(in: 0.05...0.2))
            monster.position = CGPoint(x: 1000, y: 600)
            addChild(monster)
            
            monster.run(SKAction.moveBy(x: -1000, y: 0, duration: 3))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let row = node.parent?.parent as? Row else { continue }
            if row.isHit { continue }
            row.hit()
            if node.name == "hero"{
                score -= 1
            } else if node.name == "monster" {
                score += 1
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            // x = 1000 start. x = 0 end
            if node.position.x < 10 {
                node.removeFromParent()
            }
        }
    }
}


