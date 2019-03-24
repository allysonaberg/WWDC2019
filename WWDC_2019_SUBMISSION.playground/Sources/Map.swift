import SpriteKit
import GameplayKit

public class Map {

  public var container : SKSpriteNode!

  var ground: SKTileMapNode!
  var offset : CGFloat!
  var offsetWide: CGFloat!
  var root: GameScene
  var tileSize: CGSize!

  public init(_ root: GameScene) {
    self.root = root
    self.container = SKSpriteNode()
    self.container.position = root.position
    root.addChild(container)
    setupTiles(root: root)

    self.offset = ground.mapSize.height
    self.offsetWide = ground.mapSize.width

    let groundmap = tileMapNode(tilemap: ground, level: -1)

    for item in groundmap.enumerated() {
      if item.element.texture != nil {
        if item.element.name == itemTileName {
          item.element.lightingBitMask = 1
        }
        else if item.element.name == wallTileName || item.element.name == winTileName {
          let defaultsTexture = SKTexture(imageNamed: fakeShape)
          item.element.physicsBody = SKPhysicsBody(texture: defaultsTexture, size: defaultsTexture.size())
          if let physicsBody = item.element.physicsBody {
            physicsBody.isDynamic = false
            physicsBody.contactTestBitMask = 2
            if item.element.name == wallTileName { physicsBody.categoryBitMask = 2 }
            else { physicsBody.categoryBitMask = 3 }
          }
        }
      }
    }
  }


  func setupTiles(root: GameScene) {
    self.tileSize = CGSize(width: 128, height: 64)
    self.ground = setupLevels(levelTextFile: level)
  }


  func setupLevels(levelTextFile: String) -> SKTileMapNode {

    //nothing
    let tile00 = SKTileDefinition(texture: SKTexture(imageNamed: blankTileImage), size: tileSize)
    let tileGroupRule00 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile00])
    let tileGroup00 = SKTileGroup(rules: [tileGroupRule00])
    tileGroup00.name = blankTileName
    
    //item
    let tile01 = SKTileDefinition(texture: SKTexture(imageNamed: itemTileImage), size: tileSize)
    let tileGroupRule01 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile01])
    let tileGroup01 = SKTileGroup(rules: [tileGroupRule01])
    tileGroup01.name = itemTileName
    
    //ground
    let tile02 = SKTileDefinition(texture: SKTexture(imageNamed: groundTileImage), size: tileSize)
    let tileGroupRule02 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile02])
    let tileGroup02 = SKTileGroup(rules: [tileGroupRule02])
    tileGroup02.name = groundTileName
    
    //invisible wall
    let tile03 = SKTileDefinition(texture: SKTexture(imageNamed: wallTileImage), size: tileSize)
    let tileGroupRule03 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile03])
    let tileGroup03 = SKTileGroup(rules: [tileGroupRule03])
    tileGroup03.name = wallTileName
    
    //WINNNER!
    let tile04 = SKTileDefinition(texture: SKTexture(imageNamed: winTileImage), size: tileSize)
    let tileGroupRule04 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile04])
    let tileGroup04 = SKTileGroup(rules: [tileGroupRule04])
    tileGroup04.name = winTileName

    let tileSet = SKTileSet(tileGroups: [tileGroup00, tileGroup01, tileGroup02, tileGroup03, tileGroup04], tileSetType: .isometric)

    let map = SKTileMapNode(tileSet: tileSet, columns: 37, rows: 21, tileSize: self.tileSize)

    let path = Bundle.main.path(forResource: level, ofType: nil)
    do {
      let fileContents = try String(contentsOfFile:path!, encoding: String.Encoding.utf8)
      let lines = fileContents.components(separatedBy: "\n")

      for row in 0..<lines.count {
        let items = lines[row].components(separatedBy: " ")

        for column in 0..<items.count {
          if items[column] == itemTileName {
            map.setTileGroup(tileGroup01, forColumn: column, row: row)
          } else if items[column] == groundTileName {
            map.setTileGroup(tileGroup02, forColumn: column, row: row)
          } else if items[column] == wallTileName {
            map.setTileGroup(tileGroup03, forColumn: column, row: row)
          } else if items[column] == winTileName {
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
    var spriteArray = [SKSpriteNode]()
    for col in 0..<tilemap.numberOfColumns {
      for row in 0..<tilemap.numberOfRows {
        if (tilemap.tileGroup(atColumn: col, row: row))?.name != blankTileName {
        let sprite = SKSpriteNode(texture: tilemap.tileDefinition(atColumn: col, row: row)?.textures.first)
        sprite.position = tilemap.centerOfTile(atColumn: col, row: row)
        sprite.zPosition = self.offset - sprite.position.y + tilemap.tileSize.height *  CGFloat(level)
        self.container.addChild(sprite)
        if tilemap.tileGroup(atColumn: col, row: row)?.name == itemTileName { sprite.name = itemTileName }
        else if tilemap.tileGroup(atColumn: col, row: row)?.name == wallTileName { sprite.name = wallTileName }
        else if tilemap.tileGroup(atColumn: col, row: row)?.name == winTileName { sprite.name = winTileName }
        spriteArray.append(sprite)
        }
      }
    }
    tilemap.removeFromParent()
    return spriteArray
  }
}

