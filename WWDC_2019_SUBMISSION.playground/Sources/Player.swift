import UIKit
import SpriteKit
import AVFoundation

enum Direction : String {
  case West = "W"
  case East = "E"
  case North = "N"
  case South = "S"
  case NorthWest = "NW"
  case NorthEast = "NE"
  case SouthWest = "SW"
  case SouthEast = "SE"
}

public class Player: SKNode {

  public var player: SKSpriteNode!
  let map: Map!

  init(_ root: SKNode, map: Map) {
    self.map = map
    
    super.init()
    
    setupPlayer(root)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupPlayer(_ root: SKNode) {
    player = SKSpriteNode(imageNamed: "S")
    player.size = CGSize(width: 50, height: 50)
    player.physicsBody = SKPhysicsBody(circleOfRadius: 20.0, center: CGPoint(x: 0.0, y: 0.0))
    player.physicsBody?.allowsRotation = false
    player.physicsBody?.affectedByGravity = false
    player.physicsBody?.isDynamic = true
    player.physicsBody?.categoryBitMask = 1
    player.physicsBody?.contactTestBitMask = 2
    
    player.zPosition =  self.map.offset - self.player.position.y + 1000
    
    root.addChild(player)
  }
  
  
  public func updatePlayer(position: CGPoint?) {
    guard
      let player = player,
      let position = position
      else { return }

    if shouldMove(currentPosition: player.position, goalPosition: position) {
      movePlayer(to: position)
    } else {
      player.physicsBody!.isResting = true
    }
  }


  private func shouldMove(currentPosition: CGPoint, goalPosition: CGPoint) -> Bool {
    //make sure our point isn't just in the player
    return abs(currentPosition.x - goalPosition.x) > player.frame.width / 2 || abs(currentPosition.y - goalPosition.y) > player.frame.height / 2
  }

  private func movePlayer(to: CGPoint) {
    guard let _ = self.player.physicsBody else { return }
    
    let direction = self.angleDirection(to.y - self.player.position.y, to.x - self.player.position.x)

    self.player.texture = SKTexture(imageNamed: direction.rawValue)
    self.player.zPosition =  self.map.offset - self.player.position.y + 1000

    var velocity = CGVector(dx: 0, dy: 0)
    let diagSpeed: Double = playerSpeed / 1.5

    switch direction {
    case .North: velocity = CGVector(dx: 0, dy: playerSpeed)
    case .East: velocity = CGVector(dx: playerSpeed, dy: 0)
    case .South: velocity = CGVector(dx: 0, dy: -playerSpeed)
    case .West: velocity = CGVector(dx: -playerSpeed, dy: 0)
    case .NorthEast: velocity = CGVector(dx: diagSpeed, dy: diagSpeed)
    case .NorthWest: velocity = CGVector(dx: -diagSpeed, dy: diagSpeed)
    case .SouthEast: velocity = CGVector(dx: diagSpeed, dy: -diagSpeed)
    case .SouthWest: velocity = CGVector(dx: -diagSpeed, dy: -diagSpeed)
    }

    self.player.physicsBody!.velocity = velocity
  }

  //figure out which direction we're heading...
  private func angleDirection(_ y: CGFloat, _ x: CGFloat) -> Direction {
    let radius = atan2(y, x) * (180 / CGFloat.pi)
    let angle  = CGFloat(90 / 4)

    switch radius {
    case let r where r < angle && r > -angle:
      return Direction.East
    case let r where r > angle && r < angle * 3:
      return Direction.NorthEast
    case let r where r > angle * 3 && r < angle * 5:
      return Direction.North
    case let r where r > angle * 5 && r < angle * 7:
      return Direction.NorthWest
    case let r where r > angle * 7 || r < -(angle * 7):
      return Direction.West
    case let r where r > -(angle * 7) && r < -(angle * 5):
      return Direction.SouthWest
    case let r where r > -(angle * 5) && r < -(angle * 3):
      return Direction.South
    case let r where r > -(angle * 3) && r < -angle:
      return Direction.SouthEast
    default: break
    }

    return Direction.South
  }


}

