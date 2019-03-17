import UIKit
import SpriteKit
import AVFoundation

public class LightSource {
  
  var recorder: AVAudioRecorder!
  var levelTimer = Timer()
  
  let LEVEL_THRESHOLD: Float = -10.0

  
  public init() {
//    AVAudioSession.sharedInstance().requestRecordPermission () { allowed in
//      if allowed {
//        // Set up the audio session.
//        print("YAAAS")
//        let sessionInstance = AVAudioSession.sharedInstance()
//      }
//    }
  }
  
  func setupRecorder() {
    
    let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
    let url = documents.appendingPathComponent("record.caf")
    
    let recordSettings: [String: Any] = [
      AVFormatIDKey:              kAudioFormatAppleIMA4,
      AVSampleRateKey:            44100.0,
      AVNumberOfChannelsKey:      2,
      AVEncoderBitRateKey:        12800,
      AVLinearPCMBitDepthKey:     16,
      AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
    ]
    
    do {
      try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)
      try self.recorder = AVAudioRecorder(url:url, settings: recordSettings)
      
    } catch {
      return
    }
    
    recorder.prepareToRecord()
    recorder.isMeteringEnabled = true
    
    self.levelTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(levelTimerCallback), userInfo: nil, repeats: true)
    
  }
  
  @objc func levelTimerCallback() {
    recorder.updateMeters()
    
    let level = recorder.averagePower(forChannel: 0)
    print(level)
    let isLoud = level > LEVEL_THRESHOLD
    if isLoud {
      print("LOUD")
    }
    
    // do whatever you want with isLoud
  }
  
  public func startRecording() {
    recorder.record()
  }
  

}
