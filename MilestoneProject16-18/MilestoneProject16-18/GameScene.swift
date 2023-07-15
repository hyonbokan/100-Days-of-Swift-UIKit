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
    var timeLabel: SKLabelNode!
    var bulletLabel: SKLabelNode!
    var target: SKSpriteNode!
    var reload: SKLabelNode!
    
    var gameTimer1: Timer?
    var gameTimer2: Timer?
    var gameTimer3: Timer?
    var secondsTimer: Timer?
    var gameOver = false
    var targetName = ""
    var bullets = 6 {
        didSet{
            bulletLabel.text = "Bullets left: \(bullets)"
        }
    }
    var timeLeft = 30.0 {
        didSet{
            timeLabel.text = "Time left: \(String(format: "%.1f", timeLeft))s"
        }
    }
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
        
        timeLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        timeLabel.text = "Time left: 30.0s"
        timeLabel.position = CGPoint(x: 770, y: 650)
        timeLabel.horizontalAlignmentMode = .left
        timeLabel.fontSize = 30
        addChild(timeLabel)
        
        bulletLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        bulletLabel.text = "Bullets left: 6"
        bulletLabel.position = CGPoint(x: 150, y: 650)
        bulletLabel.horizontalAlignmentMode = .center
        bulletLabel.fontSize = 30
        addChild(bulletLabel)
        
        reload = SKLabelNode(fontNamed: "AmericanTypewriter")
        reload.text = "RELOAD"
        reload.name = "reload"
        reload.position = CGPoint(x: 150, y: 700)
        reload.horizontalAlignmentMode = .center
        reload.fontSize = 38

        let buttonBackground = SKShapeNode(rectOf: CGSize(width: reload.frame.size.width + 20, height: reload.frame.size.height + 20))
        buttonBackground.fillColor = SKColor.gray
        buttonBackground.strokeColor = SKColor.clear
        buttonBackground.position = CGPoint(x: reload.position.x, y: reload.position.y + 10)
        buttonBackground.name = "reload"
        self.addChild(buttonBackground)
        self.addChild(reload)
        
        gameTimer1 = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createTargetsRow1), userInfo: nil, repeats: true)
        gameTimer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createTargetsRow2), userInfo: nil, repeats: true)
        gameTimer3 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createTargetsRow3), userInfo: nil, repeats: true)
        secondsTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(setTime), userInfo: nil, repeats: true)

    }
    
    @objc func createTargetsRow1(){
        if Int.random(in: 0...5) < 2 {
            targetName = "monster"
        } else {
            targetName = "hero"
        }
        target = SKSpriteNode(imageNamed: targetName)
        target.name = targetName
        target.setScale(CGFloat.random(in: 0.05...0.1))
        target.position = CGPoint(x: 10, y: 100)
        addChild(target)
            
        target.run(SKAction.moveBy(x: 1000, y: 0, duration: 1))

    }
    
    @objc func createTargetsRow2(){
        if Int.random(in: 0...5) > 4 {
            targetName = "monster"
        } else {
            targetName = "hero"
        }
        target = SKSpriteNode(imageNamed: targetName)
        target.name = targetName
        target.setScale(CGFloat.random(in: 0.05...0.2))
        target.position = CGPoint(x: 1000, y: 300)
        addChild(target)
            
        target.run(SKAction.moveBy(x: -1000, y: 0, duration: 2))
    }
    
    @objc func createTargetsRow3(){
        if Int.random(in: 0...5) > 2 {
            targetName = "monster"
        } else {
            targetName = "hero"
        }
        target = SKSpriteNode(imageNamed: targetName)
        target.name = targetName
        target.setScale(CGFloat.random(in: 0.05...0.2))
        target.position = CGPoint(x: 10, y: 600)
        addChild(target)
            
        target.run(SKAction.moveBy(x: 1000, y: 0, duration: 3))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        // We could use switch instead of "if" statement. But refactoring takes some time...
        if !gameOver {
            for node in tappedNodes {
                if node.name == "hero" {
                    node.removeFromParent()
                    score -= 5
                } else if node.name == "monster" {
                    if let spriteNode = node as? SKSpriteNode {
                        let nodeSize = spriteNode.size
                        print(nodeSize.height)
                        
                        if nodeSize.height < 36 {
                            score += 10
                        } else if nodeSize.height < 55 {
                            score += 5
                        } else {
                            score += 1
                        }
                        print(score)
                    }
                    node.removeFromParent()
                }
            }
            
            if bullets > 0 {
                bullets -= 1
            }
            // Needs to be a separate loop, otherwise when hero/moster is tapped, -2 bullets instead of 1
            for node in tappedNodes {
                if node.name == "reload" {
                    bullets = 7
                }
            }
        }
    }

    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            // x = 1000 start. x = 0 end
            if node.position.x < 10 || node.position.x > 1000{
                node.removeFromParent()
            }
        }

    }
    
    @objc func setTime(){
        timeLeft -= 0.1
        if timeLeft < 0.1 {
            gameTimer1?.invalidate()
            gameTimer2?.invalidate()
            gameTimer3?.invalidate()
            secondsTimer?.invalidate()
            timeLeft = 0
            
            //game over label
            let gameOverSign = SKSpriteNode(imageNamed: "gameOver")
            gameOverSign.position = CGPoint(x: 512, y: 420)
            gameOverSign.zPosition = 1
            addChild(gameOverSign)
            gameOver = true
        }
    }
}


