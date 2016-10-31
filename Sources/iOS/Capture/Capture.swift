/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import AVFoundation

@objc(CaptureMode)
public enum CaptureMode: Int {
	case photo
	case video
}

private var CaptureAdjustingExposureContext: UInt8 = 0

@objc(CapturePreset)
public enum CapturePreset: Int {
    case presetPhoto
    case presetHigh
    case presetMedium
    case presetLow
    case preset352x288
    case preset640x480
    case preset1280x720
    case preset1920x1080
    case preset3840x2160
    case presetiFrame960x540
    case presetiFrame1280x720
    case presetInputPriority
}

/**
 Converts a given CaptureSessionPreset to a String value.
 - Parameter preset: A CaptureSessionPreset to convert.
 */
public func CapturePresetToString(preset: CapturePreset) -> String {
    switch preset {
    case .presetPhoto:
        return AVCaptureSessionPresetPhoto
    case .presetHigh:
        return AVCaptureSessionPresetHigh
    case .presetMedium:
        return AVCaptureSessionPresetMedium
    case .presetLow:
        return AVCaptureSessionPresetLow
    case .preset352x288:
        return AVCaptureSessionPreset352x288
    case .preset640x480:
        return AVCaptureSessionPreset640x480
    case .preset1280x720:
        return AVCaptureSessionPreset1280x720
    case .preset1920x1080:
        return AVCaptureSessionPreset1920x1080
    case .preset3840x2160:
        if #available(iOS 9.0, *) {
            return AVCaptureSessionPreset3840x2160
        } else {
            return AVCaptureSessionPresetHigh
        }
    case .presetiFrame960x540:
        return AVCaptureSessionPresetiFrame960x540
    case .presetiFrame1280x720:
        return AVCaptureSessionPresetiFrame1280x720
    case .presetInputPriority:
        return AVCaptureSessionPresetInputPriority
    }
}

@objc(CaptureDelegate)
public protocol CaptureDelegate {
    /**
     A delegation method that is fired when the record timer has started.
     - Parameter capture: A reference to the calling capture.
     */
    @objc
    optional func captureDidStartRecordTimer(capture: Capture)
    
    /**
     A delegation method that is fired when the record timer was updated.
     - Parameter capture: A reference to the calling capture.
     - Parameter hours: An integer representing hours.
     - Parameter minutes: An integer representing minutes.
     - Parameter seconds: An integer representing seconds.
     */
    @objc
    optional func captureDidUpdateRecordTimer(capture: Capture, hours: Int, minutes: Int, seconds: Int)
    
    /**
     A delegation method that is fired when the record timer has stopped.
     - Parameter capture: A reference to the calling capture.
     - Parameter hours: An integer representing hours.
     - Parameter minutes: An integer representing minutes.
     - Parameter seconds: An integer representing seconds.
     */
    @objc
    optional func captureDidStopRecordTimer(capture: Capture, hours: Int, minutes: Int, seconds: Int)
    
    /**
     A delegation method that is fired when the user tapped to adjust the focus.
     - Parameter capture: A reference to the calling capture.
     - Parameter point: CGPoint that the user tapped at.
     */
    @objc
    optional func captureDidTapToFocusAtPoint(capture: Capture, point: CGPoint)
    
    /**
     A delegation method that is fired when the user tapped to adjust the exposure.
     - Parameter capture: A reference to the calling capture.
     - Parameter point: CGPoint that the user tapped at.
     */
    @objc
    optional func captureDidTapToExposeAtPoint(capture: Capture, point: CGPoint)
    
    /**
     A delegation method that is fired when the user tapped to reset.
     - Parameter capture: A reference to the calling capture.
     - Parameter point: CGPoint that the user tapped at.
     */
    @objc
    optional func captureDidTapToResetAtPoint(capture: Capture, point: CGPoint)
    
    /**
     A delegation method that is fired when the user pressed the flash button.
     - Parameter capture: A reference to the calling capture.
     - Parameter button: A reference to the UIButton that the user pressed.
     */
    @objc
    optional func captureDidPressFlashButton(capture: Capture, button: UIButton)
    
    /**
     A delegation method that is fired when the user pressed the switch camera button.
     - Parameter capture: A reference to the calling capture.
     - Parameter button: A reference to the UIButton that the user pressed.
     */
    @objc
    optional func captureDidPressSwitchCamerasButton(capture: Capture, button: UIButton)
    
    /**
     A delegation method that is fired when the user pressed capture button.
     - Parameter capture: A reference to the calling capture.
     - Parameter button: A reference to the UIButton that the user pressed.
     */
    @objc
    optional func captureDidPressCaptureButton(capture: Capture, button: UIButton)
    
