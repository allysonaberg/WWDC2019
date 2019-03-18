import SpriteKit
import GameplayKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
  
  // MARK: - Instance Variables
  public var player: Player!
  public var playingMap: Map!
  public var cameraNode: SKCameraNode!
  var lastTouch: CGPoint? = nil
  
  override public init(size: CGSize) {
    
    super.init(size: size)
    playingMap = Map(self)
    playingMap.container.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    player = Player(self, map: playingMap)
    
    cameraNode = SKCameraNode()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func didMove(to view: SKView) {
    self.physicsWorld.contactDelegate = self
    self.camera = cameraNode
  }
  
  // MARK: - Touch Handling
  public override func touchesBegan(_ touches: Set<UITouch>,
                                    with event: UIEvent?) {
    handleTouches(touches)
  }
  
  public override func touchesMoved(_ touches: Set<UITouch>,
                                    with event: UIEvent?) {
    handleTouches(touches)
  }
  
  public override func touchesEnded(_ touches: Set<UITouch>,
                                    with event: UIEvent?) {
    lastTouch = player.player.position
    
  }
  
  fileprivate func handleTouches(_ touches: Set<UITouch>) {
    lastTouch = touches.first?.location(in: self)
  }
  
  public override func didSimulatePhysics() {
    if player != nil {
      player.updatePlayer(position: lastTouch)
      cameraNode.position = player.player.position
    }
  }


  public func didBegin(_ contact: SKPhysicsContact) {
    var firstBody: SKPhysicsBody
    var secondBody: SKPhysicsBody
    
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      firstBody = contact.bodyA
      secondBody = contact.bodyB
    } else {
      firstBody = contact.bodyB
      secondBody = contact.bodyA
    }
    
    if firstBody.categoryBitMask == player?.player.physicsBody!.categoryBitMask &&
      secondBody.categoryBitMask == 2 {
      if let node = secondBody.node {
        addLightSource(node)
      }
    }

  }

  private func addLightSource(_ parent: SKNode) {
    let lightNode = SKLightNode()
    lightNode.lightColor = UIColor.red
    lightNode.falloff = 2
    parent.addChild(lightNode)
  }

}
