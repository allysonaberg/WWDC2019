// 
//  UIImageExtensions.swift
//
//  Copyright © 2016-2018 Apple Inc. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Returns a copy of the image scaled to size.
    ///
    /// - Parameter size: The size an image should scale.
    ///
    /// - localizationKey: UIImage.scaledImage(size:)
    public func scaledImage(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    func disabledImage(alpha: CGFloat) -> UIImage? {
        let context = CIContext(options: nil)
        guard let filter = CIFilter(name: "CIColorControls") else { return nil }
        filter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        filter.setValue(0.0, forKey: kCIInputSaturationKey)
        guard let output = filter.outputImage else { return nil }
        
        guard let cgImage = context.createCGImage(output, from: output.extent) else { return nil }
        let processedImage = UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        return UIAccessibility.isReduceTransparencyEnabled ? processedImage : processedImage.imageWithAlpha(alpha: alpha)
    }
    
    func imageWithAlpha(alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Returns an image for text (temporary).
    ///
    /// - Parameter text: The placeholder text used to represent an image.
    ///
    /// - localizationKey: UIImage.image(text:)
    public static func image(text: String) -> UIImage {
        let defaultSize = CGSize(width: 23, height: 27) // Default size for emoji with the chosen font and font size.
        let textColor: UIColor =  #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        let fontName: Font = .SystemFontRegular
        let fontSize: Int = 20
        
        let font = UIFont(name: fontName.rawValue, size: CGFloat(fontSize)) ?? UIFont.systemFont(ofSize: CGFloat(fontSize))
        
        let sourceCharacter = text as NSString
        let attributes: [NSAttributedString.Key: Any] = [.font : font, .foregroundColor: textColor]
        var textSize = sourceCharacter.size(withAttributes: attributes)
        if textSize.width < 1 || textSize.height < 1 {
            textSize = defaultSize
        }
        UIGraphicsBeginImageContextWithOptions(textSize, false, 0.0)
        
        sourceCharacter.draw(in: CGRect(x:0, y:0, width:textSize.width,  height:textSize.height), withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
    /// Returns a copy of the image overlaid with another image in the center.
    ///
    /// - Parameter overlayImage: The image to overlay.
    /// - Parameter offset: The amount by which to offset the overlay image from the center. Defaults to zero.
    ///
    /// - localizationKey: UIImage.overlaid(with:offsetBy:)
    public func overlaid(with overlayImage: UIImage, offsetBy offset: CGPoint = CGPoint.zero) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(at: CGPoint.zero)
        overlayImage.draw(at: CGPoint(x: (size.width / 2 - overlayImage.size.width / 2) + offset.x,
                                      y: (size.height / 2 - overlayImage.size.height / 2) + offset.y))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}