    /**
     A delegation method that is fired when the user enabled the photo camera.
     - Parameter capture: A reference to the calling capture.
     - Parameter button: A reference to the UIButton that the user pressed.
     */
    @objc
    optional func captureDidPressCameraButton(capture: Capture, button: UIButton)
    
    /**
     A delegation method that is fired when the user enabled the video camera.
     - Parameter capture: A reference to the calling capture.
     - Parameter button: A reference to the UIButton that the user pressed.
     */
    @objc
    optional func captureDidPressVideoButton(capture: Capture, button: UIButton)

    /**
     A delegation method that is fired when the captureSesstion failes with an error.
     - Parameter capture: A reference to the calling capture.
     - Parameter error: A Error corresponding to the error.
     */
    @objc
    optional func captureFailedWithError(capture: Capture, error: Error)
    
    /**
     A delegation method that is fired when the camera has been switched to another.
     - Parameter capture: A reference to the calling capture.
     - Parameter device position: An AVCaptureDevicePosition that the camera has switched to.
     */
    @objc
    optional func captureDidSwitchCameras(capture: Capture, device position: AVCaptureDevicePosition)
    
    /**
     A delegation method that is fired before the camera has been switched to another.
     - Parameter capture: A reference to the calling capture.
     - Parameter device position: An AVCaptureDevicePosition that the camera will switch to.
     */
    @objc
    optional func captureWillSwitchCameras(capture: Capture, device position: AVCaptureDevicePosition)
    
    /**
     A delegation method that is fired when an image has been captured asynchronously.
     - Parameter capture: A reference to the calling capture.
     - Parameter image: An image that has been captured.
     */
    @objc
    optional func captureStillImageAsynchronously(capture: Capture, image: UIImage)
    
    /**
     A delegation method that is fired when capturing an image asynchronously has failed.
     - Parameter capture: A reference to the calling capture.
     - Parameter error: A Error corresponding to the error.
     */
    @objc
    optional func captureStillImageAsynchronouslyFailedWithError(capture: Capture, error: Error)
    
    /**
     A delegation method that is fired when creating a movie file has failed.
     - Parameter capture: A reference to the calling capture.
     - Parameter error: A Error corresponding to the error.
     */
    @objc
    optional func captureCreateMovieFileFailedWithError(capture: Capture, error: Error)
    
    /**
     A delegation method that is fired when capturing a movie has failed.
     - Parameter capture: A reference to the calling capture.
     - Parameter error: A Error corresponding to the error.
     */
    @objc
    optional func captureMovieFailedWithError(capture: Capture, error: Error)
    
    /**
     A delegation method that is fired when a session started recording and writing
     to a file.
     - Parameter capture: A reference to the calling capture.
     - Parameter captureOut: An AVCaptureFileOutput.
     - Parameter fileURL: A file URL.
     - Parameter fromConnections: An array of Anys.
     */
    @objc
    optional func captureDidStartRecordingToOutputFileAtURL(capture: Capture, captureOutput: AVCaptureFileOutput, fileURL: NSURL, fromConnections connections: [Any])
    
    /**
     A delegation method that is fired when a session finished recording and writing
     to a file.
     - Parameter capture: A reference to the calling capture.
     - Parameter captureOut: An AVCaptureFileOutput.
     - Parameter fileURL: A file URL.
     - Parameter fromConnections: An array of Anys.
     - Parameter error: A Error corresponding to an error.
     */
    @objc
    optional func captureDidFinishRecordingToOutputFileAtURL(capture: Capture, captureOutput: AVCaptureFileOutput, outputFileURL: NSURL, fromConnections connections: [Any], error: Error!)
}

open class Capture: View {
    /// A boolean indicating if an animation is in progress.
    open var isAnimating = false
    
    /// A reference to the capture mode.
    open var mode = CaptureMode.video
	
    /// Delegation handler.
    open weak var delegate: CaptureDelegate?
    
	/// A reference to the CapturePreview view.
	open internal(set) var preview: CapturePreview!
		
    /// A Timer reference for when recording is enabled.
    internal var timer: Timer?
    
    /// A reference to the visualEffect .
    internal var visualEffect: UIView!
    
    /// A tap gesture reference for focus events.
    internal var tapToFocusGesture: UITapGestureRecognizer?
    
    /// A tap gesture reference for exposure events.
    internal var tapToExposeGesture: UITapGestureRecognizer?
    
    /// A tap gesture reference for reset events.
    internal var tapToResetGesture: UITapGestureRecognizer?
    
    /// A reference to the session DispatchQueue.
    internal var sessionQueue: DispatchQueue!
    
    /// A reference to the active video input.
    internal var activeVideoInput: AVCaptureDeviceInput?
    
