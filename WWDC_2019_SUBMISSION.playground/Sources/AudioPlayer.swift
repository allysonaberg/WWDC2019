import SpriteKit
import AVFoundation

public class AudioPlayer: SKNode {
  
  // Variables
  var music: AVAudioPlayer!
  
  // Initialization
  override public init() {
    self.music = AVAudioPlayer()
    
    super.init()
    
    setupPlayer()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // Public
  public func stopMusic() {
    music.stop()
  }
  
  public func startMusic() {
    music.play()
  }
  
  
  // Private
  private func setupPlayer() {
    let url = Bundle.main.url(forResource: tempDirectoryName, withExtension: "mp3")
    do {
      guard let url = url else { return }
      music = try AVAudioPlayer(contentsOf: url)
      music.prepareToPlay()
    } catch let error {
      print(error)
    }
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
