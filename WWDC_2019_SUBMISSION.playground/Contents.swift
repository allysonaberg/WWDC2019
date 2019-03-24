
import PlaygroundSupport
import SpriteKit


//TODO: this should probably store both the menu and game scene and switch between them
//rather than reinitializing
let viewSize = CGSize(width: 1024, height: 768)

let sceneView = SKView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: viewSize))
sceneView.ignoresSiblingOrder = true
sceneView.showsDrawCount = true
sceneView.preferredFramesPerSecond = UIScreen.main.maximumFramesPerSecond
sceneView.backgroundColor = gradientColorBottom
//sceneView.showsPhysics = true

if let fontURL = Bundle.main.url(forResource: "Cronus Round", withExtension: "otf") {
  CTFontManagerRegisterFontsForURL(fontURL as CFURL, CTFontManagerScope.process, nil)
}

let menuScene = MenuScene(size: sceneView.bounds.size)
menuScene.scaleMode = .aspectFill
sceneView.presentScene(menuScene)


PlaygroundPage.current.liveView = sceneView
