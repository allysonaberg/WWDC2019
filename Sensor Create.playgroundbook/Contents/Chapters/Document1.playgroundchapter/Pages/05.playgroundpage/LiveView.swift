
// 
//  LiveView.swift
//
//  Copyright © 2016-2018 Apple Inc. All rights reserved.
//



import PlaygroundSupport
import SpriteKit
import GameplayKit

let viewSize = CGSize(width: 1200, height: 800)

let sceneView = SKView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: viewSize))
sceneView.ignoresSiblingOrder = true
let gameScene = GameScene(size: viewSize)
sceneView.presentScene(gameScene)

PlaygroundPage.current.liveView = sceneView
PlaygroundPage.current.needsIndefiniteExecution = true

