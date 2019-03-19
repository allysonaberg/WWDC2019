import SpriteKit

public class MenuScene: SKScene {

  let gameTitle: String = "In The Dark"
  
  lazy var titleLabel: SKLabelNode = {
    let label = SKLabelNode(text: gameTitle)
    label.fontSize = 40
    label.fontColor = blackColor
    //todo: fix dynamic sizing placement
    label.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    label.zPosition = 100000
    return label
  }()
  
  lazy var playButton: SKLabelNode = {
    let button = SKLabelNode(text: "PLAY")
    button.fontColor = redColor
    button.fontSize = 30
    //todo: fix dynamic sizing placement
    button.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 100)
    button.zPosition = 100000
    button.name = "playButton"
    return button
  }()
  
  override public init(size: CGSize) {
  
    super.init(size: size)
    
    self.backgroundColor = whiteColor
    self.addChild(titleLabel)
    self.addChild(playButton)
  }
  

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Touch Handling
  public override func touchesBegan(_ touches: Set<UITouch>,
                                    with event: UIEvent?) {
    handleTouches(touches)
  }
  

  public func startPlaying() {
    let sKView = self.view?.scene?.view
    let gameScene = GameScene(size: CGSize(width: 1200, height: 800))
    gameScene.scaleMode = .aspectFill
    sKView?.presentScene(gameScene)
  }
  
  
  private func handleTouches(_ touches: Set<UITouch>) {
    guard let lastTouch = touches.first?.location(in: self) else { return }
    
    let nodes = self.nodes(at: lastTouch)
    for node in nodes where node.name == "playButton" {
      startPlaying()
    }
  }
  
}
