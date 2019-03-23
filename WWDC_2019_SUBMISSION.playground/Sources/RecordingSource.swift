import UIKit
import SpriteKit
import AVFoundation

public class RecordingSource {
  var recordingSession: AVAudioSession!
  let temporaryDirectoryToKeepRecords = FileManager.default.temporaryDirectory
  var fileNum = 1
  var player: AVAudioPlayer!
  var recorder: AVAudioRecorder!
  
  public init() {
    self.recordingSession = AVAudioSession.sharedInstance()
  }
  
  public func recordButtonTapped() {
    if recorder == nil {
      fileNum += 1
      
      let recordFileName = temporaryDirectoryToKeepRecords.appendingPathComponent("record\(fileNum).m4a")
      
      let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 44100, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
      
      do {
        try recordingSession.setCategory(.playAndRecord, mode: .default)
        try recordingSession.setActive(true, options: [])
        recorder = try AVAudioRecorder(url: recordFileName, settings: settings)
        recorder.isMeteringEnabled = true
        recorder.record()
      } catch {
        print(error)
      }
    }
  }
  
  public func stopButtonTapped() {
    if recorder != nil {
      recorder.stop()
      recorder = nil
    }
  }
}
