import UIKit
import SpriteKit
import AVFoundation

public class RecordingSource {
  var recordingSession: AVAudioSession!
  let temporaryDirectoryToKeepRecords = FileManager.default.temporaryDirectory
  var recordNumber = 1
  var player: AVAudioPlayer!
  var recorder: AVAudioRecorder!
  
  public init() {
    self.recordingSession = AVAudioSession.sharedInstance()
  }
  
  public func recordButtonTapped() {
    if recorder == nil {
      recordNumber += 1
      
      let recordFileName = temporaryDirectoryToKeepRecords.appendingPathComponent("record\(recordNumber).m4a")
      
      let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 44100, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
      recordingSession = AVAudioSession.sharedInstance()
      do {
        try recordingSession.setCategory(.playAndRecord, mode: .default)
        try recordingSession.setActive(true, options: [])
        recorder = try AVAudioRecorder(url: recordFileName, settings: settings)
        print(recorder.averagePower(forChannel: 0))
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
