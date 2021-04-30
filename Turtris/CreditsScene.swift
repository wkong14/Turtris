//
//  CreditsScene.swift
//  GroupProject
//
//  Created by Wisely Kong on 4/2/21.
//  Copyright © 2021 Thirteen23. All rights reserved.
//

import SpriteKit

class CreditsScene: SKScene {
    
    override func didMove(to view: SKView) {
        let bg = SKAudioNode(fileNamed: "turrit.mp3")
        self.addChild(bg)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition:SKTransition = SKTransition.fade(withDuration: 1)
        let scene = MenuScene(size: self.size)
        scene.scaleMode = self.scaleMode
        self.view?.presentScene(scene, transition: transition)
    }
}
