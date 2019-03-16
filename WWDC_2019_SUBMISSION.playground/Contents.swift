//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Instance Variables
    public var player: Player!
    public var playingMap: Map!
    var lastTouch: CGPoint? = nil
    
    
    override func didMove(to view: SKView) {
        playingMap = Map(self)
//        player = Player(self, map: playingMap)
    }
    
    // MARK: - Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        handleTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        handleTouches(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        lastTouch = player.player.position
        
    }
    
    //handle touches should be a delegate method so that player AND button can implement it
    fileprivate func handleTouches(_ touches: Set<UITouch>) {
        lastTouch = touches.first?.location(in: self)
    }
    
    override func didSimulatePhysics() {
        if player != nil {
//            player.updatePlayer(position: lastTouch)
        }
    }
}

let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
if let scene = GameScene(fileNamed: "GameScene") {
    scene.scaleMode = .aspectFill
    sceneView.presentScene(scene)
    print("presented scene")
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

