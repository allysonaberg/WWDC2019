import SpriteKit
import GameplayKit
import Foundation


public class CountdownTimer {
  
  let node: SKLabelNode!
  var count = 120
  var isRunning: Bool
  
  public init(_ root: SKNode) {
    self.node = SKLabelNode()
    self.node.text = "THIS IS NODE TEXT"
    self.node.zPosition = 10001
    self.node.color = UIColor.red
    self.isRunning = false
    root.addChild(node)
  }
  
  public func startTimer() {
    self.isRunning = true
    let _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
  }
  
  @objc public func updateTimer() {
    if count > 0 {
      let minutesLeft = String(count/60)
      let secondsLeft = String(count % 60)
      print("changing node text")
      self.node.text = minutesLeft + ":" + secondsLeft
      count = count - 1
    } else {
      handleTimesUp()
    }
    
  }
  
  private func handleTimesUp() {
    isRunning = false
    print("TIMES UP")
  }
  
}
