// 
//  Sound.swift
//
//  Copyright © 2016-2018 Apple Inc. All rights reserved.
//

import Foundation

/// An enumeration of all the different sounds that can be played. Some of the sounds you can make include: bassBomb, boop1...boop3, buttonPress1...buttonPress3, boing1...3, clang, clunk, electricBeep1...electricBeep4, electricBeepFader, helicopterWhoosh, machineGreeting1...machineGreeting3, pleasantDing1...pleasantDing3, pop1, pop2, spring1...spring4, switch1, switch2, and warble.
///
/// - localizationKey: Sound
public enum Sound: String, Codable {
    
    case bassBomb,
    boing1,
    boing2,
    boing3,
    boop1,
    boop2,
    boop3,
    bounce1,
    bounce2,
    bounce3,
    buttonPress1,
    buttonPress2,
    clang,
    clunk,
    crash,
    defeat,
    electricBeep1,
    electricBeep2,
    electricBeep3,
    electricBeep4,
    electricBeepFader,
    explode,
    helicopterWhoosh,
    laser1,
    laser2,
    laser3,
    machineGreeting1,
    machineGreeting2,
    machineGreeting3,
    pleasantDing1,
    pleasantDing2,
    pleasantDing3,
    pop1,
    pop2,
    powerUp1,
    powerUp2,
    powerUp3,
    powerUp4,
    retroBass,
    retroCollide1,
    retroCollide2,
    retroCollide3,
    retroCollide4,
    retroCollide5,
    retroJump1,
    retroJump2,
    retroPowerUp1,
    retroPowerUp2,
    retroTwang1,
    retroTwang2,
    somethingBad1,
    somethingBad2,
    somethingBad3,
    somethingBad4,
    somethingGood1,
    somethingGood2,
    somethingGood3,
    somethingGood4,
    somethingGood5,
    somethingGood6,
    somethingGood7,
    splat1,
    spring1,
    spring2,
    spring3,
    spring4,
    strangeWobble,
    switch1,
    switch2,
    thud,
    tubeHit1,
    tubeHit2,
    tubeHit3,
    victory1,
    victory2,
    victory3,
    victory4,
    warble
    
