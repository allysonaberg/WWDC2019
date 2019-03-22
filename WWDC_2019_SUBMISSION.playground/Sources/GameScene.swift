import SpriteKit
import GameplayKit

//TODO: figure out zPosition
//TODO: figure out dynamic positioning / sizes
//TODO: fix force unwrapping
//TODO: recorder and audio player cleanup
public class GameScene: SKScene, SKPhysicsContactDelegate {
  
  let menuButtonText = "MENU"
  let menuButtonName = "menu"
  
  public var hasShownTutorial: Bool = false
  
  // Instance Variables
  var player: Player!
  var playingMap: Map!
  var cameraNode: SKCameraNode!
  var recordingSource: RecordingSource!
  var musicPlayer: AudioPlayer!
  var menuNode: SKLabelNode!
  var lightSource: LightSource!
  var gradientNode: SKSpriteNode!
  var lastTouch: CGPoint? = nil
  
  var tutorial: Tutorial!

  // Initialization
  override public init(size: CGSize) {
    
    super.init(size: size)
    
    tutorial = Tutorial(self)
    tutorial.zPosition = 10000000000000
    self.addChild(tutorial)
    
    playingMap = Map(self)
    playingMap.container.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    player = Player(self, map: playingMap)
    player.player.position = CGPoint(x: self.size.width / 2 - 500 , y: self.size.height / 2 - 400 )
    
    lightSource = LightSource()
    
    cameraNode = SKCameraNode()
    
    recordingSource = RecordingSource()
    
    musicPlayer = AudioPlayer(self)
  
    setupMenuNode()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupMenuNode() {
    menuNode = SKLabelNode(text: menuButtonText)
    menuNode.fontSize = 25
    menuNode.fontColor = whiteColor
    menuNode.name = menuButtonName
    menuNode.zPosition = 100000
//    self.addChild(menuNode)
  }
  
  private func setupGradientBackground() {
    let gradientLayer = CAGradientLayer()
    guard let size = self.view?.frame.size, let origin = self.view?.frame.origin else { return }
    gradientLayer.frame.size = size
    gradientLayer.frame.origin = origin
    
    gradientLayer.colors = [redColor, whiteColor]
    UIGraphicsBeginImageContext(self.frame.size)
    self.view?.layer.render(in: UIGraphicsGetCurrentContext()!)
    let background = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    self.gradientNode = SKSpriteNode()
    gradientNode.texture = SKTexture(image: background)
    gradientNode.size = standardScreenSize
    gradientNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    gradientNode.zPosition = 2000000
    self.addChild(gradientNode)
  }
  
  private func layerToNode(layer: CAGradientLayer) -> SKSpriteNode {
    UIGraphicsBeginImageContext(self.frame.size)
    self.view?.layer.render(in: UIGraphicsGetCurrentContext()!)
    let background = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return SKSpriteNode(texture: SKTexture(image: background))
  }
  
  public override func didMove(to view: SKView) {
    let topRightCornerConstraint = SKConstraint.distance(SKRange(constantValue: 100), to: CGPoint(x: self.frame.maxX, y: self.frame.maxY))
    let topLeftCornerConstraint = SKConstraint.distance(SKRange(constantValue: 100), to: CGPoint(x: self.frame.minX, y: self.frame.maxY))
    self.physicsWorld.contactDelegate = self
    self.camera = cameraNode
    self.addChild(menuNode)
    self.addChild(musicPlayer.soundNode)
    self.player.player.addChild(lightSource.lightSource)
    self.addChild(cameraNode)
    self.recordingSource.recordButtonTapped()
    self.musicPlayer.startMusic()
    setupGradientBackground()

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
    
    if hasShownTutorial {
      let location = touches.first?.location(in: self)
      if location != nil {
        let nodes = self.nodes(at: location!)
      
        for node in nodes
        {
          if node.name == volumeButtonName {
            musicPlayer.handleTapped()
          } else if node.name == menuButtonName {
            handleShowMenu()
          } else {
            //player movement
            lastTouch = touches.first?.location(in: self)
          }
        }
      }
    } else {
      tutorial.handleInteraction(touches)
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
      menuNode.position = CGPoint(x: cameraNode.position.x - self.frame.midX / 1.5, y: cameraNode.position.y + self.frame.midY / 1.5 )
      musicPlayer.soundNode.position = CGPoint(x: cameraNode.position.x + self.frame.midX / 1.5, y: cameraNode.position.y + self.frame.midY / 1.5)
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

  private func handleWin() {
    handleShowMenu()
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
//            self.backgroundColor = redColor
    } else if firstBody.categoryBitMask == player?.player.physicsBody!.categoryBitMask &&
      secondBody.categoryBitMask == 3 {
      print("HANDLEWIN")
      handleWin()
    }
    
  }
  
  public func didEnd(_ contact: SKPhysicsContact) {
//    self.backgroundColor = whiteColor
  }
  
}
