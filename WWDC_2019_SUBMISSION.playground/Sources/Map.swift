import SpriteKit
import GameplayKit

public class Map {
    
    var ground: SKTileMapNode!
    var stone: SKTileMapNode!
    var level2: SKTileMapNode!
    
    var container : SKSpriteNode!
    var offset : CGFloat!
    
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
      let tileSize1: CGSize = CGSize(width: 128, height: 32)
      let testTile = SKTileDefinition(texture: SKTexture(imageNamed: "01"), size: tileSize1)
      let tileGroupRule = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [testTile])
      
      let tileGroup = SKTileGroup(rules: [tileGroupRule])
      let tileSet = SKTileSet(tileGroups: [tileGroup], tileSetType: SKTileSetType.isometric)
      let tileSize = tileSet.defaultTileSize // from image size
      let tileMap = SKTileMapNode(tileSet: tileSet, columns: 5, rows: 5, tileSize: tileSize1)
//      let tileGroup = tileSet.tileGroups.first
      tileMap.fill(with: tileGroup) // fill or set by column/row
      //tileMap.setTileGroup(tileGroup, forColumn: 5, row: 5)
      root.addChild(tileMap)
      
    }
    
    //Creating tiles of the map layer for further work with them
    func tileMapNode(tilemap: SKTileMapNode, level: Int) -> [SKSpriteNode] {
        var array = [SKSpriteNode]()
        print("beFOR")
        for col in 0..<tilemap.numberOfColumns {
          print("inFOR")
            for row in 0..<tilemap.numberOfRows {
                let definition = tilemap.tileDefinition(atColumn: col, row: row)
                
                guard let texture = definition?.textures.first else { continue }
                
                let sprite = SKSpriteNode(texture: texture)
                sprite.position = tilemap.centerOfTile(atColumn: col, row: row)
                sprite.zPosition = self.offset - sprite.position.y + tilemap.tileSize.height *  CGFloat(level)
                self.container.addChild(sprite)
                
                array.append(sprite)
            }
        }
        
//        tilemap.isHidden = true
      
        return array
    }
}


//struct SpriteSheet {
//
//  let baseTexture: SKTexture
//  let rows: CGFloat
//  let columns: CGFloat
//  var textureSize: (width: CGFloat, height: CGFloat) {
//    return (width: baseTexture.textureRect().width / self.columns,
//            height: baseTexture.textureRect().height / self.rows)
//  }
//
//  init(imageNamed texture: String, rows: CGFloat, columns: CGFloat) {
//    print("INIT 1")
//    self.baseTexture = SKTexture(imageNamed: texture)
//    print(baseTexture)
//    self.baseTexture.filteringMode = .nearest // best for pixel art
//    self.rows = rows
//    self.columns = columns
//  }
//
//  var testTileMap: SKTileMapNode {
//    print("2")
//    let tileSize: CGSize = CGSize(width: 16, height: 16)
//    let texture = cropTexture(row: 1, column: 10, w: 1, h: 1)
//    let tileDef = SKTileDefinition(texture: texture, size: tileSize)
//    let tileGroup = SKTileGroup(tileDefinition: tileDef)
//    let tileSet = SKTileSet(tileGroups: [tileGroup])
//    let mapNode = SKTileMapNode(tileSet: tileSet,
//                                columns: 4,
//                                rows: 4,
//                                tileSize: tileSize,
//                                fillWith: tileGroup)
//    print(mapNode)
//    return mapNode
//  }
//
//  func cropTexture(row: CGFloat, column: CGFloat, w: CGFloat, h: CGFloat) -> SKTexture {
//    print("3")
//    assert(row < rows && column < columns && row > 0 && column > 0)
//    let rect = CGRect(x: textureSize.width * (column - 1),
//                      y: textureSize.height * (self.rows - row),
//                      width: textureSize.width * w,
//                      height: textureSize.height * h)
//    return SKTexture(rect: rect, in: baseTexture)
//  }
//
//}


