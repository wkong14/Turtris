//
//  MenuScene.swift
//  GroupProject
//
//  Created by Michael Shaffer on 4/2/21.
//

import SpriteKit

class MenuScene: SKScene {
    
    private var currentBoxSpawnTime : TimeInterval = 0
    private var lastUpdateTime : TimeInterval = 0
    
    var playButton = SKSpriteNode()
    let playButtonText = SKTexture(imageNamed: "play")
    
    let credits = SKSpriteNode(imageNamed: "Credits")
    
    var turret = SKSpriteNode()
    let turretImg = SKTexture(imageNamed: "turret1")
    
    var title = SKSpriteNode()
    let titleImg = SKTexture(imageNamed: "title")
    
    let boxTexture = SKTexture(imageNamed: "box")
    private var boxDropSpawnRate : TimeInterval = 1
    private let xPosition: [Int] = [50, 150, 250, 350]

    override func didMove(to view: SKView) {
        let bg = SKAudioNode(fileNamed: "turrit.mp3")
        self.addChild(bg)
        self.backgroundColor = UIColor.lightGray
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        
        title = SKSpriteNode(texture: titleImg)
        title.position = CGPoint(x: frame.midX, y: frame.midY + 200)
        title.size = CGSize(width: 375, height: 100)
        self.addChild(title)
        
        turret = SKSpriteNode(texture: turretImg)
        turret.position = CGPoint(x: frame.midX, y:frame.midY)
        self.addChild(turret)
        
        let playText = SKLabelNode(fontNamed: "Futura-Medium")
        playText.text = "Play Game"
        playText.position = CGPoint(x: frame.midX, y: frame.midY - 200)
        playText.fontSize = 30
        playText.fontColor = SKColor.black
        self.addChild(playText)
        
        playButton = SKSpriteNode(texture: playButtonText)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY - 270)
        self.addChild(playButton)
        
        credits.position = CGPoint(x: frame.midX, y: playButton.position.y - 90)
        credits.size = CGSize(width: 100, height: 40)
        self.addChild(credits)
    }
    
    private func spawnBox() {
        let random = xPosition.randomElement()!
        let box = SKSpriteNode(texture: boxTexture)
        box.physicsBody = SKPhysicsBody(texture: boxTexture, size: box.size)
        
        box.physicsBody?.restitution = 0.0
        box.physicsBody?.allowsRotation = false
        box.zPosition = CGFloat(-1)
        box.alpha = CGFloat(0.5)
        
        if random == (50){
            box.physicsBody?.categoryBitMask = BoxOneCategory
            box.physicsBody?.collisionBitMask = BoxOneCategory | FloorCategory | AddCategory | TurretOneCategory
            box.physicsBody?.contactTestBitMask = BoxOneCategory | BulletCategory
        }else if random == (150){
            box.physicsBody?.categoryBitMask = BoxTwoCategory
            box.physicsBody?.collisionBitMask = BoxTwoCategory | FloorCategory | AddCategory | TurretTwoCategory
            box.physicsBody?.contactTestBitMask = BoxTwoCategory | BulletCategory
        }else if random == (250){
            box.physicsBody?.categoryBitMask = BoxThreeCategory
            box.physicsBody?.collisionBitMask = BoxThreeCategory | FloorCategory | AddCategory | TurretThreeCategory
            box.physicsBody?.contactTestBitMask = BoxThreeCategory | BulletCategory
        }else if random == (350){
            box.physicsBody?.categoryBitMask = BoxFourCategory
            box.physicsBody?.collisionBitMask = BoxFourCategory | FloorCategory | AddCategory | TurretFourCategory
            box.physicsBody?.contactTestBitMask = BoxFourCategory | BulletCategory
        }
        
        let yPosition = size.height + box.size.height
        
         
        box.position = CGPoint(x: CGFloat(random), y: yPosition)
        box.speed = 0.1
        addChild(box)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update the Spawn Timer
        currentBoxSpawnTime += dt
        
        if currentBoxSpawnTime > boxDropSpawnRate {
            currentBoxSpawnTime = 0
            spawnBox()
        }
        
        self.lastUpdateTime = currentTime
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            let transition:SKTransition = SKTransition.fade(withDuration: 1)

            if node == playButton {
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
            } else if node == credits {
                let cred = CreditsScene(fileNamed: "CreditsScene")
                cred?.scaleMode = .aspectFill
                self.scene?.view?.presentScene(cred!, transition: transition)
            }
        }
    }
}
