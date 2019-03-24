import Foundation
import UIKit

//GENERAL SYSTEM STUFF
public var standardScreenSize = CGSize(width: 1024, height: 768)
public var whiteColor = UIColor.white
public var blackColor = UIColor.black
public var redColor = UIColor.red
public var font = "Cronus Round"

//GAMESCENE
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

//MENUSCENE
public let gameTitle: String = "Way Home"
public let buttonTitle: String = "PLAY"
public let mainCharacterSprite: String = "S"
public let mainCharacterBlink: String = "S_blink"


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

//MAP
public let level = "Level.txt"
public let fakeShape = "shape"

public let blankTileImage = "03"
public let blankTileName = "00"

public let itemTileImage = "02"
public let itemTileName = "01"

public let groundTileImage = "01"
public let groundTileName = "02"

public let wallTileImage = "03"
public let wallTileName = "03"

public let winTileImage = "WIN"
public let winTileName = "04"


//LIGHT SOURCE
public var ambientLightColor: UIColor = UIColor(red: 211/255, green: 245/255, blue: 254/255, alpha: 1.0) /* #d3f5fe */
public var lightSourceDefaultFalloff: CGFloat = 200


public var playerBitMask = 1
public var edgeTileBitMask = 2
public var winningTileBitMask = 3
