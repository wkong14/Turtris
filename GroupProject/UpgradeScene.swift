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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition:SKTransition = SKTransition.fade(withDuration: 1)
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        let name = touchedNode.name
        switch name {
        case "Upgrade1.1":
            prevScene?.currentUpgrade = 1
            print("Hey this is upgrade 1")
            self.view?.presentScene(prevScene!, transition: transition)
        case "Upgrade1.2":
            prevScene?.currentUpgrade = 2
            self.view?.presentScene(prevScene!, transition: transition)
        case "Upgrade2.1":
            prevScene?.currentUpgrade = 3
            self.view?.presentScene(prevScene!, transition: transition)
        case "Upgrade2.2":
            prevScene?.currentUpgrade = 4
            self.view?.presentScene(prevScene!, transition: transition)
        case "Upgrade2.3":
            prevScene?.currentUpgrade = 5
            self.view?.presentScene(prevScene!, transition: transition)
        case "Upgrade3.1":
            prevScene?.currentUpgrade = 6
            self.view?.presentScene(prevScene!, transition: transition)
        case "Upgrade3.2":
            prevScene?.currentUpgrade = 7
            self.view?.presentScene(prevScene!, transition: transition)
        case "Upgrade3.3":
            prevScene?.currentUpgrade = 8
            self.view?.presentScene(prevScene!, transition: transition)
        default:
            prevScene?.currentUpgrade = 0
        }
    }
}
