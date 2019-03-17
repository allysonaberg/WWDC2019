// 
//  DynamicComposerViewController.swift
//
//  Copyright © 2016-2018 Apple Inc. All rights reserved.
//


import UIKit
import UIKit.UIGestureRecognizerSubclass
import PlaygroundSupport
import Foundation
import SpriteKit

public let sceneSize = CGSize(width:1000, height: 1000)
public let contentInset : CGFloat = 10 // The amount we’ll inset the edge length to pull it away from the edge

public class DynamicComposerViewController : UIViewController, PlaygroundLiveViewSafeAreaContainer, UIGestureRecognizerDelegate, LiveViewSceneDelegate {
    
    let kTopButtonAvoidanceMargin = CGFloat(80)
    let kMinTopAvoidanceMargin = CGFloat(20)
    let kSmallSafeAreaLimit = CGFloat(350)
    var messageProcessingQueue: DispatchQueue? = nil
    let skView = LiveView(frame: .zero)
    let masterStackView = UIStackView(arrangedSubviews: [])
    let axUIStackView = AXUIStackView(arrangedSubviews:[])
    let axUIToneView = ToneAccessibilityView(frame: .zero)
    let axUILightView = LightAccessibilityView(frame: .zero)
    let liveViewScene = LiveViewScene(size: sceneSize)
    let backgroundView = UIView(frame: .zero)
    let audioBarButton = BarButton()
    let axUIBarButton = BarButton()
    let sensorInputUIShowing = "sensorInputUIShowing"
    var topButtonAvoidanceConstraint: NSLayoutConstraint?
    
    var sendTouchEvents:Bool = false
    var constraintsAdded = false
    var standardBackgroundImageSet = false
    var receivedAXToneMessage = false
    var receivedAXColorMessage = false
    var receivedAXMessageTimer: Timer?
    