    /// A reference to the active audio input.
    internal var activeAudioInput: AVCaptureDeviceInput?
    
    /// A reference to the image output.
    internal var imageOutput: AVCaptureStillImageOutput!
    
    /// A reference to the movie output.
    internal var movieOutput: AVCaptureMovieFileOutput!
    
    /// A reference to the movie output URL.
    internal var movieOutputURL: URL?
    
    /// A reference to the AVCaptureSession.
    internal var session: AVCaptureSession!
    
    /// A boolean indicating if the session is running.
    open internal(set) var isRunning = false
    
    /// A boolean indicating if the session is recording.
    open internal(set) var isRecording = false
    
    /// A reference to the recorded time duration.
    open var recordedDuration: CMTime {
        return movieOutput.recordedDuration
    }
    
    /// An optional reference to the active camera if one exists.
    open var activeCamera: AVCaptureDevice? {
        return activeVideoInput?.device
    }
    
    /// An optional reference to the inactive camera if one exists.
    open var inactiveCamera: AVCaptureDevice? {
        var device: AVCaptureDevice?
        if 1 < cameraCount {
            if activeCamera?.position == .back {
                device = camera(at: .front)
            } else {
                device = camera(at: .back)
            }
        }
        return device
    }
    
    /// Available number of cameras.
    open var cameraCount: Int {
        return AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count
    }
    
    /// A boolean indicating whether the camera can switch to another.
    open var canSwitchCameras: Bool {
        return 1 < cameraCount
    }
    
    /// A booealn indicating whether the camrea supports focus.
    open var isFocusPointOfInterestSupported: Bool {
        return nil == activeCamera ? false : activeCamera!.isFocusPointOfInterestSupported
    }
    
    /// A booealn indicating whether the camrea supports exposure.
    open var isExposurePointOfInterestSupported: Bool {
        return nil == activeCamera ? false : activeCamera!.isExposurePointOfInterestSupported
    }
    
    /// A boolean indicating if the active camera has flash.
    open var isFlashAvailable: Bool {
        return nil == activeCamera ? false : activeCamera!.hasFlash
    }
    
    /// A boolean indicating if the active camera has a torch.
    open var isTorchAvailable: Bool {
        return nil == activeCamera ? false : activeCamera!.hasTorch
    }
    
    /// A reference to the active camera position if the active camera exists.
    open var devicePosition: AVCaptureDevicePosition? {
        return activeCamera?.position
    }
    
    /// A reference to the focusMode.
    open var focusMode: AVCaptureFocusMode {
        get {
            return activeCamera!.focusMode
        }
        set(value) {
            var error: NSError?
            if isFocusModeSupported(focusMode: focusMode) {
                do {
                    let device: AVCaptureDevice = activeCamera!
                    try device.lockForConfiguration()
                    device.focusMode = value
                    device.unlockForConfiguration()
                } catch let e as NSError {
                    error = e
                }
            } else {
                var userInfo: Dictionary<String, Any> = Dictionary<String, Any>()
                userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported focusMode.]"
                userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported focusMode.]"
                error = NSError(domain: "io.cosmicmind.Material.Capture", code: 0001, userInfo: userInfo)
                userInfo[NSUnderlyingErrorKey] = error
            }
            
