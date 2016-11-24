/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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
     A delegation method that is executed when the captureSesstion failes with an error.
     - Parameter capture: A reference to the calling capture.
     - Parameter error: A Error corresponding to the error.
     */
    @objc
    optional func capture(capture: Capture, failedWith error: Error)
    
    /**
     A delegation method that is executed when the record timer has started.
     - Parameter capture: A reference to the calling capture.
     - Parameter didStartRecord timer: A Timer.
     */
    @objc
    optional func capture(capture: Capture, didStartRecord timer: Timer)
    
    /**
     A delegation method that is executed when the record timer was updated.
     - Parameter capture: A reference to the calling capture.
     - Parameter didUpdateRecord timer: A Timer.
     - Parameter hours: An integer representing hours.
     - Parameter minutes: An integer representing minutes.
     - Parameter seconds: An integer representing seconds.
     */
    @objc
    optional func capture(capture: Capture, didUpdateRecord timer: Timer, hours: Int, minutes: Int, seconds: Int)
    
    /**
     A delegation method that is executed when the record timer has stopped.
     - Parameter capture: A reference to the calling capture.
     - Parameter didStopRecord timer: A Timer.
     - Parameter hours: An integer representing hours.
     - Parameter minutes: An integer representing minutes.
     - Parameter seconds: An integer representing seconds.
     */
    @objc
    optional func capture(capture: Capture, didStopRecord time: Timer, hours: Int, minutes: Int, seconds: Int)
    
    /**
     A delegation method that is executed when the user tapped to adjust the focus.
     - Parameter capture: A reference to the calling capture.
     - Parameter didTapToFocusAt point: CGPoint that the user tapped at.
     */
    @objc
    optional func capture(capture: Capture, didTapToFocusAt point: CGPoint)
    
    /**
     A delegation method that is executed when the user tapped to adjust the exposure.
     - Parameter capture: A reference to the calling capture.
     - Parameter didTapToExposeAt point: CGPoint that the user tapped at.
     */
    @objc
    optional func capture(capture: Capture, didTapToExposeAt point: CGPoint)
    
    /**
     A delegation method that is executed when the user tapped to reset.
     - Parameter capture: A reference to the calling capture.
     - Parameter didTapToResetAt point: CGPoint that the user tapped at.
     */
    @objc
    optional func capture(capture: Capture, didTapToResetAt point: CGPoint)
    
    /**
     A delegation method that is executed when the user pressed the change mode button.
     - Parameter capture: A reference to the calling capture.
     - Parameter didPressChangeMode button: A reference to the UIButton that the user pressed.
     */
    @objc
    optional func capture(capture: Capture, didPressChangeMode button: UIButton)
    
    /**
     A delegation method that is executed when the user pressed the change camera button.
     - Parameter capture: A reference to the calling capture.
     - Parameter didPressChangeCamera button: A reference to the UIButton that the user pressed.
     */
    @objc
    optional func capture(capture: Capture, didPressChangeCamera button: UIButton)
    
    /**
     A delegation method that is executed when the user pressed capture button.
     - Parameter capture: A reference to the calling capture.
     - Parameter didPressCapture button: A reference to the UIButton that the user pressed.
     */
    @objc
    optional func capture(capture: Capture, didPressCapture button: UIButton)
    
    /**
     A delegation method that is fired when the user pressed the flash button.
     - Parameter capture: A reference to the calling capture.
     - Parameter didPressFlash button: A reference to the UIButton that the user pressed.
     */
    @objc
    optional func capture(capture: Capture, didPressFlash button: UIButton)
    
    /**
     A delegation method that is executed before the camera has been changed to another mode.
     - Parameter capture: A reference to the calling capture.
     - Parameter mode: A CaptureMode.
     */
    @objc
    optional func capture(capture: Capture, willChange mode: CaptureMode)
    
    /**
     A delegation method that is executed after the camera has been changed to another mode.
     - Parameter capture: A reference to the calling capture.
     - Parameter mode: A CaptureMode.
     */
    @objc
    optional func capture(capture: Capture, didChange mode: CaptureMode)
    
    /**
     A delegation method that is executed before the camera has been changed to another.
     - Parameter capture: A reference to the calling capture.
     - Parameter willChangeCamera devicePosition: An AVCaptureDevicePosition that the camera will change to.
     */
    @objc
    optional func capture(capture: Capture, willChangeCamera devicePosition: AVCaptureDevicePosition)
    
    /**
     A delegation method that is executed when the camera has been changed to another.
     - Parameter capture: A reference to the calling capture.
     - Parameter didChangeCamera devicePosition: An AVCaptureDevicePosition that the camera has changed to.
     */
    @objc
    optional func capture(capture: Capture, didChangeCamera devicePosition: AVCaptureDevicePosition)
    
    /**
     A delegation method that is executed when the device orientation changes.
     - Parameter capture: A reference to the calling capture.
     - Paremeter didChange videoOrientation: An AVCaptureVideoOrientation value.
     */
    @objc
    optional func capture(capture: Capture, didChangeFrom previousVideoOrientation: AVCaptureVideoOrientation, to videoOrientation: AVCaptureVideoOrientation)
    
    /**
     A delegation method that is executed when an image has been captured asynchronously.
     - Parameter capture: A reference to the calling capture.
     - Parameter asynchronouslyStill image: An image that has been captured.
     */
    @objc
    optional func capture(capture: Capture, asynchronouslyStill image: UIImage)
    
    /**
     A delegation method that is executed when capturing an image asynchronously has failed.
     - Parameter capture: A reference to the calling capture.
     - Parameter asynchronouslyStillImageFailedWith error: A Error corresponding to the error.
     */
    @objc
    optional func capture(capture: Capture, asynchronouslyStillImageFailedWith error: Error)
    
    /**
     A delegation method that is executed when creating a movie file has failed.
     - Parameter capture: A reference to the calling capture.
     - Parameter createMovieFileFailedWith error: A Error corresponding to the error.
     */
    @objc
    optional func capture(capture: Capture, createMovieFileFailedWith error: Error)
    
    /**
     A delegation method that is executed when a session started recording and writing
     to a file.
     - Parameter capture: A reference to the calling capture.
     - Parameter captureOutput: An AVCaptureFileOutput.
     - Parameter didStartRecordingToOutputFileAt fileURL: A file URL.
     - Parameter fromConnections: An array of Anys.
     */
    @objc
    optional func capture(capture: Capture, captureOutput: AVCaptureFileOutput, didStartRecordingToOutputFileAt fileURL: NSURL, fromConnections connections: [Any])
    
    /**
     A delegation method that is executed when a session finished recording and writing
     to a file.
     - Parameter capture: A reference to the calling capture.
     - Parameter captureOutput: An AVCaptureFileOutput.
     - Parameter didFinishRecordingToOutputFileAt outputFileURL: A file URL.
     - Parameter fromConnections: An array of Anys.
     - Parameter error: A Error corresponding to an error.
     */
    @objc
    optional func capture(capture: Capture, captureOutput: AVCaptureFileOutput, didFinishRecordingToOutputFileAt outputFileURL: NSURL, fromConnections connections: [Any], error: Error!)
}