    var accessibilityUIEnabled: Bool = false {
        didSet {
            updateAXUIButton()
            
            if accessibilityUIEnabled {
                if let showingPlaygroundValue = PlaygroundKeyValueStore.current[sensorInputUIShowing] {
                    if case let .boolean(showing) = showingPlaygroundValue {
                        accessibilityUIShowing = showing
                    }
                }
            }
        }
    }
    var accessibilityUIShowing: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3) {
                if self.accessibilityUIEnabled && self.accessibilityUIShowing {
                    self.axUIStackView.isHidden = false
                    self.axUIStackView.alpha = 1.0
                } else {
                    self.axUIStackView.alpha = 0.0
                    self.axUIStackView.isHidden = true
                }
                
                self.masterStackView.layoutIfNeeded()
                
                self.updateAXUIButton()
            }
            
            PlaygroundKeyValueStore.current[sensorInputUIShowing] = .boolean(accessibilityUIShowing)
        }
    }

    public var backgroundImage : Image? {
        didSet {
            var image : UIImage?
            if let bgImage = backgroundImage {
                image = UIImage(named: bgImage.path)
                
                standardBackgroundImageSet = false
            }
            else {
                // Default to the friends background when the background image
                image = UIImage(named:"background5")
                
                standardBackgroundImageSet = true
            }

            guard let imageView = backgroundView.subviews[0] as? UIImageView else { fatalError("failed to find backgroundImage imageView") }
            imageView.image = image
            imageView.contentMode = .center
        }
    }
    
    public var lightSensorImage : UIImage? {
        didSet {
            var image : UIImage?
            if var lsImage = lightSensorImage {
                
                if interfaceOrientation != .landscapeRight, let cgImage = lsImage.cgImage {
                    var orientation = UIImage.Orientation.up
                    
                    // rotate image if necessary
                    if interfaceOrientation == .portrait {
                        orientation = .left
                    } else if interfaceOrientation == .landscapeLeft {
                        orientation = .down
                    } else if interfaceOrientation == .portraitUpsideDown {
                        orientation = .right
                    }
                    
                    lsImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: orientation)
                }
                
                // don’t override a set background
                if standardBackgroundImageSet || backgroundImage == nil {
                    image = lsImage
                    
                    guard let imageView = backgroundView.subviews[0] as? UIImageView else { fatalError("failed to find backgroundImage imageView") }
                    imageView.image = image
                    imageView.contentMode = .scaleAspectFit
                }
            } else {
                // Default to the friends background when the background image
                backgroundImage = nil
            }
        }
    }
    
    // MARK: View Controller Lifecycle
    
    public override func viewDidLoad() {
        Process.setIsLive()
        // The scene needs to inform us of some events
        liveViewScene.sceneDelegate = self
        // Because the background image is *not* part of the scene itself, transparency is needed for the view and scene
        skView.allowsTransparency = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        skView.translatesAutoresizingMaskIntoConstraints = false
        masterStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundView)
        view.addSubview(masterStackView)
        
        topButtonAvoidanceConstraint = masterStackView.topAnchor.constraint(greaterThanOrEqualTo: liveViewSafeAreaGuide.topAnchor, constant: kTopButtonAvoidanceMargin)
        
        let masterStackViewConstraints = [
            masterStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            masterStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            masterStackView.leftAnchor.constraint(greaterThanOrEqualTo: liveViewSafeAreaGuide.leftAnchor, constant: contentInset),
            masterStackView.bottomAnchor.constraint(lessThanOrEqualTo: liveViewSafeAreaGuide.bottomAnchor),
            masterStackView.rightAnchor.constraint(lessThanOrEqualTo: liveViewSafeAreaGuide.rightAnchor, constant: -contentInset),
            topButtonAvoidanceConstraint!
        ]
        
        // allow masterStackView centering constraints to be broken
        masterStackViewConstraints[0].priority = .defaultLow
        masterStackViewConstraints[1].priority = .defaultLow
        
        NSLayoutConstraint.activate(masterStackViewConstraints)
        
        masterStackView.addArrangedSubview(skView)
        masterStackView.addArrangedSubview(axUIStackView)
        
        axUIStackView.isHidden = true
        axUIStackView.alpha = 0.0
        
        skView.presentScene(liveViewScene)

        func _constrainCenterAndSize(parent: UIView, child: UIView) {
            child.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                child.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
                child.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
                child.widthAnchor.constraint(equalTo: parent.widthAnchor),
                child.heightAnchor.constraint(equalTo: parent.heightAnchor)
                ])
        }

        let borderColorView = AddressableContentBorderView(frame: .zero)
        skView.addSubview(borderColorView)
        _constrainCenterAndSize(parent: skView, child: borderColorView)
        
        // Create a blue background image
        let image : UIImage? = {
            UIGraphicsBeginImageContextWithOptions(CGSize(width:2500, height:2500), false, 2.0)
            #colorLiteral(red: 0.1911527216, green: 0.3274578452, blue: 0.4287572503, alpha: 1).set()
            UIRectFill(CGRect(x: 0, y: 0, width: 2500, height: 2500))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }()
        let defaultBackgroundView = UIImageView(image:image)
        defaultBackgroundView.contentMode = .center
        defaultBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(defaultBackgroundView)
        
        audioBarButton.translatesAutoresizingMaskIntoConstraints = false
        audioBarButton.addTarget(self, action: #selector(didTapAudioBarButton(_:)), for: .touchUpInside)
        view.addSubview(audioBarButton)
        
        _constrainCenterAndSize(parent: view, child: backgroundView)
        _constrainCenterAndSize(parent: backgroundView, child: defaultBackgroundView)
        
        NSLayoutConstraint.activate([
            skView.widthAnchor.constraint(equalTo: skView.heightAnchor),
            audioBarButton.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: 20),
            audioBarButton.trailingAnchor.constraint(equalTo: liveViewSafeAreaGuide.trailingAnchor, constant: -20),
            audioBarButton.widthAnchor.constraint(equalToConstant: 44),
            audioBarButton.heightAnchor.constraint(equalToConstant: 44)
            ])
        
        axUIBarButton.translatesAutoresizingMaskIntoConstraints = false
        axUIBarButton.addTarget(self, action: #selector(didTapAXUIBarButton(_:)), for: .touchUpInside)
        view.addSubview(axUIBarButton)
        
        NSLayoutConstraint.activate([
            axUIBarButton.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: 20),
            axUIBarButton.trailingAnchor.constraint(equalTo: liveViewSafeAreaGuide.trailingAnchor, constant: -80),
            axUIBarButton.widthAnchor.constraint(equalToConstant: 44),
            axUIBarButton.heightAnchor.constraint(equalToConstant: 44)
            ])
        
        updateAudioButton()
        updateAXUIButton()
        updateStackViews()
        registerForTapGesture()
    }

    public override func viewWillAppear(_ animated: Bool) {
        guard constraintsAdded == false else { return }
        if let parentView = self.view.superview {
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
                view.widthAnchor.constraint(equalTo: parentView.widthAnchor),
                view.heightAnchor.constraint(equalTo: parentView.heightAnchor)])
        }
        constraintsAdded = true
    }
    
    // MARK: Layout
    
    public override func viewDidLayoutSubviews() {
        updateStackViews()
        
        if let topButtonAvoidanceConstraint = topButtonAvoidanceConstraint {
            if liveViewSafeAreaGuide.layoutFrame.height < kSmallSafeAreaLimit {
                topButtonAvoidanceConstraint.constant = kMinTopAvoidanceMargin
            } else {
                topButtonAvoidanceConstraint.constant = kTopButtonAvoidanceMargin
            }
        }
    }
    
    // MARK: Audio
    
    private func updateAudioButton() {
        audioBarButton.setTitle(nil, for: .normal)
        let allAudioEnabled = audioController.isAllAudioEnabled
        let iconImage = allAudioEnabled ? UIImage(named: "AudioOn") : UIImage(named: "AudioOff")
        audioBarButton.accessibilityLabel = allAudioEnabled ?
            NSLocalizedString("Sound On", comment: "AX hint for Sound On button") :
            NSLocalizedString("Sound Off", comment: "AX hint for Sound Off button")
        audioBarButton.setImage(iconImage, for: .normal)
    }
    
    private func updateAXUIButton() {
        axUIBarButton.setTitle(nil, for: .normal)
        let iconImage = UIImage(named: "AXUIToggle")
        axUIBarButton.accessibilityLabel = accessibilityUIShowing ?
            NSLocalizedString("Input Simulator On", comment: "AX hint for Input Simulator On button") :
            NSLocalizedString("Input Simulator Off", comment: "AX hint for Input Simulator Off button")
        axUIBarButton.setImage(iconImage, for: .normal)
        axUIBarButton.isHidden = !accessibilityUIEnabled
    }
    
    private func updateStackViews() {
        let horizontalLayout = liveViewSafeAreaGuide.layoutFrame.size.width > liveViewSafeAreaGuide.layoutFrame.size.height
        
        masterStackView.axis = horizontalLayout ? .horizontal : .vertical
        masterStackView.distribution = .fill
        masterStackView.alignment = .center
        masterStackView.spacing = 5.0
        
        axUIStackView.axis = horizontalLayout ? .vertical : .horizontal
        axUIStackView.distribution = .fill
        axUIStackView.alignment = .center
        axUIStackView.spacing = 10.0
    }
    
    private func triggerAXUITimeout() {
        receivedAXToneMessage = false
        receivedAXColorMessage = false
        
        receivedAXMessageTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            if self.accessibilityUIEnabled && !(self.receivedAXToneMessage || self.receivedAXColorMessage) {
                self.accessibilityUIEnabled = false
                self.accessibilityUIShowing = false
            }
            
            self.updateToneAXUIView()
            self.updateColorAXUIView()
            
            self.receivedAXMessageTimer = nil
        }
    }
    
    private func updateToneAXUIView() {
        if !self.axUIStackView.arrangedSubviews.contains(self.axUIToneView) && receivedAXToneMessage {
            self.axUIStackView.addArrangedSubview(self.axUIToneView)
            
            self.axUIToneView.delegate = self
        } else if !receivedAXToneMessage {
            self.axUIStackView.removeArrangedSubview(self.axUIToneView)
            
            self.axUIToneView.removeFromSuperview()
        }
    }
    
    private func updateColorAXUIView() {
        if !self.axUIStackView.arrangedSubviews.contains(self.axUILightView) && receivedAXColorMessage {
            self.axUIStackView.addArrangedSubview(self.axUILightView)
            
            self.axUILightView.delegate = self
        } else if !receivedAXColorMessage {
            self.axUIStackView.removeArrangedSubview(self.axUILightView)
            
            self.axUILightView.removeFromSuperview()
        }
    }

    /// Dismisses the audio menu if visible. Returns true if there was a menu to dismiss
    @discardableResult
    func dismissAudioMenu() -> Bool {
        if let vc = presentedViewController as? AudioMenuController {
            vc.dismiss(animated: true, completion: nil)
            return true
        }
        return false
    }
    
    // MARK: Actions

    @objc
    func didTapAudioBarButton(_ button: UIButton) {
        if dismissAudioMenu() {
            // Just dismissing a previously presented `AudioMenuController`.
            return
        }
        
        let menu = AudioMenuController()
        menu.modalPresentationStyle = .popover
        menu.popoverPresentationController?.passthroughViews = [view]
        menu.popoverPresentationController?.backgroundColor = .white
        
        menu.popoverPresentationController?.permittedArrowDirections = .up
        menu.popoverPresentationController?.sourceView = button
        
        // Offset the popup arrow under the button.
        menu.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 5, width: 44, height: 44)
        
        menu.popoverPresentationController?.delegate = self
        menu.backgroundAudioEnabled = audioController.isBackgroundAudioEnabled
        menu.soundEffectsAudioEnabled = audioController.isSoundEffectsAudioEnabled
        menu.delegate = self
        
        present(menu, animated: true, completion: nil)
    }
    
    // MARK: Tap Gesture
    
    func registerForTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapAction(_ recognizer: UITapGestureRecognizer) {
        dismissAudioMenu()
    }
    
    @objc
    func didTapAXUIBarButton(_ sender: Any) {
        accessibilityUIShowing = !accessibilityUIShowing
    }
    
    override public func didReceiveMemoryWarning() {
        LiveViewGraphic.didReceiveMemoryWarning()
    }
}