            if let e = error {
                delegate?.captureFailedWithError?(capture: self, error: e)
            }
        }
    }
    
    /// A reference to the flashMode.
    open var flashMode: AVCaptureFlashMode {
        get {
            return activeCamera!.flashMode
        }
        set(value) {
            var error: Error?
            if isFlashModeSupported(flashMode: flashMode) {
                do {
                    let device: AVCaptureDevice = activeCamera!
                    try device.lockForConfiguration()
                    device.flashMode = value
                    device.unlockForConfiguration()
                } catch let e as NSError {
                    error = e
                }
            } else {
                var userInfo: Dictionary<String, Any> = Dictionary<String, Any>()
                userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported flashMode.]"
                userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported flashMode.]"
                error = NSError(domain: "io.cosmicmind.Material.Capture", code: 0002, userInfo: userInfo)
                userInfo[NSUnderlyingErrorKey] = error
            }
            
            if let e = error {
                delegate?.captureFailedWithError?(capture: self, error: e)
            }
        }
    }
    
    /// A reference to the torchMode.
    open var torchMode: AVCaptureTorchMode {
        get {
            return activeCamera!.torchMode
        }
        set(value) {
            var error: NSError?
            if isTorchModeSupported(torchMode: torchMode) {
                do {
                    let device: AVCaptureDevice = activeCamera!
                    try device.lockForConfiguration()
                    device.torchMode = value
                    device.unlockForConfiguration()
                } catch let e as NSError {
                    error = e
                }
            } else {
                var userInfo: Dictionary<String, Any> = Dictionary<String, Any>()
                userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported torchMode.]"
                userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported torchMode.]"
                error = NSError(domain: "io.cosmicmind.Material.Capture", code: 0003, userInfo: userInfo)
                userInfo[NSUnderlyingErrorKey] = error
            }
            
            if let e = error {
                delegate?.captureFailedWithError?(capture: self, error: e)
            }
        }
    }
    
    /// The session quality preset.
    open var capturePreset = CapturePreset.presetHigh {
        didSet {
            session.sessionPreset = CapturePresetToString(preset: capturePreset)
        }
    }
    
    /// The capture video orientation.
    open var videoOrientation: AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation
        switch UIDevice.current.orientation {
        case .portrait:
            orientation = .portrait
        case .landscapeRight:
            orientation = .landscapeLeft
        case .portraitUpsideDown:
            orientation = .portraitUpsideDown
        default:
            orientation = .landscapeRight
        }
        return orientation
    }
    
    /// A reference to the captureButton.
    @IBInspectable
    open var captureButton: UIButton? {
        didSet {
            prepareCaptureButton()
        }
    }
    
    /// A reference to the cameraButton.
    @IBInspectable
    open var cameraButton: UIButton? {
        didSet {
            prepareCameraButton()
        }
    }
    
    /// A reference to the videoButton.
    @IBInspectable
    open var videoButton: UIButton? {
        didSet {
            prepareVideoButton()
        }
    }
    
    /// A reference to the switchCameraButton.
    @IBInspectable
    open var switchCamerasButton: UIButton? {
        didSet {
            prepareSwitchCamerasButton()
        }
    }
    
    /// A reference to the flashButton.
    @IBInspectable
    open var flashButton: UIButton? {
        didSet {
            prepareFlashButton()
        }
    }
    
    /// A boolean indicating whether to enable tap to focus.
    @IBInspectable
    open var isTapToFocusEnabled = false {
        didSet {
            guard isTapToFocusEnabled else {
                removeTapGesture(gesture: &tapToFocusGesture)
                return
            }
            
            isTapToResetEnabled = true
            
            prepareTapGesture(gesture: &tapToFocusGesture, numberOfTapsRequired: 1, numberOfTouchesRequired: 1, selector: #selector(handleTapToFocusGesture))
            
            if let v = tapToExposeGesture {
                tapToFocusGesture!.require(toFail: v)
            }
        }
    }
    
    /// A boolean indicating whether to enable tap to expose.
    @IBInspectable
    open var isTapToExposeEnabled = false {
        didSet {
            guard isTapToExposeEnabled else {
                removeTapGesture(gesture: &tapToExposeGesture)
                return
            }
            
            isTapToResetEnabled = true
            
            prepareTapGesture(gesture: &tapToExposeGesture, numberOfTapsRequired: 2, numberOfTouchesRequired: 1, selector: #selector(handleTapToExposeGesture))
            
            if let v = tapToFocusGesture {
                v.require(toFail: tapToExposeGesture!)
            }
        }
    }
    
    /// A boolean indicating whether to enable tap to reset.
    @IBInspectable
    open var isTapToResetEnabled = false {
        didSet {
            guard isTapToResetEnabled else {
                removeTapGesture(gesture: &tapToResetGesture)
                return
            }
            
            prepareTapGesture(gesture: &tapToResetGesture, numberOfTapsRequired: 2, numberOfTouchesRequired: 2, selector: #selector(handleTapToResetGesture))
            
            if let v = tapToFocusGesture {
                v.require(toFail: tapToResetGesture!)
            }
            
            if let v = tapToExposeGesture {
                v.require(toFail: tapToResetGesture!)
            }
        }
    }
    
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: .zero)
	}
	
    /**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
	open override func prepare() {
		super.prepare()
		backgroundColor = .black
        
        prepareVisualEffect()
        prepareSession()
        prepareSessionQueue()
        prepareActiveVideoInput()
        prepareActiveAudioInput()
        prepareImageOutput()
        prepareMovieOutput()
        preparePreview()
        
        isTapToFocusEnabled = true
        isTapToExposeEnabled = true
	}
}

extension Capture {
    /// Prepares the visualEffect.
    internal func prepareVisualEffect() {
        let blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffect = UIView()
        visualEffect.backgroundColor = nil
        visualEffect.layout(blurEffect).edges()
    }
    
    /// Prepares the preview.
    internal func preparePreview() {
		preview = CapturePreview()
        layout(preview).edges()
        bringSubview(toFront: visualEffect)
        
        (preview.layer as! AVCaptureVideoPreviewLayer).session = session
		startSession()
	}
    
    /// Prepares the captureButton.
    internal func prepareCaptureButton() {
        captureButton?.addTarget(self, action: #selector(handleCaptureButton), for: .touchUpInside)
    }
    
    /// Prepares the cameraButton.
    internal func prepareCameraButton() {
        cameraButton?.addTarget(self, action: #selector(handleCameraButton), for: .touchUpInside)
    }
    
    /// Preapres the videoButton.
    internal func prepareVideoButton() {
        videoButton?.addTarget(self, action: #selector(handleVideoButton), for: .touchUpInside)
    }
    
    /// Prepares the switchCameraButton.
    internal func prepareSwitchCamerasButton() {
        switchCamerasButton?.addTarget(self, action: #selector(handleSwitchCamerasButton), for: .touchUpInside)
    }
    
    /// Prepares the flashButton.
    internal func prepareFlashButton() {
        flashButton?.addTarget(self, action: #selector(handleFlashButton), for: .touchUpInside)
    }
    
    /// Prepares the sessionQueue.
    internal func prepareSessionQueue() {
        sessionQueue = DispatchQueue(label: "io.cosmicmind.Material.CaptureSession", attributes: .concurrent, target: nil)
    }
    
    /// Prepares the session.
    internal func prepareSession() {
        session = AVCaptureSession()
    }
    
    /// Prepares the activeVideoInput.
    internal func prepareActiveVideoInput() {
        do {
            activeVideoInput = try AVCaptureDeviceInput(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo))
            
            guard session.canAddInput(activeVideoInput) else {
                return
            }
            
            session.addInput(activeVideoInput)
        } catch let e as NSError {
            delegate?.captureFailedWithError?(capture: self, error: e)
        }
    }
    
    /// Prepares the activeAudioInput.
    internal func prepareActiveAudioInput() {
        do {
            activeAudioInput = try AVCaptureDeviceInput(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio))
            
            guard session.canAddInput(activeAudioInput) else {
                return
            }
            
            session.addInput(activeAudioInput)
        } catch let e as NSError {
            delegate?.captureFailedWithError?(capture: self, error: e)
        }
    }
    
    /// Prepares the imageOutput.
    internal func prepareImageOutput() {
        imageOutput = AVCaptureStillImageOutput()
        
        guard session.canAddOutput(imageOutput) else {
            return
        }
        
        imageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        session.addOutput(imageOutput)
    }
    
    /// Prepares the movieOutput.
    internal func prepareMovieOutput() {
        movieOutput = AVCaptureMovieFileOutput()
        
        guard session.canAddOutput(movieOutput) else {
            return
        }
        
        session.addOutput(movieOutput)
    }
}

extension Capture {
    /// Starts the session.
    open func startSession() {
        guard !isRunning else {
            return
        }
        
        sessionQueue.async() { [weak self] in
            self?.session.startRunning()
        }
    }
    
    /// Stops the session.
    open func stopSession() {
        guard isRunning else {
            return
        }
        
        sessionQueue.async() { [weak self] in
            self?.session.stopRunning()
        }
    }
    
    /// Switches the camera if possible.
    open func switchCameras() {
        guard canSwitchCameras && !isAnimating else {
            return
        }
        
        do {
            guard let v = devicePosition else {
                return
            }
            
            delegate?.captureWillSwitchCameras?(capture: self, device: v)
            
            let videoInput = try AVCaptureDeviceInput(device: inactiveCamera!)
            session.beginConfiguration()
            session.removeInput(activeVideoInput)
            
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
                activeVideoInput = videoInput
            } else {
                session.addInput(activeVideoInput)
            }
            
            session.commitConfiguration()
            
            isAnimating = true
            Motion.delay(time: 0.15) { [weak self] in
                guard let s = self else {
                    return
                }
                
                s.delegate?.captureDidSwitchCameras?(capture: s, device: s.devicePosition!)
                
                UIView.animate(withDuration: 0.15, animations: { [weak self] in
                    self?.visualEffect.alpha = 0
                }, completion: { [weak self] _ in
                    guard let s = self else {
                        return
                    }
                    
                    s.visualEffect.removeFromSuperview()
                    s.isAnimating = false
                })
            }
        } catch let e as NSError {
            delegate?.captureFailedWithError?(capture: self, error: e)
        }
    }
    
    /**
     Checks if a given focus mode is supported.
     - Parameter focusMode: An AVCaptureFocusMode.
     - Returns: A boolean of the result, true if supported, false otherwise.
     */
    open func isFocusModeSupported(focusMode: AVCaptureFocusMode) -> Bool {
        return activeCamera!.isFocusModeSupported(focusMode)
    }
    
    /**
     Checks if a given exposure mode is supported.
     - Parameter exposureMode: An AVCaptureExposureMode.
     - Returns: A boolean of the result, true if supported, false otherwise.
     */
    open func isExposureModeSupported(exposureMode: AVCaptureExposureMode) -> Bool {
        return activeCamera!.isExposureModeSupported(exposureMode)
    }
    
    /**
     Checks if a given flash mode is supported.
     - Parameter flashMode: An AVCaptureFlashMode.
     - Returns: A boolean of the result, true if supported, false otherwise.
     */
    open func isFlashModeSupported(flashMode: AVCaptureFlashMode) -> Bool {
        return activeCamera!.isFlashModeSupported(flashMode)
    }
    
    /**
     Checks if a given torch mode is supported.
     - Parameter torchMode: An AVCaptureTorchMode.
     - Returns: A boolean of the result, true if supported, false otherwise.
     */
    open func isTorchModeSupported(torchMode: AVCaptureTorchMode) -> Bool {
        return activeCamera!.isTorchModeSupported(torchMode)
    }
    
    /**
     Focuses the camera at a given point.
     - Parameter at: A CGPoint to focus at.
     */
    open func focus(at point: CGPoint) {
        var error: NSError?
        if isFocusPointOfInterestSupported && isFocusModeSupported(focusMode: .autoFocus) {
            do {
                let device = activeCamera!
                try device.lockForConfiguration()
                device.focusPointOfInterest = point
                device.focusMode = .autoFocus
                device.unlockForConfiguration()
            } catch let e as NSError {
                error = e
            }
        } else {
            var userInfo = [String: Any]()
            userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported focus.]"
            userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported focus.]"
            error = NSError(domain: "io.cosmicmind.Material.Capture", code: 0004, userInfo: userInfo)
            userInfo[NSUnderlyingErrorKey] = error
        }
        
        if let e = error {
            delegate?.captureFailedWithError?(capture: self, error: e)
        }
    }
    
    /**
     Exposes the camera at a given point.
     - Parameter at: A CGPoint to expose at.
     */
    open func expose(at point: CGPoint) {
        var error: NSError?
        if isExposurePointOfInterestSupported && isExposureModeSupported(exposureMode: .continuousAutoExposure) {
            do {
                let device = activeCamera!
                try device.lockForConfiguration()
                device.exposurePointOfInterest = point
                device.exposureMode = .continuousAutoExposure
                if device.isExposureModeSupported(.locked) {
                    device.addObserver(self, forKeyPath: "adjustingExposure", options: .new, context: &CaptureAdjustingExposureContext)
                }
                device.unlockForConfiguration()
            } catch let e as NSError {
                error = e
            }
        } else {
            var userInfo = [String: Any]()
            userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported expose.]"
            userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported expose.]"
            error = NSError(domain: "io.cosmicmind.Material.Capture", code: 0005, userInfo: userInfo)
            userInfo[NSUnderlyingErrorKey] = error
        }
        
        if let e = error {
            delegate?.captureFailedWithError?(capture: self, error: e)
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if context == &CaptureAdjustingExposureContext {
            let device = object as! AVCaptureDevice
            if !device.isAdjustingExposure && device.isExposureModeSupported(.locked) {
                (object! as AnyObject).removeObserver(self, forKeyPath: "adjustingExposure", context: &CaptureAdjustingExposureContext)
                DispatchQueue.main.async() {
                    do {
                        try device.lockForConfiguration()
                        device.exposureMode = .locked
                        device.unlockForConfiguration()
                    } catch let e as NSError {
                        self.delegate?.captureFailedWithError?(capture: self, error: e)
                    }
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of : object, change: change, context: context)
        }
    }
    
    /**
     Resets the camera focus and exposure.
     - Parameter focus: A boolean indicating to reset the focus.
     - Parameter exposure: A boolean indicating to reset the exposure.
     */
    open func reset(focus: Bool = true, exposure: Bool = true) {
        let device = activeCamera!
        let canResetFocus = device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.continuousAutoFocus)
        let canResetExposure = device.isExposurePointOfInterestSupported && device.isExposureModeSupported(.continuousAutoExposure)
        let centerPoint = CGPoint(x: 0.5, y: 0.5)
        
        do {
            try device.lockForConfiguration()
            if canResetFocus && focus {
                device.focusMode = .continuousAutoFocus
                device.focusPointOfInterest = centerPoint
            }
            
            if canResetExposure && exposure {
                device.exposureMode = .continuousAutoExposure
                device.exposurePointOfInterest = centerPoint
            }
            
            device.unlockForConfiguration()
        } catch let e as NSError {
            delegate?.captureFailedWithError?(capture: self, error: e)
        }
    }
    
    /// Captures a still image.
    open func captureStillImage() {
        sessionQueue.async() { [weak self] in
            guard let s = self else {
                return
            }
            
            guard let v = s.imageOutput.connection(withMediaType: AVMediaTypeVideo) else {
                return
            }
            
            v.videoOrientation = s.videoOrientation
            s.imageOutput.captureStillImageAsynchronously(from: v) { [weak self] (sampleBuffer: CMSampleBuffer?, error: Error?) -> Void in
                guard let s = self else {
                    return
                }
                
                var captureError = error
                if nil == captureError {
                    let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)!
                    
                    if let image1 = UIImage(data: data) {
                        if let image2 = image1.adjustOrientation() {
                            s.delegate?.captureStillImageAsynchronously?(capture: s, image: image2)
                        } else {
                            var userInfo = [String: Any]()
                            userInfo[NSLocalizedDescriptionKey] = "[Material Error: Cannot fix image orientation.]"
                            userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Cannot fix image orientation.]"
                            captureError = NSError(domain: "io.cosmicmind.Material.Capture", code: 0006, userInfo: userInfo)
                            userInfo[NSUnderlyingErrorKey] = error
                        }
                    } else {
                        var userInfo = [String: Any]()
                        userInfo[NSLocalizedDescriptionKey] = "[Material Error: Cannot capture image from data.]"
                        userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Cannot capture image from data.]"
                        captureError = NSError(domain: "io.cosmicmind.Material.Capture", code: 0007, userInfo: userInfo)
                        userInfo[NSUnderlyingErrorKey] = error
                    }
                }
                
                if let e = captureError {
                    s.delegate?.captureStillImageAsynchronouslyFailedWithError?(capture: s, error: e)
                }
            }
        }
    }
    
    /// Starts recording.
    open func startRecording() {
        if !isRecording {
            sessionQueue.async() { [weak self] in
                guard let s = self else {
                    return
                }
                
                if let v = s.movieOutput.connection(withMediaType: AVMediaTypeVideo) {
                    v.videoOrientation = s.videoOrientation
                    v.preferredVideoStabilizationMode = .auto
                }
                
                guard let v = s.activeCamera else {
                    return
                }
                
                if v.isSmoothAutoFocusSupported {
                    do {
                        try v.lockForConfiguration()
                        v.isSmoothAutoFocusEnabled = true
                        v.unlockForConfiguration()
                    } catch let e as NSError {
                        s.delegate?.captureFailedWithError?(capture: s, error: e)
                    }
                }
                
                s.movieOutputURL = s.uniqueURL()
                if let v = s.movieOutputURL {
                    s.movieOutput.startRecording(toOutputFileURL: v as URL!, recordingDelegate: s)
                }
            }
        }
    }
    
    /// Stops recording.
    open func stopRecording() {
        guard isRecording else {
            return
        }
        
        movieOutput.stopRecording()
    }
    
    /**
     A reference to the camera at a given position, if one exists.
     - Parameter at: An AVCaptureDevicePosition.
     - Returns: An AVCaptureDevice if one exists, or nil otherwise.
     */
    internal func camera(at position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
        for device in devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    /**
     Creates a unique URL if possible.
     - Returns: A NSURL if it is possible to create one.
     */
    internal func uniqueURL() -> URL? {
        do {
            let directory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .full
            
            return directory.appendingPathComponent(dateFormatter.string(from: NSDate() as Date) + ".mov")
        } catch let e as NSError {
            delegate?.captureCreateMovieFileFailedWithError?(capture: self, error: e)
        }
        return nil
    }
}

