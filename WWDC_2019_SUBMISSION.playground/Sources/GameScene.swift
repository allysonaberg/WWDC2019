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
    
    playingMap = Map(self)
    playingMap.container.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    player = Player(self, map: playingMap)
    player.player.position = CGPoint(x: self.size.width / 2 - 500 , y: self.size.height / 2 - 150 )


    lightSource = LightSource()
    
    cameraNode = SKCameraNode()
    
    recordingSource = RecordingSource()
    
    musicPlayer = AudioPlayer()
  
    setupMenuNode()
    
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
    menuNode = SKLabelNode(text: menuButtonText)
    menuNode.fontSize = 25
    menuNode.fontColor = whiteColor
    menuNode.name = menuButtonName
    menuNode.zPosition = 100000
  }
  
  private func setupGradientBackground() {
    let topColor = gradientColorTop
    let bottomColor = gradientColorBottom
    
    let texture = SKTexture(size: self.playingMap.ground!.mapSize, startColor: topColor, endcolor: bottomColor)
    self.gradientNode = SKSpriteNode(texture: texture)
    gradientNode.zPosition = -1
    gradientNode.alpha = 1
    
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
    self.physicsWorld.contactDelegate = self
    self.camera = cameraNode
    self.addChild(menuNode)
    self.addChild(musicPlayer.soundNode)
    self.player.player.addChild(lightSource.lightSource)
    self.addChild(cameraNode)
    self.recordingSource.recordButtonTapped()
    self.musicPlayer.startMusic()
    self.addChild(tutorial)
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
