import SpriteKit
import GameplayKit

//TODO: figure out zPosition
//TODO: figure out dynamic positioning / sizes
//TODO: fix force unwrapping
//TODO: recorder and audio player cleanup
public class GameScene: SKScene, SKPhysicsContactDelegate {
  
  let menuButtonText = "MENU"
  let menuButtonName = "menu"
  
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
    musicPlayer.soundNode.position = CGPoint(x: self.size.width + 500, y: self.size.height + 300)
  
    setupMenuNode()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupMenuNode() {
    menuNode = SKLabelNode(text: menuButtonText)
    menuNode.fontSize = 25
    menuNode.fontColor = redColor
    menuNode.position = CGPoint(x: self.size.width, y: self.size.height)
    menuNode.name = menuButtonName
    menuNode.zPosition = 100000
    self.addChild(menuNode)
  }
  
  public override func didMove(to view: SKView) {
    self.physicsWorld.contactDelegate = self
    self.camera = cameraNode
    self.player.player.addChild(lightSource.lightSource)
    
    self.recordingSource.recordButtonTapped()
    self.musicPlayer.startMusic()

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
    if lastTouch != nil {
      let nodes = self.nodes(at: lastTouch!)
      
      for node in nodes
      {
        if node.name == volumeButtonName {
          musicPlayer.handleTapped()
        }
        if node.name == menuButtonName {
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
  
  private func handleShowMenu() {
    recordingSource?.recorder.stop()
    musicPlayer.stopMusic()
    
    let sKView = self.view?.scene?.view
    let menuScene = MenuScene(size: standardScreenSize)
    menuScene.scaleMode = .aspectFill
    sKView?.presentScene(menuScene)
  }

  
  //SKPhysicsContactDelegateMethods
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
            self.backgroundColor = redColor
    }
    
  }
  
  public func didEnd(_ contact: SKPhysicsContact) {
    self.backgroundColor = blackColor
  }
  
}
