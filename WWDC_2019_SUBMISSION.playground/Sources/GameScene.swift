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
  lazy var startingPosition: CGPoint = {
    guard let startingPosition = self.playingMap.startingPosition else { return CGPoint(x: self.size.width / 2 - 500 , y: self.size.height / 2 - 150 )
}
    return startingPosition
  }()
  
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
    playingMap.container.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    player = Player(self, map: playingMap)
    player.player.position = CGPoint(x: self.size.width / 2 - 500 , y: self.size.height / 2 - 150 )

    lightSource = LightSource()
    
    cameraNode = SKCameraNode()
    
    recordingSource = RecordingSource()
    
    musicPlayer = AudioPlayer()
  
    setupMenuNode()
    setupGradientBackground()
    gradientNode.size = CGSize(width: CGFloat(standardScreenSize.width*5), height: CGFloat(standardScreenSize.height*5))

    NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { (notification) in
      
    }
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
  
  func setupClouds() {
    let clouds1 = SKSpriteNode(imageNamed: "clouds")
    clouds1.alpha = 0.9
    clouds1.isUserInteractionEnabled = false
    let moveClouds = SKAction.moveTo(x: 1000, duration: 350)
    clouds1.zPosition = 100000000000000000
    self.addChild(clouds1)
    clouds1.isUserInteractionEnabled = false
    clouds1.run(moveClouds)
    
    
    let clouds2 = SKSpriteNode(imageNamed: "clouds")
    clouds2.position = CGPoint(x: self.player.position.x - 900, y: self.player.position.y + 900)
    clouds2.alpha = 1
    clouds2.isUserInteractionEnabled = false
    let moveClouds2 = SKAction.moveTo(x: 1200, duration: 600)
    clouds2.zPosition = 100000000000000000
    self.addChild(clouds2)
    clouds2.isUserInteractionEnabled = false
    clouds2.run(moveClouds2)
    
    let clouds3 = SKSpriteNode(imageNamed: "clouds")
    clouds3.position = CGPoint(x: self.player.position.x + 200, y: self.player.position.y + 400)
    clouds3.alpha = 0.8
    clouds3.isUserInteractionEnabled = false
    let moveClouds3 = SKAction.moveTo(x: 1200, duration: 450)
    clouds3.zPosition = 100000000000000000
    self.addChild(clouds3)
    clouds3.isUserInteractionEnabled = false
    clouds3.run(moveClouds3)
    
    let clouds4 = SKSpriteNode(imageNamed: "clouds")
    clouds4.position = CGPoint(x: self.player.position.x + 600, y: self.player.position.y)
    clouds4.alpha = 0.8
    clouds4.isUserInteractionEnabled = false
    let moveClouds4 = SKAction.moveTo(x: 2200, duration: 450)
    clouds4.zPosition = 100000000000000000
    self.addChild(clouds4)
    clouds4.isUserInteractionEnabled = false
    clouds4.run(moveClouds4)
    
    let clouds5 = SKSpriteNode(imageNamed: "clouds")
    clouds5.position = CGPoint(x: self.player.position.x + 1200, y: self.player.position.y - 2000)
    clouds5.alpha = 1
    clouds5.isUserInteractionEnabled = false
    let moveClouds5 = SKAction.moveTo(x: 2200, duration: 350)
    clouds5.zPosition = 100000000000000000
    self.addChild(clouds5)
    clouds5.isUserInteractionEnabled = false
    clouds5.run(moveClouds5)
    
    let clouds6 = SKSpriteNode(imageNamed: "clouds")
    clouds6.position = CGPoint(x: self.player.position.x + 500, y: self.player.position.y - 3500)
    clouds6.alpha = 0.8
    clouds6.isUserInteractionEnabled = false
    let moveClouds6 = SKAction.moveTo(x: 2200, duration: 450)
    clouds6.zPosition = 100000000000000000
    self.addChild(clouds6)
    clouds6.isUserInteractionEnabled = false
    clouds6.run(moveClouds6)
    
    let clouds7 = SKSpriteNode(imageNamed: "clouds")
    clouds7.position = CGPoint(x: self.player.position.x + 100, y: self.player.position.y - 5500)
    clouds7.alpha = 1
    clouds7.isUserInteractionEnabled = false
    let moveClouds7 = SKAction.moveTo(x: 3200, duration: 550)
    clouds7.zPosition = 100000000000000000
    self.addChild(clouds7)
    clouds7.isUserInteractionEnabled = false
    clouds7.run(moveClouds7)
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
      //if CGFloat(abs(recordingSource.recorder.averagePower(forChannel: 0))) < 30.0 {
      //LOWER = more light
      //1.075 just looks good...
      lightSource.lightSource.falloff = pow(1.075, CGFloat(abs(recordingSource.recorder.averagePower(forChannel: 0))))
    }
    
    if player != nil {
      player.updatePlayer(position: lastTouch)
      cameraNode.position.x += (player.player.position.x - cameraNode.position.x) / 8
      cameraNode.position.y += (player.player.position.y - cameraNode.position.y) / 8
      tutorial.position = cameraNode.position
      menuNode.position = CGPoint(x: cameraNode.position.x + self.frame.midX / 1.5 + 100, y: cameraNode.position.y + self.frame.midY / 1.5 )
      musicPlayer.soundNode.position = CGPoint(x: cameraNode.position.x + self.frame.midX / 1.5, y: cameraNode.position.y + self.frame.midY / 1.5)
    }
  }
  
  private func handleShowMenu() {
    handleCleanUp()
    
    let sKView = self.view?.scene?.view
    let menuScene = MenuScene(size: standardScreenSize)
    menuScene.scaleMode = .aspectFill
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
        print("contact")
        lastTouch = player.player.position
      
    }
    
  }
  
  public func didEnd(_ contact: SKPhysicsContact) {
//    self.backgroundColor = whiteColor
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
