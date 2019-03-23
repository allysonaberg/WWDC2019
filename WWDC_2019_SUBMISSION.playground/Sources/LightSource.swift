import Foundation
import UIKit
import SpriteKit


public class LightSource {
  
  public var lightSource: SKLightNode!
  
  public init() {
    self.lightSource = SKLightNode()
    lightSource.lightColor = UIColor.red
    lightSource.ambientColor = UIColor(red: 211/255, green: 245/255, blue: 254/255, alpha: 1.0) /* #d3f5fe */
    lightSource.shadowColor = UIColor.red
    lightSource.falloff = 200
  }
}

