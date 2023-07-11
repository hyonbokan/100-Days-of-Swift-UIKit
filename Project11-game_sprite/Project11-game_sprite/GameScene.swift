//
//  GameScene.swift
//  Project11-game_sprite
//
//  Created by dnlab on 2023/06/26.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    var ballLabel: SKLabelNode!
    
    let ballColor = ["ballRed", "ballYellow", "ballPurple", "ballCyan", "ballBlue", "ballGreen"]
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var numberOfBalls = 5 {
        didSet{
            ballLabel.text = "Balls: \(numberOfBalls)"
        }
    }
    
    var editLabel: SKLabelNode!
    var didCollideBox: Bool = false
    
    var editingMode: Bool = false {
        didSet {
            if editingMode{
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        // positioning in sprite is different from UIKit
        background.position = CGPoint(x: 512, y: 384)
        //Blend modes determine how a node is drawn, and SpriteKit gives you many options. The .replace option means "just draw it, ignoring any alpha values," which makes it fast for things without gaps such as our background. We're also going to give the background a zPosition of -1, which in our game means "draw this behind everything else."
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        ballLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballLabel.text = "Balls: 5"
        ballLabel.position = CGPoint(x: 900, y: 650)
        addChild(ballLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 900, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y:700)
        addChild(editLabel)
        
        // the line below defines boundaries for the boxes
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
//            editingMode = !editingMode - .toggle() does the same
            editingMode.toggle()
        } else {
            if editingMode {
                // create a box
                makeBox(at: location)
            } else {
                if numberOfBalls != 0 {
                    makeBall(at: CGPoint(x: location.x, y: 740))
                }
            }
          
        }
    }
    func makeBox(at position: CGPoint){
        let size = CGSize(width: Int.random(in: 16...128), height: 16)
        let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
        box.zRotation = CGFloat.random(in: 0...3)
        box.position = position
        box.name = "box"
        
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        addChild(box)
    }
    func makeBall(at position: CGPoint){
        
        //        let box = SKSpriteNode(color: .red, size: CGSize(width: 64, height: 64))
        //        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
        //        box.position = location
        //        addChild(box)
        let ballImage = ballColor.randomElement() ?? "ballRed"
            let ball = SKSpriteNode(imageNamed: ballImage)
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            // adding bounce affect
            ball.physicsBody?.restitution = 0.4
            // The collisionBitMask bitmask means "which nodes should I bump into?" By default, it's set to everything, which is why our ball are already hitting each other and the bouncers. The contactTestBitMask bitmask means "which collisions do you want to know about?" and by default it's set to nothing. So by setting contactTestBitMask to the value of collisionBitMask we're saying, "tell me about every collision."
            ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
            
//                    ball.position = location
        ball.position = position
        ball.name = "ball"
            addChild(ball)
        numberOfBalls -= 1
    }

    func makeBouncer(at position: CGPoint) {
        // adding bouncer in the middle
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool){
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good"{
            destroy(ball: ball)
            score += 1
            if didCollideBox == true{
                numberOfBalls += 1
                didCollideBox.toggle()
            }
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    func collisionWithBox(ball: SKNode, box: SKNode) {
            box.removeFromParent()
            didCollideBox = true
    }
    
    func destroy(ball: SKNode){
        //The SKEmitterNode class is new and powerful: it's designed to create high-performance particle effects in SpriteKit games, and all you need to do is provide it with the filename of the particles you designed and it will do the rest.
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        print(nodeA.name ?? "none")
        print(nodeB.name ?? "none")
        print("-------------------")
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
        
//didBegin reports if a contact was made between objects - NodeA and NodeB;
//Two if blocks needed as they should be separate black-cases
        if nodeA.name == "box" {
            collisionWithBox(ball: nodeB, box: nodeA)
        } else if nodeB.name == "box" {
            collisionWithBox(ball: nodeA, box: nodeB)
        }
    }
}
