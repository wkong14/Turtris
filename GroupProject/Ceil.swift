import SpriteKit

public class CeilingNode : SKNode {

  public func setup(size : CGSize) {
    let yPos : CGFloat = size.height * 1
    let startPoint = CGPoint(x: 0, y: yPos)
    let endPoint = CGPoint(x: size.width, y: yPos)
    physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
    physicsBody?.restitution = 0
    physicsBody?.categoryBitMask = CeilCategory
    physicsBody?.contactTestBitMask = BoxOneCategory | BoxTwoCategory | BoxThreeCategory | BoxFourCategory
    
  }
}
