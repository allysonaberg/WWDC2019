import SpriteKit
import GameplayKit
import PlaygroundSupport

public class GameScene: SKScene {
    
     //MARK: - Instance Variables
    var player: Player!
    var playingMap: Map!
    var lastTouch: CGPoint? = nil
    
    
    public override func didMove(to view: SKView) {
//        playingMap = Map(self)
//        player = Player(self, map: playingMap)
    }

    // MARK: - Touch Handling

    public override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        handleTouches(touches)
    }

    public override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        handleTouches(touches)
    }

    public override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        lastTouch = player.player.position

    }

    //handle touches should be a delegate method so that player AND button can implement it
    fileprivate func handleTouches(_ touches: Set<UITouch>) {
        lastTouch = touches.first?.location(in: self)
    }

    public override func didSimulatePhysics() {
        if player != nil {
            player.updatePlayer(position: lastTouch)
        }
    }
}

