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
*	*	Neither the name of Material nor the names of its
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
	:name:	captureSessionFailedWithError
	*/
	optional func captureSessionFailedWithError(capture: CaptureSession, error: NSError)
	
	/**
	:name:	captureSessionDidSwitchCameras
	*/
	optional func captureSessionDidSwitchCameras(capture: CaptureSession, position: AVCaptureDevicePosition)
	
	/**
	:name:	captureSessionWillSwitchCameras
	*/
	optional func captureSessionWillSwitchCameras(capture: CaptureSession, position: AVCaptureDevicePosition)
	
	/**
	:name:	captureStillImageAsynchronously
	*/
	optional func captureStillImageAsynchronously(capture: CaptureSession, image: UIImage)
	
	/**
	:name:	captureStillImageAsynchronouslyFailedWithError
	*/
	optional func captureStillImageAsynchronouslyFailedWithError(capture: CaptureSession, error: NSError)
	
	/**
	:name:	captureCreateMovieFileFailedWithError
	*/
	optional func captureCreateMovieFileFailedWithError(capture: CaptureSession, error: NSError)
	
	/**
	:name:	captureMovieFailedWithError
	*/
	optional func captureMovieFailedWithError(capture: CaptureSession, error: NSError)
	
	/**
	:name:	captureDidStartRecordingToOutputFileAtURL
	*/
	optional func captureDidStartRecordingToOutputFileAtURL(capture: CaptureSession, captureOutput: AVCaptureFileOutput, fileURL: NSURL, fromConnections connections: [AnyObject])
	
	/**
	:name:	captureDidFinishRecordingToOutputFileAtURL
	*/
	optional func captureDidFinishRecordingToOutputFileAtURL(capture: CaptureSession, captureOutput: AVCaptureFileOutput, outputFileURL: NSURL, fromConnections connections: [AnyObject], error: NSError!)
}