open class Capture: View {
    /// A reference to the capture mode.
    open var mode = CaptureMode.photo
	
    /// Delegation handler.
    open weak var delegate: CaptureDelegate?
    
	/// A reference to the CapturePreview view.
	open let preview = CapturePreview()
		
    /// A Timer reference for when recording is enabled.
    open fileprivate(set) var timer: Timer?
    
    /// A tap gesture reference for focus events.
    fileprivate var tapToFocusGesture: UITapGestureRecognizer?
    
    /// A tap gesture reference for exposure events.
    fileprivate var tapToExposeGesture: UITapGestureRecognizer?
    
    /// A tap gesture reference for reset events.
    fileprivate var tapToResetGesture: UITapGestureRecognizer?
    
    /// A reference to the session DispatchQueue.
    fileprivate var sessionQueue: DispatchQueue!
    
    /// A reference to the active video input.
    fileprivate var activeVideoInput: AVCaptureDeviceInput?
    
    /// A reference to the active audio input.
    fileprivate var activeAudioInput: AVCaptureDeviceInput?
    
    /// A reference to the image output.
    fileprivate var imageOutput: AVCaptureStillImageOutput!
    
    /// A reference to the movie output.
    fileprivate var movieOutput: AVCaptureMovieFileOutput!
    
    /// A reference to the movie output URL.
    fileprivate var movieOutputURL: URL?
    
    /// A reference to the AVCaptureSession.
    fileprivate var session: AVCaptureSession!
    
