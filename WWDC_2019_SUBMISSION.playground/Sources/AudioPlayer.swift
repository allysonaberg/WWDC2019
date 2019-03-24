import SpriteKit
import AVFoundation

public class AudioPlayer: SKNode {
  
  var music: AVAudioPlayer!
  var isOn: Bool! = false
  
  override public init() {
    self.music = AVAudioPlayer()
    
    super.init()
    
    setupPlayer()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
      stopMusic()
      isOn = false
    } else {
      startMusic()
      isOn = true
    }
  }
  
  public func stopMusic() {
    music.stop()
  }
  
  public func startMusic() {
    music.play()
  }
  
  private func clearTempDirectory() {
    do {
      let savedFiles = try FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory())
      for file in savedFiles {
        guard let fileURL = URL(string: file) else { continue }
        try FileManager.default.removeItem(at: fileURL)
      }
      print("temp file removal successful")
    } catch {
      print(error)
    }
  }
  
}
