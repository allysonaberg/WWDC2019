import SpriteKit
import AVFoundation

public class AudioPlayer {
  
  var music: AVAudioPlayer!
  var soundNode: SKSpriteNode!
  var isOn: Bool! = false
  
  public init(_ root: SKNode) {
    setupNode(root)
    setupPlayer()
  }
  
  func setupNode(_ root: SKNode) {
    self.soundNode = SKSpriteNode(imageNamed: "speaker")
    soundNode.name = volumeButtonName
    soundNode.zPosition = 100000
    soundNode.size = CGSize(width: 80, height: 80)
    root.addChild(soundNode)
  }
  
  func setupPlayer() {
    let url = Bundle.main.url(forResource: "song", withExtension: "mp3")
    do {
      guard let url = url else { return }
        music = try AVAudioPlayer(contentsOf: url)
        music.prepareToPlay()
    } catch let error {
      print(error)
    }
  }
  
  public func handleTapped() {
    if isOn {
      music.stop()
      isOn = false
    } else {
      music.play()
      isOn = true
    }
  }
  
}
