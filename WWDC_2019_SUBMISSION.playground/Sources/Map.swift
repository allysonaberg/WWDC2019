import SpriteKit
import GameplayKit

public class Map {
    
//    var ground: SKTileMapNode!
//    var stone: SKTileMapNode!
//    var level2: SKTileMapNode!
//
    public var container : SKSpriteNode!
    var offset : CGFloat!
  
  var tileMap: SKTileMapNode!
    
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

      root.addChild(container)
      self.offset = tileMap.mapSize.height
      let ground = tileMapNode(tilemap: tileMap, level: 0)

      for item in ground.enumerated() {
        item.element.physicsBody = SKPhysicsBody(polygonFrom: self.bodyPath)
        item.element.physicsBody?.isDynamic = false
      }

    }
  
  func setupTiles(root: SKNode) {
    print("setting up tiles")
    let tileSize: CGSize = CGSize(width: 128, height: 64)
    let tile01 = SKTileDefinition(texture: SKTexture(imageNamed: "01"), size: tileSize)
    let tile02 = SKTileDefinition(texture: SKTexture(imageNamed: "02"), size: tileSize)
    let tileGroupRule01 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile01])
    let tileGroup01 = SKTileGroup(rules: [tileGroupRule01])
    let tileGroupRule02 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile02])
    let tileGroup02 = SKTileGroup(rules: [tileGroupRule02])
    let tileSet = SKTileSet(tileGroups: [tileGroup01, tileGroup02], tileSetType: .isometric)

    self.tileMap = SKTileMapNode(tileSet: tileSet, columns: 5, rows: 5, tileSize: tileSize)
    //      tileMap.fill(with: tileGroup) // fill or set by column/row
    //      tileMap.setTileGroup(tileGroup, forColumn: 1, row: 1)
    
    
    
    let path = Bundle.main.path(forResource: "Level1.txt", ofType: nil)
    do {
      let fileContents = try String(contentsOfFile:path!, encoding: String.Encoding.utf8)
      let lines = fileContents.components(separatedBy: "\n")
      
      for row in 0..<lines.count {
        let items = lines[row].components(separatedBy: " ")
        
        for column in 0..<items.count {
//          let tile = tileMap.tileSet.tileGroups.first(where: {$0.name == items[column]})
          
          if items[column] == "01" {
            tileMap.setTileGroup(tileGroup01, forColumn: column, row: row)
          } else {
            tileMap.setTileGroup(tileGroup02, forColumn: column, row: row)
          }
        }
      }
    } catch {
      print("Error loading map")
    }
    
    root.addChild(tileMap)
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