@objc(CaptureSession)
public class CaptureSession : NSObject, AVCaptureFileOutputRecordingDelegate {
	/**
	:name:	sessionQueue
	*/
	private lazy var sessionQueue: dispatch_queue_t = dispatch_queue_create("io.material.CaptureSession", DISPATCH_QUEUE_SERIAL)
	
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
			if activeCamera?.position == .Back {
				device = cameraWithPosition(.Front)
			} else {
				device = cameraWithPosition(.Back)
			}
		}
		return device
	}
	
	/**
	:name:	cameraCount
	*/
	public var cameraCount: Int {
		return AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo).count
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
		return nil == activeCamera ? false : activeCamera!.focusPointOfInterestSupported
	}
	
	/**
	:name:	cameraSupportsTapToExpose
	*/
	public var cameraSupportsTapToExpose: Bool {
		return nil == activeCamera ? false : activeCamera!.exposurePointOfInterestSupported
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
			if isFocusModeSupported(focusMode) {
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
				delegate?.captureSessionFailedWithError?(self, error: e)
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
			if isFlashModeSupported(flashMode) {
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
				delegate?.captureSessionFailedWithError?(self, error: e)
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
			if isTorchModeSupported(torchMode) {
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
				delegate?.captureSessionFailedWithError?(self, error: e)
			}
		}
	}
	
	/// The session quality preset.
	public var sessionPreset: CaptureSessionPreset {
		didSet {
			session.sessionPreset = CaptureSessionPresetToString(sessionPreset)
		}
	}
	
	/// The capture video orientation.
	public var videoOrientation: AVCaptureVideoOrientation {
		var orientation: AVCaptureVideoOrientation
		switch UIDevice.currentDevice().orientation {
		case .Portrait:
			orientation = .Portrait
		case .LandscapeRight:
			orientation = .LandscapeLeft
		case .PortraitUpsideDown:
			orientation = .PortraitUpsideDown
		default:
			orientation = .LandscapeRight
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
			dispatch_async(sessionQueue) { [weak self] in
				self?.session.startRunning()
			}
		}
	}
	
	/// Stops the session.
	public func stopSession() {
		if isRunning {
			dispatch_async(sessionQueue) { [weak self] in
				self?.session.stopRunning()
			}
		}
	}
	
	/// Switches the camera if possible.
	public func switchCameras() {
		if canSwitchCameras {
			do {
				if let v: AVCaptureDevicePosition = cameraPosition {
					delegate?.captureSessionWillSwitchCameras?(self, position: v)
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
					delegate?.captureSessionDidSwitchCameras?(self, position: cameraPosition!)
				}
			} catch let e as NSError {
				delegate?.captureSessionFailedWithError?(self, error: e)
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
		if cameraSupportsTapToFocus && isFocusModeSupported(.AutoFocus) {
			do {
				let device: AVCaptureDevice = activeCamera!
				try device.lockForConfiguration()
				device.focusPointOfInterest = point
				device.focusMode = .AutoFocus
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
			delegate?.captureSessionFailedWithError?(self, error: e)
		}
	}
	
	/**
	:name:	exposeAtPoint
	*/
	public func exposeAtPoint(point: CGPoint) {
		var error: NSError?
		if cameraSupportsTapToExpose && isExposureModeSupported(.ContinuousAutoExposure) {
			do {
				let device: AVCaptureDevice = activeCamera!
				try device.lockForConfiguration()
				device.exposurePointOfInterest = point
				device.exposureMode = .ContinuousAutoExposure
				if device.isExposureModeSupported(.Locked) {
					device.addObserver(self, forKeyPath: "adjustingExposure", options: .New, context: &CaptureSessionAdjustingExposureContext)
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
			delegate?.captureSessionFailedWithError?(self, error: e)
		}
	}
	
	/**
	:name:	observeValueForKeyPath
	*/
	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if context == &CaptureSessionAdjustingExposureContext {
			let device: AVCaptureDevice = object as! AVCaptureDevice
			if !device.adjustingExposure && device.isExposureModeSupported(.Locked) {
				object!.removeObserver(self, forKeyPath: "adjustingExposure", context: &CaptureSessionAdjustingExposureContext)
				dispatch_async(dispatch_get_main_queue()) {
					do {
						try device.lockForConfiguration()
						device.exposureMode = .Locked
						device.unlockForConfiguration()
					} catch let e as NSError {
						self.delegate?.captureSessionFailedWithError?(self, error: e)
					}
				}
			}
		} else {
			super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
		}
	}
	
	/**
	:name:	resetFocusAndExposureModes
	*/
	public func resetFocusAndExposureModes() {
		let device: AVCaptureDevice = activeCamera!
		let canResetFocus: Bool = device.focusPointOfInterestSupported && device.isFocusModeSupported(.ContinuousAutoFocus)
		let canResetExposure: Bool = device.exposurePointOfInterestSupported && device.isExposureModeSupported(.ContinuousAutoExposure)
		let centerPoint: CGPoint = CGPointMake(0.5, 0.5)
		do {
			try device.lockForConfiguration()
			if canResetFocus {
				device.focusMode = .ContinuousAutoFocus
				device.focusPointOfInterest = centerPoint
			}
			if canResetExposure {
				device.exposureMode = .ContinuousAutoExposure
				device.exposurePointOfInterest = centerPoint
			}
			device.unlockForConfiguration()
		} catch let e as NSError {
			delegate?.captureSessionFailedWithError?(self, error: e)
		}
	}
	
	/**
	:name:	captureStillImage
	*/
	public func captureStillImage() {
		dispatch_async(sessionQueue) { [weak self] in
			if let s: CaptureSession = self {
				if let v: AVCaptureConnection = s.imageOutput.connectionWithMediaType(AVMediaTypeVideo) {
					v.videoOrientation = s.videoOrientation
					s.imageOutput.captureStillImageAsynchronouslyFromConnection(v) { [weak self] (sampleBuffer: CMSampleBuffer!, error: NSError!) -> Void in
						if let s: CaptureSession = self {
							var captureError: NSError? = error
							if nil == captureError {
								let data: NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
								if let image1: UIImage = UIImage(data: data) {
									if let image2: UIImage = s.adjustOrientationForImage(image1) {
										s.delegate?.captureStillImageAsynchronously?(s, image: image2)
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
								s.delegate?.captureStillImageAsynchronouslyFailedWithError?(s, error: e)
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
			dispatch_async(sessionQueue) { [weak self] in
				if let s: CaptureSession = self {
					if let v: AVCaptureConnection = s.movieOutput.connectionWithMediaType(AVMediaTypeVideo) {
						v.videoOrientation = s.videoOrientation
						v.preferredVideoStabilizationMode = .Auto
					}
					if let v: AVCaptureDevice = s.activeCamera {
						if v.smoothAutoFocusSupported {
							do {
								try v.lockForConfiguration()
								v.smoothAutoFocusEnabled = true
								v.unlockForConfiguration()
							} catch let e as NSError {
								s.delegate?.captureSessionFailedWithError?(s, error: e)
							}
						}
						
						s.movieOutputURL = s.uniqueURL()
						if let v: NSURL = s.movieOutputURL {
							s.movieOutput.startRecordingToOutputFileURL(v, recordingDelegate: s)
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
	public func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
		isRecording = true
		delegate?.captureDidStartRecordingToOutputFileAtURL?(self, captureOutput: captureOutput, fileURL: fileURL, fromConnections: connections)
	}
	
	/**
	:name:	captureOutput
	*/
	public func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
		isRecording = false
		delegate?.captureDidFinishRecordingToOutputFileAtURL?(self, captureOutput: captureOutput, outputFileURL: outputFileURL, fromConnections: connections, error: error)
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
			activeVideoInput = try AVCaptureDeviceInput(device: AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo))
			if session.canAddInput(activeVideoInput) {
				session.addInput(activeVideoInput)
			}
		} catch let e as NSError {
			delegate?.captureSessionFailedWithError?(self, error: e)
		}
	}
	
	/**
	:name:	prepareAudioInput
	*/
	private func prepareAudioInput() {
		do {
			activeAudioInput = try AVCaptureDeviceInput(device: AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio))
			if session.canAddInput(activeAudioInput) {
				session.addInput(activeAudioInput)
			}
		} catch let e as NSError {
			delegate?.captureSessionFailedWithError?(self, error: e)
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
		let devices: Array<AVCaptureDevice> = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! Array<AVCaptureDevice>
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
			let directory: NSURL = try NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateStyle = .FullStyle
			dateFormatter.timeStyle = .FullStyle
			return directory.URLByAppendingPathComponent(dateFormatter.stringFromDate(NSDate()) + ".mov")
		} catch let e as NSError {
			delegate?.captureCreateMovieFileFailedWithError?(self, error: e)
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
		guard .Up != image.imageOrientation else {
			return image
		}
		
		var transform: CGAffineTransform = CGAffineTransformIdentity
		
		// Rotate if Left, Right, or Down.
		switch image.imageOrientation {
		case .Down, .DownMirrored:
			transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height)
			transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
		case .Left, .LeftMirrored:
			transform = CGAffineTransformTranslate(transform, image.size.width, 0)
			transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
		case .Right, .RightMirrored:
			transform = CGAffineTransformTranslate(transform, 0, image.size.height)
			transform = CGAffineTransformRotate(transform, -CGFloat(M_PI_2))
		default:break
		}
		
		// Flip if mirrored.
		switch image.imageOrientation {
		case .UpMirrored, .DownMirrored:
			transform = CGAffineTransformTranslate(transform, image.size.width, 0)
			transform = CGAffineTransformScale(transform, -1, 1)
		case .LeftMirrored, .RightMirrored:
			transform = CGAffineTransformTranslate(transform, image.size.height, 0)
			transform = CGAffineTransformScale(transform, -1, 1)
		default:break
		}
		
		// Draw the underlying CGImage with the calculated transform.
		guard let context = CGBitmapContextCreate(nil, Int(image.size.width), Int(image.size.height), CGImageGetBitsPerComponent(image.CGImage), 0, CGImageGetColorSpace(image.CGImage), CGImageGetBitmapInfo(image.CGImage).rawValue) else {
			return nil
		}
		
		CGContextConcatCTM(context, transform)
		
		switch image.imageOrientation {
		case .Left, .LeftMirrored, .Right, .RightMirrored:
			CGContextDrawImage(context, CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width), image.CGImage)
		default:
			CGContextDrawImage(context, CGRect(origin: .zero, size: image.size), image.CGImage)
		}
		
		guard let CGImage = CGBitmapContextCreateImage(context) else {
			return nil
		}
		
		return UIImage(CGImage: CGImage)
	}
}
