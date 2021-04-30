//
//  UpgradeScene.swift
//  GroupProject
//
//  Created by Wisely Kong on 4/2/21.
//  Copyright © 2021 Thirteen23. All rights reserved.
//

import SpriteKit

class UpgradeScene: SKScene {
    public var prevScene: GameScene? = nil
    public var currentUpgrade: Int = 0
    var score = SKLabelNode()
    
    override func didMove(to view: SKView) {
        let bg = SKAudioNode(fileNamed: "turrit.mp3")
        self.addChild(bg)
        score = self.childNode(withName: "scoreLabel") as! SKLabelNode
        score.text = "Money: $\(prevScene!.money)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition:SKTransition = SKTransition.fade(withDuration: 1)
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        let name = touchedNode.name
        switch name {
        case "Upgrade1.1":
            if prevScene!.money >= 5 {
                prevScene?.currentUpgrade = 1
                prevScene?.money -= 5
            }
        case "Upgrade1.2":
            if prevScene!.money >= 10 {
                prevScene?.currentUpgrade = 2
                prevScene?.money -= 10
            }
        case "Upgrade2.1":
            if prevScene!.money >= 15 {
                prevScene?.currentUpgrade = 3
                prevScene?.money -= 15
            }
        case "Upgrade2.2":
            if prevScene!.money >= 20 {
                prevScene?.currentUpgrade = 4
                prevScene?.money -= 20
            }
        case "Upgrade2.3":
            if prevScene!.money >= 25 {
                prevScene?.currentUpgrade = 5
                prevScene?.money -= 25
            }
        case "Upgrade3.1":
            if prevScene!.money >= 30 {
                prevScene?.currentUpgrade = 6
                prevScene?.money -= 30
            }
        case "Upgrade3.2":
            if prevScene!.money >= 35 {
                prevScene?.currentUpgrade = 7
                prevScene?.money -= 35
            }
        case "Upgrade3.3":
            if prevScene!.money >= 40 {
                prevScene?.currentUpgrade = 8
                prevScene?.money -= 40
            }
        default:
            prevScene?.currentUpgrade = 0
        }
        self.view?.presentScene(prevScene!, transition: transition)
    }
}