extension Capture {
    /**
     Handler for the captureButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleCaptureButton(button: UIButton) {
        switch mode {
        case .photo:
            captureStillImage()
        case .video:
            if isRecording {
                stopRecording()
                stopTimer()
            } else {
                startRecording()
                startTimer()
            }
        }
        
        delegate?.captureDidPressCaptureButton?(capture: self, button: button)
    }
    
    /**
     Handler for the cameraButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleCameraButton(button: UIButton) {
        mode = .photo
        delegate?.captureDidPressCameraButton?(capture: self, button: button)
    }
    
    /**
     Handler for the flashButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleFlashButton(button: UIButton) {
        delegate?.captureDidPressFlashButton?(capture: self, button: button)
    }
    
    /**
     Handler for the switchCameraButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleSwitchCamerasButton(button: UIButton) {
        visualEffect.alpha = 0
        layout(visualEffect).edges()
        
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            self?.visualEffect.alpha = 1
        }) { [weak self] _ in
            self?.switchCameras()
        }
        
        delegate?.captureDidPressSwitchCamerasButton?(capture: self, button: button)
    }
    
    /**
     Handler for the videoButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleVideoButton(button: UIButton) {
        mode = .video
        delegate?.captureDidPressVideoButton?(capture: self, button: button)
    }
    
    /**
     Handler for the tapToFocusGesture.
     - Parameter recognizer: A UITapGestureRecognizer that is associated with the event.
     */
    @objc
    internal func handleTapToFocusGesture(recognizer: UITapGestureRecognizer) {
        guard isTapToFocusEnabled && isFocusPointOfInterestSupported else {
            return
        }
        
        let point = recognizer.location(in: self)
        focus(at: preview.captureDevicePointOfInterestForPoint(point: point))
        delegate?.captureDidTapToFocusAtPoint?(capture: self, point: point)
    }
    
