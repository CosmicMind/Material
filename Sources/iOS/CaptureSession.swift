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

private var CaptureSessionAdjustingExposureContext: UInt8 = 0

@objc(CaptureSessionPreset)
public enum CaptureSessionPreset: Int {
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
public func CaptureSessionPresetToString(preset: CaptureSessionPreset) -> String {
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

@objc(CaptureSessionDelegate)
public protocol CaptureSessionDelegate {
	/**
     A delegation method that is fired when the captureSesstion failes with an error.
     - Parameter captureSession: A reference to the calling CaptureSession.
     - Parameter error: A Error corresponding to the error.
     */
	@objc
    optional func captureSessionFailedWithError(captureSession: CaptureSession, error: Error)
	
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
	optional func captureSessionStillImageAsynchronously(captureSession: CaptureSession, image: UIImage)
	
    /**
     A delegation method that is fired when capturing an image asynchronously has failed.
     - Parameter captureSession: A reference to the calling CaptureSession.
     - Parameter error: A Error corresponding to the error.
     */
    @objc
	optional func captureSessionStillImageAsynchronouslyFailedWithError(captureSession: CaptureSession, error: Error)
	
    /**
     A delegation method that is fired when creating a movie file has failed.
     - Parameter captureSession: A reference to the calling CaptureSession.
     - Parameter error: A Error corresponding to the error.
     */
    @objc
	optional func captureSessionCreateMovieFileFailedWithError(captureSession: CaptureSession, error: Error)
	
    /**
     A delegation method that is fired when capturing a movie has failed.
     - Parameter captureSession: A reference to the calling CaptureSession.
     - Parameter error: A Error corresponding to the error.
     */
    @objc
	optional func captureSessionMovieFailedWithError(captureSession: CaptureSession, error: Error)
	
    /**
     A delegation method that is fired when a session started recording and writing
     to a file.
     - Parameter captureSession: A reference to the calling CaptureSession.
     - Parameter captureOut: An AVCaptureFileOutput.
     - Parameter fileURL: A file URL.
     - Parameter fromConnections: An array of Anys.
     */
    @objc
	optional func captureSessionDidStartRecordingToOutputFileAtURL(captureSession: CaptureSession, captureOutput: AVCaptureFileOutput, fileURL: NSURL, fromConnections connections: [Any])
	
    /**
     A delegation method that is fired when a session finished recording and writing
     to a file.
     - Parameter captureSession: A reference to the calling CaptureSession.
     - Parameter captureOut: An AVCaptureFileOutput.
     - Parameter fileURL: A file URL.
     - Parameter fromConnections: An array of Anys.
     - Parameter error: A Error corresponding to an error.
     */
    @objc
	optional func captureSessionDidFinishRecordingToOutputFileAtURL(captureSession: CaptureSession, captureOutput: AVCaptureFileOutput, outputFileURL: NSURL, fromConnections connections: [Any], error: Error!)
}

@objc(CaptureSession)
open class CaptureSession: NSObject, AVCaptureFileOutputRecordingDelegate {
	/// A reference to the session DispatchQueue.
    private var sessionQueue: DispatchQueue!
	
	/// A reference to the active video input.
	private var activeVideoInput: AVCaptureDeviceInput?
	
	/// A reference to the active audio input.
	private var activeAudioInput: AVCaptureDeviceInput?
	
	/// A reference to the image output.
	private var imageOutput: AVCaptureStillImageOutput!
	
	/// A reference to the movie output.
	private var movieOutput: AVCaptureMovieFileOutput!
	
	/// A reference to the movie output URL.
	private var movieOutputURL: URL?
	
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
	open var hasFlash: Bool {
		return nil == activeCamera ? false : activeCamera!.hasFlash
	}
	
    /// A boolean indicating if the active camera has a torch.
    open var hasTorch: Bool {
		return nil == activeCamera ? false : activeCamera!.hasTorch
	}
	
	/// A reference to the active camera position if the active camera exists.
	open var position: AVCaptureDevicePosition? {
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
				delegate?.captureSessionFailedWithError?(captureSession: self, error: e)
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
				delegate?.captureSessionFailedWithError?(captureSession: self, error: e)
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
			if let e: NSError = error {
				delegate?.captureSessionFailedWithError?(captureSession: self, error: e)
			}
		}
	}
	
	/// The session quality preset.
	open var preset: CaptureSessionPreset {
		didSet {
			session.sessionPreset = CaptureSessionPresetToString(preset: preset)
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
	
	/// A delegation property for CaptureSessionDelegate.
	open weak var delegate: CaptureSessionDelegate?
	
	/// Initializer.
	public override init() {
		preset = .presetHigh
		super.init()
		prepareSession()
        prepareSessionQueue()
        prepareActiveVideoInput()
        prepareActiveAudioInput()
        prepareImageOutput()
        prepareMovieOutput()
	}
	
	/// Starts the session.
	open func startSession() {
		if !isRunning {
			sessionQueue.async() { [weak self] in
				self?.session.startRunning()
			}
		}
	}
	
	/// Stops the session.
	open func stopSession() {
		if isRunning {
			sessionQueue.async() { [weak self] in
				self?.session.stopRunning()
			}
		}
	}
	
	/// Switches the camera if possible.
	open func switchCameras() {
		if canSwitchCameras {
			do {
				if let v: AVCaptureDevicePosition = position {
					delegate?.captureSessionWillSwitchCameras?(captureSession: self, position: v)
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
					delegate?.captureSessionDidSwitchCameras?(captureSession: self, position: position!)
				}
			} catch let e as NSError {
				delegate?.captureSessionFailedWithError?(captureSession: self, error: e)
			}
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
				let device: AVCaptureDevice = activeCamera!
				try device.lockForConfiguration()
				device.focusPointOfInterest = point
				device.focusMode = .autoFocus
				device.unlockForConfiguration()
			} catch let e as NSError {
				error = e
			}
		} else {
			var userInfo: Dictionary<String, Any> = Dictionary<String, Any>()
			userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported focus.]"
			userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported focus.]"
			error = NSError(domain: "io.cosmicmind.Material.Capture", code: 0004, userInfo: userInfo)
			userInfo[NSUnderlyingErrorKey] = error
		}
		if let e = error {
			delegate?.captureSessionFailedWithError?(captureSession: self, error: e)
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
			var userInfo: Dictionary<String, Any> = Dictionary<String, Any>()
			userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported expose.]"
			userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported expose.]"
			error = NSError(domain: "io.cosmicmind.Material.Capture", code: 0005, userInfo: userInfo)
			userInfo[NSUnderlyingErrorKey] = error
		}
		if let e = error {
			delegate?.captureSessionFailedWithError?(captureSession: self, error: e)
		}
	}
	
	open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
		if context == &CaptureSessionAdjustingExposureContext {
			let device: AVCaptureDevice = object as! AVCaptureDevice
			if !device.isAdjustingExposure && device.isExposureModeSupported(.locked) {
				(object! as AnyObject).removeObserver(self, forKeyPath: "adjustingExposure", context: &CaptureSessionAdjustingExposureContext)
				DispatchQueue.main.async() {
					do {
						try device.lockForConfiguration()
						device.exposureMode = .locked
						device.unlockForConfiguration()
					} catch let e as NSError {
						self.delegate?.captureSessionFailedWithError?(captureSession: self, error: e)
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
		let device: AVCaptureDevice = activeCamera!
		let canResetFocus: Bool = device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.continuousAutoFocus)
		let canResetExposure: Bool = device.isExposurePointOfInterestSupported && device.isExposureModeSupported(.continuousAutoExposure)
        let centerPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
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
			delegate?.captureSessionFailedWithError?(captureSession: self, error: e)
		}
	}
	
	/// Captures a still image.
	open func captureStillImage() {
		sessionQueue.async() { [weak self] in
			if let s: CaptureSession = self {
				if let v: AVCaptureConnection = s.imageOutput.connection(withMediaType: AVMediaTypeVideo) {
					v.videoOrientation = s.videoOrientation
                    s.imageOutput.captureStillImageAsynchronously(from: v) { [weak self] (sampleBuffer: CMSampleBuffer?, error: Error?) -> Void in
						if let s = self {
							var captureError = error
							if nil == captureError {
								let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)!
								if let image1 = UIImage(data: data) {
                                    if let image2 = image1.adjustOrientation() {
										s.delegate?.captureSessionStillImageAsynchronously?(captureSession: s, image: image2)
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
							
							if let e: Error = captureError {
								s.delegate?.captureSessionStillImageAsynchronouslyFailedWithError?(captureSession: s, error: e)
							}
						}
					}
				}
			}
		}
	}
	
	/// Starts recording.
	open func startRecording() {
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
								s.delegate?.captureSessionFailedWithError?(captureSession: s, error: e)
							}
						}
						
						s.movieOutputURL = s.uniqueURL()
						if let v = s.movieOutputURL {
							s.movieOutput.startRecording(toOutputFileURL: v as URL!, recordingDelegate: s)
						}
					}
				}
			}
		}
	}
	
	/// Stops recording.
	open func stopRecording() {
		if isRecording {
			movieOutput.stopRecording()
		}
	}
	
	public func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        isRecording = true
		delegate?.captureSessionDidStartRecordingToOutputFileAtURL?(captureSession: self, captureOutput: captureOutput, fileURL: fileURL as NSURL, fromConnections: connections)
	}
	
	public func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
    	isRecording = false
		delegate?.captureSessionDidFinishRecordingToOutputFileAtURL?(captureSession: self, captureOutput: captureOutput, outputFileURL: outputFileURL as NSURL, fromConnections: connections, error: error)
	}
    
    /// Prepares the sessionQueue.
    private func prepareSessionQueue() {
        sessionQueue = DispatchQueue(label: "io.cosmicmind.Material.CaptureSession", attributes: .concurrent, target: nil)
    }
	
	/// Prepares the session.
	private func prepareSession() {
		session = AVCaptureSession()
	}
	
	/// Prepares the activeVideoInput.
	private func prepareActiveVideoInput() {
		do {
			activeVideoInput = try AVCaptureDeviceInput(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo))
			if session.canAddInput(activeVideoInput) {
				session.addInput(activeVideoInput)
			}
		} catch let e as NSError {
			delegate?.captureSessionFailedWithError?(captureSession: self, error: e)
		}
	}
	
    /// Prepares the activeAudioInput.
    private func prepareActiveAudioInput() {
		do {
			activeAudioInput = try AVCaptureDeviceInput(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio))
			if session.canAddInput(activeAudioInput) {
				session.addInput(activeAudioInput)
			}
		} catch let e as NSError {
			delegate?.captureSessionFailedWithError?(captureSession: self, error: e)
		}
	}
	
    /// Prepares the imageOutput.
	private func prepareImageOutput() {
        imageOutput = AVCaptureStillImageOutput()
        if session.canAddOutput(imageOutput) {
			imageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
			session.addOutput(imageOutput)
		}
	}
	
	/// Prepares the movieOutput.
	private func prepareMovieOutput() {
        movieOutput = AVCaptureMovieFileOutput()
        if session.canAddOutput(movieOutput) {
            session.addOutput(movieOutput)
		}
	}
	
	/**
     A reference to the camera at a given position, if one exists.
     - Parameter at: An AVCaptureDevicePosition.
     - Returns: An AVCaptureDevice if one exists, or nil otherwise.
     */
	private func camera(at position: AVCaptureDevicePosition) -> AVCaptureDevice? {
		let devices: Array<AVCaptureDevice> = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! Array<AVCaptureDevice>
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
	private func uniqueURL() -> URL? {
		do {
            let directory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
			let dateFormatter = DateFormatter()
			dateFormatter.dateStyle = .full
			dateFormatter.timeStyle = .full
			return directory.appendingPathComponent(dateFormatter.string(from: NSDate() as Date) + ".mov")
		} catch let e as NSError {
			delegate?.captureSessionCreateMovieFileFailedWithError?(captureSession: self, error: e)
		}
		return nil
	}
}
