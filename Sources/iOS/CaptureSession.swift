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

private var CaptureSessionAdjustingExposureContext: UInt8 = 1

public enum CaptureSessionPreset {
	case PresetPhoto
	case PresetHigh
	case PresetMedium
	case PresetLow
	case Preset352x288
	case Preset640x480
	case Preset1280x720
	case Preset1920x1080
	case Preset3840x2160
	case PresetiFrame960x540
	case PresetiFrame1280x720
	case PresetInputPriority
}

/**
	:name:	CaptureSessionPresetToString
*/
public func CaptureSessionPresetToString(preset: CaptureSessionPreset) -> String {
	switch preset {
	case .PresetPhoto:
		return AVCaptureSessionPresetPhoto
	case .PresetHigh:
		return AVCaptureSessionPresetHigh
	case .PresetMedium:
		return AVCaptureSessionPresetMedium
	case .PresetLow:
		return AVCaptureSessionPresetLow
	case .Preset352x288:
		return AVCaptureSessionPreset352x288
	case .Preset640x480:
		return AVCaptureSessionPreset640x480
	case .Preset1280x720:
		return AVCaptureSessionPreset1280x720
	case .Preset1920x1080:
		return AVCaptureSessionPreset1920x1080
	case .Preset3840x2160:
		if #available(iOS 9.0, *) {
			return AVCaptureSessionPreset3840x2160
		} else {
			return AVCaptureSessionPresetHigh
		}
	case .PresetiFrame960x540:
		return AVCaptureSessionPresetiFrame960x540
	case .PresetiFrame1280x720:
		return AVCaptureSessionPresetiFrame1280x720
	case .PresetInputPriority:
		return AVCaptureSessionPresetInputPriority
	}
}

@objc(CaptureSessionDelegate)
public protocol CaptureSessionDelegate {
	/**
     A delegation method that is fired when the captureSesstion failes with an error.
     - Parameter captureSession: A reference to the calling CaptureSession.
     - Parameter error: A NSError corresponding to the error.
     */
	@objc
    optional func captureSessionFailedWithError(captureSession: CaptureSession, error: NSError)
	
    /**
     A delegation method that is fired when the camera has been switched to another.
     - Parameter captureSession: A reference to the calling CaptureSession.
     - Parameter position: An AVCaptureDevicePosition that the camera has switched to.
     */
    @objc
    optional func captureSessionDidSwitchCameras(captureSession: CaptureSession, position: AVCaptureDevicePosition)
	
    /**
     A delegation method that is fired before the camera has been switched to another.
     - Parameter captureSession: A reference to the calling CaptureSession.
     - Parameter position: An AVCaptureDevicePosition that the camera will switch to.
     */
    @objc
	optional func captureSessionWillSwitchCameras(captureSession: CaptureSession, position: AVCaptureDevicePosition)
	
    /**
     A delegation method that is fired when an image has been captured asynchronously.
     - Parameter captureSession: A reference to the calling CaptureSession.
     - Parameter image: An image that has been captured.
     */
    @objc
	optional func captureStillImageAsynchronously(captureSession: CaptureSession, image: UIImage)
	
    /**
     A delegation method that is fired when capturing an image asynchronously has failed.
     - Parameter captureSession: A reference to the calling CaptureSession.
     - Parameter error: A NSError corresponding to the error.
     */
    @objc
	optional func captureStillImageAsynchronouslyFailedWithError(captureSession: CaptureSession, error: NSError)
	
	/**
	:name:	captureCreateMovieFileFailedWithError
	*/
    @objc
	optional func captureCreateMovieFileFailedWithError(captureSession: CaptureSession, error: NSError)
	
	/**
	:name:	captureMovieFailedWithError
	*/
    @objc
	optional func captureMovieFailedWithError(captureSession: CaptureSession, error: NSError)
	
