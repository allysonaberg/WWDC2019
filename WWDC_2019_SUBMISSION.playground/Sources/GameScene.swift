import SpriteKit
import GameplayKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
  
  // Variables
  public var hasShownTutorial: Bool = false
  var didWin: Bool = false
  var cloudsShown: Bool = false
  
  var player: Player!
  var playingMap: Map!
  var cameraNode: SKCameraNode!
  var recordingSource: RecordingSource!
  var musicPlayer: AudioPlayer!
  var lightSource: LightSource!
  var gradientNode: SKSpriteNode!
  var lastTouch: CGPoint? = nil
  var tutorial: Tutorial!

  
  // Initialization
  override public init(size: CGSize) {

    super.init(size: size)
    
    playingMap = Map(self)
    player = Player(self, map: playingMap)
    self.addChild(player)

    tutorial = Tutorial(self)
    tutorial.zPosition = self.playingMap.offsetWide
    
    setupAudio()
    lightSource = LightSource()
    cameraNode = SKCameraNode()
    recordingSource = RecordingSource()
    setupGradientBackground()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    //deinit not consistently called, but when it is, cleanup
    handleCleanUp()
  }
  
  
  public override func didSimulatePhysics() {
    if (!cloudsShown && hasShownTutorial) {
      player.player.removeAllActions()
      setupClouds()
      cloudsShown = true
    }
    
    if recordingSource?.recorder != nil && !didWin  {
      recordingSource.recorder.updateMeters()
      //generally, the numbers hover around -20->-40 db, this is just a random equation that makes it sensitive
      //1.075 just looks good...
      lightSource.lightSource.falloff = pow(1.075, CGFloat(abs(recordingSource.recorder.averagePower(forChannel: 0))))
    }
    
    if player != nil {
      player.updatePlayer(position: lastTouch)
      cameraNode.position.x += (player.player.position.x - cameraNode.position.x) / 8
      cameraNode.position.y += (player.player.position.y - cameraNode.position.y) / 8
      tutorial.position = cameraNode.position
    }
  }
  
  
  
  // Setup
  private func setupAudio() {
    self.musicPlayer = AudioPlayer()
    musicPlayer.startMusic()
    musicPlayer.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 150)
  }
  
  private func setupGradientBackground() {
    let texture = SKTexture(size: CGSize(width: CGFloat(standardScreenSize.width*5), height: CGFloat(standardScreenSize.height*5)), startColor: redColor, endcolor: gradientColorBottom)
    self.gradientNode = SKSpriteNode(texture: texture)
    gradientNode.zPosition = -1
    gradientNode.alpha = 1
    
    self.addChild(gradientNode)
  }
  
  public override func didMove(to view: SKView) {
    self.physicsWorld.contactDelegate = self
    self.camera = cameraNode
    self.player.player.addChild(lightSource.lightSource)
    self.addChild(cameraNode)
    self.recordingSource.recordButtonTapped()
    self.addChild(tutorial)
  }
  
  
  func setupClouds() {
    setupCloudsNode(alpha: 1, to: 4000, duration: 650.0, xDiff: -1200, yDiff: 1200)
    setupCloudsNode(alpha: 1, to: 1200, duration: 750.0, xDiff: -1020, yDiff: 1000)
    setupCloudsNode(alpha: 1, to: 4000, duration: 650.0, xDiff: 10, yDiff: 1000)
    setupCloudsNode(alpha: 0.9, to: 1000, duration: 350.0, xDiff: -500, yDiff: 800)
    setupCloudsNode(alpha: 0.9, to: 1000, duration: 350.0, xDiff: -100, yDiff: 200)
    setupCloudsNode(alpha: 1, to: 1200, duration: 600.0, xDiff: -900, yDiff: 2000)
    setupCloudsNode(alpha: 0.9, to: 1000, duration: 350.0, xDiff: 1000, yDiff: 800)
    setupCloudsNode(alpha: 0.8, to: 1200, duration: 450.0, xDiff: 200, yDiff: 400)
    setupCloudsNode(alpha: 0.9, to: 1000, duration: 350.0, xDiff: 600, yDiff: -300)
    setupCloudsNode(alpha: 0.9, to: 1000, duration: 350.0, xDiff: 1200, yDiff: -300)
    setupCloudsNode(alpha: 1, to: 2000, duration: 650.0, xDiff: -800, yDiff: -1000)
    setupCloudsNode(alpha: 0.9, to: 1000, duration: 400.0, xDiff: 1000, yDiff: -2000)
    setupCloudsNode(alpha: 0.9, to: 1000, duration: 400.0, xDiff: 100, yDiff: -2200)
    setupCloudsNode(alpha: 1, to: 4000, duration: 650.0, xDiff: -900, yDiff: -4000)
    setupCloudsNode(alpha: 1, to: 4000, duration: 650.0, xDiff: -1024, yDiff: -4400)
  }
  
  func setupCloudsNode(alpha: CGFloat, to: Int, duration: Double, xDiff: Int, yDiff: Int) {
    let clouds = SKSpriteNode(imageNamed: cloudsImage)
    clouds.alpha = alpha
    clouds.isUserInteractionEnabled = false
    clouds.position = CGPoint(x: self.player.position.x + CGFloat(xDiff), y: self.player.position.y + CGFloat(yDiff))
    clouds.zPosition = playingMap.offsetWide
    self.addChild(clouds)
    
    let moveClouds = SKAction.move(to: CGPoint(x: clouds.position.x + CGFloat(to), y: clouds.position.y), duration: duration)
    clouds.run(moveClouds)
  }
  
  
  
  // Touch Handling
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
        for node in nodes where node.name != "player" { lastTouch = touches.first?.location(in: self) }
      }
    } else {
      tutorial.handleInteraction(touches)
    }
  }

  
  public func handleShowMenu() {
    handleCleanUp()
    
    let sKView = self.view?.scene?.view
    let menuScene = MenuScene(size: standardScreenSize)
    menuScene.scaleMode = .aspectFill
    sKView?.presentScene(menuScene)
  }

  private func handleWin() {
    self.tutorial.showWinningOverlay()
   
    DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
      self.handleShowMenu()
    })
    
  }
  
  private func handleCleanUp() {
    recordingSource?.recorder.stop()
    musicPlayer.stopMusic()
  }
  

  
  
  // SKPhysicsContactDelegateMethods
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
      secondBody.categoryBitMask == winningTileBitMask {
      handleWin()
    } else if firstBody.categoryBitMask == player?.player.physicsBody!.categoryBitMask &&
      secondBody.categoryBitMask == edgeTileBitMask {
      //stop the player
        lastTouch = player.player.position
    }
  }
  
}

extension SKTexture {
  
  convenience init(size: CGSize, startColor: SKColor, endcolor: SKColor) {
    let context = CIContext(options: nil)
    let filter = CIFilter(name: filterGradient)!
    
    filter.setDefaults()
    
    let startVector: CIVector = CIVector(x: size.width/2, y:0)
    let endVector: CIVector = CIVector(x: size.width/2, y:size.height)
    
    filter.setValue(startVector, forKey: input0)
    filter.setValue(endVector, forKey: input1)
    filter.setValue(CIColor(color: startColor), forKey: inputColor0)
    filter.setValue(CIColor(color: endcolor), forKey: inputColor1)
    
    let image = context.createCGImage(filter.outputImage!, from: CGRect(origin: .zero, size: size))
    self.init(cgImage: image!)
  }
}



