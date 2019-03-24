import UIKit
import SpriteKit


public class LightSource: SKNode {
  
  // Variables
  public var lightSource: SKLightNode!
  
  
  // Initialization
  override public init() {
    self.lightSource = SKLightNode()
    
    super.init()
    
    setupLightPresets()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // Setup
  private func setupLightPresets() {
    lightSource.lightColor = whiteColor
    lightSource.ambientColor = ambientLightColor
    lightSource.shadowColor = whiteColor
    lightSource.falloff = lightSourceDefaultFalloff
  }
  
}

