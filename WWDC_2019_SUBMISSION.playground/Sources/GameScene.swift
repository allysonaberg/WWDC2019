import SpriteKit
import GameplayKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
  
  // MARK: - Instance Variables
  public var player: Player!
  public var playingMap: Map!
  public var cameraNode: SKCameraNode!
  public var recordingSource: RecordingSource!
  public var musicPlayer: AudioPlayer!
  var lastTouch: CGPoint? = nil
  public var lightSource: LightSource!
  
  override public init(size: CGSize) {
    
    super.init(size: size)
    self.backgroundColor = UIColor.black

    
    playingMap = Map(self)
    playingMap.container.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    
    player = Player(self, map: playingMap)
    player.player.position = CGPoint(x: 400, y: 400)

    lightSource = LightSource()
    
    cameraNode = SKCameraNode()
    
    recordingSource = RecordingSource()
    
    musicPlayer = AudioPlayer(self)
    musicPlayer.soundNode.position = CGPoint(x: size.width, y: size.height)
    
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func didMove(to view: SKView) {
    self.physicsWorld.contactDelegate = self
    self.camera = cameraNode
//    self.camera?.addChild(musicPlayer.soundNode)
    self.player.player.addChild(lightSource.lightSource)
    self.recordingSource.recordButtonTapped()
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
    if lastTouch != nil {
      let nodes = self.nodes(at: lastTouch!)
    
      for node in nodes
      {
        if node.name == "volumeButton" {
          musicPlayer.stopMusic()
        }
      }
    }
    
  }
  
  public override func didSimulatePhysics() {
    if recordingSource?.recorder != nil {
      recordingSource.recorder.updateMeters()
      //need this to be sensitive...
      //generally, the numbers hover around -20->-40 db, this is just a random equation that makes it sensitive
      lightSource.lightSource.falloff = CGFloat(abs(recordingSource.recorder.averagePower(forChannel: 0)) / 10.0)
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

    print(firstBody.categoryBitMask)
    print(secondBody.categoryBitMask)
    if firstBody.categoryBitMask == player?.player.physicsBody!.categoryBitMask &&
      secondBody.categoryBitMask == 2 {
      print("CONTACT")
      self.backgroundColor = UIColor.red
//      if let node = secondBody.node {
//        addLightSource(node)
//      }
    }

  }
  
  public func didEnd(_ contact: SKPhysicsContact) {
    self.backgroundColor = UIColor.black
  }

  private func addLightSource(_ parent: SKNode) {
    let lightNode = SKLightNode()
    lightNode.lightColor = UIColor.red
    lightNode.falloff = 2
    parent.addChild(lightNode)
  }

}