public class AXUIStackView : UIStackView {
    override public var axis: NSLayoutConstraint.Axis {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        get {
            var size = CGSize.zero
            
            arrangedSubviews.forEach {
                if axis == .horizontal {
                    size.width += $0.intrinsicContentSize.width
                    size.height = max(size.height, $0.intrinsicContentSize.height)
                } else {
                    size.width = max(size.width, $0.intrinsicContentSize.width)
                    size.height += $0.intrinsicContentSize.height
                }
            }
            
            return size
        }
    }
}

public class LiveView : SKView, PlaygroundLiveViewSafeAreaContainer {
    let contentEdgeLength : CGFloat = max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.width) / 2.0
    
    override public var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: contentEdgeLength, height: contentEdgeLength)
        }
    }

    override public func contentCompressionResistancePriority(for axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
        return .defaultLow
    }
}

public class SelfIgnoringView : UIView {
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if (view == self) {
            return nil
        }
        return view
    }
}

public class AddressableContentBorderView : SelfIgnoringView {
    override public var isOpaque: Bool {
        set {}
        get { return false }
    }
    override public func draw(_ rect: CGRect) {
        UIColor.clear.set()
        let path = UIBezierPath(rect: self.bounds)
        path.fill()

        let pattern = Array<CGFloat>(arrayLiteral: 3.0, 3.0)
        path.setLineDash(pattern, count: 2, phase: 0.0)
        path.lineJoinStyle = .round
        UIColor.white.set()
        path.stroke()
    }
}