	/**
	:name:	captureDidStartRecordingToOutputFileAtURL
	*/
    @objc
	optional func captureDidStartRecordingToOutputFileAtURL(captureSession: CaptureSession, captureOutput: AVCaptureFileOutput, fileURL: NSURL, fromConnections connections: [AnyObject])
	
	/**
	:name:	captureDidFinishRecordingToOutputFileAtURL
	*/
    @objc
	optional func captureDidFinishRecordingToOutputFileAtURL(captureSession: CaptureSession, captureOutput: AVCaptureFileOutput, outputFileURL: NSURL, fromConnections connections: [AnyObject], error: NSError!)
}

@objc(CaptureSession)
public class CaptureSession: NSObject, AVCaptureFileOutputRecordingDelegate {
	/**
	:name:	sessionQueue
	*/
    private var sessionQueue: DispatchQueue!
	
	/**
	:name:	activeVideoInput
	*/
	private var activeVideoInput: AVCaptureDeviceInput?
	
	/**
	:name:	activeAudioInput
	*/
	private var activeAudioInput: AVCaptureDeviceInput?
	
	/**
	:name:	imageOutput
	*/
	private lazy var imageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
	
	/**
	:name:	movieOutput
	*/
	private lazy var movieOutput: AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
	
	/**
	:name:	movieOutputURL
	*/
	private var movieOutputURL: NSURL?
	
	/**
	:name: session
	*/
	internal lazy var session: AVCaptureSession = AVCaptureSession()
	
	/**
	:name:	isRunning
	*/
	public private(set) lazy var isRunning: Bool = false
	
	/**
	:name:	isRecording
	*/
	public private(set) lazy var isRecording: Bool = false
	
	/**
	:name:	recordedDuration
	*/
	public var recordedDuration: CMTime {
		return movieOutput.recordedDuration
	}
	
	/**
	:name:	activeCamera
	*/
	public var activeCamera: AVCaptureDevice? {
		return activeVideoInput?.device
	}
	
	/**
	:name:	inactiveCamera
	*/
	public var inactiveCamera: AVCaptureDevice? {
		var device: AVCaptureDevice?
		if 1 < cameraCount {
			if activeCamera?.position == .back {
				device = cameraWithPosition(position: .front)
			} else {
				device = cameraWithPosition(position: .back)
			}
		}
		return device
	}
	
	/**
	:name:	cameraCount
	*/
	public var cameraCount: Int {
		return AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count
	}
	
	/**
	:name:	canSwitchCameras
	*/
	public var canSwitchCameras: Bool {
		return 1 < cameraCount
	}
	
	/**
	:name:	caneraSupportsTapToFocus
	*/
	public var cameraSupportsTapToFocus: Bool {
		return nil == activeCamera ? false : activeCamera!.isFocusPointOfInterestSupported
	}
	
	/**
	:name:	cameraSupportsTapToExpose
	*/
	public var cameraSupportsTapToExpose: Bool {
		return nil == activeCamera ? false : activeCamera!.isExposurePointOfInterestSupported
	}
	
	/**
	:name:	cameraHasFlash
	*/
	public var cameraHasFlash: Bool {
		return nil == activeCamera ? false : activeCamera!.hasFlash
	}
	
	/**
	:name:	cameraHasTorch
	*/
	public var cameraHasTorch: Bool {
		return nil == activeCamera ? false : activeCamera!.hasTorch
	}
	
	/**
	:name:	cameraPosition
	*/
	public var cameraPosition: AVCaptureDevicePosition? {
		return activeCamera?.position
	}
	
