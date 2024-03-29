import SpriteKit
import GameplayKit

public class Map: SKNode {

  public var container : SKSpriteNode!

  var ground: SKTileMapNode!
  var offset : CGFloat!
  var root: GameScene
  var tileSize: CGSize!

  public init(_ root: GameScene) {
    self.root = root
    self.container = SKSpriteNode()
    self.container.position = root.position
    self.ground = SKTileMapNode()
    self.offset = ground.mapSize.height
    self.tileSize = CGSize(width: 128, height: 64)

    super.init()
    
    root.addChild(container)
    setupTiles(root: root)


    let groundmap = tileMapNode(tilemap: ground, level: -1)

    for item in groundmap.enumerated() {
      if item.element.texture != nil {
        if item.element.name == "01" { item.element.lightingBitMask = 1 }
        else if item.element.name == "03" {
          let defaultsTexture = SKTexture(imageNamed: "shape")
          item.element.physicsBody = SKPhysicsBody(texture: defaultsTexture, size: defaultsTexture.size())
          if let physicsBody = item.element.physicsBody {
            physicsBody.isDynamic = false
            physicsBody.contactTestBitMask = 2
            physicsBody.categoryBitMask = 2
          }
        } else if item.element.name == "04" {
          let defaultsTexture = SKTexture(imageNamed: "shape")
          item.element.physicsBody = SKPhysicsBody(texture: defaultsTexture, size: defaultsTexture.size())
          if let physicsBody = item.element.physicsBody {
            physicsBody.isDynamic = false
            physicsBody.contactTestBitMask = 2
            physicsBody.categoryBitMask = 3
          }
        }
      }
    }
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupTiles(root: GameScene) {
    self.ground = setupLevels(level: "Level1.txt")
  }


  func setupLevels(level: String) -> SKTileMapNode {

    //nothing
    let tile00 = SKTileDefinition(texture: SKTexture(imageNamed: "03"), size: tileSize)
    let tileGroupRule00 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile00])
    let tileGroup00 = SKTileGroup(rules: [tileGroupRule00])
    tileGroup00.name = "00"
    
    //item
    let tile01 = SKTileDefinition(texture: SKTexture(imageNamed: "02"), size: tileSize)
    let tileGroupRule01 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile01])
    let tileGroup01 = SKTileGroup(rules: [tileGroupRule01])
    tileGroup01.name = "01"

    //ground
    let tile02 = SKTileDefinition(texture: SKTexture(imageNamed: "01_real"), size: tileSize)
    let tileGroupRule02 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile02])
    let tileGroup02 = SKTileGroup(rules: [tileGroupRule02])
    tileGroup02.name = "02"

    //invisible wall
    let tile03 = SKTileDefinition(texture: SKTexture(imageNamed: "03"), size: tileSize)
    let tileGroupRule03 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile03])
    let tileGroup03 = SKTileGroup(rules: [tileGroupRule03])
    tileGroup03.name = "03"
    
    //WINNNER!
    let tile04 = SKTileDefinition(texture: SKTexture(imageNamed: "011"), size: tileSize)
    let tileGroupRule04 = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: [tile04])
    let tileGroup04 = SKTileGroup(rules: [tileGroupRule04])
    tileGroup04.name = "04"

    let tileSet = SKTileSet(tileGroups: [tileGroup00, tileGroup01, tileGroup02, tileGroup03, tileGroup04], tileSetType: .isometric)

    let map = SKTileMapNode(tileSet: tileSet, columns: 37, rows: 21, tileSize: self.tileSize)

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
        if (tilemap.tileGroup(atColumn: col, row: row))?.name != "00" {
        let sprite = SKSpriteNode(texture: tilemap.tileDefinition(atColumn: col, row: row)?.textures.first)
        sprite.position = tilemap.centerOfTile(atColumn: col, row: row)
        sprite.zPosition = self.offset - sprite.position.y + tilemap.tileSize.height *  CGFloat(level)
        self.container.addChild(sprite)
        if tilemap.tileGroup(atColumn: col, row: row)?.name == "01" { sprite.name = "01" }
        else if tilemap.tileGroup(atColumn: col, row: row)?.name == "03" { sprite.name = "03" }
        else if tilemap.tileGroup(atColumn: col, row: row)?.name == "04" {
          sprite.name = "04"
        }
        array.append(sprite)
      }
      }
    }
    tilemap.removeFromParent()
    return array
  }
}



