import SpriteKit

class Tutorial: SKNode {
  
  var text: SKLabelNode
  var continueButton: SKLabelNode
  var page: Int = 0
  //todo: make play button a lazy var
  var playButton: SKLabelNode
  var skipButton: SKLabelNode
  var root: GameScene
  
  let fadeIn: SKAction!
  let fadeOut: SKAction!
  let overlay: SKSpriteNode!
  
  
  init(_ root: GameScene) {
    self.root = root
    
    self.page = 0
    
    self.text = SKLabelNode(text: tutorialPageText[page])
    self.text.fontName = font
    self.text.numberOfLines = 0
    self.text.alpha = 0
    
    self.continueButton = SKLabelNode(text: continueButtonText)
    self.continueButton.fontName = font
    self.continueButton.name = continueButtonName
    
    self.playButton = SKLabelNode(text: playButtonText)
    self.playButton.fontName = font
    self.playButton.name = playButtonName
    
    self.skipButton = SKLabelNode(text: skipButtonText)
    self.skipButton.fontName = font
    self.skipButton.name = skipButtonName
    
    self.fadeIn = SKAction.fadeIn(withDuration: 2)
    self.fadeOut = SKAction.fadeOut(withDuration: 2)
    
    self.overlay = SKSpriteNode()

    super.init()

    self.text.position = CGPoint(x: self.position.x, y: self.position.y + 100)
    self.text.run(fadeIn)
    self.continueButton.position = CGPoint(x: self.position.x, y: self.position.y - 150)
    self.skipButton.position = CGPoint(x: self.continueButton.position.x, y: self.continueButton.position.y - 100)
    self.playButton.position = self.continueButton.position
    self.playButton.isHidden = true
    self.playButton.isUserInteractionEnabled = false

    self.addChild(text)
    self.addChild(continueButton)
    self.addChild(skipButton)
    self.addChild(playButton)
    
    overlay.size = standardScreenSize
    overlay.color = blackColor
    overlay.alpha = 0.9
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
          nextPage()
        } else if node.name == playButtonName || node.name == skipButtonName {
          startPlaying()
        }
      }
    }
  }
  
  private func nextPage() {
    //TODO: unowned self
    self.text.run(fadeOut, completion: {
      self.page+=1
        self.text.text = tutorialPageText[self.page]
        self.text.run(self.fadeIn)
      if (self.page == 3) {
        self.continueButton.isHidden = true
        self.continueButton.isUserInteractionEnabled = false
        self.playButton.isHidden = false
        self.playButton.isUserInteractionEnabled = true
      }
    })
  }
  
  
  private func startPlaying() {
    self.removeFromParent()
    root.hasShownTutorial = true
  }
}