    /**
     Handler for the tapToExposeGesture.
     - Parameter recognizer: A UITapGestureRecognizer that is associated with the event.
     */
    @objc
    internal func handleTapToExposeGesture(recognizer: UITapGestureRecognizer) {
        guard isTapToExposeEnabled && isExposurePointOfInterestSupported else {
            return
        }
        
        let point = recognizer.location(in: self)
        expose(at: preview.captureDevicePointOfInterestForPoint(point: point))
        delegate?.captureDidTapToExposeAtPoint?(capture: self, point: point)
    }
    
    /**
     Handler for the tapToResetGesture.
     - Parameter recognizer: A UITapGestureRecognizer that is associated with the event.
     */
    @objc
    internal func handleTapToResetGesture(recognizer: UITapGestureRecognizer) {
        guard isTapToResetEnabled else {
            return
        }
        
        reset()
        
        let point = preview.pointForCaptureDevicePointOfInterest(point: CGPoint(x: 0.5, y: 0.5))
        delegate?.captureDidTapToResetAtPoint?(capture: self, point: point)
    }
}

extension Capture {
    /// Starts the timer for recording.
    internal func startTimer() {
        timer?.invalidate()
        timer = Timer(timeInterval: 0.5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .commonModes)
        
        delegate?.captureDidStartRecordTimer?(capture: self)
    }
    