    /// A boolean indicating if the session is running.
    open fileprivate(set) var isRunning = false
    
    /// A boolean indicating if the session is recording.
    open fileprivate(set) var isRecording = false
    
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
    
    /// A boolean indicating whether the camera can change to another.
    open var canChangeCamera: Bool {
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
                    let device = activeCamera!
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
                error = NSError(domain: "com.cosmicmind.material.capture", code: 0001, userInfo: userInfo)
                userInfo[NSUnderlyingErrorKey] = error
            }
            
            if let e = error {
                delegate?.capture?(capture: self, failedWith: e)
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
                    let device = activeCamera!
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
                error = NSError(domain: "com.cosmicmind.material.capture", code: 0002, userInfo: userInfo)
                userInfo[NSUnderlyingErrorKey] = error
            }
            
            if let e = error {
                delegate?.capture?(capture: self, failedWith: e)
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
                error = NSError(domain: "com.cosmicmind.material.capture", code: 0003, userInfo: userInfo)
                userInfo[NSUnderlyingErrorKey] = error
            }
            
            if let e = error {
                delegate?.capture?(capture: self, failedWith: e)
            }
        }
    }
    
    /// The session quality preset.
    open var capturePreset = CapturePreset.presetHigh {
        didSet {
            session.sessionPreset = CapturePresetToString(preset: capturePreset)
        }
    }
    
    /// A reference to the previous AVCaptureVideoOrientation.
    open fileprivate(set) var previousVideoOrientation: AVCaptureVideoOrientation!
    
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
    
    /// A reference to the changeModeButton.
    @IBInspectable
    open var changeModeButton: UIButton? {
        didSet {
            prepareChangeModeButton()
        }
    }
    
    /// A reference to the changeCameraButton.
    @IBInspectable
    open var changeCameraButton: UIButton? {
        didSet {
            prepareChangeCameraButton()
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
    
    deinit {
        removeOrientationNotifications()
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
        
        prepareSession()
        prepareSessionQueue()
        prepareActiveVideoInput()
        prepareActiveAudioInput()
        prepareImageOutput()
        prepareMovieOutput()
        preparePreview()
        prepareOrientationNotifications()
        
        previousVideoOrientation = videoOrientation
        
        isTapToFocusEnabled = true
        isTapToExposeEnabled = true
	}
}

extension Capture {
    /// Prepares self to observe orientation change notifications.
    fileprivate func prepareOrientationNotifications() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationNotifications(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    /// Removes self from observing orientation change notifications.
    fileprivate func removeOrientationNotifications() {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     Handler for the captureButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    fileprivate func handleOrientationNotifications(_ notification: Notification) {
        delegate?.capture?(capture: self, didChangeFrom: previousVideoOrientation, to: videoOrientation)
        previousVideoOrientation = videoOrientation
    }
}

extension Capture {
    /// Prepares the preview.
    fileprivate func preparePreview() {
		layout(preview).edges()
        
        (preview.layer as! AVCaptureVideoPreviewLayer).session = session
		startSession()
	}
    
    /// Prepares the captureButton.
    fileprivate func prepareCaptureButton() {
        captureButton?.addTarget(self, action: #selector(handleCaptureButton(button:)), for: .touchUpInside)
    }
    
    /// Prepares the cameraButton.
    fileprivate func prepareChangeModeButton() {
        changeModeButton?.addTarget(self, action: #selector(handleChangeModeButton(button:)), for: .touchUpInside)
    }
    
    /// Prepares the changeCameraButton.
    fileprivate func prepareChangeCameraButton() {
        changeCameraButton?.addTarget(self, action: #selector(handleChangeCameraButton(button:)), for: .touchUpInside)
    }
    
    /// Prepares the flashButton.
    fileprivate func prepareFlashButton() {
        flashButton?.addTarget(self, action: #selector(handleFlashButton(button:)), for: .touchUpInside)
    }
    
    /// Prepares the sessionQueue.
    fileprivate func prepareSessionQueue() {
        sessionQueue = DispatchQueue(label: "com.cosmicmind.material.capture", attributes: .concurrent, target: nil)
    }
    
    /// Prepares the session.
    fileprivate func prepareSession() {
        session = AVCaptureSession()
    }
    
    /// Prepares the activeVideoInput.
    fileprivate func prepareActiveVideoInput() {
        do {
            activeVideoInput = try AVCaptureDeviceInput(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo))
            
            guard session.canAddInput(activeVideoInput) else {
                return
            }
            
            session.addInput(activeVideoInput)
        } catch let e as NSError {
            delegate?.capture?(capture: self, failedWith: e)
        }
    }
    
    /// Prepares the activeAudioInput.
    fileprivate func prepareActiveAudioInput() {
        do {
            activeAudioInput = try AVCaptureDeviceInput(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio))
            
            guard session.canAddInput(activeAudioInput) else {
                return
            }
            
            session.addInput(activeAudioInput)
        } catch let e as NSError {
            delegate?.capture?(capture: self, failedWith: e)
        }
    }
    
    /// Prepares the imageOutput.
    fileprivate func prepareImageOutput() {
        imageOutput = AVCaptureStillImageOutput()
        
        guard session.canAddOutput(imageOutput) else {
            return
        }
        
        imageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        session.addOutput(imageOutput)
    }
    
    /// Prepares the movieOutput.
    fileprivate func prepareMovieOutput() {
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
    
    /// Changees the camera if possible.
    open func changeCamera() {
        guard canChangeCamera else {
            return
        }
        
        do {
            guard let v = devicePosition else {
                return
            }
            
            delegate?.capture?(capture: self, willChangeCamera: v)
            
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
            
            delegate?.capture?(capture: self, didChangeCamera: v)
        } catch let e as NSError {
            delegate?.capture?(capture: self, failedWith: e)
        }
    }
    
    /// Changees the mode.
    open func changeMode() {
        delegate?.capture?(capture: self, willChange: mode)
        mode = .photo == mode ? .video : .photo
        delegate?.capture?(capture: self, didChange: mode)
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
            error = NSError(domain: "com.cosmicmind.material.capture", code: 0004, userInfo: userInfo)
            userInfo[NSUnderlyingErrorKey] = error
        }
        
        if let e = error {
            delegate?.capture?(capture: self, failedWith: e)
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
            error = NSError(domain: "com.cosmicmind.material.capture", code: 0005, userInfo: userInfo)
            userInfo[NSUnderlyingErrorKey] = error
        }
        
        if let e = error {
            delegate?.capture?(capture: self, failedWith: e)
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if context == &CaptureAdjustingExposureContext {
            let device = object as! AVCaptureDevice
            if !device.isAdjustingExposure && device.isExposureModeSupported(.locked) {
                (object! as AnyObject).removeObserver(self, forKeyPath: "adjustingExposure", context: &CaptureAdjustingExposureContext)
                DispatchQueue.main.async { [weak self] in
                    do {
                        try device.lockForConfiguration()
                        device.exposureMode = .locked
                        device.unlockForConfiguration()
                    } catch let e as NSError {
                        guard let s = self else {
                            return
                        }
                        
                        s.delegate?.capture?(capture: s, failedWith: e)
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
            delegate?.capture?(capture: self, failedWith: e)
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
                            s.delegate?.capture?(capture: s, asynchronouslyStill: image2)
                        } else {
                            var userInfo = [String: Any]()
                            userInfo[NSLocalizedDescriptionKey] = "[Material Error: Cannot fix image orientation.]"
                            userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Cannot fix image orientation.]"
                            captureError = NSError(domain: "com.cosmicmind.material.capture", code: 0006, userInfo: userInfo)
                            userInfo[NSUnderlyingErrorKey] = error
                        }
                    } else {
                        var userInfo = [String: Any]()
                        userInfo[NSLocalizedDescriptionKey] = "[Material Error: Cannot capture image from data.]"
                        userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Cannot capture image from data.]"
                        captureError = NSError(domain: "com.cosmicmind.material.capture", code: 0007, userInfo: userInfo)
                        userInfo[NSUnderlyingErrorKey] = error
                    }
                }
                
                if let e = captureError {
                    s.delegate?.capture?(capture: s, asynchronouslyStillImageFailedWith: e)
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
                        s.delegate?.capture?(capture: s, failedWith: e)
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
    fileprivate func camera(at position: AVCaptureDevicePosition) -> AVCaptureDevice? {
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
    fileprivate func uniqueURL() -> URL? {
        do {
            let directory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .full
            
            return directory.appendingPathComponent(dateFormatter.string(from: NSDate() as Date) + ".mov")
        } catch let e as NSError {
            delegate?.capture?(capture: self, createMovieFileFailedWith: e)
            
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
    fileprivate func handleCaptureButton(button: UIButton) {
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
        
        delegate?.capture?(capture: self, didPressCapture: button)
    }
    
    /**
     Handler for the changeModeButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    fileprivate func handleChangeModeButton(button: UIButton) {
        changeMode()
        delegate?.capture?(capture: self, didPressChangeMode: button)
    }
    
    /**
     Handler for the changeCameraButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    fileprivate func handleChangeCameraButton(button: UIButton) {
        DispatchQueue.main.async { [weak self] in
            self?.changeCamera()
        }
        
        delegate?.capture?(capture: self, didPressChangeCamera: button)
    }
    
    /**
     Handler for the flashButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    fileprivate func handleFlashButton(button: UIButton) {
        delegate?.capture?(capture: self, didPressFlash: button)
    }
    
    /**
     Handler for the tapToFocusGesture.
     - Parameter recognizer: A UITapGestureRecognizer that is associated with the event.
     */
    @objc
    fileprivate func handleTapToFocusGesture(recognizer: UITapGestureRecognizer) {
        guard isTapToFocusEnabled && isFocusPointOfInterestSupported else {
            return
        }
        
        let point = recognizer.location(in: self)
        focus(at: preview.captureDevicePointOfInterestForPoint(point: point))
        delegate?.capture?(capture: self, didTapToFocusAt: point)
    }
    
    /**
     Handler for the tapToExposeGesture.
     - Parameter recognizer: A UITapGestureRecognizer that is associated with the event.
     */
    @objc
    fileprivate func handleTapToExposeGesture(recognizer: UITapGestureRecognizer) {
        guard isTapToExposeEnabled && isExposurePointOfInterestSupported else {
            return
        }
        
        let point = recognizer.location(in: self)
        expose(at: preview.captureDevicePointOfInterestForPoint(point: point))
        delegate?.capture?(capture: self, didTapToExposeAt: point)
    }
    
    /**
     Handler for the tapToResetGesture.
     - Parameter recognizer: A UITapGestureRecognizer that is associated with the event.
     */
    @objc
    fileprivate func handleTapToResetGesture(recognizer: UITapGestureRecognizer) {
        guard isTapToResetEnabled else {
            return
        }
        
        reset()
        
        let point = preview.pointForCaptureDevicePointOfInterest(point: CGPoint(x: 0.5, y: 0.5))
        delegate?.capture?(capture: self, didTapToResetAt: point)
    }
}

extension Capture {
    /// Starts the timer for recording.
    fileprivate func startTimer() {
        timer?.invalidate()
        timer = Timer(timeInterval: 0.5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .commonModes)
        
        delegate?.capture?(capture: self, didStartRecord: timer!)
    }
    
    /// Updates the timer when recording.
    @objc
    fileprivate func updateTimer() {
        let duration = recordedDuration
        let time = CMTimeGetSeconds(duration)
        let hours = Int(time / 3600)
        let minutes = Int((time / 60).truncatingRemainder(dividingBy: 60))
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        
        delegate?.capture?(capture: self, didUpdateRecord: timer!, hours: hours, minutes: minutes, seconds: seconds)
    }
    
    /// Stops the timer when recording.
    fileprivate func stopTimer() {
        let duration = recordedDuration
        let time = CMTimeGetSeconds(duration)
        let hours = Int(time / 3600)
        let minutes = Int((time / 60).truncatingRemainder(dividingBy: 60))
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        
        timer?.invalidate()
        
        delegate?.capture?(capture: self, didStopRecord: timer!, hours: hours, minutes: minutes, seconds: seconds)
        
        timer = nil
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
    fileprivate func prepareTapGesture(gesture: inout UITapGestureRecognizer?, numberOfTapsRequired: Int, numberOfTouchesRequired: Int, selector: Selector) {
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
    fileprivate func removeTapGesture(gesture: inout UITapGestureRecognizer?) {
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
        delegate?.capture?(capture: self, captureOutput: captureOutput, didStartRecordingToOutputFileAt: fileURL as NSURL, fromConnections: connections)
    }
    
    public func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        isRecording = false
        delegate?.capture?(capture: self, captureOutput: captureOutput, didFinishRecordingToOutputFileAt: outputFileURL as NSURL, fromConnections: connections, error: error)
    }
}
