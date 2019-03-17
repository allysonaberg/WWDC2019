// 
//  Transformables.swift
//
//  Copyright © 2016-2018 Apple Inc. All rights reserved.
//


import Foundation
import UIKit
import SpriteKit
import PlaygroundSupport

public protocol PlaygroundValueTransformable {
    
    var playgroundValue: PlaygroundValue? { get }
    static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable?
    
}


extension String: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        
        return .string(self)
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .string(let string) = playgroundValue else { return nil }

        return string
    }
    
}



extension Bool: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        
        return .boolean(self)
    }

    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .boolean(let boolean) = playgroundValue else { return nil }
        
        return boolean
    }
    
}



extension Int: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        
        return .integer(self)
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .integer(let integer) = playgroundValue else { return nil }
        
        return integer
    }
    
}



extension CGFloat: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        
        return .floatingPoint(Double(self))
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .floatingPoint(let doubleValue) = playgroundValue else { return nil }
        
        return CGFloat(doubleValue)
    }
    
}

extension Double: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        return .floatingPoint(self)
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .floatingPoint(let doubleValue) = playgroundValue else { return nil }
        return doubleValue
    }
    
}



extension MessageName: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        
        return .string(rawValue)
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .string(let name) = playgroundValue else { return nil }
        
        return MessageName(rawValue: name)
    }
    
}



extension UIBezierPath: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        return .data(data)
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .data(let data) = playgroundValue else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? UIBezierPath
    }
}



extension CGPoint: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        return .array([.floatingPoint(Double(x)), .floatingPoint(Double(y))])
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard
            case .array(let components) = playgroundValue,
            components.count == 2,
            case .floatingPoint(let x) = components[0],
            case .floatingPoint(let y) = components[1]
            
            else { return nil }
        return CGPoint(x: x, y: y)
    }
    
}

extension CGSize: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        return .array([.floatingPoint(Double(width)), .floatingPoint(Double(height))])
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard
            case .array(let components) = playgroundValue,
            components.count == 2,
            case .floatingPoint(let width) = components[0],
            case .floatingPoint(let height) = components[1]
            
            else { return nil }
        return CGSize(width: width, height: height)
    }
    
}

extension CGVector: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        return .array([.floatingPoint(Double(dx)), .floatingPoint(Double(dy))])
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard
            case .array(let components) = playgroundValue,
            components.count == 2,
            case .floatingPoint(let dx) = components[0],
            case .floatingPoint(let dy) = components[1]
            
            else { return nil }
        
        return CGVector(dx: dx, dy: dy)
    }
}

extension Point: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        return .array([.floatingPoint(Double(x)), .floatingPoint(Double(y))])
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard
            case .array(let components) = playgroundValue,
            components.count == 2,
            case .floatingPoint(let x) = components[0],
            case .floatingPoint(let y) = components[1]
            
            else { return nil }
        return Point(x: x, y: y)
    }
    
}



extension UIColor: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
       
        return .array([.floatingPoint(Double(redComponent)),
                       .floatingPoint(Double(greenComponent)),
                       .floatingPoint(Double(blueComponent)),
                       .floatingPoint(Double(alpha))])
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard
            case .array(let components) = playgroundValue,
            components.count == 4,
            case .floatingPoint(let red)   = components[0],
            case .floatingPoint(let green) = components[1],
            case .floatingPoint(let blue)  = components[2],
            case .floatingPoint(let alpha) = components[3] else { return nil }
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
}

extension Tone: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        
        return .array([.floatingPoint(Double(pitch)),
                       .floatingPoint(Double(volume))])
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard
            case .array(let components) = playgroundValue,
            components.count == 2,
            case .floatingPoint(let pitch)   = components[0],
            case .floatingPoint(let volume) = components[1] else { return nil }
        
        return Tone(pitch: pitch, volume: volume)
    }
    
}



