import SpriteKit

class Tutorial: SKNode {
  
  var text: SKLabelNode
  var continueButton: SKLabelNode
  var root: GameScene
  
  let continueButtonName = "continue"
  
  //todo: do I need to add text and continueButton as children?
  init(_ root: GameScene, size: CGSize) {
    self.root = root
    
    self.text = SKLabelNode(text: "this is tutorial text")
    self.text.color = redColor
    
    self.continueButton = SKLabelNode(text: "CONTINUE")
    self.continueButton.color = redColor
    self.continueButton.name = continueButtonName
    
    super.init()

    self.addChild(text)
    

    self.addChild(continueButton)
    
    
    let overlay = SKSpriteNode()
    overlay.size = size
    overlay.color = UIColor.blue
    overlay.alpha = 0.4
    self.addChild(overlay)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func handleInteraction(_ touches: Set<UITouch>) {
    let location = touches.first?.location(in: self)
    if location != nil {
      let nodes = self.nodes(at: location!)
      
      for node in nodes
      {
        if node.name == continueButtonName {
          startPlaying()
        }
      }
    }
  }
  
  private func startPlaying() {
    print("STARTING")
    root.hasShownTutorial = true
    self.removeFromParent()
  }
}

