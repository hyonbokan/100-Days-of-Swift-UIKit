//
//  GameScene.swift
//  Project20-Fireworks
//
//  Created by dnlab on 2023/07/16.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    var scoreLabel: SKLabelNode!
    var lauchNumLabel: SKLabelNode!
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    var lauchesLeft = 10 {
        didSet {
            lauchNumLabel.text = "Launches left: \(lauchesLeft)"
        }
    }
    var score = 0 {
        didSet {
            if score < 9999 {
                scoreLabel.text = "Score: \(score)"
            } else {
                let formattedScore = String(format: "%.1fK", Double(score) / 1000.0)
                scoreLabel.text = "Score: \(formattedScore)"
            }
            
        }
    }
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 770, y: 700)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 38
        addChild(scoreLabel)
        
        lauchNumLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        lauchNumLabel.text = "Launches left: 3"
        lauchNumLabel.position = CGPoint(x: 700, y: 650)
        lauchNumLabel.horizontalAlignmentMode = .left
        lauchNumLabel.fontSize = 28
        addChild(lauchNumLabel)
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(launchFireworkds), userInfo: nil, repeats: true)
    }
    
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        //Pure .color
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2){
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    @objc func launchFireworkds(){
        let movementAmount: CGFloat = 1800
        if lauchesLeft > 0 {
            switch Int.random(in: 0...3){
            case 0:
                // fire five, straight up
                createFirework(xMovement: 0, x: 512, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
            case 1:
                // fire five, in a fan
                createFirework(xMovement: 0, x: 512, y: bottomEdge)
                createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
                createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
                createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
                createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
            case 2:
                // fire five, from the left to the right
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
            case 3:
                // fire five, from the right to the left
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            default:
                break
            }
            lauchesLeft -= 1
        } else {
            gameTimer?.invalidate()
            print("Game Over")
        }
        
    }
    
    func checkTouches(_ touches: Set<UITouch>){
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        // run loop only if node is SKSpriteNode
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { return }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            
            let wait = SKAction.wait(forDuration: 1.0)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([wait, remove])
            addChild(emitter)
            emitter.run(sequence)
        }

        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }
            
            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 3:
            score += 500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
}
