import SpriteKit

//todo: fix dynamic sizing placement
//todo: fix zPosition
public class MenuScene: SKScene {

  var titleLabel: SKLabelNode!
  var playButton: SKLabelNode!
  var music: AudioPlayer!
  
  override public init(size: CGSize) {
    super.init(size: size)
    
    self.music = AudioPlayer(self)
    self.backgroundColor = whiteColor
    setupTitleLabel()
    setupPlayButton()
    setupAudio()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    //deinit not consistently called, but when it is, cleanup
    handleCleanUp()
  }
  
  //setup
  private func setupTitleLabel() {
    titleLabel = SKLabelNode(text: gameTitle)
    titleLabel.fontSize = 50
    titleLabel.fontColor = blackColor
    titleLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    titleLabel.zPosition = 100000
    self.addChild(titleLabel)
  }
  
  private func setupPlayButton() {
    self.playButton = SKLabelNode(text: buttonTitle)
    playButton.fontColor = redColor
    playButton.fontSize = 40
    playButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 100)
    playButton.zPosition = 100000
    playButton.name = playButtonName
    self.addChild(playButton)
  }
  
  private func setupAudio() {
    music.startMusic()
    music.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 150)
    music.soundNode.name = volumeButtonName
  }
  
  private func handleCleanUp() {
    music.stopMusic()
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
      } else if node.name == volumeButtonName {
        music.handleTapped()
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
