//
//  UpgradeScene.swift
//  GroupProject
//
//  Created by Wisely Kong on 4/2/21.
//  Copyright © 2021 Thirteen23. All rights reserved.
//

import SpriteKit

class UpgradeScene: SKScene {
    public var prevScene: SKScene? = nil
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition:SKTransition = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(prevScene!, transition: transition)
    }
}