    /// Updates the timer when recording.
    internal func updateTimer() {
        let duration = recordedDuration
        let time = CMTimeGetSeconds(duration)
        let hours = Int(time / 3600)
        let minutes = Int((time / 60).truncatingRemainder(dividingBy: 60))
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        
        delegate?.captureDidUpdateRecordTimer?(capture: self, hours: hours, minutes: minutes, seconds: seconds)
    }
    
    /// Stops the timer when recording.
    internal func stopTimer() {
        let duration = recordedDuration
        let time = CMTimeGetSeconds(duration)
        let hours = Int(time / 3600)
        let minutes = Int((time / 60).truncatingRemainder(dividingBy: 60))
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        
        timer?.invalidate()
        timer = nil
        
        delegate?.captureDidStopRecordTimer?(capture: self, hours: hours, minutes: minutes, seconds: seconds)
    }
}

extension Capture: UIGestureRecognizerDelegate {
    /**
     Prepares a given tap gesture.
     - Parameter gesture: An optional UITapGestureRecognizer to prepare.
     - Parameter numberOfTapsRequired: An integer of the number of taps required
     to activate the gesture.
     - Parameter numberOfTouchesRequired: An integer of the number of touches, fingers,
     required to activate the gesture.
     - Parameter selector: A Selector to handle the event.
     */
    internal func prepareTapGesture(gesture: inout UITapGestureRecognizer?, numberOfTapsRequired: Int, numberOfTouchesRequired: Int, selector: Selector) {
        guard nil == gesture else {
            return
        }
        
        gesture = UITapGestureRecognizer(target: self, action: selector)
        gesture!.delegate = self
        gesture!.numberOfTapsRequired = numberOfTapsRequired
        gesture!.numberOfTouchesRequired = numberOfTouchesRequired
        addGestureRecognizer(gesture!)
    }
    
    /**
     Removes a given tap gesture.
     - Parameter gesture: An optional UITapGestureRecognizer to remove.
     */
    internal func removeTapGesture(gesture: inout UITapGestureRecognizer?) {
        guard let v = gesture else {
            return
        }
        
        removeGestureRecognizer(v)
        gesture = nil
    }
}

extension Capture: AVCaptureFileOutputRecordingDelegate {
    public func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        isRecording = true
        delegate?.captureDidStartRecordingToOutputFileAtURL?(capture: self, captureOutput: captureOutput, fileURL: fileURL as NSURL, fromConnections: connections)
    }
    
    public func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        isRecording = false
        delegate?.captureDidFinishRecordingToOutputFileAtURL?(capture: self, captureOutput: captureOutput, outputFileURL: outputFileURL as NSURL, fromConnections: connections, error: error)
    }
}
