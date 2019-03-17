//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
  private var tileMap: Map!
  
  override func didMove(to view: SKView) {
    self.tileMap = Map(self)
  }
  
    @objc static override var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
//if let scene = GameScene(fileNamed: "GameScene") {
//    // Set the scale mode to scale to fit the window
//    scene.scaleMode = .aspectFill
//
//    // Present the scene
//    sceneView.presentScene(scene)
//  print("SUCCESS")
//}

let scene1 = GameScene()
  sceneView.presentScene(scene1)
  print("SUCCESS!")


PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
