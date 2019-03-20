import SpriteKit
import GameplayKit

//TODO: figure out zPosition
//TODO: figure out dynamic positioning / sizes
//TODO: fix force unwrapping
public class GameScene: SKScene, SKPhysicsContactDelegate {
  
  let menuButtonText = "MENU"
  let menuButtonName = "Menu"
  let volumeButtonName = "volumeButton"
  
  // Instance Variables
  var player: Player!
  var playingMap: Map!
  var cameraNode: SKCameraNode!
  var recordingSource: RecordingSource!
  var musicPlayer: AudioPlayer!
  var menuNode: SKLabelNode!
  var lightSource: LightSource!
  var lastTouch: CGPoint? = nil

  // Initialization
  override public init(size: CGSize) {
    
    super.init(size: size)
    
    playingMap = Map(self)
    playingMap.container.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    
    player = Player(self, map: playingMap)
    player.player.position = CGPoint(x: 400, y: 400)
    
    lightSource = LightSource()
    
    cameraNode = SKCameraNode()
    
    recordingSource = RecordingSource()
    
    musicPlayer = AudioPlayer(self)
    musicPlayer.soundNode.position = CGPoint(x: size.width + 500, y: size.height + 300)
    
    menuNode = SKLabelNode(text: "MENU")
    menuNode.fontSize = 25
    menuNode.fontColor = UIColor.red
    menuNode.position = CGPoint(x: musicPlayer.soundNode.position.x, y: musicPlayer.soundNode.position.y - 150)
    menuNode.name = "menu"
    menuNode.zPosition = 100000
    self.addChild(menuNode)
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [gradientColorTop, gradientColorBottom]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.frame.size = size
    self.view?.layer.addSublayer(gradientLayer)
    
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func didMove(to view: SKView) {
    self.physicsWorld.contactDelegate = self
    self.camera = cameraNode
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
          musicPlayer.handleTapped()
        }
        if node.name == "menu" {
          handleShowMenu()
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
      musicPlayer.soundNode.position = CGPoint(x: player.player.position.x + 500, y: player.player.position.y + 300)
      menuNode.position = CGPoint(x: player.player.position.x + 300,
                                  y: player.player.position.y + 100)
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
      //      self.backgroundColor = UIColor.red
    }
    
  }
  
  private func handleShowMenu() {
    let sKView = self.view?.scene?.view
    let menuScene = MenuScene(size: CGSize(width: 1200, height: 800))
    menuScene.scaleMode = .aspectFill
    sKView?.presentScene(menuScene)
  }

}
