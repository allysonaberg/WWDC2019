import Foundation
import UIKit

//GENERAL SYSTEM
public var standardScreenSize = CGSize(width: 1024, height: 768)
public var whiteColor = UIColor.white
public var blackColor = UIColor.black
public var redColor = UIColor.red


//GameScene
public var gradientColorBottom = UIColor(red: 252/255, green: 202/255, blue: 40/255, alpha: 1.0) /*   */
public var gradientColorTop = UIColor(red: 247/255, green: 131/255, blue: 0/255, alpha: 1.0) /* #f78300 */
public let menuButtonText = "MENU"
public let menuButtonName = "Menu"

//MenuScene
public let gameTitle: String = "In The Dark"
public let buttonTitle: String = "PLAY"


//AUDIO I/O
public let volumeButtonName = "Volume"
public var volumeImage = "volume"
public var muteVolumeImage = "volume_mute"

//TUTORIAL
public let playButtonText = "PLAY"
public let skipButtonText = "SKIP"
public let continueButtonText = "CONTINUE"
public let continueButtonName = "continue"
public let playButtonName = "play"
public let skipButtonName = "skip"

public let tutorialPageText = [
  "This is a game about BLEH",
  "bla bla bloo",
  "haha haha haha",
  "AHHHHHHHHHHH",
]

//PLAYER
public var playerSpeed: Double = 300.0


//LIGHT SOURCE
public var ambientLightColor: UIColor = UIColor(red: 211/255, green: 245/255, blue: 254/255, alpha: 1.0) /* #d3f5fe */
public var lightSourceDefaultFalloff: CGFloat = 200