    var url : URL? {
        
        var fileName: String?
        
        switch self {
        case .bassBomb:
            fileName = "bassBomb"
        case .boing1:
            fileName = "boing1"
        case .boing2:
            fileName = "boing2"
        case .boing3:
            fileName = "boing3"
        case .boop1:
            fileName = "boop1"
        case .boop2:
            fileName = "boop2"
        case .boop3:
            fileName = "boop3"
        case .bounce1:
            fileName = "Bounce1"
        case .bounce2:
            fileName = "Bounce2"
        case .bounce3:
            fileName = "Bounce3"
        case .buttonPress1:
            fileName = "buttonPress1"
        case .buttonPress2:
            fileName = "UI Button Push_v1_01"
        case .clang:
            fileName = "clang"
        case .clunk:
            fileName = "clunk"
        case .crash:
            fileName = "crash"
        case .defeat:
            fileName = "Defeat1"
        case .electricBeep1:
            fileName = "electricBeep1"
        case .electricBeep2:
            fileName = "electricBeep2"
        case .electricBeep3:
            fileName = "electricBeep3"
        case .electricBeep4:
            fileName = "electricBeep4"
        case .electricBeepFader:
            fileName = "electricBeepFader"
        case .explode:
            fileName = "Explosion_short"
        case .helicopterWhoosh:
            fileName = "helicopterWhoosh"
        case .laser1:
            fileName = "laser1"
        case .laser2:
            fileName = "laser2"
        case .laser3:
            fileName = "laser3"
        case .machineGreeting1:
            fileName = "machineGreeting1"
        case .machineGreeting2:
            fileName = "machineGreeting2"
        case .machineGreeting3:
            fileName = "machineGreeting3"
        case .pleasantDing1:
            fileName = "pleasantDing1"
        case .pleasantDing2:
            fileName = "pleasantDing2"
        case .pleasantDing3:
            fileName = "pleasantDing3"
        case .pop1:
            fileName = "pop1"
        case .pop2:
            fileName = "pop2"
        case .powerUp1:
            fileName = "powerUp1"
        case .powerUp2:
            fileName = "powerUp2"
        case .powerUp3:
            fileName = "powerUp3"
        case .powerUp4:
            fileName = "powerUp4"
        case .retroJump1:
            fileName = "retroFXJump1"
        case .retroJump2:
            fileName = "retroFXJump2"
        case .retroPowerUp1:
            fileName = "retroFXPowerUp1"
        case .retroPowerUp2:
            fileName = "retroFXPowerUp2"
        case .retroTwang1:
            fileName = "retroFXTwang1"
        case .retroTwang2:
            fileName = "retroFXTwang2"
        case .retroCollide1:
            fileName = "retroFXCollide1"
        case .retroCollide2:
            fileName = "retroFXCollide2"
        case .retroCollide3:
            fileName = "retroFXCollide3"
        case .retroCollide4:
            fileName = "retroFXCollide4"
        case .retroCollide5:
            fileName = "retroFXCollide5"
        case .retroBass:
            fileName = "retroFXBass"
        case .somethingBad1:
            fileName = "somethingBad1"
        case .somethingBad2:
            fileName = "somethingBad2"
        case .somethingBad3:
            fileName = "somethingBad3"
        case .somethingBad4:
            fileName = "somethingBad4"
        case .somethingGood1:
            fileName = "somethingGood1"
        case .somethingGood2:
            fileName = "somethingGood2"
        case .somethingGood3:
            fileName = "somethingGood3"
        case .somethingGood4:
            fileName = "somethingGood4"
        case .somethingGood5:
            fileName = "somethingGood5"
        case .somethingGood6:
            fileName = "somethingGood6"
        case .somethingGood7:
            fileName = "somethingGood7"
        case .splat1:
            fileName = "splat"
        case .spring1:
            fileName = "spring1"
        case .spring2:
            fileName = "spring2"
        case .spring3:
            fileName = "spring3"
        case .spring4:
            fileName = "spring4"
        case .strangeWobble:
            fileName = "strangeWobble"
        case .switch1:
            fileName = "Switch_v1_01"
        case .switch2:
            fileName = "Switch_v1_02"
        case .thud:
            fileName = "thud"
        case .tubeHit1:
            fileName = "tubeHit1"
        case .tubeHit2:
            fileName = "tubeHit2"
        case .tubeHit3:
            fileName = "tubeHit3"
        case .victory1:
            fileName = "Victory_v1_short"
        case .victory2:
            fileName = "Victory2_v1"
        case .victory3:
            fileName = "Victory3_v1"
        case .victory4:
            fileName = "Victory4_v1"
        case .warble:
            fileName = "Warble_001"
        }
            
        guard let resourceName = fileName else { return nil }
        
        return Bundle.main.url(forResource: resourceName, withExtension: "m4a")
    }
}
/// An enumeration of the different types of Music you can play, including: friendlyPassage, aroundTheCorner, southAMPitches, watchEverythingFall, puzzleJam, simSationalSmile, fightForAmericas, and rox2TheBox.
///
/// - localizationKey: Music
public enum Music: String {
    
    case friendlyPassage, aroundTheCorner, southAMPitches, watchEverythingFall, puzzleJam, simSationalSmile, fightForAmericas, rox2TheBox
    
    var url : URL? {
        
        var fileName: String?
        
        switch self {
        case .friendlyPassage:
            fileName = "A_Friendly_Passage"
        case .aroundTheCorner:
            fileName = "Around the Corner-02FullMix-ExtraWoodBlock"
        case .southAMPitches:
            fileName = "South_Am_Pitches-r1"
        case .watchEverythingFall:
            fileName = "Just_Watch_Everything_Fall-02FullMIx-ExtraTopLoop"
        case .puzzleJam:
            fileName = "Puzzle Jam-02FullMix-ExtraDrums"
        case .simSationalSmile:
            fileName = "SIMSational_Smile-r1_Loopable"
        case .fightForAmericas:
            fileName = "Fight for the Americas-01 Full MIX-with Claps"
        case .rox2TheBox:
            fileName = "Rox_2_the_Box-r2-03FullMix-ExtraPerc2"
            
        }
        guard let resourceName = fileName else { return nil }
        
        return Bundle.main.url(forResource: resourceName, withExtension: "m4a")
    }
}

