import Foundation
import UIKit

//GENERAL SYSTEM
public var standardScreenSize = CGSize(width: 1024, height: 768)
public var whiteColor = UIColor.white
public var blackColor = UIColor.black
public var redColor = UIColor.red
public var font = "Cronus Round"

//GameScene
public var gradientColorBottom = UIColor(red: 252/255, green: 202/255, blue: 40/255, alpha: 1.0)
public var gradientColorTop = redColor
public let menuButtonText = "MENU"
public let menuButtonName = "Menu"
public let playerName = "player"
public let cloudsImage = "clouds"

//GRADIENT
public let filterGradient = "CILinearGradient"
public let input0 = "inputPoint0"
public let input1 = "inputPoint1"
public let inputColor0 = "inputColor0"
public let inputColor1 = "inputColor1"

//MenuScene
public let gameTitle: String = "Way Home"
public let buttonTitle: String = "PLAY"


//AUDIO I/O
public let volumeButtonName = "Volume"
public let tempDirectoryName = "song"

//TUTORIAL
public let playButtonText = "PLAY"
public let skipButtonText = "SKIP"
public let continueButtonText = "CONTINUE"
public let continueButtonName = "continue"
public let playButtonName = "play"
public let skipButtonName = "skip"

public let tutorialPageText = [
  "This game is best experienced in full-screen landscape mode,\n with microphone permissions enabled",
  "To play, you must use more than just\nyour eyes... \nUsing your voice, guide our hero home\nthrough the ancient aztec ruins",
  "The louder you speak,\nthe brighter the path\nout of the ruins becomes",
  "Enjoy the journey...",
]

public let winPageText = "Congratulations!\nYou helped our hero navigate the ruins and find his way home"

//PLAYER
public var playerSpeed: Double = 300.0


//LIGHT SOURCE
public var ambientLightColor: UIColor = UIColor(red: 211/255, green: 245/255, blue: 254/255, alpha: 1.0) /* #d3f5fe */
public var lightSourceDefaultFalloff: CGFloat = 200


public var playerBitMask = 1
public var edgeTileBitMask = 2
public var winningTileBitMask = 3
