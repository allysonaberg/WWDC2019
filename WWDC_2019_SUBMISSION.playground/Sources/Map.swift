import SpriteKit
import GameplayKit

public class Map {
  
  public var container : SKSpriteNode!

  var ground: SKTileMapNode!
  var stone: SKTileMapNode!
  var level2: SKTileMapNode!
  var offset : CGFloat!
  var root: SKNode!
  var tileSize: CGSize!
  
  
    // The shape of the physical body of each map tile
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
      
//      let groundmap = tileMapNode(tilemap: ground, level: -1)
      let stonemap = tileMapNode(tilemap: ground, level: 1)

      for item in stonemap.enumerated() {
        if item.element.texture != nil {
          item.element.physicsBody = SKPhysicsBody(polygonFrom: self.bodyPath)
          item.element.physicsBody?.isDynamic = false
        }
      }

    }
  
  func setupTiles(root: SKNode) {
    self.tileSize = CGSize(width: 128, height: 64)
    self.ground = setupLevels(level: "Level1.txt")
    self.stone = setupLevels(level: "Level2.txt")

  }
  
  
  func setupLevels(level: String) -> SKTileMapNode {
    let tile01 = SKTileDefinition(texture: SKTexture(imageNamed: "01"), size: tileSize)
    let tile02 = SKTileDefinition(texture: SKTexture(imageNamed: "02"), size: tileSize)
    let tileGroupRule01 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile01])
    let tileGroup01 = SKTileGroup(rules: [tileGroupRule01])
    let tileGroupRule02 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile02])
    let tileGroup02 = SKTileGroup(rules: [tileGroupRule02])
    
    let tileSet = SKTileSet(tileGroups: [tileGroup01, tileGroup02], tileSetType: .isometric)
    
    let map = SKTileMapNode(tileSet: tileSet, columns: 11, rows: 10, tileSize: self.tileSize)
//    map.fill(with: tileGroup01) // fill or set by column/row
    //      tileMap.setTileGroup(tileGroup, forColumn: 1, row: 1)
    
    let path = Bundle.main.path(forResource: level, ofType: nil)
    do {
      let fileContents = try String(contentsOfFile:path!, encoding: String.Encoding.utf8)
      let lines = fileContents.components(separatedBy: "\n")

      for row in 0..<lines.count {
        let items = lines[row].components(separatedBy: " ")

        for column in 0..<items.count {
          //          let tile = tileMap.tileSet.tileGroups.first(where: {$0.name == items[column]})

          if items[column] == "01" {
            map.setTileGroup(tileGroup01, forColumn: column, row: row)
          } else if items[column] == "02" {
            map.setTileGroup(tileGroup02, forColumn: column, row: row)
          }
        }
      }
    } catch {
      print("Error loading map")
    }
    return map
//    self.root.addChild(map)
    
  }

    //Creating tiles of the map layer for further work with them
    func tileMapNode(tilemap: SKTileMapNode, level: Int) -> [SKSpriteNode] {
        var array = [SKSpriteNode]()
        for col in 0..<tilemap.numberOfColumns {
            for row in 0..<tilemap.numberOfRows {
                let sprite = SKSpriteNode(texture: tilemap.tileDefinition(atColumn: col, row: row)?.textures.first)
                sprite.position = tilemap.centerOfTile(atColumn: col, row: row)
                sprite.zPosition = self.offset - sprite.position.y + tilemap.tileSize.height *  CGFloat(level)
                self.container.addChild(sprite)
                array.append(sprite)
            }
        }
       tilemap.isHidden = true
        return array
    }
}



