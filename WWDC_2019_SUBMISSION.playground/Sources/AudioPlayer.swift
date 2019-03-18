import SpriteKit
import AVFoundation

//TODO: convert this to a struct?
public class AudioPlayer {
  
  var music: AVAudioPlayer!
  var soundNode: SKSpriteNode!
  
  public init() {
    setupNode()
    setupPlayer()
  }
  
  func setupNode() {
    self.soundNode = SKSpriteNode(imageNamed: "volume")
    soundNode.name = "volumeButton"
    soundNode.zPosition = 100000
  }
  
  func setupPlayer() {
    let url = Bundle.main.url(forResource: "song", withExtension: "mp3")
    
    do {
      guard let url = url else { return }
        music = try AVAudioPlayer(contentsOf: url)
        music.prepareToPlay()
        music.play()
    } catch let error {
      print(error)
    }
  }
  
  public func playMusic() {
    if music != nil {
      music.play()
    }
  }
  
  public func stopMusic() {
    if music != nil {
      music.stop()
    }
  }
  
}
