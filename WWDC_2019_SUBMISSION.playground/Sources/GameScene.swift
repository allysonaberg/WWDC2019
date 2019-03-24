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
  var cloudsShown: Bool = false
  
  // Instance Variables
  var player: Player!
  var playingMap: Map!
  var cameraNode: SKCameraNode!
  var recordingSource: RecordingSource!
  var musicPlayer: AudioPlayer!
  var menuNode: SKSpriteNode!
  var lightSource: LightSource!
  var gradientNode: SKSpriteNode!
  var lastTouch: CGPoint? = nil

  
  var tutorial: Tutorial!

  // Initialization
  override public init(size: CGSize) {

    super.init(size: size)
    
    
    tutorial = Tutorial(self)
    tutorial.zPosition = 10000000000000
    
    playingMap = Map(self)
    player = Player(self, map: playingMap)
    self.addChild(player)

    lightSource = LightSource()
    
    cameraNode = SKCameraNode()
    
    recordingSource = RecordingSource()
    
    musicPlayer = AudioPlayer()
  
    setupMenuNode()
    setupGradientBackground()
    gradientNode.size = CGSize(width: CGFloat(standardScreenSize.width*5), height: CGFloat(standardScreenSize.height*5))
  }
  
  private func handlePortraitOrientation() {
    let testNode = SKLabelNode(text: "PORTRAIT")
    testNode.zPosition = 1000000
    self.addChild(testNode)
    menuNode.removeFromParent()
    musicPlayer.removeFromParent()
  }
  
  private func handleLandscapeOrientation() {
    let testNode = SKLabelNode(text: "LANDSCAPE")
    testNode.zPosition = 100000000
    self.addChild(testNode)
    menuNode.removeFromParent()
    musicPlayer.removeFromParent()
//    menuNode.position = CGPoint(x: cameraNode.position.x + self.frame.midX / 1.5 + 50, y: cameraNode.position.y + self.frame.midY / 1.5 )
//    musicPlayer.soundNode.position = CGPoint(x: cameraNode.position.x + self.frame.midX / 1.5, y: cameraNode.position.y + self.frame.midY / 1.5)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
//    handleCleanUp()
  }
  
  private func setupMenuNode() {
    menuNode = SKSpriteNode(imageNamed: "menu_button")
    menuNode.size = CGSize(width: 45, height: 45)
    menuNode.name = menuButtonName
    menuNode.zPosition = 100000
  }
  
  private func setupGradientBackground() {
    let texture = SKTexture(size: CGSize(width: CGFloat(standardScreenSize.width*2), height: CGFloat(standardScreenSize.height*3)), startColor: redColor, endcolor: gradientColorBottom)
    self.gradientNode = SKSpriteNode(texture: texture)
    gradientNode.zPosition = -1
    gradientNode.alpha = 1
    
    self.addChild(gradientNode)
  }
  
  public override func didMove(to view: SKView) {
    self.physicsWorld.contactDelegate = self
    self.camera = cameraNode
    self.addChild(menuNode)
    self.addChild(musicPlayer.soundNode)
    self.player.player.addChild(lightSource.lightSource)
    self.addChild(cameraNode)
    self.recordingSource.recordButtonTapped()
    self.musicPlayer.startMusic()
    self.addChild(tutorial)
  }
  
  //TODO: FIX
  func setupClouds() {
    setupCloudsNode(alpha: 1, to: 4000, duration: 650.0, xDiff: 1000, yDiff: 3200)
    setupCloudsNode(alpha: 1, to: 4000, duration: 650.0, xDiff: 2000, yDiff: 2900)
    setupCloudsNode(alpha: 0.9, to: 1000, duration: 350.0, xDiff: 0, yDiff: 0)
    setupCloudsNode(alpha: 0.9, to: 1000, duration: 350.0, xDiff: 800, yDiff: 0)
    setupCloudsNode(alpha: 1, to: 1200, duration: 600.0, xDiff: -900, yDiff: 2000)
    setupCloudsNode(alpha: 0.9, to: 1000, duration: 350.0, xDiff: 1000, yDiff: 800)
    setupCloudsNode(alpha: 0.8, to: 1200, duration: 450.0, xDiff: 200, yDiff: 400)
    setupCloudsNode(alpha: 0.9, to: 1000, duration: 350.0, xDiff: 600, yDiff: -300)
    setupCloudsNode(alpha: 0.9, to: 1000, duration: 350.0, xDiff: 1200, yDiff: -300)
    setupCloudsNode(alpha: 1, to: 2000, duration: 650.0, xDiff: -1000, yDiff: -1000)
    setupCloudsNode(alpha: 0.9, to: 1000, duration: 400.0, xDiff: -1500, yDiff: -2000)
    setupCloudsNode(alpha: 0.9, to: 1000, duration: 400.0, xDiff: 1800, yDiff: -2200)
    setupCloudsNode(alpha: 1, to: 4000, duration: 650.0, xDiff: -2000, yDiff: -4000)
    setupCloudsNode(alpha: 1, to: 4000, duration: 650.0, xDiff: 1500, yDiff: -4400)
  }
  
  func setupCloudsNode(alpha: CGFloat, to: Int, duration: Double, xDiff: Int, yDiff: Int) {
    let clouds = SKSpriteNode(imageNamed: "clouds")
    clouds.alpha = alpha
    clouds.isUserInteractionEnabled = false
    clouds.position = CGPoint(x: self.player.position.x + CGFloat(xDiff), y: self.player.position.y + CGFloat(yDiff))
    clouds.zPosition = 1000000000000000
    self.addChild(clouds)
    
    let moveClouds = SKAction.move(to: CGPoint(x: clouds.position.x + CGFloat(to), y: clouds.position.y), duration: duration)
    clouds.run(moveClouds)
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
            break
          } else if node.name == menuButtonName {
            handleShowMenu()
            break
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
    
    if (!cloudsShown && hasShownTutorial) {
      setupClouds()
      cloudsShown = true
    }
    
    if recordingSource?.recorder != nil   {
      recordingSource.recorder.updateMeters()
      //need this to be sensitive...
      //generally, the numbers hover around -20->-40 db, this is just a random equation that makes it sensitive
      //1.075 just looks good...
      lightSource.lightSource.falloff = pow(1.075, CGFloat(abs(recordingSource.recorder.averagePower(forChannel: 0))))
    }
    
    if player != nil {
      player.updatePlayer(position: lastTouch)
      cameraNode.position.x += (player.player.position.x - cameraNode.position.x) / 8
      cameraNode.position.y += (player.player.position.y - cameraNode.position.y) / 8

      guard let sKView = self.view?.scene?.view else { return }
      tutorial.position = cameraNode.position
      menuNode.position = CGPoint(x: cameraNode.position.x + sKView.scene!.size.width / 3, y: cameraNode.position.y + sKView.scene!.size.height / 3)
      musicPlayer.soundNode.position = CGPoint(x: menuNode.position.x + 50, y: menuNode.position.y)
//      menuNode.position = CGPoint(x: cameraNode.position.x + self.frame.midX / 2 + 50, y: cameraNode.position.y + self.frame.midY / 2 )
//      musicPlayer.soundNode.position = CGPoint(x: cameraNode.position.x + self.frame.midX / 2, y: cameraNode.position.y + self.frame.midY / 2)
    }
  }
  
  private func handleShowMenu() {
    handleCleanUp()
    
    let sKView = self.view?.scene?.view
    let menuScene = MenuScene(size: standardScreenSize)
    menuScene.scaleMode = .aspectFit
    sKView?.presentScene(menuScene)
  }

  private func handleWin() {
    handleShowMenu()
  }
  
  private func handleCleanUp() {
    recordingSource?.recorder.stop()
    musicPlayer.stopMusic()
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
      secondBody.categoryBitMask == 3 {
      handleWin()
    } else if firstBody.categoryBitMask == player?.player.physicsBody!.categoryBitMask &&
      secondBody.categoryBitMask == 2 {
        lastTouch = player.player.position
    }
  }
  
}

extension SKTexture {
  
  convenience init(size: CGSize, startColor: SKColor, endcolor: SKColor) {
    let context = CIContext(options: nil)
    let filter = CIFilter(name: "CILinearGradient")!
    
    filter.setDefaults()

    let startVector: CIVector = CIVector(x: size.width/2, y:0)
    let endVector: CIVector = CIVector(x: size.width/2, y:size.height)
    
    filter.setValue(startVector, forKey: "inputPoint0")
    filter.setValue(endVector, forKey: "inputPoint1")
    filter.setValue(CIColor(color: startColor), forKey: "inputColor0")
    filter.setValue(CIColor(color: endcolor), forKey: "inputColor1")
    
    let image = context.createCGImage(filter.outputImage!, from: CGRect(origin: .zero, size: size))
    
    self.init(cgImage: image!)
    
  }
}
