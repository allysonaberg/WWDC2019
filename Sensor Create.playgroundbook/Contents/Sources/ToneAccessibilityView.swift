//
//  ToneAccessibilityView.swift
//  SupportingContent
//
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

protocol ToneAccessibilityDelegate {
    func accessibilityToneGenerated(tone: Tone)
}

class ToneAccessibilityView : UIView {
    private let toneImage = UIImage(named: "AXUITone")!
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
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(toneGesture(sender:)))
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(toneGesture(sender:)))
        
        longPressGestureRecognizer.minimumPressDuration = 0.0
        
        addGestureRecognizer(panGestureRecognizer)
        addGestureRecognizer(longPressGestureRecognizer)
        
        let imageView = UIImageView(image: toneImage)
        
        self.frame.size = toneImage.size
        
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = NSLocalizedString("Tone input region", comment: "AX: Tone input label")
        imageView.accessibilityHint = NSLocalizedString("Manually adjust Tone Sensor pitch and volume values. Slide left and right to adjust pitch. Slide up and down to adjust volume.", comment: "AX: Tone input hint")
        imageView.accessibilityTraits = .allowsDirectInteraction
        
        self.addSubview(imageView)
    }
    
    var tone:Tone = Tone(pitch: 0.0, volume: 0.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var delegate: ToneAccessibilityDelegate?
    
    override var intrinsicContentSize: CGSize {
        return toneImage.size
    }
    
    @objc
    func toneGesture(sender: UIGestureRecognizer) {
        var tone: Tone?
        
        let notifyDelegate: (Tone?) -> Void = { tone in
            if let delegate = self.delegate, let tone = tone {
                delegate.accessibilityToneGenerated(tone: tone)
            }
        }
        
        if (sender.state == .began || sender.state == .changed) && sender.numberOfTouches > 0 {
            let point = sender.location(ofTouch: 0, in: self)
            let marginInset = CGFloat(40.0)
            let toneBounds = CGRect(x: bounds.origin.x + marginInset , y: bounds.origin.y, width: bounds.size.width - marginInset, height: bounds.size.height - marginInset)
            
            if toneBounds.contains(point) {
                tone = Tone(pitch: Double((point.x - marginInset) / toneBounds.size.width) * 4000.0, volume: 1.0 - Double(point.y / toneBounds.size.height))
                
                continuousInputTimer?.invalidate()
                continuousInputTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
                    notifyDelegate(tone)
                })
            } else {
                tone = nil
            }
        }
        
        if sender.state == .ended || tone == nil {
            tone = Tone(pitch: 0.0, volume: 0.0) // turn off last tone
            
            continuousInputTimer?.invalidate()
        }
        
        notifyDelegate(tone)
    }
}