	/**
	:name:	focusMode
	*/
	public var focusMode: AVCaptureFocusMode {
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
				var userInfo: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported focusMode.]"
				userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported focusMode.]"
				error = NSError(domain: "io.cosmicmind.Material.CaptureView", code: 0001, userInfo: userInfo)
				userInfo[NSUnderlyingErrorKey] = error
			}
			if let e: NSError = error {
				delegate?.captureSessionFailedWithError?(capture: self, error: e)
			}
		}
	}
	
	/**
	:name:	flashMode
	*/
	public var flashMode: AVCaptureFlashMode {
		get {
			return activeCamera!.flashMode
		}
		set(value) {
			var error: NSError?
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
				var userInfo: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported flashMode.]"
				userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported flashMode.]"
				error = NSError(domain: "io.cosmicmind.Material.CaptureView", code: 0002, userInfo: userInfo)
				userInfo[NSUnderlyingErrorKey] = error
			}
			if let e: NSError = error {
				delegate?.captureSessionFailedWithError?(capture: self, error: e)
			}
		}
	}
	
	/**
	:name:	torchMode
	*/
	public var torchMode: AVCaptureTorchMode {
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
				var userInfo: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported torchMode.]"
				userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported torchMode.]"
				error = NSError(domain: "io.cosmicmind.Material.CaptureView", code: 0003, userInfo: userInfo)
				userInfo[NSUnderlyingErrorKey] = error
			}
			if let e: NSError = error {
				delegate?.captureSessionFailedWithError?(capture: self, error: e)
			}
		}
	}
	
	/// The session quality preset.
	public var sessionPreset: CaptureSessionPreset {
		didSet {
			session.sessionPreset = CaptureSessionPresetToString(preset: sessionPreset)
		}
	}
	
	/// The capture video orientation.
	public var videoOrientation: AVCaptureVideoOrientation {
		var orientation: AVCaptureVideoOrientation
		switch UIDevice.current().orientation {
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
	
	/// A delegation property for CaptureSessionDelegate.
	public weak var delegate: CaptureSessionDelegate?
	
	/// Initializer.
	public override init() {
		sessionPreset = .PresetHigh
		super.init()
		prepareSession()
	}
	
	/// Starts the session.
	public func startSession() {
		if !isRunning {
			sessionQueue.async() { [weak self] in
				self?.session.startRunning()
			}
		}
	}
	
	/// Stops the session.
	public func stopSession() {
		if isRunning {
			sessionQueue.async() { [weak self] in
				self?.session.stopRunning()
			}
		}
	}
	
	/// Switches the camera if possible.
	public func switchCameras() {
		if canSwitchCameras {
			do {
				if let v: AVCaptureDevicePosition = cameraPosition {
					delegate?.captureSessionWillSwitchCameras?(capture: self, position: v)
					let videoInput: AVCaptureDeviceInput? = try AVCaptureDeviceInput(device: inactiveCamera!)
					session.beginConfiguration()
					session.removeInput(activeVideoInput)
					
					if session.canAddInput(videoInput) {
						session.addInput(videoInput)
						activeVideoInput = videoInput
					} else {
						session.addInput(activeVideoInput)
					}
					session.commitConfiguration()
					delegate?.captureSessionDidSwitchCameras?(capture: self, position: cameraPosition!)
				}
			} catch let e as NSError {
				delegate?.captureSessionFailedWithError?(capture: self, error: e)
			}
		}
	}
	
	/**
	:name:	isFocusModeSupported
	*/
	public func isFocusModeSupported(focusMode: AVCaptureFocusMode) -> Bool {
		return activeCamera!.isFocusModeSupported(focusMode)
	}
	
	/**
	:name:	isExposureModeSupported
	*/
	public func isExposureModeSupported(exposureMode: AVCaptureExposureMode) -> Bool {
		return activeCamera!.isExposureModeSupported(exposureMode)
	}
	
	/**
	:name:	isFlashModeSupported
	*/
	public func isFlashModeSupported(flashMode: AVCaptureFlashMode) -> Bool {
		return activeCamera!.isFlashModeSupported(flashMode)
	}
	
	/**
	:name:	isTorchModeSupported
	*/
	public func isTorchModeSupported(torchMode: AVCaptureTorchMode) -> Bool {
		return activeCamera!.isTorchModeSupported(torchMode)
	}
	
	/**
	:name:	focusAtPoint
	*/
	public func focusAtPoint(point: CGPoint) {
		var error: NSError?
		if cameraSupportsTapToFocus && isFocusModeSupported(focusMode: .autoFocus) {
			do {
				let device: AVCaptureDevice = activeCamera!
				try device.lockForConfiguration()
				device.focusPointOfInterest = point
				device.focusMode = .autoFocus
				device.unlockForConfiguration()
			} catch let e as NSError {
				error = e
			}
		} else {
			var userInfo: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
			userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported focusAtPoint.]"
			userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported focusAtPoint.]"
			error = NSError(domain: "io.cosmicmind.Material.CaptureView", code: 0004, userInfo: userInfo)
			userInfo[NSUnderlyingErrorKey] = error
		}
		if let e: NSError = error {
			delegate?.captureSessionFailedWithError?(capture: self, error: e)
		}
	}
	
	/**
	:name:	exposeAtPoint
	*/
	public func exposeAtPoint(point: CGPoint) {
		var error: NSError?
		if cameraSupportsTapToExpose && isExposureModeSupported(exposureMode: .continuousAutoExposure) {
			do {
				let device: AVCaptureDevice = activeCamera!
				try device.lockForConfiguration()
				device.exposurePointOfInterest = point
				device.exposureMode = .continuousAutoExposure
				if device.isExposureModeSupported(.locked) {
					device.addObserver(self, forKeyPath: "adjustingExposure", options: .new, context: &CaptureSessionAdjustingExposureContext)
				}
				device.unlockForConfiguration()
			} catch let e as NSError {
				error = e
			}
		} else {
			var userInfo: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
			userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported exposeAtPoint.]"
			userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported exposeAtPoint.]"
			error = NSError(domain: "io.cosmicmind.Material.CaptureView", code: 0005, userInfo: userInfo)
			userInfo[NSUnderlyingErrorKey] = error
		}
		if let e: NSError = error {
			delegate?.captureSessionFailedWithError?(capture: self, error: e)
		}
	}
	
	/**
	:name:	observeValueForKeyPath
	*/
	public override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey: AnyObject]?, context: UnsafeMutablePointer<Void>?) {
		if context == &CaptureSessionAdjustingExposureContext {
			let device: AVCaptureDevice = object as! AVCaptureDevice
			if !device.isAdjustingExposure && device.isExposureModeSupported(.locked) {
				object!.removeObserver(self, forKeyPath: "adjustingExposure", context: &CaptureSessionAdjustingExposureContext)
				DispatchQueue.main.async() {
					do {
						try device.lockForConfiguration()
						device.exposureMode = .locked
						device.unlockForConfiguration()
					} catch let e as NSError {
						self.delegate?.captureSessionFailedWithError?(capture: self, error: e)
					}
				}
			}
		} else {
            super.observeValue(forKeyPath: keyPath, of : object, change: change, context: context)
		}
	}
	
	/**
	:name:	resetFocusAndExposureModes
	*/
	public func resetFocusAndExposureModes() {
		let device: AVCaptureDevice = activeCamera!
		let canResetFocus: Bool = device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.continuousAutoFocus)
		let canResetExposure: Bool = device.isExposurePointOfInterestSupported && device.isExposureModeSupported(.continuousAutoExposure)
        let centerPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
		do {
			try device.lockForConfiguration()
			if canResetFocus {
				device.focusMode = .continuousAutoFocus
				device.focusPointOfInterest = centerPoint
			}
			if canResetExposure {
				device.exposureMode = .continuousAutoExposure
				device.exposurePointOfInterest = centerPoint
			}
			device.unlockForConfiguration()
		} catch let e as NSError {
			delegate?.captureSessionFailedWithError?(capture: self, error: e)
		}
	}
	
	/**
	:name:	captureStillImage
	*/
	public func captureStillImage() {
		sessionQueue.async() { [weak self] in
			if let s: CaptureSession = self {
				if let v: AVCaptureConnection = s.imageOutput.connection(withMediaType: AVMediaTypeVideo) {
					v.videoOrientation = s.videoOrientation
                    s.imageOutput.captureStillImageAsynchronously(from: v) { [weak self] (sampleBuffer: CMSampleBuffer?, error: NSError?) -> Void in
						if let s: CaptureSession = self {
							var captureError: NSError? = error
							if nil == captureError {
								let data: NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
								if let image1: UIImage = UIImage(data: data as Data) {
									if let image2: UIImage = s.adjustOrientationForImage(image: image1) {
										s.delegate?.captureStillImageAsynchronously?(capture: s, image: image2)
									} else {
										var userInfo: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
										userInfo[NSLocalizedDescriptionKey] = "[Material Error: Cannot fix image orientation.]"
										userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Cannot fix image orientation.]"
										captureError = NSError(domain: "io.cosmicmind.Material.CaptureView", code: 0006, userInfo: userInfo)
										userInfo[NSUnderlyingErrorKey] = error
									}
								} else {
									var userInfo: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
									userInfo[NSLocalizedDescriptionKey] = "[Material Error: Cannot capture image from data.]"
									userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Cannot capture image from data.]"
									captureError = NSError(domain: "io.cosmicmind.Material.CaptureView", code: 0007, userInfo: userInfo)
									userInfo[NSUnderlyingErrorKey] = error
								}
							}
							
							if let e: NSError = captureError {
								s.delegate?.captureStillImageAsynchronouslyFailedWithError?(capture: s, error: e)
							}
						}
					}
				}
			}
		}
	}
	
	/**
	:name:	startRecording
	*/
	public func startRecording() {
		if !isRecording {
			sessionQueue.async() { [weak self] in
				if let s: CaptureSession = self {
					if let v: AVCaptureConnection = s.movieOutput.connection(withMediaType: AVMediaTypeVideo) {
						v.videoOrientation = s.videoOrientation
						v.preferredVideoStabilizationMode = .auto
					}
					if let v: AVCaptureDevice = s.activeCamera {
						if v.isSmoothAutoFocusSupported {
							do {
								try v.lockForConfiguration()
								v.isSmoothAutoFocusEnabled = true
								v.unlockForConfiguration()
							} catch let e as NSError {
								s.delegate?.captureSessionFailedWithError?(capture: s, error: e)
							}
						}
						
						s.movieOutputURL = s.uniqueURL()
						if let v: NSURL = s.movieOutputURL {
							s.movieOutput.startRecording(toOutputFileURL: v as URL!, recordingDelegate: s)
						}
					}
				}
			}
		}
	}
	
	/**
	:name:	stopRecording
	*/
	public func stopRecording() {
		if isRecording {
			movieOutput.stopRecording()
		}
	}
	
	/**
	:name:	captureOutput
	*/
    public func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [AnyObject]!) {
        isRecording = true
		delegate?.captureDidStartRecordingToOutputFileAtURL?(capture: self, captureOutput: captureOutput, fileURL: fileURL, fromConnections: connections)
	}
	
	/**
	:name:	captureOutput
	*/
    public func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [AnyObject]!, error: NSError!) {
    	isRecording = false
		delegate?.captureDidFinishRecordingToOutputFileAtURL?(capture: self, captureOutput: captureOutput, outputFileURL: outputFileURL, fromConnections: connections, error: error)
	}
    
    /// Prepares the sessionQueue.
    private func prepareSessionQueue() {
        sessionQueue = DispatchQueue(label: "io.cosmicmind.Material.CaptureSession", attributes: .serial, target: nil)
    }
	
	/**
	:name:	prepareSession
	*/
	private func prepareSession() {
		prepareVideoInput()
		prepareAudioInput()
		prepareImageOutput()
		prepareMovieOutput()
	}
	
	/**
	:name:	prepareVideoInput
	*/
	private func prepareVideoInput() {
		do {
			activeVideoInput = try AVCaptureDeviceInput(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo))
			if session.canAddInput(activeVideoInput) {
				session.addInput(activeVideoInput)
			}
		} catch let e as NSError {
			delegate?.captureSessionFailedWithError?(capture: self, error: e)
		}
	}
	
	/**
	:name:	prepareAudioInput
	*/
	private func prepareAudioInput() {
		do {
			activeAudioInput = try AVCaptureDeviceInput(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio))
			if session.canAddInput(activeAudioInput) {
				session.addInput(activeAudioInput)
			}
		} catch let e as NSError {
			delegate?.captureSessionFailedWithError?(capture: self, error: e)
		}
	}
	
	/**
	:name:	prepareImageOutput
	*/
	private func prepareImageOutput() {
		if session.canAddOutput(imageOutput) {
			imageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
			session.addOutput(imageOutput)
		}
	}
	
	/**
	:name:	prepareMovieOutput
	*/
	private func prepareMovieOutput() {
		if session.canAddOutput(movieOutput) {
			session.addOutput(movieOutput)
		}
	}
	
	/**
	:name:	cameraWithPosition
	*/
	private func cameraWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
		let devices: Array<AVCaptureDevice> = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! Array<AVCaptureDevice>
		for device in devices {
			if device.position == position {
				return device
			}
		}
		return nil
	}
	
	/**
	:name:	uniqueURL
	*/
	private func uniqueURL() -> NSURL? {
		do {
			let directory: NSURL = try FileManager.default().urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
			let dateFormatter = DateFormatter()
			dateFormatter.dateStyle = .fullStyle
			dateFormatter.timeStyle = .fullStyle
			return directory.appendingPathComponent(dateFormatter.string(from: NSDate() as Date) + ".mov")
		} catch let e as NSError {
			delegate?.captureCreateMovieFileFailedWithError?(capture: self, error: e)
		}
		return nil
	}
	
	/**
	Adjusts the orientation of the image from the capture orientation.
	This is an issue when taking images, the capture orientation is not set correctly
	when using Portrait.
	- Parameter image: A UIImage to adjust.
	- Returns: An optional UIImage if successful.
	*/
	private func adjustOrientationForImage(image: UIImage) -> UIImage? {
		guard .up != image.imageOrientation else {
			return image
		}
		
		var transform: CGAffineTransform = .identity
		
		// Rotate if Left, Right, or Down.
		switch image.imageOrientation {
		case .down, .downMirrored:
			transform = transform.translateBy(x: image.size.width, y: image.size.height)
			transform = transform.rotate(CGFloat(M_PI))
		case .left, .leftMirrored:
			transform = transform.translateBy(x: image.size.width, y: 0)
			transform = transform.rotate(CGFloat(M_PI_2))
		case .right, .rightMirrored:
			transform = transform.translateBy(x: 0, y: image.size.height)
			transform = transform.rotate(-CGFloat(M_PI_2))
		default:break
		}
		
		// Flip if mirrored.
		switch image.imageOrientation {
		case .upMirrored, .downMirrored:
			transform = transform.translateBy(x: image.size.width, y: 0)
			transform = transform.scaleBy(x: -1, y: 1)
		case .leftMirrored, .rightMirrored:
			transform = transform.translateBy(x: image.size.height, y: 0)
			transform = transform.scaleBy(x: -1, y: 1)
		default:break
		}
		
		// Draw the underlying CGImage with the calculated transform.
		guard let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue) else {
			return nil
		}
		
		context.concatCTM(transform)
		
		switch image.imageOrientation {
		case .left, .leftMirrored, .right, .rightMirrored:
			context.draw(in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width), image: image.cgImage!)
		default:
			context.draw(in: CGRect(origin: .zero, size: image.size), image: image.cgImage!)
		}
		
		guard let cgImage = context.makeImage() else {
			return nil
		}
		
		return UIImage(cgImage: cgImage)
	}
}