extension UIImage: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        var imgData:Data?
        if let data = self.pngData() {
            imgData = data
        }
        else {
            // The image is backed by a non-CGImage type. We'll need to render a copy to send it across the wire.
            let renderer = UIGraphicsImageRenderer(size: self.size)
            imgData = renderer.pngData { ctx in
                self.draw(in: CGRect(origin: .zero, size: self.size))
            }
        }
      
        if let data = imgData {
            return .data(data)
        }
        else {
            return nil
        }
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .data(let data) = playgroundValue else { return nil }
      
        return UIImage(data: data)
    }
}


extension Image: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        if self.path == ImageUIImageResourceName {
            return self.uiImage.playgroundValue
        }
        else {
            return .string(path)
        }
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        
        switch playgroundValue {
        case .string(let path):
            return Image(imageLiteralResourceName: path)
        case .data(let data):
            if let uiimage = UIImage(data: data) {
                let img = Image(with: uiimage)
                return img
            }
            else {
                return nil
            }
        default:
            return nil
        }
    }
}

extension BasicShape: PlaygroundValueTransformable {
    public var playgroundValue: PlaygroundValue? {
        var values = [String: PlaygroundValue]()

        switch self {
        case .circle(let radius, let color, let gradientColor):
            values["type"] = .string("circle")
            values["radius"] = .integer(radius)
            values["color"] = color.playgroundValue
            values["gradientColor"] = gradientColor.playgroundValue
        case .rectangle(let width, let height, let cornerRadius, let color, let gradientColor):
            values["type"] = .string("rectangle")
            values["width"] = .integer(width)
            values["height"] = .integer(height)
            values["cornerRadius"] = .floatingPoint(cornerRadius)
            values["color"] = color.playgroundValue
            values["gradientColor"] = gradientColor.playgroundValue
        case .polygon(let radius, let sides, let color, let gradientColor):
            values["type"] = .string("polygon")
            values["radius"] = .integer(radius)
            values["sides"] = .integer(sides)
            values["color"] = color.playgroundValue
            values["gradientColor"] = gradientColor.playgroundValue
        case .star(let radius, let points, let sharpness, let color, let gradientColor):
            values["type"] = .string("star")
            values["radius"] = .integer(radius)
            values["points"] = .integer(points)
            values["sharpness"] = .floatingPoint(sharpness)
            values["color"] = color.playgroundValue
            values["gradientColor"] = gradientColor.playgroundValue
        }
        return .dictionary(values)
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard
            case .dictionary(let values) = playgroundValue,
            case .string(let shapeType)? = values["type"]
            else { return nil }
        
        var returnShape: BasicShape?
        
        switch shapeType {
        case "circle":
            guard
                case .integer(let radius)? = values["radius"],
                case .array(let color)? = values["color"],
                case .array(let gradientColor)? = values["gradientColor"]
                else { return nil }
            if let playgroundColorValue = color.playgroundValue,
               let color = UIColor.from(playgroundColorValue) as? Color,
               let playgroundGradientColorValue = gradientColor.playgroundValue,
               let gradientColor = UIColor.from(playgroundGradientColorValue) as? Color {
                returnShape = .circle(radius: radius, color: color, gradientColor: gradientColor)
            }
            
        case "rectangle":
            guard
                case .integer(let width)? = values["width"],
                case .integer(let height)? = values["height"],
                case .floatingPoint(let cornerRadius)? = values["cornerRadius"],
                case .array(let color)? = values["color"],
                case .array(let gradientColor)? = values["gradientColor"]
                else { return nil }
            
            if let playgroundColorValue = color.playgroundValue,
                let color = UIColor.from(playgroundColorValue) as? Color,
                let playgroundGradientColorValue = gradientColor.playgroundValue,
                let gradientColor = UIColor.from(playgroundGradientColorValue) as? Color {
                returnShape = .rectangle(width: width, height: height, cornerRadius: cornerRadius, color: color, gradientColor: gradientColor)
            }
            
        case "polygon":
            guard
                case .integer(let radius)? = values["radius"],
                case .integer(let sides)? = values["sides"],
                case .array(let color)? = values["color"],
                case .array(let gradientColor)? = values["gradientColor"]
                else { return nil }
            
            if let playgroundColorValue = color.playgroundValue,
                let color = UIColor.from(playgroundColorValue) as? Color,
                let playgroundGradientColorValue = gradientColor.playgroundValue,
                let gradientColor = UIColor.from(playgroundGradientColorValue) as? Color {
                returnShape = .polygon(radius: radius, sides: sides, color: color, gradientColor: gradientColor)
            }
            
        case "star":
            guard
                case .integer(let radius)? = values["radius"],
                case .integer(let points)? = values["points"],
                case .floatingPoint(let sharpness)? = values["sharpness"],
                case .array(let color)? = values["color"],
                case .array(let gradientColor)? = values["gradientColor"]
                else { return nil }
            
            if let playgroundColorValue = color.playgroundValue,
                let color = UIColor.from(playgroundColorValue) as? Color,
                let playgroundGradientColorValue = gradientColor.playgroundValue,
                let gradientColor = UIColor.from(playgroundGradientColorValue) as? Color {
                returnShape = .star(radius: radius, points: points, sharpness: sharpness, color: color, gradientColor: gradientColor)
            }
            
        default:
            break
            
        }
        
        return returnShape
    }
}

