//
//  GameViewController.swift
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let sceneNode = MenuScene(size: view.frame.size)
    if let view = self.view as! SKView? {
      view.presentScene(sceneNode)
      view.ignoresSiblingOrder = false
      view.showsPhysics = false
      view.showsFPS = false
      view.showsNodeCount = false
    }
  }

  override var shouldAutorotate: Bool {
    return true
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }
}
