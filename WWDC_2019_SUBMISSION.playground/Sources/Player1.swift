import UIKit
import SpriteKit
import AVFoundation

//direction enum, will help us determine what player texture to use
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


public class Player1 {
  
  let speed: CGFloat = 200.0
  let map: Map!
  public var player1: SKSpriteNode!
  
  public init(_ root: SKNode, map: Map) {
    self.map = map
    setupPlayer(root)
  }
  
  public func updatePlayer(position: CGPoint?) {
    guard
      let player1 = player1,
      let position = position
      else { return }
    
    
    let currentPosition = player1.position
    
    if shouldMove(currentPosition: currentPosition, goalPosition: position) {
      movePlayer(to: position)
    } else {
      player1.physicsBody?.isResting = true
    }
  }
  
  
  private func setupPlayer(_ root: SKNode) {
    player1 = SKSpriteNode(imageNamed: "S")
    player1.size = CGSize(width: 50, height: 50)
    player1.physicsBody = SKPhysicsBody(circleOfRadius: 20.0, center: CGPoint(x: 0.0, y: -30.0))
    player1.physicsBody?.friction = 0
    player1.physicsBody?.restitution = 0
    player1.physicsBody?.linearDamping = 0
    player1.physicsBody?.angularDamping = 0
    player1.physicsBody?.allowsRotation = false
    player1.physicsBody?.affectedByGravity = false
    
    player1.lightingBitMask = 1
    player1.shadowedBitMask = 1
    player1.shadowCastBitMask = 1
    
    player1.position = CGPoint(x: map.stone.mapSize.width / 2, y: map.stone.mapSize.height / 2)
    
    root.addChild(player1)
  }
  
  //this will eventually be determined by a specific control panel?
  private func shouldMove(currentPosition: CGPoint, goalPosition: CGPoint) -> Bool {
    return abs(currentPosition.x - goalPosition.x) > player1.frame.width / 2 || abs(currentPosition.y - goalPosition.y) > player1.frame.height / 2
  }
  
  private func movePlayer(to: CGPoint) {
    let direction = self.angleDirection(to.y - self.player1.position.y, to.x - self.player1.position.x)
    
    self.player1.texture = SKTexture(imageNamed: direction.rawValue)
    self.player1.zPosition =  self.map.offset - self.player1.position.y + 1000
    
    var velocity = CGVector(dx: 0, dy: 0)
    let diagSpeed: CGFloat = speed/1.5
    
    
    switch direction {
    case .North: velocity = CGVector(dx: 0, dy: speed)
    case .East: velocity = CGVector(dx: speed, dy: 0)
    case .South: velocity = CGVector(dx: 0, dy: -speed)
    case .West: velocity = CGVector(dx: -speed, dy: 0)
    case .NorthEast: velocity = CGVector(dx: diagSpeed, dy: diagSpeed)
    case .NorthWest: velocity = CGVector(dx: -diagSpeed, dy: diagSpeed)
    case .SouthEast: velocity = CGVector(dx: diagSpeed, dy: -diagSpeed)
    case .SouthWest: velocity = CGVector(dx: -diagSpeed, dy: -diagSpeed)
    }
    
    self.player1.physicsBody?.velocity = velocity
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

