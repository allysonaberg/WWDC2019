import SpriteKit

//todo: fix dynamic sizing placement
public class MenuScene: SKScene {

  var titleLabel: SKLabelNode!
  var playButton: SKLabelNode!
  var character: SKSpriteNode!
  
  override public init(size: CGSize) {
    super.init(size: size)
    
    self.backgroundColor = UIColor.red
    setupTitleLabel()
    setupCharacter()
    setupPlayButton()
    setupClouds()
    setupBackground()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //setup
  private func setupTitleLabel() {
    titleLabel = SKLabelNode(text: gameTitle)
    titleLabel.fontName = font
    titleLabel.fontSize = 45
    titleLabel.fontColor = whiteColor
    titleLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 + 100)
    self.addChild(titleLabel)
  }
  
  private func setupCharacter() {
    character = SKSpriteNode(imageNamed: "S")
    character.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    character.size = CGSize(width: 40, height: 40)
    self.addChild(character)
  }
  
  private func setupPlayButton() {
    self.playButton = SKLabelNode(text: buttonTitle)
    playButton.fontColor = whiteColor
    playButton.fontName = font
    playButton.fontSize = 35
    playButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 100)
    playButton.name = playButtonName
    self.addChild(playButton)
  }
  
  func setupClouds() {
    setupCloudsNode(alpha: 1, to: 4000, duration: 650.0, xDiff: -100, yDiff: 100)
  }
  
  func setupCloudsNode(alpha: CGFloat, to: Int, duration: Double, xDiff: Int, yDiff: Int) {
    let clouds = SKSpriteNode(imageNamed: "clouds")
    clouds.alpha = alpha
    clouds.isUserInteractionEnabled = false
    clouds.position = CGPoint(x: self.size.width / 2 + CGFloat(xDiff), y: self.size.height / 2 + CGFloat(yDiff))
    self.addChild(clouds)
    
    let moveClouds = SKAction.move(to: CGPoint(x: clouds.position.x + CGFloat(to), y: clouds.position.y), duration: duration)
    clouds.run(moveClouds)
  }

  func setupBackground() {
    let texture = SKTexture(size: self.size, startColor: redColor, endcolor: gradientColorBottom)
    let gradientNode = SKSpriteNode(texture: texture)
    gradientNode.zPosition = -1
    gradientNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    gradientNode.alpha = 1
    
    self.addChild(gradientNode)
  }
  
  // Touch Handling
  public override func touchesBegan(_ touches: Set<UITouch>,
                                    with event: UIEvent?) {
    handleTouches(touches)
  }
  
  
  private func handleTouches(_ touches: Set<UITouch>) {
    guard let lastTouch = touches.first?.location(in: self) else { return }
    
    let nodes = self.nodes(at: lastTouch)
    for node in nodes {
      if node.name == playButtonName {
      startPlaying()
      }
    }
  }
  
  private func startPlaying() {
    guard let sKView = self.view?.scene?.view else { return }
    let gameScene = GameScene(size: sKView.scene!.size)
    gameScene.scaleMode = .aspectFill
    sKView.presentScene(gameScene)
  }
  
}
