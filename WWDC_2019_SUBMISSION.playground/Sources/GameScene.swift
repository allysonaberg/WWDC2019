import SpriteKit
import GameplayKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
  
  // MARK: - Instance Variables
  public var player: Player!
  public var playingMap: Map!
  public var cameraNode: SKCameraNode!
  public var timer: CountdownTimer!
  public var recordingSource: RecordingSource!
  var lastTouch: CGPoint? = nil
  public var label: SKLabelNode!
  public var lightSource: LightSource!
  
  override public init(size: CGSize) {
    
    super.init(size: size)
    
    playingMap = Map(self)
    playingMap.container.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    player = Player(self, map: playingMap)
    lightSource = LightSource()
    timer = CountdownTimer(self)
    timer.node.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    label = SKLabelNode()
    label.text = "LABEL TEXT"
    label.color = UIColor.red
    label.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    label.zPosition = 1000
    self.addChild(label)
    recordingSource = RecordingSource()
    recordingSource.recordButtonTapped()
    cameraNode = SKCameraNode()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func didMove(to view: SKView) {
    self.physicsWorld.contactDelegate = self
    self.camera = cameraNode
    self.player.player.addChild(lightSource.lightSource)
  }
  
  // MARK: - Touch Handling
  public override func touchesBegan(_ touches: Set<UITouch>,
                                    with event: UIEvent?) {
    print("HANDLE TOUCHES")
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
    if recordingSource?.recorder != nil && label != nil {
      recordingSource.recorder.updateMeters()
      print(recordingSource.recorder.averagePower(forChannel: 0))
      print(label.position)
      label.text = String(recordingSource.recorder.averagePower(forChannel: 0))
      lightSource.lightSource.falloff = CGFloat(abs(recordingSource.recorder.averagePower(forChannel: 0)) / 60.0)
    }
    
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
//      if let node = secondBody.node {
//        addLightSource(node)
//      }
    }

  }

  private func addLightSource(_ parent: SKNode) {
    let lightNode = SKLightNode()
    lightNode.lightColor = UIColor.red
    lightNode.falloff = 2
    parent.addChild(lightNode)
  }

}