extension Sound: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        return .string(String(rawValue))
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .string(let sound) = playgroundValue else { return nil }
        
        return Sound(rawValue: sound)
    }
}

extension AssessmentTrigger: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        var array = [PlaygroundValue]()
        array.append(.integer(rawValue[0]))
        if(rawValue.count > 1) {
            array.append(.integer(rawValue[1]))
        }
        
        return .array(array)
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard
            case .array(let array) = playgroundValue,
            array.count > 0,
            case .integer(let trigger) = array[0]
            else { return nil }
        
        var returnTrigger: AssessmentTrigger?
       
        switch trigger {
        
        case 0:
            guard
                array.count > 1,
                case .integer(let rawValue) = array[1],
                let context = AssessmentInfo.Context(rawValue: rawValue)
                else { return nil }
            returnTrigger = .start(context: context)
            
        case 1:
            returnTrigger = .stop
            
        case 2:
            returnTrigger = .evaluate
            
        default:
            returnTrigger = nil
        }

        return returnTrigger
    }
}

extension Array: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        var values = [PlaygroundValue]()
        self.forEach { item in
            if let transformable = item as? PlaygroundValueTransformable,
                let value = transformable.playgroundValue {
                values.append(value)
            }
        }
        guard values.count > 0 else { return nil }
        
        return .array(values)
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .array(let values) = playgroundValue else { return nil }
        var messages = [Message]()
        for value in values {
            if let message = Message(rawValue: value) { messages.append(message) }
        }
        guard messages.count > 0 else { return nil }
        
        return messages
    }
    
}

extension Dictionary: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        var values = [String : PlaygroundValue]()
        for (key, value) in self {
            if let stringKey = key as? String,
               let transformable = value as? PlaygroundValueTransformable,
                let pgValue = transformable.playgroundValue {
                values[stringKey] = pgValue
            }
        }
        guard values.count > 0 else { return nil }
        return .dictionary(values)
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .dictionary(let values) = playgroundValue else { return nil }
        var messages = [String : Message]()
        for (key, value) in values {
            if let message = Message(rawValue: value) { messages[key] = message }
        }
        guard messages.count > 0 else { return nil }
        
        return messages
    }
    
}


extension SKAction: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        return .data(data)
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .data(let data) = playgroundValue else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? SKAction
    }
}


extension Touch: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        guard
            let positionValue = CGPoint(position).playgroundValue,
            let distanceValue = previousPlaceDistance.playgroundValue,
            let firstTouch = firstTouch.playgroundValue
        else { return nil }
        
        var array = [positionValue, distanceValue, firstTouch]
        
        if let touchedGraphic = touchedGraphic?.playgroundValue {
            array.append(touchedGraphic)
        }

        return .array(array)
        
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard
            case .array(let array) = playgroundValue, array.count > 2,
            let touchPosition = CGPoint.from(array[0]) as? CGPoint,
            let touchDistance = Double.from(array[1]) as? Double,
            let firstTouch = Bool.from(array[2]) as? Bool
        else { return nil }
        
        var touchedGraphic: Graphic? = nil
        
        if array.count > 3 {
           touchedGraphic = Graphic.from(array[3])
        }

        return Touch(position: Point(touchPosition),
                     previousPlaceDistance: touchDistance,
                     firstTouch: firstTouch,
                     touchedGraphic: touchedGraphic)

    }
}

