import SpriteKit
import GameplayKit

public class GameScene: SKScene {
  
  // MARK: - Instance Variables
  public var player1: Player1!
  public var playingMap: Map!
  public var cameraNode: SKCameraNode!
  var lastTouch: CGPoint? = nil
  
  
  
  override public init(size: CGSize) {
    
    super.init(size: size)
    playingMap = Map(self)
    playingMap.container.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    player1 = Player1(self, map: playingMap)
    
//    let lightSource = LightSource()
    cameraNode = SKCameraNode()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func sceneDidLoad() {
    print("scene did load")
  }
  public override func didMove(to view: SKView) {
    self.camera = cameraNode
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
    lastTouch = player1.player1.position
    
  }
  
  //handle touches should be a delegate method so that player AND button can implement it
  fileprivate func handleTouches(_ touches: Set<UITouch>) {
    lastTouch = touches.first?.location(in: self)
  }
  
  public override func didSimulatePhysics() {
    if player1 != nil {
      player1.updatePlayer(position: lastTouch)
      cameraNode.position = player1.player1.position
    }
  }
}
