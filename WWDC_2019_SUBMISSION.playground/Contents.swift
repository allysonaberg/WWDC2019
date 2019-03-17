//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import GameplayKit

let viewSize = CGSize(width: 800, height: 500)

let sceneView = SKView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: viewSize))
sceneView.ignoresSiblingOrder = true
let gameScene = GameScene(size: viewSize)
sceneView.presentScene(gameScene)

PlaygroundPage.current.liveView = sceneView
PlaygroundPage.current.needsIndefiniteExecution = true

