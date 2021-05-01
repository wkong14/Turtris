//
//  GameScene.swift
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    public var currentUpgrade = 0
    private var boxesDestroyed: Int = 0
    private var boxSpawned: Bool = false
    private var wave: Int = 1
    let upgrade = SKSpriteNode(imageNamed: "Upgrades_Menu")
    private let xPosition: [Int] = [50, 155, 260, 365]
    private var lastUpdateTime : TimeInterval = 0
    private var currentBoxSpawnTime : TimeInterval = 0
    private var boxDropSpawnRate : TimeInterval = 3
    private var counter: Int = 0
    private var counter2: Int = 0
    private var counter3: Int = 0
    private var counter4: Int = 0
    private var cooltime = DispatchTimeInterval.seconds(3)
    private let backgroundNode = BackgroundNode()
    private let ceilingNode = CeilingNode()
    
    var turretLaneOne = "default"
    var turretLaneTwo = "default"
    var turretLaneThree = "default"
    var turretLaneFour = "default"
    
    var laneOneShots = 0
    var laneTwoShots = 0
    var laneThreeShots = 0
    var laneFourShots = 0
    
    let cdTextureDef = SKTexture(imageNamed: "cooldown")
    let cdTextureOne = SKTexture(imageNamed: "cooldown2")
    let cdTextureTwo = SKTexture(imageNamed: "cooldown3")
    let cdTextureThree = SKTexture(imageNamed: "cooldown4")
    let cdTextureFour = SKTexture(imageNamed: "cooldown5")
    let cdTextureFive = SKTexture(imageNamed: "cooldown6")
    let cdTextureSix = SKTexture(imageNamed: "cooldown7")
    let cdTextureSeven = SKTexture(imageNamed: "cooldown8")
    let cdTextureEight = SKTexture(imageNamed: "cooldown9")
    
        
    let upgradeOne = SKTexture(imageNamed: "upgrade1")
    let upgradeTwo = SKTexture(imageNamed: "upgrade2")
    let upgradeThree = SKTexture(imageNamed: "upgrade3")
    let upgradeFour = SKTexture(imageNamed: "upgrade4")
    let upgradeFive = SKTexture(imageNamed: "upgrade5")
    let upgradeSix = SKTexture(imageNamed: "upgrade6")
    let upgradeSeven = SKTexture(imageNamed: "upgrade7")
    let upgradeEight = SKTexture(imageNamed: "upgrade8")
    
    let boxTexture = SKTexture(imageNamed: "box")
    let bulletTexture = SKTexture(imageNamed: "bullet")
    let addTexture = SKTexture(imageNamed: "add")
    let turretTexture = SKTexture(imageNamed:"turret1")
    var turretOne: SKSpriteNode!
    var turretTwo: SKSpriteNode!
    var turretThree: SKSpriteNode!
    var turretFour: SKSpriteNode!
    var bg: SKAudioNode!
    var money: Int = 5
    let score = SKLabelNode(fontNamed: "Futura")
    let waveLabel = SKLabelNode(fontNamed: "Futura")
    let wavecd = SKLabelNode(fontNamed: "Futura")
    let gameover = SKLabelNode(fontNamed: "Futura")
    
    override func didMove(to view: SKView) {
        let music = SKAudioNode(fileNamed: "turrit.mp3")
        bg = music
        addChild(bg)
        score.text = "Money: $\(money)"
        upgrade.name = "upgrade"
        upgrade.position = CGPoint(x: 335, y: frame.height - 85)
        upgrade.size = CGSize(width: 100, height: 50)
        upgrade.zPosition = CGFloat(100)
        upgrade.removeFromParent()
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
        addLaneTwo.position = CGPoint(x: 155, y: 130)

        let addLaneThree = SKSpriteNode(texture: addTexture)
        addLaneThree.name = "three"
        addLaneThree.physicsBody = SKPhysicsBody(texture: addTexture, size: addLaneThree.size)
        addLaneThree.physicsBody?.restitution = 0.0
        addLaneThree.physicsBody?.allowsRotation = false
        addLaneThree.physicsBody?.pinned = true
        addLaneThree.physicsBody?.categoryBitMask = AddCategory
        addLaneThree.physicsBody?.contactTestBitMask =  BoxThreeCategory
        addLaneThree.position = CGPoint(x: 260, y: 130)

        let addLaneFour = SKSpriteNode(texture: addTexture)
        addLaneFour.name = "four"
        addLaneFour.physicsBody = SKPhysicsBody(texture: addTexture, size: addLaneFour.size)
        addLaneFour.physicsBody?.restitution = 0.0
        addLaneFour.physicsBody?.allowsRotation = false
        addLaneFour.physicsBody?.pinned = true
        addLaneFour.physicsBody?.categoryBitMask = AddCategory
        addLaneFour.physicsBody?.contactTestBitMask =  BoxFourCategory
        addLaneFour.position = CGPoint(x: 365, y: 130)

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
            turret.position = CGPoint(x: 155, y: 130)
            turretTwo = turret
        }else if lane == "three"{
            turret.name = "laneThree"
            turret.physicsBody?.categoryBitMask = TurretThreeCategory
            turret.physicsBody?.contactTestBitMask = BoxThreeCategory
            turret.position = CGPoint(x: 260, y: 130)
            turretThree = turret
        }else if lane == "four"{
            turret.name = "laneFour"
            turret.physicsBody?.categoryBitMask = TurretFourCategory
            turret.physicsBody?.contactTestBitMask = BoxFourCategory
            turret.position = CGPoint(x: 365, y: 130)
            turretFour = turret
        }
        
        addChild(turret)
    }
    
   
    
    func cooldown(node: SKNode, laneTurr: String){
        var action:SKAction
        var wait:SKAction
        var turTexture:SKTexture
        
        if laneTurr == "laneOne"{
            switch turretLaneOne{
            case "default":
                action = SKAction.setTexture(cdTextureDef)
                node.run(action)
                wait = SKAction.wait(forDuration: 3)
                turTexture = SKTexture(imageNamed: "turret1")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade1":
                action = SKAction.setTexture(cdTextureOne)
                node.run(action)
                wait = SKAction.wait(forDuration: 3)
                turTexture = SKTexture(imageNamed: "upgrade1")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade2":
                action = SKAction.setTexture(cdTextureTwo)
                node.run(action)
                wait = SKAction.wait(forDuration: 3)
                turTexture = SKTexture(imageNamed: "upgrade2")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade3":
                action = SKAction.setTexture(cdTextureThree)
                node.run(action)
                wait = SKAction.wait(forDuration: 2)
                cooltime = DispatchTimeInterval.seconds(2)
                turTexture = SKTexture(imageNamed: "upgrade3")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade4":
                action = SKAction.setTexture(cdTextureFour)
                node.run(action)
                wait = SKAction.wait(forDuration: 2)
                cooltime = DispatchTimeInterval.seconds(2)
                turTexture = SKTexture(imageNamed: "upgrade4")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade5":
                action = SKAction.setTexture(cdTextureFive)
                node.run(action)
                wait = SKAction.wait(forDuration: 2)
                cooltime = DispatchTimeInterval.seconds(2)
                turTexture = SKTexture(imageNamed: "upgrade5")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade6":
                action = SKAction.setTexture(cdTextureSix)
                node.run(action)
                wait = SKAction.wait(forDuration: 1)
                cooltime = DispatchTimeInterval.seconds(1)
                turTexture = SKTexture(imageNamed: "upgrade6")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade7":
                action = SKAction.setTexture(cdTextureSeven)
                node.run(action)
                wait = SKAction.wait(forDuration: 1)
                cooltime = DispatchTimeInterval.seconds(1)
                turTexture = SKTexture(imageNamed: "upgrade7")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade8":
                action = SKAction.setTexture(cdTextureEight)
                node.run(action)
                wait = SKAction.wait(forDuration: 0)
                turTexture = SKTexture(imageNamed: "upgrade8")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            default:
                print("wrong")
            }
        }else if laneTurr == "laneTwo"{
            switch turretLaneTwo{
            case "default":
                action = SKAction.setTexture(cdTextureDef)
                node.run(action)
                wait = SKAction.wait(forDuration: 3)
                turTexture = SKTexture(imageNamed: "turret1")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade1":
                action = SKAction.setTexture(cdTextureOne)
                node.run(action)
                wait = SKAction.wait(forDuration: 3)
                turTexture = SKTexture(imageNamed: "upgrade1")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade2":
                action = SKAction.setTexture(cdTextureTwo)
                node.run(action)
                wait = SKAction.wait(forDuration: 3)
                turTexture = SKTexture(imageNamed: "upgrade2")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade3":
                action = SKAction.setTexture(cdTextureThree)
                node.run(action)
                wait = SKAction.wait(forDuration: 2)
                cooltime = DispatchTimeInterval.seconds(2)
                turTexture = SKTexture(imageNamed: "upgrade3")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade4":
                action = SKAction.setTexture(cdTextureFour)
                node.run(action)
                wait = SKAction.wait(forDuration: 2)
                cooltime = DispatchTimeInterval.seconds(2)
                turTexture = SKTexture(imageNamed: "upgrade4")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade5":
                action = SKAction.setTexture(cdTextureFive)
                node.run(action)
                wait = SKAction.wait(forDuration: 2)
                cooltime = DispatchTimeInterval.seconds(2)
                turTexture = SKTexture(imageNamed: "upgrade5")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade6":
                action = SKAction.setTexture(cdTextureSix)
                node.run(action)
                wait = SKAction.wait(forDuration: 1)
                cooltime = DispatchTimeInterval.seconds(1)
                turTexture = SKTexture(imageNamed: "upgrade6")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade7":
                action = SKAction.setTexture(cdTextureSeven)
                node.run(action)
                wait = SKAction.wait(forDuration: 1)
                cooltime = DispatchTimeInterval.seconds(1)
                turTexture = SKTexture(imageNamed: "upgrade7")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade8":
                action = SKAction.setTexture(cdTextureEight)
                node.run(action)
                wait = SKAction.wait(forDuration: 0)
                turTexture = SKTexture(imageNamed: "upgrade8")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            default:
                print("wrong")
            }
        }else if laneTurr == "laneThree"{
            switch turretLaneThree{
            case "default":
                action = SKAction.setTexture(cdTextureDef)
                node.run(action)
                wait = SKAction.wait(forDuration: 3)
                turTexture = SKTexture(imageNamed: "turret1")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade1":
                action = SKAction.setTexture(cdTextureOne)
                node.run(action)
                wait = SKAction.wait(forDuration: 3)
                turTexture = SKTexture(imageNamed: "upgrade1")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade2":
                action = SKAction.setTexture(cdTextureTwo)
                node.run(action)
                wait = SKAction.wait(forDuration: 3)
                turTexture = SKTexture(imageNamed: "upgrade2")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade3":
                action = SKAction.setTexture(cdTextureThree)
                node.run(action)
                wait = SKAction.wait(forDuration: 2)
                cooltime = DispatchTimeInterval.seconds(2)
                turTexture = SKTexture(imageNamed: "upgrade3")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade4":
                action = SKAction.setTexture(cdTextureFour)
                node.run(action)
                wait = SKAction.wait(forDuration: 2)
                cooltime = DispatchTimeInterval.seconds(2)
                turTexture = SKTexture(imageNamed: "upgrade4")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade5":
                action = SKAction.setTexture(cdTextureFive)
                node.run(action)
                wait = SKAction.wait(forDuration: 2)
                cooltime = DispatchTimeInterval.seconds(2)
                turTexture = SKTexture(imageNamed: "upgrade5")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade6":
                action = SKAction.setTexture(cdTextureSix)
                node.run(action)
                wait = SKAction.wait(forDuration: 1)
                cooltime = DispatchTimeInterval.seconds(1)
                turTexture = SKTexture(imageNamed: "upgrade6")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade7":
                action = SKAction.setTexture(cdTextureSeven)
                node.run(action)
                wait = SKAction.wait(forDuration: 1)
                cooltime = DispatchTimeInterval.seconds(1)
                turTexture = SKTexture(imageNamed: "upgrade7")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade8":
                action = SKAction.setTexture(cdTextureEight)
                node.run(action)
                wait = SKAction.wait(forDuration: 0)
                turTexture = SKTexture(imageNamed: "upgrade8")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            default:
                print("wrong")
            }
        }else if laneTurr == "laneFour"{
            switch turretLaneFour{
            case "default":
                action = SKAction.setTexture(cdTextureDef)
                node.run(action)
                wait = SKAction.wait(forDuration: 3)
                turTexture = SKTexture(imageNamed: "turret1")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade1":
                action = SKAction.setTexture(cdTextureOne)
                node.run(action)
                wait = SKAction.wait(forDuration: 3)
                turTexture = SKTexture(imageNamed: "upgrade1")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade2":
                action = SKAction.setTexture(cdTextureTwo)
                node.run(action)
                wait = SKAction.wait(forDuration: 3)
                turTexture = SKTexture(imageNamed: "upgrade2")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade3":
                action = SKAction.setTexture(cdTextureThree)
                node.run(action)
                wait = SKAction.wait(forDuration: 2)
                turTexture = SKTexture(imageNamed: "upgrade3")
                cooltime = DispatchTimeInterval.seconds(2)
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade4":
                action = SKAction.setTexture(cdTextureFour)
                node.run(action)
                wait = SKAction.wait(forDuration: 2)
                turTexture = SKTexture(imageNamed: "upgrade4")
                cooltime = DispatchTimeInterval.seconds(2)
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade5":
                action = SKAction.setTexture(cdTextureFive)
                node.run(action)
                wait = SKAction.wait(forDuration: 2)
                cooltime = DispatchTimeInterval.seconds(2)
                turTexture = SKTexture(imageNamed: "upgrade5")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade6":
                action = SKAction.setTexture(cdTextureSix)
                node.run(action)
                wait = SKAction.wait(forDuration: 1)
                cooltime = DispatchTimeInterval.seconds(1)
                turTexture = SKTexture(imageNamed: "upgrade6")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade7":
                action = SKAction.setTexture(cdTextureSeven)
                node.run(action)
                wait = SKAction.wait(forDuration: 1)
                cooltime = DispatchTimeInterval.seconds(2)
                turTexture = SKTexture(imageNamed: "upgrade7")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            case "upgrade8":
                action = SKAction.setTexture(cdTextureEight)
                node.run(action)
                wait = SKAction.wait(forDuration: 0)
                turTexture = SKTexture(imageNamed: "upgrade8")
                let cooldown = SKAction.sequence([wait, SKAction.setTexture(turTexture)])
                node.run(cooldown)
            default:
                print("wrong")
            }
        }
    
        
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + cooltime){
            if node.physicsBody?.categoryBitMask == TurretOneCategory{
                node.name = "laneOne"
            }else if node.physicsBody?.categoryBitMask == TurretTwoCategory{
                node.name = "laneTwo"
            }else if node.physicsBody?.categoryBitMask == TurretThreeCategory{
                node.name = "laneThree"
            }else if node.physicsBody?.categoryBitMask == TurretFourCategory{
                node.name = "laneFour"
            }
        }
         
        
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
        box.physicsBody?.friction = 0.0
        box.physicsBody?.allowsRotation = false
    
        
        if random == (50){
            box.name = "box1"
            box.physicsBody?.categoryBitMask = BoxOneCategory
            box.physicsBody?.collisionBitMask = BoxOneCategory | FloorCategory | AddCategory | TurretOneCategory
            box.physicsBody?.contactTestBitMask = BoxOneCategory | BulletCategory | CeilCategory
        }else if random == (155){
            box.name = "box2"
            box.physicsBody?.categoryBitMask = BoxTwoCategory
            box.physicsBody?.collisionBitMask = BoxTwoCategory | FloorCategory | AddCategory | TurretTwoCategory
            box.physicsBody?.contactTestBitMask = BoxTwoCategory | BulletCategory | CeilCategory
        }else if random == (260){
            box.name = "box3"
            box.physicsBody?.categoryBitMask = BoxThreeCategory
            box.physicsBody?.collisionBitMask = BoxThreeCategory | FloorCategory | AddCategory | TurretThreeCategory
            box.physicsBody?.contactTestBitMask = BoxThreeCategory | BulletCategory | CeilCategory
        }else if random == (365){
            box.name = "box4"
            box.physicsBody?.categoryBitMask = BoxFourCategory
            box.physicsBody?.collisionBitMask = BoxFourCategory | FloorCategory | AddCategory | TurretFourCategory
            box.physicsBody?.contactTestBitMask = BoxFourCategory | BulletCategory | CeilCategory
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
        
        ceilingNode.setup(size:size)
        addChild(ceilingNode)
        
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
        
        wavecd.text = "You have 10 seconds until the next wave!"
        wavecd.position = CGPoint(x: frame.midX, y: frame.midY)
        wavecd.fontSize = 20
        wavecd.zPosition = CGFloat(100)
        wavecd.alpha = CGFloat(0.8)
        wavecd.isHidden = true
        addChild(wavecd)
        
        self.physicsWorld.contactDelegate = self
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision:UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == BoxOneCategory | BoxOneCategory{
            contact.bodyB.node?.physicsBody?.velocity.dx = 0
            contact.bodyB.node?.physicsBody?.velocity.dy = 0
            contact.bodyA.node?.physicsBody?.velocity.dx = 0
            contact.bodyA.node?.physicsBody?.velocity.dy = 0
        }else if collision == BoxTwoCategory | BoxTwoCategory{
            
            contact.bodyB.node?.physicsBody?.velocity.dx = 0
            contact.bodyB.node?.physicsBody?.velocity.dy = 0
            contact.bodyA.node?.physicsBody?.velocity.dx = 0
            contact.bodyA.node?.physicsBody?.velocity.dy = 0
            
        }else if collision == BoxThreeCategory | BoxThreeCategory{
            
            contact.bodyB.node?.physicsBody?.velocity.dx = 0
            contact.bodyB.node?.physicsBody?.velocity.dy = 0
            contact.bodyA.node?.physicsBody?.velocity.dx = 0
            contact.bodyA.node?.physicsBody?.velocity.dy = 0
          
        }else if collision == BoxFourCategory | BoxFourCategory{
            
            contact.bodyB.node?.physicsBody?.velocity.dx = 0
            contact.bodyB.node?.physicsBody?.velocity.dy = 0
            contact.bodyA.node?.physicsBody?.velocity.dx = 0
            contact.bodyA.node?.physicsBody?.velocity.dy = 0
          
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
            counter -= 1
        }else if collision == BulletCategory | BoxTwoCategory{
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            money += 1
            score.text = "Money: $\(money)"
            boxesDestroyed += 1
            counter2 -= 1
        }else if collision == BulletCategory | BoxThreeCategory{
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            money += 1
            score.text = "Money: $\(money)"
            boxesDestroyed += 1
            counter3 -= 1
        }else if collision == BulletCategory | BoxFourCategory{
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            money += 1
            score.text = "Money: $\(money)"
            boxesDestroyed += 1
            counter4 -= 1
        }else if collision == BoxOneCategory | FloorCategory{
            contact.bodyB.node?.physicsBody?.velocity.dx = 0
            contact.bodyB.node?.physicsBody?.velocity.dy = 0
        }else if collision == BoxTwoCategory | FloorCategory{
            contact.bodyB.node?.physicsBody?.velocity.dx = 0
            contact.bodyB.node?.physicsBody?.velocity.dy = 0
        }else if collision == BoxThreeCategory | FloorCategory{
            contact.bodyB.node?.physicsBody?.velocity.dx = 0
            contact.bodyB.node?.physicsBody?.velocity.dy = 0
        }else if collision == BoxFourCategory | FloorCategory{
            contact.bodyB.node?.physicsBody?.velocity.dx = 0
            contact.bodyB.node?.physicsBody?.velocity.dy = 0
        }else if collision == BoxOneCategory | TurretOneCategory{
            if contact.bodyA.node?.physicsBody?.categoryBitMask == TurretOneCategory{
                contact.bodyA.node?.removeFromParent()
            }else if contact.bodyB.node?.physicsBody?.categoryBitMask == TurretOneCategory{
                contact.bodyB.node?.removeFromParent()
            }
             
        }else if collision == BoxTwoCategory | TurretTwoCategory{
            if contact.bodyA.node?.physicsBody?.categoryBitMask == TurretTwoCategory{
                contact.bodyA.node?.removeFromParent()
            }else if contact.bodyB.node?.physicsBody?.categoryBitMask == TurretTwoCategory{
                contact.bodyB.node?.removeFromParent()
            }
        }else if collision == BoxThreeCategory | TurretThreeCategory{
            if contact.bodyA.node?.physicsBody?.categoryBitMask == TurretThreeCategory{
                contact.bodyA.node?.removeFromParent()
            }else if contact.bodyB.node?.physicsBody?.categoryBitMask == TurretThreeCategory{
                contact.bodyB.node?.removeFromParent()
            }
        }else if collision == BoxFourCategory | TurretFourCategory{
            if contact.bodyA.node?.physicsBody?.categoryBitMask == TurretFourCategory{
                contact.bodyA.node?.removeFromParent()
            }else if contact.bodyB.node?.physicsBody?.categoryBitMask == TurretFourCategory{
                contact.bodyB.node?.removeFromParent()
            }
        }else if collision == BoxOneCategory | CeilCategory{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.counter += 1
            }
    

        }else if collision == BoxTwoCategory | CeilCategory{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.counter2 += 1
            }
        }else if collision == BoxThreeCategory | CeilCategory{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.counter3 += 1
            }
        }else if collision == BoxFourCategory | CeilCategory{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.counter4 += 1
            }
        }
        
    }
    
    func upgradeTurret(node: SKNode, upgrade:Int){
        score.text = "Money: $\(money)"
        let action: SKAction
        switch upgrade{
        case 1:
            action = SKAction.setTexture(upgradeOne)
            node.run(action)
            if node.name == "laneOne"{
                turretLaneOne = "upgrade1"
            }else if node.name == "laneTwo"{
                turretLaneTwo = "upgrade1"
            }else if node.name == "laneThree"{
                turretLaneThree = "upgrade1"
            }else if node.name == "laneFour"{
                turretLaneFour = "upgrade1"
            }
        case 2:
            action = SKAction.setTexture(upgradeTwo)
            node.run(action)
            if node.name == "laneOne"{
                turretLaneOne = "upgrade2"
            }else if node.name == "laneTwo"{
                turretLaneTwo = "upgrade2"
            }else if node.name == "laneThree"{
                turretLaneThree = "upgrade2"
            }else if node.name == "laneFour"{
                turretLaneFour = "upgrade2"
            }
        case 3:
            action = SKAction.setTexture(upgradeThree)
            node.run(action)
            if node.name == "laneOne"{
                turretLaneOne = "upgrade3"
            }else if node.name == "laneTwo"{
                turretLaneTwo = "upgrade3"
            }else if node.name == "laneThree"{
                turretLaneThree = "upgrade3"
            }else if node.name == "laneFour"{
                turretLaneFour = "upgrade3"
            }
        case 4:
            action = SKAction.setTexture(upgradeFour)
            node.run(action)
            if node.name == "laneOne"{
                turretLaneOne = "upgrade4"
            }else if node.name == "laneTwo"{
                turretLaneTwo = "upgrade4"
            }else if node.name == "laneThree"{
                turretLaneThree = "upgrade4"
            }else if node.name == "laneFour"{
                turretLaneFour = "upgrade4"
            }
        case 5:
            action = SKAction.setTexture(upgradeFive)
            node.run(action)
            if node.name == "laneOne"{
                turretLaneOne = "upgrade5"
            }else if node.name == "laneTwo"{
                turretLaneTwo = "upgrade5"
            }else if node.name == "laneThree"{
                turretLaneThree = "upgrade5"
            }else if node.name == "laneFour"{
                turretLaneFour = "upgrade5"
            }
        case 6:
            action = SKAction.setTexture(upgradeSix)
            node.run(action)
            if node.name == "laneOne"{
                turretLaneOne = "upgrade6"
            }else if node.name == "laneTwo"{
                turretLaneTwo = "upgrade6"
            }else if node.name == "laneThree"{
                turretLaneThree = "upgrade6"
            }else if node.name == "laneFour"{
                turretLaneFour = "upgrade6"
            }
        case 7:
            action = SKAction.setTexture(upgradeSeven)
            node.run(action)
            if node.name == "laneOne"{
                turretLaneOne = "upgrade7"
            }else if node.name == "laneTwo"{
                turretLaneTwo = "upgrade7"
            }else if node.name == "laneThree"{
                turretLaneThree = "upgrade7"
            }else if node.name == "laneFour"{
                turretLaneFour = "upgrade7"
            }
        case 8:
            action = SKAction.setTexture(upgradeEight)
            node.run(action)
            if node.name == "laneOne"{
                turretLaneOne = "upgrade8"
            }else if node.name == "laneTwo"{
                turretLaneTwo = "upgrade8"
            }else if node.name == "laneThree"{
                turretLaneThree = "upgrade8"
            }else if node.name == "laneFour"{
                turretLaneFour = "upgrade8"
            }
            
        default:
            print("oops")
        }
        
         
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let up = UpgradeScene(fileNamed: "UpgradeScene")
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        let name = touchedNode.name
//        print(positionInScene)
//        print(touchedNode.physicsBody?.velocity ?? 1)
        if ["one", "two", "three", "four"].contains(name) {
            touchedNode.removeFromParent()
            spawnTurret(lane: name!)
        }else if ["laneOne", "laneTwo", "laneThree", "laneFour"].contains(name) {
            switch currentUpgrade {
            case 1:
                upgradeTurret(node: touchedNode, upgrade: currentUpgrade)
                currentUpgrade = 0
            case 2:
                upgradeTurret(node: touchedNode, upgrade: currentUpgrade)
                currentUpgrade = 0
            case 3:
                upgradeTurret(node: touchedNode, upgrade: currentUpgrade)
                currentUpgrade = 0
            case 4:
                upgradeTurret(node: touchedNode, upgrade: currentUpgrade)
                currentUpgrade = 0
            case 5:
                upgradeTurret(node: touchedNode, upgrade: currentUpgrade)
                currentUpgrade = 0
            case 6:
                upgradeTurret(node: touchedNode, upgrade: currentUpgrade)
                currentUpgrade = 0
            case 7:
                upgradeTurret(node: touchedNode, upgrade: currentUpgrade)
                currentUpgrade = 0
            case 8:
                upgradeTurret(node: touchedNode, upgrade: currentUpgrade)
                currentUpgrade = 0
            default:
                spawnBullet(lane: name!)
                if touchedNode.name == "laneOne" {
                    laneOneShots += 1
                    if turretLaneOne == "upgrade1" && laneOneShots == 2{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneOneShots = 0
                    } else if turretLaneOne == "upgrade2" && laneOneShots == 3{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneOneShots = 0
                    } else if turretLaneOne == "upgrade3" && laneOneShots == 2{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneOneShots = 0
                    } else if turretLaneOne == "upgrade4" && laneOneShots == 3{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneOneShots = 0
                    } else if turretLaneOne == "upgrade5" && laneOneShots == 4{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneOneShots = 0
                    } else if turretLaneOne == "upgrade6" && laneOneShots == 4{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneOneShots = 0
                    } else if turretLaneOne == "upgrade7" && laneOneShots == 5{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneOneShots = 0
                    } else if turretLaneOne == "default" && laneOneShots == 1{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneOneShots = 0
                    }
                } else if touchedNode.name == "laneTwo" {
                    laneTwoShots += 1
                    if turretLaneTwo == "upgrade1" && laneTwoShots == 2{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneTwoShots = 0
                    } else if turretLaneTwo == "upgrade2" && laneTwoShots == 3{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneTwoShots = 0
                    } else if turretLaneTwo == "upgrade3" && laneTwoShots == 2{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneTwoShots = 0
                    } else if turretLaneTwo == "upgrade4" && laneTwoShots == 3{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneTwoShots = 0
                    } else if turretLaneTwo == "upgrade5" && laneTwoShots == 4{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneTwoShots = 0
                    } else if turretLaneTwo == "upgrade6" && laneTwoShots == 4{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneTwoShots = 0
                    } else if turretLaneTwo == "upgrade7" && laneTwoShots == 5{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneTwoShots = 0
                    } else if turretLaneTwo == "default" && laneTwoShots == 1{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneTwoShots = 0
                    }
                } else if touchedNode.name == "laneThree" {
                    laneThreeShots += 1
                    if turretLaneThree == "upgrade1" && laneThreeShots == 2{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneThreeShots = 0
                    } else if turretLaneThree == "upgrade2" && laneThreeShots == 3{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneThreeShots = 0
                    } else if turretLaneThree == "upgrade3" && laneThreeShots == 2{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneThreeShots = 0
                    } else if turretLaneThree == "upgrade4" && laneThreeShots == 3{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneThreeShots = 0
                    } else if turretLaneThree == "upgrade5" && laneThreeShots == 4{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneThreeShots = 0
                    } else if turretLaneThree == "upgrade6" && laneThreeShots == 4{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneThreeShots = 0
                    } else if turretLaneThree == "upgrade7" && laneThreeShots == 5{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneThreeShots = 0
                    } else if turretLaneThree == "default" && laneThreeShots == 1{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneThreeShots = 0
                    }
                } else if touchedNode.name == "laneFour" {
                    laneFourShots += 1
                    if turretLaneFour == "upgrade1" && laneFourShots == 2{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneFourShots = 0
                    } else if turretLaneFour == "upgrade2" && laneFourShots == 3{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneFourShots = 0
                    } else if turretLaneFour == "upgrade3" && laneFourShots == 2{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneFourShots = 0
                    } else if turretLaneFour == "upgrade4" && laneFourShots == 3{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneFourShots = 0
                    } else if turretLaneFour == "upgrade5" && laneFourShots == 4{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneFourShots = 0
                    } else if turretLaneFour == "upgrade6" && laneFourShots == 4{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneFourShots = 0
                    } else if turretLaneFour == "upgrade7" && laneFourShots == 5{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneFourShots = 0
                    } else if turretLaneFour == "default" && laneFourShots == 1{
                        touchedNode.name = "cooldown"
                        cooldown(node: touchedNode, laneTurr: name!)
                        laneFourShots = 0
                    }
                }
            }
        }else if name == "upgrade" {
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            up?.prevScene = self
            up?.scaleMode = .aspectFill
            bg.removeFromParent()
            self.scene?.view?.presentScene(up!, transition: transition)
        }else if name == "box1" && touchedNode.position.y <= 143 && money != 0{
            money -= 1
            score.text = "Money: $\(money)"
            counter -= 1
            touchedNode.removeFromParent()
            spawnTurret(lane: "one")
        }else if name == "box2" && touchedNode.position.y <= 143 && money != 0{
            money -= 1
            score.text = "Money: $\(money)"
            counter2 -= 1
            touchedNode.removeFromParent()
            spawnTurret(lane: "two")
        }else if name == "box3" && touchedNode.position.y <= 143 && money != 0{
            money -= 1
            score.text = "Money: $\(money)"
            counter3 -= 1
            touchedNode.removeFromParent()
            spawnTurret(lane: "three")
        }else if name == "box4" && touchedNode.position.y <= 143 && money != 0{
            money -= 1
            score.text = "Money: $\(money)"
            counter4 -= 1
            touchedNode.removeFromParent()
            spawnTurret(lane: "four")
        }



    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func goToGameScene(){
        let gameScene: GameScene = GameScene(size: self.view!.bounds.size)
        let transition = SKTransition.fade(withDuration: 1)
        gameScene.scaleMode = SKSceneScaleMode.fill
        self.view!.presentScene(gameScene, transition: transition)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if boxesDestroyed == 5 {
            if boxSpawned == true {
                boxDropSpawnRate = 10
                wave = 2
                waveLabel.text = "Wave: \(wave)"
                wavecd.isHidden = false
            }
            else {
                wavecd.isHidden = true
                boxDropSpawnRate = 2.7
            }
        }
        else if boxesDestroyed == 10 {
            if boxSpawned == true {
                boxDropSpawnRate = 10
                wave = 3
                waveLabel.text = "Wave: \(wave)"
                wavecd.isHidden = false
            }
            else {
                wavecd.isHidden = true
                boxDropSpawnRate = 2.7
                self.physicsWorld.gravity = CGVector(dx: 0.0,dy: -3.0)
            }
        }
        else if boxesDestroyed == 18 {
            if boxSpawned == true {
                boxDropSpawnRate = 10
                wave = 4
                waveLabel.text = "Wave: \(wave)"
                wavecd.isHidden = false
            }
            else {
                wavecd.isHidden = true
                boxDropSpawnRate = 2.4
            }
        }
        else if boxesDestroyed == 28 {
            if boxSpawned == true {
                boxDropSpawnRate = 10
                wave = 5
                waveLabel.text = "Wave: \(wave)"
                wavecd.isHidden = false
            }
            else {
                wavecd.isHidden = true
                boxDropSpawnRate = 2.4
                self.physicsWorld.gravity = CGVector(dx: 0.0,dy: -3.2)
            }
        }
        else if boxesDestroyed == 40 {
            if boxSpawned == true {
                boxDropSpawnRate = 10
                wave = 6
                waveLabel.text = "Wave: \(wave)"
                wavecd.isHidden = false
            }
            else {
                wavecd.isHidden = true
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
        
        if counter == 8 || counter2 == 8 || counter3 == 8 || counter4 == 8{
            
            print("GAME OVER")
            gameover.text = "GAME OVER"
            gameover.position = CGPoint(x: frame.midX, y: frame.midY)
            gameover.fontSize = 45
            gameover.zPosition = CGFloat(100)
            gameover.alpha = CGFloat(0.8)
            addChild(gameover)
            scene?.view?.isPaused = true
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                self.scene?.view?.isPaused = false
                self.removeAllChildren()
                self.goToGameScene()
            }
            
        }
    }
}
