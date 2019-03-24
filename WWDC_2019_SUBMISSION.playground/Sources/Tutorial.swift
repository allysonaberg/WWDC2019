import SpriteKit

class Tutorial: SKNode {
  
  var text: SKLabelNode
  var continueButton: SKLabelNode
  var page: Int = 0
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
    self.text.fontColor = blackColor
    self.text.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
    
    self.continueButton = SKLabelNode(text: continueButtonText)
    self.continueButton.fontName = font
    self.continueButton.name = continueButtonName
    self.continueButton.fontColor = blackColor
    
    self.skipButton = SKLabelNode(text: skipButtonText)
    self.skipButton.fontName = font
    self.skipButton.name = skipButtonName
    self.skipButton.fontColor = blackColor
    
    self.fadeIn = SKAction.fadeIn(withDuration: 0.5)
    self.fadeOut = SKAction.fadeOut(withDuration: 0.5)
    
    self.overlay = SKSpriteNode()

    super.init()

    self.text.position = CGPoint(x: self.position.x, y: self.position.y + 100)
    self.text.run(fadeIn)
    self.continueButton.position = CGPoint(x: self.position.x, y: self.position.y - 150)
    self.skipButton.position = CGPoint(x: self.continueButton.position.x, y: self.continueButton.position.y - 100)

    self.addChild(text)
    self.addChild(continueButton)
    self.addChild(skipButton)
    
    overlay.size = standardScreenSize
    overlay.color = whiteColor
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
        if node.name == continueButtonName && page < 3 {
          nextPage()
        } else if node.name == playButtonName || node.name == skipButtonName {
          startPlaying()
        }
      }
    }
  }
  
  private func nextPage() {
    self.text.run(fadeOut, completion: {
      self.page+=1
      if (self.page == (tutorialPageText.count - 1)) {
        self.setupPlay()
      }
      if self.page < 4 {
        self.text.text = tutorialPageText[self.page]
        self.text.run(self.fadeIn)
      }
    })
  }
  
  
  private func setupPlay() {
    self.continueButton.text = playButtonText
    self.continueButton.name = playButtonName
  }
  
  private func startPlaying() {
    continueButton.removeFromParent()
    skipButton.removeFromParent()
    self.isHidden = true
    self.isUserInteractionEnabled = false
    root.hasShownTutorial = true
  }
  
  public func showWinningOverlay() {
    self.isHidden = false
    self.isUserInteractionEnabled = true
    self.text.text = winPageText
  }
  
}

