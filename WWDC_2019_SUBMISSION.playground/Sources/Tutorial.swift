import SpriteKit

class Tutorial: SKNode {
  
  var text: SKLabelNode
  var continueButton: SKLabelNode
  var page: Int = 0
  //todo: make play button a lazy var
  var playButton: SKLabelNode
  var skipButton: SKLabelNode
  var root: GameScene
  
  //todo: wrap this in a block
  let fadeIn: SKAction!
  let fadeOut: SKAction!
  
  let continueButtonName = "continue"
  let playButtonName = "play"
  let skipButtonName = "skip"
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
    self.text.alpha = 0
    
    self.continueButton = SKLabelNode(text: "CONTINUE")
    self.continueButton.color = redColor
    self.continueButton.name = continueButtonName
    
    self.playButton = SKLabelNode(text: "PLAY")
    self.playButton.color = redColor
    self.playButton.name = playButtonName
    
    self.skipButton = SKLabelNode(text: "SKIP")
    self.skipButton.color = redColor
    self.skipButton.name = skipButtonName
    
    self.fadeIn = SKAction.fadeIn(withDuration: 2)
    self.fadeOut = SKAction.fadeOut(withDuration: 2)

    super.init()

    self.text.position = CGPoint(x: self.position.x, y: self.position.y)
    self.text.run(fadeIn)
    self.continueButton.position = CGPoint(x: self.position.x, y: self.position.y - 200)
    self.skipButton.position = CGPoint(x: self.continueButton.position.x - 100, y: self.continueButton.position.y)
    self.playButton.position = self.continueButton.position
    self.playButton.isHidden = true
    self.playButton.isUserInteractionEnabled = false

    self.addChild(text)
    self.addChild(continueButton)
    self.addChild(skipButton)
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
        print("TOUCH INTERACTION")
        print(node.name)
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
        self.text.text = self.pageText[self.page]
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
    print("STARTING")
    self.removeFromParent()
    root.hasShownTutorial = true
  }
}