extension Collision: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        guard let graphicAValue = spriteA.playgroundValue, let graphicBValue = spriteB.playgroundValue, let normalContact = CGVector(fromVector: angle).playgroundValue, let impulse = force.playgroundValue else { return nil }
        let array = [graphicAValue,graphicBValue, normalContact, impulse]
        return .array(array)
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard
            case .array(let array) = playgroundValue, array.count > 3,
            let spriteA: Sprite = Sprite.from(array[0]),
            let spriteB: Sprite = Sprite.from(array[1]),
            let angle = CGVector.from(array[2]) as? CGVector,
            let force = Double.from(array[3]) as? Double
            else { return nil }
        
        let vector = Vector(dx: Double(angle.dx), dy: Double(angle.dy))
        return Collision(spriteA: spriteA, spriteB: spriteB, angle: vector, force: force)
    }
}

extension Graphic: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        var info = [String : PlaygroundValue]()
        info["id"] = id.playgroundValue
        info["graphicType"] = graphicType.rawValue.playgroundValue
        info["position"] = CGPoint(position).playgroundValue
        info["rotation"] = rotationRadians.playgroundValue
        info["xScale"] = xScale.playgroundValue
        info["yScale"] = yScale.playgroundValue
        info["text"] = text.playgroundValue
        info["alpha"] = alpha.playgroundValue
        info["name"] = name.playgroundValue
        
        if let sprite = self as? Sprite {
            info["isDynamic"] = sprite.isDynamic.playgroundValue
            info["allowsRotation"] = sprite.allowsRotation.playgroundValue
            info["isAffectedByGravity"] = sprite.isAffectedByGravity.playgroundValue
        }
        
        return .dictionary(info)
    }
    
    public static func from<T>(_ playgroundValue: PlaygroundValue) ->T? {
        
        guard case .dictionary(let info) = playgroundValue else { return nil }
        
        var graphic: Graphic? = nil
        
        if let value = info["id"], let graphicTypeValue = info["graphicType"] {
            guard
                let id = String.from(value) as? String,
                let graphicTypeRawValue = String.from(graphicTypeValue) as? String,
                let graphicType = GraphicType(rawValue: graphicTypeRawValue)
                else { return nil }
            switch graphicType {
            case .sprite:
                graphic = Sprite(id: id, graphicType: .sprite)
            default:
                graphic = Graphic(id: id)
            }
        }
        
        graphic?.suppressMessageSending = true
        
        if let value = info["position"], let position = CGPoint.from(value) as? CGPoint {
            graphic?.position = Point(position)
        }

        if let value = info["rotation"], let rotation = CGFloat.from(value) as? CGFloat {
            graphic?.rotationRadians = rotation
        }

        if let value = info["scale"], let scale = Double.from(value) as? Double {
            graphic?.scale = scale
        }

        if let value = info["text"], let text = String.from(value) as? String {
            graphic?.text = text
        }

        if let value = info["alpha"], let alpha = Double.from(value) as? Double {
            graphic?.alpha = alpha
        }
        
        if let value = info["name"], let name = String.from(value) as? String {
            graphic?.name = name
        }
        
        if let sprite = graphic as? Sprite {
            
            if let value = info["isDynamic"], let isDynamic = Bool.from(value) as? Bool {
                sprite.isDynamic = isDynamic
            }
            
            if let value = info["allowsRotation"], let allowsRotation = Bool.from(value) as? Bool {
                sprite.allowsRotation = allowsRotation
            }
            
            if let value = info["isAffectedByGravity"], let isAffectedByGravity = Bool.from(value) as? Bool {
                sprite.isAffectedByGravity = isAffectedByGravity
            }
        }
        
        graphic?.suppressMessageSending = false
        
        return graphic as? T
    }
}

