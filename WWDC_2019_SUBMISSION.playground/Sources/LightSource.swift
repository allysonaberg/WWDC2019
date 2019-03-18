import Foundation
import UIKit
import SpriteKit


public class LightSource {
  
  public var lightSource: SKLightNode!
  
  public init() {
    self.lightSource = SKLightNode()
    lightSource.lightColor = UIColor.red
    lightSource.falloff = 2
  }
}

