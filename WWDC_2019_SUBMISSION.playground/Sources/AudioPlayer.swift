import SpriteKit
import AVFoundation

//TODO: convert this to a struct?
public class AudioPlayer {
  
  var music: AVAudioPlayer!
  
  public init() {
    setupPlayer()
  }
  
  func setupPlayer() {
    let url = Bundle.main.url(forResource: "song", withExtension: "mp3")
    
    do {
      print(url)
      guard let url = url else { return }
        music = try AVAudioPlayer(contentsOf: url)
        music.prepareToPlay()
        music.play()
        print("PLAYYYYYY")
    } catch let error {
      print(error)
    }
  }
  
  public func playMusic() {
    if music != nil {
      music.play()
    }
  }
  
}