extension DynamicComposerViewController : PlaygroundLiveViewMessageHandler {
    
    public func liveViewMessageConnectionOpened() {
        PBLog()
        messageProcessingQueue = DispatchQueue(label: "Message Processing Queue")
        liveViewScene.connectedToUserCode()
        
        triggerAXUITimeout()
        enableFullScreenLiveViewIfNeeded()
    }
    
    public func liveViewMessageConnectionClosed() {
        PBLog()
        liveViewScene.disconnectedFromUserCode()
        disableFullScreenLiveViewIfNeeded()
    }
    
    public func receive(_ message: PlaygroundValue) {
        messageProcessingQueue?.async { [unowned self] in
            self.processMessage(message)
        }
    }
    
    private func processMessage(_ message: PlaygroundValue) {
        guard let unpackedMessage = Message(rawValue: message) else {
            return
        }

        switch unpackedMessage {
   
        case .registerTouchHandler(let registered):
            DispatchQueue.main.async { [unowned self] in
                self.sendTouchEvents = registered
            }
            
        case .setAXUITone(_):
            DispatchQueue.main.async { [unowned self] in
                self.receivedAXToneMessage = true
                
                self.updateToneAXUIView()
                
                self.accessibilityUIEnabled = true
            }
        
        case .setAXUIColor(_):
            DispatchQueue.main.async { [unowned self] in
                self.receivedAXColorMessage = true
                
                self.updateColorAXUIView()
                
                self.accessibilityUIEnabled = true
            }
          
        default:
            self.liveViewScene.handleMessage(message: unpackedMessage)
        }
    }
    
    func enableFullScreenLiveViewIfNeeded() {
        if traitCollection.horizontalSizeClass == .compact {
            PlaygroundPage.current.wantsFullScreenLiveView = true
        }
    }
    
    func disableFullScreenLiveViewIfNeeded() {
        PlaygroundPage.current.wantsFullScreenLiveView = false
    }
    
}

extension DynamicComposerViewController: AudioMenuDelegate {
    // MARK: AudioMenuDelegate
    
    func enableSoundEffectsAudio(_ isEnabled: Bool) {
        audioController.isSoundEffectsAudioEnabled = isEnabled
        updateAudioButton()
    }
    
    func enableBackgroundAudio(_ isEnabled: Bool) {
        audioController.isBackgroundAudioEnabled = isEnabled
        updateAudioButton()
        
        // Resume (actually restart) background audio if it had been playing.
        if isEnabled, let backgroundMusic = audioController.backgroundAudioMusic {
            audioController.playBackgroundAudioLoop(backgroundMusic)
        }
    }
}

extension DynamicComposerViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension DynamicComposerViewController: ToneAccessibilityDelegate {
    public func accessibilityToneGenerated(tone: Tone) {
        liveViewScene.enqueue(.setAXUITone(tone))
    }
}

extension DynamicComposerViewController: LightAccessibilityDelegate {
    public func accessibilityColorGenerated(color: Color) {
        liveViewScene.enqueue(.setAXUIColor(color))
    }
}

