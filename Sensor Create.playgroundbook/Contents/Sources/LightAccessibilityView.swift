//
//  LightAccessibilityView.swift
//  SupportingContent
//
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

protocol LightAccessibilityDelegate {
    func accessibilityColorGenerated(color: Color)
}

let spacing = CGFloat(10.0)

class LightAccessibilityView : UIView {
    private let hueImageView = UIImageView(image: UIImage(named: "AXUIHue"))
    private let brightnessImageView = UIImageView(image: UIImage(named: "AXUIBrightness"))
    private var hueSlider = UISlider(frame: .zero)
    private var brightnessSlider = UISlider(frame: .zero)
    var continuousInputTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        addSubview(hueImageView)
        hueImageView.isUserInteractionEnabled = true
        
        hueSlider.addTarget(self, action: #selector(updateColor(_:)), for: .valueChanged)
        hueSlider.addTarget(self, action: #selector(updateColor(_:)), for: .touchDown)
        hueSlider.frame = hueImageView.frame
        hueSlider.isUserInteractionEnabled = true
        hueSlider.minimumTrackTintColor = UIColor.clear
        hueSlider.maximumTrackTintColor = UIColor.clear
        hueSlider.isAccessibilityElement = true
        hueSlider.accessibilityLabel = NSLocalizedString("Hue slider", comment: "AX: Hue slider label")
        hueSlider.accessibilityHint = NSLocalizedString("Manually adjust Light Sensor hue value", comment: "AX: Hue slider hint")
        hueImageView.addSubview(hueSlider)
        
        var brightnessFrame = brightnessImageView.frame
        brightnessFrame.origin.y += brightnessFrame.size.height + spacing
        brightnessImageView.frame = brightnessFrame
        brightnessImageView.isUserInteractionEnabled = true
        addSubview(brightnessImageView)
        
        brightnessSlider.addTarget(self, action: #selector(updateColor(_:)), for: .valueChanged)
        brightnessSlider.addTarget(self, action: #selector(updateColor(_:)), for: .touchDown)
        brightnessSlider.frame = hueSlider.frame
        brightnessSlider.isUserInteractionEnabled = true
        brightnessSlider.minimumTrackTintColor = UIColor.clear
        brightnessSlider.maximumTrackTintColor = UIColor.clear
        brightnessSlider.isAccessibilityElement = true
        brightnessSlider.accessibilityLabel = NSLocalizedString("Brightness slider", comment: "AX: Brightness slider label")
        brightnessSlider.accessibilityHint = NSLocalizedString("Manually adjust Light Sensor brightness value", comment: "AX: Brightness slider hint")
        brightnessImageView.addSubview(brightnessSlider)
    }
    
    var color: Color = Color.white {
        didSet {
            hueSlider.value = Float(color.hue)
            brightnessSlider.value = Float(color.brightness)
        }
    }
    
    var delegate: LightAccessibilityDelegate?
    
    override var intrinsicContentSize: CGSize {
        get {
            var size = CGSize.zero
            
            if let image = hueImageView.image {
                size = CGSize(width: image.size.width, height: image.size.height * 2 + spacing)
            }
            
            return size
        }
    }
    
    @objc
    func updateColor(_ sender: UISlider) {
        if let delegate = delegate {
            let color = Color(hue: CGFloat(hueSlider.value), saturation: 1.0, brightness: CGFloat(1.0 - brightnessSlider.value), alpha: 1.0)
            
            let notifyDelegate: (Color) -> Void = { color in
                delegate.accessibilityColorGenerated(color: color)
            }
            
            continuousInputTimer?.invalidate()
            continuousInputTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
                notifyDelegate(color)
                
                if !sender.isTracking {
                    self.continuousInputTimer?.invalidate()
                }
            })
            
            notifyDelegate(color)
        }
    }
}
