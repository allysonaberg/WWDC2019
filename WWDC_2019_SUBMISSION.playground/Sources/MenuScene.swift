import SpriteKit
import GameplayKit

public class MenuScene: SKScene, SKPhysicsContactDelegate {

  override public init(size: CGSize) {
    
    super.init(size: size)
    self.backgroundColor = UIColor.red
    
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
