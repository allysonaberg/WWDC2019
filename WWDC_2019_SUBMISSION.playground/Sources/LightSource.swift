import Foundation
import UIKit
import SpriteKit


public class LightSource {
  
  public var lightSource: SKLightNode!
  
  public init() {
    self.lightSource = SKLightNode()
    lightSource.lightColor = UIColor.white
    lightSource.ambientColor = redColor
    lightSource.shadowColor = redColor
    lightSource.falloff = 2
  }
}

