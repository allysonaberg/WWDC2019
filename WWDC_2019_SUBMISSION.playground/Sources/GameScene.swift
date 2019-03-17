import SpriteKit
import GameplayKit

public class GameScene: SKScene {
  
  // MARK: - Instance Variables
  public var player: Player!
  public var playingMap: Map!
  var lastTouch: CGPoint? = nil
  
  
  override public init(size: CGSize) {
    
    super.init(size: size)
    player = Player(self)
    playingMap = Map(self)
    playingMap.container.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    
    
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func sceneDidLoad() {
    print("scene did load")
  }
  public override func didMove(to view: SKView) {
    
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
