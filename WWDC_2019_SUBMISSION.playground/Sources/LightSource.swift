import UIKit
import SpriteKit
import AVFoundation

public class LightSource {
  
  public init(_ parent: SKNode) {
    let lightNode = SKLightNode()
    lightNode.lightColor = UIColor.red
    lightNode.falloff = 2
  }
}
