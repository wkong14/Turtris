//
//  GameScene.swift
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var boxesDestroyed: Int = 0
    private var boxSpawned: Bool = false
    private var wave: Int = 1
    let upgrade = SKSpriteNode(imageNamed: "add")
    private let xPosition: [Int] = [50, 150, 250, 350]
    private var lastUpdateTime : TimeInterval = 0
    private var currentBoxSpawnTime : TimeInterval = 0
    private var boxDropSpawnRate : TimeInterval = 3
    private var counter: Int = 0
    private var counter2: Int = 0
    private var counter3: Int = 0
    private var counter4: Int = 0
    private let backgroundNode = BackgroundNode()
    let boxTexture = SKTexture(imageNamed: "box")
    let bulletTexture = SKTexture(imageNamed: "bullet")
    let addTexture = SKTexture(imageNamed: "add")
    let turretTexture = SKTexture(imageNamed:"turret1")
    var turretOne: SKSpriteNode!
    var turretTwo: SKSpriteNode!
    var turretThree: SKSpriteNode!
    var turretFour: SKSpriteNode!
    var money: Int = 5
    let score = SKLabelNode(fontNamed: "Futura")
    let waveLabel = SKLabelNode(fontNamed: "Futura")
    let cooldown = SKLabelNode(fontNamed: "Futura")
    
    override func didMove(to view: SKView) {
        upgrade.name = "upgrade"
        upgrade.position = CGPoint(x: 350, y: 800)
        self.addChild(upgrade)
    }
    
    private func spawnPlus(){
        
        let addLaneOne = SKSpriteNode(texture: addTexture)
        addLaneOne.name = "one"
        addLaneOne.isUserInteractionEnabled = false
        addLaneOne.physicsBody = SKPhysicsBody(texture: addTexture, size: addLaneOne.size)
        addLaneOne.physicsBody?.restitution = 0.0
        addLaneOne.physicsBody?.allowsRotation = false
        addLaneOne.physicsBody?.pinned = true
        addLaneOne.physicsBody?.categoryBitMask = AddCategory
        addLaneOne.physicsBody?.contactTestBitMask = BoxOneCategory
        addLaneOne.position = CGPoint(x: 50, y: 130)
        
        let addLaneTwo = SKSpriteNode(texture: addTexture)
        addLaneTwo.name = "two"
        addLaneTwo.physicsBody = SKPhysicsBody(texture: addTexture, size: addLaneTwo.size)
        addLaneTwo.physicsBody?.restitution = 0.0
        addLaneTwo.physicsBody?.allowsRotation = false
        addLaneTwo.physicsBody?.pinned = true
        addLaneTwo.physicsBody?.categoryBitMask = AddCategory
        addLaneTwo.physicsBody?.contactTestBitMask =  BoxTwoCategory
        addLaneTwo.position = CGPoint(x: 150, y: 130)

        let addLaneThree = SKSpriteNode(texture: addTexture)
        addLaneThree.name = "three"
        addLaneThree.physicsBody = SKPhysicsBody(texture: addTexture, size: addLaneThree.size)
        addLaneThree.physicsBody?.restitution = 0.0
        addLaneThree.physicsBody?.allowsRotation = false
        addLaneThree.physicsBody?.pinned = true
        addLaneThree.physicsBody?.categoryBitMask = AddCategory
        addLaneThree.physicsBody?.contactTestBitMask =  BoxThreeCategory
        addLaneThree.position = CGPoint(x: 250, y: 130)

        let addLaneFour = SKSpriteNode(texture: addTexture)
        addLaneFour.name = "four"
        addLaneFour.physicsBody = SKPhysicsBody(texture: addTexture, size: addLaneFour.size)
        addLaneFour.physicsBody?.restitution = 0.0
        addLaneFour.physicsBody?.allowsRotation = false
        addLaneFour.physicsBody?.pinned = true
        addLaneFour.physicsBody?.categoryBitMask = AddCategory
        addLaneFour.physicsBody?.contactTestBitMask =  BoxFourCategory
        addLaneFour.position = CGPoint(x: 350, y: 130)

        addChild(addLaneOne)
        addChild(addLaneTwo)
        addChild(addLaneThree)
        addChild(addLaneFour)
    }
    
    private func spawnTurret(lane: String){
        let turret = SKSpriteNode(texture: turretTexture)
        
        turret.physicsBody = SKPhysicsBody(texture: turretTexture, size: turret.size)
        turret.physicsBody?.restitution = 0.0
        turret.physicsBody?.friction = 0.0
        turret.physicsBody?.allowsRotation = false
        turret.physicsBody?.pinned = true
        turret.physicsBody?.collisionBitMask = AddCategory
        
        if lane == "one"{
            turret.name = "laneOne"
            turret.physicsBody?.categoryBitMask = TurretOneCategory
            turret.physicsBody?.contactTestBitMask = BoxOneCategory
            turret.position = CGPoint(x: 50, y: 130)
            turretOne = turret
        }else if lane == "two"{
            turret.name = "laneTwo"
            turret.physicsBody?.categoryBitMask = TurretTwoCategory
            turret.physicsBody?.contactTestBitMask = BoxTwoCategory
            turret.position = CGPoint(x: 150, y: 130)
            turretTwo = turret
        }else if lane == "three"{
            turret.name = "laneThree"
            turret.physicsBody?.categoryBitMask = TurretThreeCategory
            turret.physicsBody?.contactTestBitMask = BoxThreeCategory
            turret.position = CGPoint(x: 250, y: 130)
            turretThree = turret
        }else if lane == "four"{
            turret.name = "laneFour"
            turret.physicsBody?.categoryBitMask = TurretFourCategory
            turret.physicsBody?.contactTestBitMask = BoxFourCategory
            turret.position = CGPoint(x: 350, y: 130)
            turretFour = turret
        }
        
        addChild(turret)
    }
    
    func spawnBullet(lane: String) {
        let animationDuration:TimeInterval = 1
        var actionArray = [SKAction]()
        let bullet = SKSpriteNode(imageNamed: "bullet")
        if lane == "laneOne"{
            bullet.position = turretOne.position
            actionArray.append(SKAction.move(to: CGPoint(x: turretOne.position.x, y:frame.size.height+10), duration: animationDuration))
            bullet.physicsBody?.contactTestBitMask = BoxOneCategory
            
        }else if lane == "laneTwo"{
            bullet.position = turretTwo.position
            actionArray.append(SKAction.move(to: CGPoint(x: turretTwo.position.x, y:frame.size.height+10), duration: animationDuration))
            bullet.physicsBody?.contactTestBitMask = BoxTwoCategory
        }else if lane == "laneThree"{
            bullet.position = turretThree.position
            actionArray.append(SKAction.move(to: CGPoint(x: turretThree.position.x, y:frame.size.height+10), duration: animationDuration))
            bullet.physicsBody?.contactTestBitMask = BoxThreeCategory
        }else if lane == "laneFour"{
            bullet.position = turretFour.position
            actionArray.append(SKAction.move(to: CGPoint(x: turretFour.position.x, y:frame.size.height+10), duration: animationDuration))
            bullet.physicsBody?.contactTestBitMask = BoxFourCategory
        }
        
        bullet.physicsBody = SKPhysicsBody(texture: bulletTexture, size: CGSize(width: bullet.size.width/5, height: bullet.size.height/5))
        bullet.physicsBody?.categoryBitMask = BulletCategory
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = BulletCategory
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        actionArray.append(SKAction.removeFromParent())
        addChild(bullet)
        
        bullet.run(SKAction.sequence(actionArray))
    }
    
    private func spawnBox() {
        let random = xPosition.randomElement()!
        let box = SKSpriteNode(texture: boxTexture)
        box.physicsBody = SKPhysicsBody(texture: boxTexture, size: box.size)
        
        box.physicsBody?.restitution = 0.0
        box.physicsBody?.allowsRotation = false
    
        
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
        if boxesDestroyed == 5 {
            boxSpawned = false
        }
        else if boxesDestroyed == 10 {
            boxSpawned = false
        }
        else if boxesDestroyed == 18 {
            boxSpawned = false
        }
        else if boxesDestroyed == 28 {
            boxSpawned = false
        }
        else if boxesDestroyed == 40 {
            boxSpawned = false
        }
        else {
            boxSpawned = true
        }
    }
    
    override func sceneDidLoad() {
        self.backgroundColor = UIColor.darkGray
        self.physicsWorld.gravity = CGVector(dx: 0.0,dy: -2.8)
        self.lastUpdateTime = 0
        backgroundNode.setup(size: size)
        addChild(backgroundNode)
        spawnPlus()
        
        score.text = "Money: $\(money)"
        score.position = CGPoint(x: 85, y:frame.height - 85)
        score.fontSize = 25
        score.zPosition = CGFloat(100)
        score.alpha = CGFloat(0.8)
        addChild(score)
        
        waveLabel.text = "Wave: \(wave)"
        waveLabel.position = CGPoint(x: 70, y: score.position.y - 35)
        waveLabel.fontSize = 25
        waveLabel.zPosition = CGFloat(100)
        waveLabel.alpha = CGFloat(0.8)
        addChild(waveLabel)
        
        cooldown.text = "You have 10 seconds until the next wave!"
        cooldown.position = CGPoint(x: frame.midX, y: frame.midY)
        cooldown.fontSize = 20
        cooldown.zPosition = CGFloat(100)
        cooldown.alpha = CGFloat(0.8)
        cooldown.isHidden = true
        addChild(cooldown)
        
        self.physicsWorld.contactDelegate = self
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision:UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == BoxOneCategory | BoxOneCategory{
            print("Collision Lane 1 made")
            counter = counter + 1
            print(counter)
        }else if collision == BoxTwoCategory | BoxTwoCategory{
            print("Collision Lane 2 made")
            counter2 = counter2 + 1
            print(counter2)
        }else if collision == BoxThreeCategory | BoxThreeCategory{
            print("Collision Lane 3 made")
            counter3 = counter3 + 1
            print(counter3)
        }else if collision == BoxFourCategory | BoxFourCategory{
            print("Collision Lane 4 made")
            counter4 = counter4 + 1
            print(counter4)
        }else if collision == BoxOneCategory | AddCategory{
            if contact.bodyA.categoryBitMask == AddCategory{
                contact.bodyA.node?.removeFromParent()
            }else{
                contact.bodyB.node?.removeFromParent()
            }
        }else if collision == BoxTwoCategory | AddCategory{
            if contact.bodyA.categoryBitMask == AddCategory{
                contact.bodyA.node?.removeFromParent()
            }else{
                contact.bodyB.node?.removeFromParent()
            }
        }else if collision == BoxThreeCategory | AddCategory{
            if contact.bodyA.categoryBitMask == AddCategory{
                contact.bodyA.node?.removeFromParent()
            }else{
                contact.bodyB.node?.removeFromParent()
            }
        }else if collision == BoxFourCategory | AddCategory{
            if contact.bodyA.categoryBitMask == AddCategory{
                contact.bodyA.node?.removeFromParent()
            }else{
                contact.bodyB.node?.removeFromParent()
            }
        }else if collision == BulletCategory | BoxOneCategory{
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            money += 1
            score.text = "Money: $\(money)"
            boxesDestroyed += 1
        }else if collision == BulletCategory | BoxTwoCategory{
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            money += 1
            score.text = "Money: $\(money)"
            boxesDestroyed += 1
        }else if collision == BulletCategory | BoxThreeCategory{
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            money += 1
            score.text = "Money: $\(money)"
            boxesDestroyed += 1
        }else if collision == BulletCategory | BoxFourCategory{
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            money += 1
            score.text = "Money: $\(money)"
            boxesDestroyed += 1
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        let name = touchedNode.name
        print(positionInScene)
        if name == "one"{
            touchedNode.removeFromParent()
            spawnTurret(lane: name!)
        }else if name == "two"{
            touchedNode.removeFromParent()
            spawnTurret(lane: name!)
            spawnBullet(lane: name!)
        }else if name == "three"{
            touchedNode.removeFromParent()
            spawnTurret(lane: name!)
            spawnBullet(lane: name!)
        }else if name == "four"{
            touchedNode.removeFromParent()
            spawnTurret(lane: name!)
            spawnBullet(lane: name!)
        }else if name == "laneOne"{
            spawnBullet(lane: name!)
        }else if name == "laneTwo"{
            spawnBullet(lane: name!)
        }else if name == "laneThree"{
            spawnBullet(lane: name!)
        }else if name == "laneFour"{
            spawnBullet(lane: name!)
        }else if name == "upgrade" {
            let up = UpgradeScene(fileNamed: "UpgradeScene")
            up?.scaleMode = .aspectFill
            self.scene?.view?.presentScene(up)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if boxesDestroyed == 5 {
            if boxSpawned == true {
                boxDropSpawnRate = 10
                wave = 2
                waveLabel.text = "Wave: \(wave)"
                cooldown.isHidden = false
            }
            else {
                cooldown.isHidden = true
                boxDropSpawnRate = 2.7
            }
        }
        else if boxesDestroyed == 10 {
            if boxSpawned == true {
                boxDropSpawnRate = 10
                wave = 3
                waveLabel.text = "Wave: \(wave)"
                cooldown.isHidden = false
            }
            else {
                cooldown.isHidden = true
                boxDropSpawnRate = 2.7
                self.physicsWorld.gravity = CGVector(dx: 0.0,dy: -3.0)
            }
        }
        else if boxesDestroyed == 18 {
            if boxSpawned == true {
                boxDropSpawnRate = 10
                wave = 4
                waveLabel.text = "Wave: \(wave)"
                cooldown.isHidden = false
            }
            else {
                cooldown.isHidden = true
                boxDropSpawnRate = 2.4
            }
        }
        else if boxesDestroyed == 28 {
            if boxSpawned == true {
                boxDropSpawnRate = 10
                wave = 5
                waveLabel.text = "Wave: \(wave)"
                cooldown.isHidden = false
            }
            else {
                cooldown.isHidden = true
                boxDropSpawnRate = 2.4
                self.physicsWorld.gravity = CGVector(dx: 0.0,dy: -3.2)
            }
        }
        else if boxesDestroyed == 40 {
            if boxSpawned == true {
                boxDropSpawnRate = 10
                wave = 6
                waveLabel.text = "Wave: \(wave)"
                cooldown.isHidden = false
            }
            else {
                cooldown.isHidden = true
                boxDropSpawnRate = 2
            }
        }
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
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
        
        if counter == 6 || counter2 == 6 || counter3 == 6 || counter4 == 6{
            scene?.view?.isPaused = true
            print("GAME OVER MAN")
        }
    }
}