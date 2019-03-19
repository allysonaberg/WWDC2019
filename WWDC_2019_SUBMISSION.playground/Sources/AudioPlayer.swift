import SpriteKit
import AVFoundation

//TODO: convert this to a struct?
public class AudioPlayer {
  
  var music: AVAudioPlayer!
  var soundNode: SKSpriteNode!
  public var isOn: Bool!
  

  public init(_ root: SKNode) {
    setupNode(root)
    setupPlayer()
  }
  
  func setupNode(_ root: SKNode) {
    self.soundNode = SKSpriteNode(imageNamed: "speaker")
    soundNode.name = "volumeButton"
    soundNode.zPosition = 100000
    soundNode.size = CGSize(width: 80, height: 80)
    self.isOn = false
    root.addChild(soundNode)
  }
  
  func setupPlayer() {
    let url = Bundle.main.url(forResource: "song", withExtension: "mp3")
    
    do {
      guard let url = url else { return }
        music = try AVAudioPlayer(contentsOf: url)
        music.prepareToPlay()
        music.play()
      self.isOn = true
    } catch let error {
      print(error)
    }
  }
  
  
  public func handleTapped() {
    print(isOn)
    if isOn {
      music.stop()
      self.isOn = false
    } else {
      music.play()
      self.isOn = true
    }
  }
  
}
