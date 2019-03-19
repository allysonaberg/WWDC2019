import SpriteKit
import GameplayKit

public class Map {
  
  public var container : SKSpriteNode!
  
  var ground: SKTileMapNode!
  var stone: SKTileMapNode!
  var danger: SKTileMapNode!
  var offset : CGFloat!
  var root: SKNode!
  var tileSize: CGSize!
  
  
  var bodyPath: CGPath {
    let nsPath = CGMutablePath()
    nsPath.move(to: CGPoint(x: 0, y: -64))
    nsPath.addLine(to: CGPoint(x: -64.0, y: -32.0))
    nsPath.addLine(to: CGPoint(x: 0.0, y: 0.0))
    nsPath.addLine(to: CGPoint(x: 64.0, y: -32.0))
    nsPath.closeSubpath()
    
    return nsPath
  }
  
  public init(_ root: SKNode) {
    setupTiles(root: root)
    self.container = SKSpriteNode()
    self.root = root
    root.addChild(container)
    
    self.offset = stone.mapSize.height
    
    let groundmap = tileMapNode(tilemap: ground, level: -1)
    let stonemap = tileMapNode(tilemap: stone, level: 1)

    for item in stonemap.enumerated() {
      if item.element.texture != nil {
        item.element.physicsBody = SKPhysicsBody(polygonFrom: self.bodyPath)
//        item.element.physicsBody!.affectedByGravity = false
        item.element.physicsBody!.isDynamic = false
        item.element.physicsBody!.contactTestBitMask = 2
        item.element.physicsBody!.categoryBitMask = 2
      }
    }
    
    for item in groundmap.enumerated() {
      if item.element.texture != nil {
        if item.element.name == "03" {
          print("found 03")
          item.element.lightingBitMask = 1
        }
      }
    }
    
  }
  
  
  func setupTiles(root: SKNode) {
    self.tileSize = CGSize(width: 128, height: 64)
    self.ground = setupLevels(level: "Level1.txt")
    self.stone = setupLevels(level: "Level3.txt")
  }
  
  
  func setupLevels(level: String) -> SKTileMapNode {
    
    //white ground
    let tile01 = SKTileDefinition(texture: SKTexture(imageNamed: "01"), size: tileSize)
    let tileGroupRule01 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile01])
    let tileGroup01 = SKTileGroup(rules: [tileGroupRule01])
    tileGroup01.name = "01"
    
    //white ground
    let tile02 = SKTileDefinition(texture: SKTexture(imageNamed: "01"), size: tileSize)
    let tileGroupRule02 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile02])
    let tileGroup02 = SKTileGroup(rules: [tileGroupRule02])
    tileGroup02.name = "02"
    
    //item
    let tile03 = SKTileDefinition(texture: SKTexture(imageNamed: "02"), size: tileSize)
    let tileGroupRule03 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile03])
    let tileGroup03 = SKTileGroup(rules: [tileGroupRule03])
    tileGroup03.name = "03"
    
    //danger
    let tile04 = SKTileDefinition(texture: SKTexture(imageNamed: "01"), size: tileSize)
    let tileGroupRule04 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile04])
    let tileGroup04 = SKTileGroup(rules: [tileGroupRule04])
    tileGroup04.name = "04"
    
    let tileSet = SKTileSet(tileGroups: [tileGroup01, tileGroup02, tileGroup03, tileGroup04], tileSetType: .isometric)
    
    let map = SKTileMapNode(tileSet: tileSet, columns: 22, rows: 22, tileSize: self.tileSize)
    
    let path = Bundle.main.path(forResource: level, ofType: nil)
    do {
      let fileContents = try String(contentsOfFile:path!, encoding: String.Encoding.utf8)
      let lines = fileContents.components(separatedBy: "\n")
      
      for row in 0..<lines.count {
        let items = lines[row].components(separatedBy: " ")
        
        for column in 0..<items.count {
          if items[column] == "01" {
            map.setTileGroup(tileGroup01, forColumn: column, row: row)
          } else if items[column] == "02" {
            map.setTileGroup(tileGroup02, forColumn: column, row: row)
          } else if items[column] == "03" {
            map.setTileGroup(tileGroup03, forColumn: column, row: row)
          } else if items[column] == "04" {
            map.setTileGroup(tileGroup04, forColumn: column, row: row)
          }
        }
      }
    } catch {
      print("Error loading map")
    }
    return map
    
  }
  
  func tileMapNode(tilemap: SKTileMapNode, level: Int) -> [SKSpriteNode] {
    var array = [SKSpriteNode]()
    for col in 0..<tilemap.numberOfColumns {
      for row in 0..<tilemap.numberOfRows {
        let sprite = SKSpriteNode(texture: tilemap.tileDefinition(atColumn: col, row: row)?.textures.first)
        sprite.position = tilemap.centerOfTile(atColumn: col, row: row)
        sprite.zPosition = self.offset - sprite.position.y + tilemap.tileSize.height *  CGFloat(level)
        self.container.addChild(sprite)
        if tilemap.tileGroup(atColumn: col, row: row)?.name == "03" {
          sprite.name = "03"
        }
        if tilemap.tileGroup(atColumn: col, row: row)?.name == "04" {
          sprite.name = "04"
        }
        array.append(sprite)
      }
    }
    //todo: remove from parent
    tilemap.isHidden = true
    return array
  }
}



