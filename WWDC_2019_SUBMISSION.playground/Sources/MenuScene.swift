import SpriteKit

//todo: fix dynamic sizing placement
public class MenuScene: SKScene {

  var titleLabel: SKLabelNode!
  var playButton: SKLabelNode!
  
  override public init(size: CGSize) {
    super.init(size: size)
    
    self.backgroundColor = whiteColor
    setupTitleLabel()
    setupPlayButton()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //setup
  private func setupTitleLabel() {
    titleLabel = SKLabelNode(text: gameTitle)
    titleLabel.fontSize = 50
    titleLabel.fontColor = blackColor
    titleLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    self.addChild(titleLabel)
  }
  
  private func setupPlayButton() {
    self.playButton = SKLabelNode(text: buttonTitle)
    playButton.fontColor = redColor
    playButton.fontSize = 40
    playButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 100)
    playButton.name = playButtonName
    self.addChild(playButton)
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
