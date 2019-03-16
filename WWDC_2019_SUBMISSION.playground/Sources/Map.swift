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
        
//        ground = root.childNode(withName: "ground") as? SKTileMapNode
//        stone = root.childNode(withName: "ground") as? SKTileMapNode
//        level2 = root.childNode(withName: "level2") as? SKTileMapNode
//
//        offset = self.stone.mapSize.height
//
//        container = SKSpriteNode()
//        root.addChild(container)
//
//        let tileBottom = self.tileMapNode(tilemap: stone, level: 0)
//        ////        let tileLevel2 = self.tileMapNode(tilemap: level2, level: 1)
//        for item in tileBottom.enumerated() {
//
//            // Assign the shape of the physical body
//            item.element.physicsBody = SKPhysicsBody(polygonFrom: self.bodyPath)
//
//            // Reset all physical parameters of the object
//            item.element.physicsBody?.friction = 0
//            item.element.physicsBody?.restitution = 0
//            item.element.physicsBody?.linearDamping = 0
//            item.element.physicsBody?.angularDamping = 0
//            item.element.physicsBody?.isDynamic = false
//        }
        
    }
    
    //Creating tiles of the map layer for further work with them
    func tileMapNode(tilemap: SKTileMapNode, level: Int) -> [SKSpriteNode] {
        var array = [SKSpriteNode]()
        
        for col in 0..<tilemap.numberOfColumns {
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
        
        tilemap.isHidden = true
        
        return array
    }
}


