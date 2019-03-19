import SpriteKit
import GameplayKit

public class MenuScene: SKScene {

  public var titleLabel: SKLabelNode!
  public var playButton: SKLabelNode!
  
  override public init(size: CGSize) {
  
    super.init(size: size)
    self.backgroundColor = UIColor.white
    
    titleLabel = SKLabelNode(text: "In The Dark")
    titleLabel.fontSize = 40
    titleLabel.fontColor = UIColor.black
    titleLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)

    titleLabel.zPosition = 100000
    self.addChild(titleLabel)
    
    playButton = SKLabelNode(text: "PLAY")
    playButton.fontColor = UIColor.red
    playButton.fontSize = 30
    playButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
    playButton.position.y = titleLabel.position.y - 100
    playButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 100)
    playButton.zPosition = 100000
    playButton.name = "playButton"
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
  

  fileprivate func handleTouches(_ touches: Set<UITouch>) {
    let lastTouch = touches.first?.location(in: self)
    if lastTouch != nil {
      let nodes = self.nodes(at: lastTouch!)
      
      for node in nodes
      {
        if node.name == "playButton" {
          startPlaying()
        }
      }
    }
  }
  
  public func startPlaying() {
    let sKView = self.view?.scene?.view
    let gameScene = GameScene(size: CGSize(width: 1200, height: 800))
    
    sKView?.presentScene(gameScene)
  }
}