// PlaygroundValue is used as the value in the dictionary when the underlying type is a collection type: Array, Dictionary.
extension PlaygroundValue: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
     
        return self
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        switch playgroundValue {
        case .array(let array):
            return PlaygroundValueArray(array: array)
            
        case .dictionary(let dictionary):
            return PlaygroundValueDictionary(dictionary: dictionary)
            
        default:
            return nil
        }
    }
}



public struct PlaygroundValueArray: PlaygroundValueTransformable {
    
    public var array: [PlaygroundValue]? = nil
    
    
    init(array: [PlaygroundValue]) {
        self.array = array
    }
    
    
    init?(playgroundValue: PlaygroundValue) {
        guard case .array(let playgroundValues) = playgroundValue else { return nil }
        array = playgroundValues
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .array(let playgroundValues) = playgroundValue else { return nil }
        
        return PlaygroundValueArray(array: playgroundValues)
    }
    
    
    public var playgroundValue: PlaygroundValue? {
        guard let values = array else { return nil }
        return .array(values)
    }
    
}



public struct PlaygroundValueDictionary: PlaygroundValueTransformable {
    
    public var dictionary: [String : PlaygroundValue]? = nil
    
    
    init(dictionary: [String : PlaygroundValue]) {
        self.dictionary = dictionary
    }
    
    
    init?(playgroundValue: PlaygroundValue) {
        guard case .dictionary(let dictionary) = playgroundValue else { return nil }
        self.dictionary = dictionary
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .dictionary(let dictionary) = playgroundValue else { return nil }
        
        return PlaygroundValueDictionary(dictionary: dictionary)
    }
    
    
    public var playgroundValue: PlaygroundValue? {
        guard let info = dictionary else { return nil }
        return .dictionary(info)
    }
    
}

extension PlaygroundPage.AssessmentStatus: PlaygroundValueTransformable {
    // MARK: Assessment 
    
    public var playgroundValue: PlaygroundValue? {
        let passed: Bool
        let message: String?
        let hints: [String]
        
        switch self {
        case let .pass(success):
            passed = true
            hints = []
            message = success
            
        case let .fail(failureHints, solution):
            passed = false
            hints = failureHints
            message = solution
        }
        
        let hintValues: [PlaygroundValue] = hints.map {
            return .string($0)
        }
        
        var values: [PlaygroundValue] = [.boolean(passed), .array(hintValues)]
        if let message = message {
            values += [.string(message)]
        }
        
        return .array(values)
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case let .array(arr) = playgroundValue else { return nil }
        guard case let .boolean(passed)? = arr.first else { return nil }
        
        if passed {
            var message: String? = nil
            if case let .string(m)? = arr.last {
                message = m
            }
            
            return PlaygroundPage.AssessmentStatus.pass(message: message)
        }
        else {
            var message: String? = nil
            if case let .string(m)? = arr.last {
                message = m
            }
            
            var hints = [String]()
            if arr.count > 2, case let .array(hintValues) = arr[1] {
                hints = hintValues.compactMap { value in
                    guard case let .string(hint) = value else { return nil }
                    return hint
                }
            }
            
            return PlaygroundPage.AssessmentStatus.fail(hints: hints, solution: message)
        }
    }
    
}

extension Overlay: PlaygroundValueTransformable {

    public var playgroundValue: PlaygroundValue? {
        return .integer(rawValue)
    }

    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .integer(let intValue) = playgroundValue else { return nil }
        return Overlay(rawValue: intValue)
    }
}

extension AccessibilityHints: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        let encoder = JSONEncoder()
        
        guard let data = try? encoder.encode(self) else { return nil }
        
        return .data(data)
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .data(let data) = playgroundValue else { return nil }
        
        let decoder = JSONDecoder()
        
        return try? decoder.decode(AccessibilityHints.self, from: data)
    }
}


