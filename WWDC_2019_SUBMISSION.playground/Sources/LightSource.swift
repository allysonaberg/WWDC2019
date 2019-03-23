import Foundation
import UIKit
import SpriteKit


public class LightSource: SKNode {
  
  public var lightSource: SKLightNode!
  
  override public init() {
    self.lightSource = SKLightNode()
    
    super.init()
    
    setupLightPresets()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLightPresets() {
    lightSource.lightColor = redColor
    lightSource.ambientColor = ambientLightColor
    lightSource.shadowColor = redColor
    lightSource.falloff = lightSourceDefaultFalloff
  }
  
}

