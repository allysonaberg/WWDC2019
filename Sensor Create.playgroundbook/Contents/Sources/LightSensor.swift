//
//  LightSensor.swift
//  SupportingContent
//
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import AVFoundation
import UIKit
import Accelerate
import PlaygroundSupport

public enum LightSensorConfiguration {
    case front
    case back
}

/// Start taking in data from the camera. Use this object to receive five types of light data: brightness, color (red, green, and blue), alpha, saturation, and hue.
///
/// - localizationKey: LightSensor
public class LightSensor: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var captureSession = AVCaptureSession()
    var captureVideoOutput: AVCaptureVideoDataOutput?
    var isCaptureSessionConfigured = false
    var sessionQueue: DispatchQueue!
    var capturedBuffer: CMSampleBuffer?
    var didSenseLightHandler: ((_ color: Color) -> Void)?
    var sensorConfig: LightSensorConfiguration = .front
    var axOverrideTimer: Timer? = nil
    
    private override init() {}
    
    public convenience init(configuration: LightSensorConfiguration = .front) {
        self.init()
        
        sensorConfig = configuration
        
        sessionQueue = DispatchQueue(label: "session queue")
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.main) { notification in
            // reconfigure the running capture session to re-autoExpose the front camera after backgrounding and lock screen
            if self.sensorConfig == .front && self.captureSession.isRunning {
                self.stop()
                self.isCaptureSessionConfigured = false
                self.captureSession = AVCaptureSession()
                self.start()
            }
        }
        
        start()
    }
    
    /// The current sample of light.
    ///
    /// - localizationKey: LightSensor.currentSample
    public var currentSample: Color {
        var color = Color.black
        
        if axOverrideTimer != nil {
            color = axUIColor
        } else if let buffer = capturedBuffer {
            color = colorFromBuffer(sampleBuffer:buffer)
        }
        
        return color
    }
    
    /// Sets the handler to update the light data.
    /// - parameter handler: The function to be called whenever the light data is updated.
    ///
    /// - localizationKey: LightSensor.setOnUpdateHandler(_:)
    public func setOnUpdateHandler(_ handler: @escaping ((Color) -> Void)) {
        didSenseLightHandler = handler
    }
    
    /// Starts collecting data from the camera.
    ///
    /// - localizationKey: LightSensor.start()
    public func start() {
        
        if self.isCaptureSessionConfigured {
            
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
            
        } else {
            
            // First time: Request camera access, configure and start the capture session.
            self.checkCameraAuthorization(completionHandler: { authorized in
                
                print("checkCameraAuthorization \(authorized)")
                
                guard authorized else {
                    print("Permission to use camera denied.")
                    return
                }
                
                self.sessionQueue.async {
                    
                    self.configureCaptureSession(completionHandler: { success in
                        
                        guard success else { return }
                        
                        self.isCaptureSessionConfigured = true
                        
                        self.captureSession.startRunning()
                    })
                }
                
                DispatchQueue.main.async {
                    // signal to the live view that a light sensor is active
                    Message.setAXUIColor(self.currentSample).send()
                    
                    Scene.axUILightSensor = self
                }
            })
        }
        
    }
    
    /// Stops collecting data from the camera.
    ///
    /// - localizationKey: LightSensor.stop()
    public func stop() {
        guard isCaptureSessionConfigured else { return }
        
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    var axUIColor = Color.black {
        didSet {            
            axOverrideTimer?.invalidate()
            
            axOverrideTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.axOverrideTimer?.invalidate()
                self.axOverrideTimer = nil
            }
        }
    }
    
    func configureCaptureSession(completionHandler: ((_ success: Bool) -> Void)) {
        
        var success = false
        
        defer { completionHandler(success) }   // Called on exit.
        
        let position: AVCaptureDevice.Position = (sensorConfig == .front) ? .front : .back
        
        // Get video input.
        guard
            let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: position),
            let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice)
            else {
                print("Unable to obtain video input for default camera.")
                return
            }
        
        do {
            try videoCaptureDevice.lockForConfiguration()
            
            if sensorConfig == .front {
                videoCaptureDevice.exposureMode = .autoExpose
            }
            
            videoCaptureDevice.unlockForConfiguration()
        } catch {
            print("Unable to set torch level.")
        }
        
        // Create and configure the photo output.
        let captureVideoOutput = AVCaptureVideoDataOutput()
        
        captureVideoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        captureVideoOutput.videoSettings = [String(kCVPixelBufferPixelFormatTypeKey):kCVPixelFormatType_32BGRA]
        captureVideoOutput.alwaysDiscardsLateVideoFrames = true
        
        // Make sure inputs and output can be added to session.
        guard self.captureSession.canAddInput(videoInput) else { return }
        guard self.captureSession.canAddOutput(captureVideoOutput) else { return }
        
        // Configure the session.
        self.captureSession.beginConfiguration()
        self.captureSession.sessionPreset = AVCaptureSession.Preset.cif352x288
        self.captureSession.addInput(videoInput)
        self.captureSession.addOutput(captureVideoOutput)
        self.captureSession.commitConfiguration()
        
        self.captureVideoOutput = captureVideoOutput
        
        if let photoOutputConnection = captureVideoOutput.connection(with: AVMediaType.video) {
            photoOutputConnection.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        }
        
        success = true
    }
    
    func checkCameraAuthorization(completionHandler: @escaping ((_ authorized: Bool) -> Void)) {
        
        // Check camera authorization status. Video access is required; audio access is optional.
        // If audio access is denied, audio is not recorded during live photo recording.
        
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
            
        case .authorized:
            //The user has previously granted access to the camera.
            completionHandler(true)
            
        case .notDetermined:
            // The user has not yet been presented with the option to grant video access so request access.
            
            // We suspend the session queue to delay session setup until the access request has completed to avoid
            // asking the user for audio access if video access is denied.
            // Note that audio access will be implicitly requested when we create an AVCaptureDeviceInput for audio during session setup.
            self.sessionQueue.suspend()
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { success in
                
                self.sessionQueue.resume()
                
                completionHandler(success)
            })
            
        case .denied:
            // The user has previously denied access.
            completionHandler(false)
            
        case .restricted:
            // The user doesn’t have the authority to request access (for example, parental restriction).
            completionHandler(false)
        }
    }
    
    func colorFromBuffer(sampleBuffer: CMSampleBuffer) -> UIColor {
        var resultColor = UIColor.black
        
        if  let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
            
            let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
            let dataBuffer = baseAddress!.assumingMemoryBound(to: UInt8.self)
            
            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            
            let width = CVPixelBufferGetWidth(pixelBuffer)
            let height = CVPixelBufferGetHeight(pixelBuffer)
            
            let pixelCount = width*height
            
            var greenVector:[Float] = Array(repeating: 0.0, count: pixelCount)
            var blueVector:[Float] = Array(repeating: 0.0, count: pixelCount)
            var redVector:[Float] = Array(repeating: 0.0, count: pixelCount)
            
            vDSP_vfltu8(dataBuffer, 4, &blueVector, 1, vDSP_Length(pixelCount))
            vDSP_vfltu8(dataBuffer+1, 4, &greenVector, 1, vDSP_Length(pixelCount))
            vDSP_vfltu8(dataBuffer+2, 4, &redVector, 1, vDSP_Length(pixelCount))
            
            var redAverage:Float = 0.0
            var blueAverage:Float = 0.0
            var greenAverage:Float = 0.0
            
            vDSP_meamgv(&redVector, 1, &redAverage, vDSP_Length(pixelCount))
            vDSP_meamgv(&greenVector, 1, &greenAverage, vDSP_Length(pixelCount))
            vDSP_meamgv(&blueVector, 1, &blueAverage, vDSP_Length(pixelCount))
            
            resultColor = UIColor(red: CGFloat(redAverage/255.0), green: CGFloat(greenAverage/255.0), blue: CGFloat(blueAverage/255.0), alpha: 1.0)
        }
        
        return resultColor
    }
    
    func imageFromBuffer(sampleBuffer : CMSampleBuffer) -> UIImage?
    {
        var resultImage: UIImage?
        
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
            
            let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
            let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
            let width = CVPixelBufferGetWidth(pixelBuffer)
            let height = CVPixelBufferGetHeight(pixelBuffer)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
            
            bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
            
            let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
            let cgImage = context?.makeImage()
            
            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
            
            resultImage = UIImage.init(cgImage: cgImage!)
        }
        
        return resultImage
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        self.capturedBuffer = nil
        
        CMSampleBufferCreateCopy(allocator: kCFAllocatorDefault, sampleBuffer: sampleBuffer, sampleBufferOut: &self.capturedBuffer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let lightSensorImage = self.imageFromBuffer(sampleBuffer: sampleBuffer) {
                let size = CGSize(width: lightSensorImage.size.width/10.0, height: lightSensorImage.size.height/10.0) // Make it good and pixely.
                let pixelyImage = lightSensorImage.scaledToFit(within: size, scale: 1.0)
                let colorizedImage = pixelyImage.colorizeWithColor(self.currentSample)
                
                DispatchQueue.main.async {
                    Message.setLightSensorImage(colorizedImage).send()
                }
            
                if let didSenseLightHandler = self.didSenseLightHandler, let _ = self.capturedBuffer {
                    DispatchQueue.main.async {
                        didSenseLightHandler(self.currentSample)
                    }
                }
            }
        }
    }
}

