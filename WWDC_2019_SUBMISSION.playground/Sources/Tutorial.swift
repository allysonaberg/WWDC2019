import SpriteKit

class Tutorial: SKNode {
  
  var text: SKLabelNode
  var continueButton: SKLabelNode
  var page: Int = 0
  //todo: make play button a lazy var
  var playButton: SKLabelNode
  var root: GameScene
  
  let continueButtonName = "continue"
  let playButtonName = "play"
  
  //todo: build out pages as separate classes... also put the text in a dic
  let pageText = [
  "This is a game about BLEH",
  "bla bla bloo",
  "haha haha haha",
  "AHHHHHHHHHHH",
  ]
  
  //todo: do I need to add text and continueButton as children?
  init(_ root: GameScene) {
    print("setting up tutorial")
    self.root = root
    
    self.page = 0

    self.text = SKLabelNode(text: pageText[page])
    self.text.color = redColor
    
    self.continueButton = SKLabelNode(text: "CONTINUE")
    self.continueButton.color = redColor
    self.continueButton.name = continueButtonName
    
    self.playButton = SKLabelNode(text: "PLAY")
    self.playButton.color = redColor
    self.playButton.name = playButtonName
    
    super.init()

    self.text.position = CGPoint(x: self.position.x, y: self.position.y)
    self.continueButton.position = CGPoint(x: self.position.x, y: self.position.y - 200)
    self.playButton.position = self.continueButton.position
    self.playButton.isHidden = true
    self.playButton.isUserInteractionEnabled = false

    self.addChild(text)
    self.addChild(continueButton)
    self.addChild(playButton)
    
    let overlay = SKSpriteNode()
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
        } else if node.name == playButtonName {
          startPlaying()
        }
      }
    }
  }
  
  private func nextPage() {
    page+=1
    if (page < 3) {
      self.text.text = pageText[page]
    } else {
      self.continueButton.isHidden = true
      self.continueButton.isUserInteractionEnabled = false
      self.playButton.isHidden = false
      self.playButton.isUserInteractionEnabled = true
    }
  }
  
  
  private func startPlaying() {
    print("STARTING")
    self.removeFromParent()
    root.hasShownTutorial = true
  }
}