public extension UIImage {
    
    func scaledToFit(within availableSize: CGSize, scale: CGFloat) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth = availableSize.width / self.size.width
        let aspectHeight = availableSize.height / self.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.scale = scale
        
        let renderer = UIGraphicsImageRenderer(size: scaledImageRect.size, format: rendererFormat)
        let scaledImage = renderer.image { _ in
            self.draw(in: scaledImageRect)
        }
        return scaledImage
    }

    func colorizeWithColor(_ color: UIColor) -> UIImage {
        var resultImage = self
        
        UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
        
        if let context = UIGraphicsGetCurrentContext(),
           let grayscale = CGColorSpace(name: CGColorSpace.linearGray),
           let rgb = CGColorSpace(name: CGColorSpace.genericRGBLinear) {
            context.setFillColorSpace(grayscale)
            self.draw(at: .zero, blendMode: .normal, alpha: 1.0)
            
            let saturatedColor = UIColor(hue: CGFloat(color.hue), saturation: 1.0, brightness: CGFloat(color.brightness), alpha: 1.0)
            
            context.setFillColorSpace(rgb)
            context.setFillColor(saturatedColor.cgColor)
            context.setBlendMode(.color)
            context.setAlpha(1.0)
            
            context.fill(CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
            
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                resultImage = image
            }
            
            UIGraphicsEndImageContext()
        }
        
        return resultImage
    }
}
