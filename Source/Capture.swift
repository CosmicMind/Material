//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit
import AVFoundation
import AssetsLibrary

@objc(CaptureDelegate)
public protocol CaptureDelegate {
	optional func captureDeviceConfigurationFailed(capture: Capture, error: NSError!)
	optional func captureMediaCaptureFailed(capture: Capture, error: NSError!)
	optional func captureAsetLibraryWriteFailed(capture: Capture, error: NSError!)
	optional func capture(capture: Capture, assetLibraryDidWrite image: UIImage!)
}

public class Capture: NSObject, AVCaptureFileOutputRecordingDelegate {
	/**
	* activeVideoInput
	* The video input that is currently active.
	*/
	private var activeVideoInput: AVCaptureDeviceInput?
	
	/**
	* imageOutput
	* When the session is taking a photo, this is the output manager.
	*/
	private lazy var imageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
	
	/**
	* movieOutput
	* When the session is shooting a video, this is the output manager.
	*/
	private lazy var movieOutput: AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
	
	/**
	* movieOutputURL
	* The output URL of the movie file.
	*/
	private var movieOutputURL: NSURL?
	
	/**
	* queue
	* Async job queue.
	*/
	private lazy var queue: dispatch_queue_t = {
		return dispatch_queue_create("io.graphkit.Capture", nil)
	}()
	
	/**
	* CaptureAdjustingExposureContext
	* Used for KVO observation context.
	*/
	public var CaptureAdjustingExposureContext: NSString?
	
	/**
	* cameraCount
	* The number of available cameras on the device.
	*/
	public var cameraCount: Int {
		return AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo).count
	}
	
	/**
	* session
	* An AVCaptureSession that manages all inputs and outputs in that session.
	*/
	public lazy var session: AVCaptureSession = AVCaptureSession()
	
	/**
	* delegate
	* An optional instance of CaptureDelegate to handle events that are triggered during various
	* stages in the session.
	*/
	public weak var delegate: CaptureDelegate?
	
	/**
	* setupSession
	* A helper method that prepares the session with the various available inputs and outputs.
	* @param		preset: String, default: AVCaptureSessionPresetHigh
	* @return		A boolean value, true if successful, false otherwise.
	*/
	public func setupSession(preset: String = AVCaptureSessionPresetHigh) -> Bool {
		session.sessionPreset = preset
		
		var error: NSError?
		
		// setup default camera device
		let videoDevice: AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
		var videoInput: AVCaptureDeviceInput? = AVCaptureDeviceInput.deviceInputWithDevice(videoDevice, error: &error) as? AVCaptureDeviceInput
		
		if nil == videoInput {
			return false
		}
		
		if session.canAddInput(videoInput) {
			session.addInput(videoInput)
			activeVideoInput = videoInput
		}
		
		let audioDevice: AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
		var audioInput: AVCaptureDeviceInput? = AVCaptureDeviceInput.deviceInputWithDevice(audioDevice, error: &error) as? AVCaptureDeviceInput
		
		if nil == audioInput {
			return false
		}
		
		if session.canAddInput(audioInput) {
			session.addInput(audioInput)
		}
		
		imageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
		
		if session.canAddOutput(imageOutput) {
			session.addOutput(imageOutput)
		}
		
		if session.canAddOutput(movieOutput) {
			session.addOutput(movieOutput)
		}
		
		return true
	}
	
	/**
	* startSession
	* Starts the capture session if it is not already running.
	*/
	public func startSession() {
		if !session.running {
			dispatch_async(queue) {
				self.session.startRunning()
			}
		}
	}
	
	/**
	* stopSession
	* Stops the capture session if it is already running.
	*/
	public func stopSession() {
		if session.running {
			dispatch_async(queue) {
				self.session.stopRunning()
			}
		}
	}
	
	/**
	* cameraWithPosition
	* @param		position: AVCaptureDevicePosition
	* @return		An AVCaptureDevice optional.
	*/
	public func cameraWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
		for device in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) {
			if position == device.position {
				return device as? AVCaptureDevice
			}
		}
		return nil
	}
	
	/**
	* activeCamera
	* @return		The active cameras video input device.
	*/
	public var activeCamera: AVCaptureDevice {
		get {
			return activeVideoInput!.device
		}
	}
	
	/**
	* inactiveCamera
	* @return		The inactive cameras video input device.
	*/
	public var inactiveCamera: AVCaptureDevice? {
		get {
			var device: AVCaptureDevice?
			if 1 < cameraCount {
				device = activeCamera.position == .Back ? cameraWithPosition(.Front) : cameraWithPosition(.Back)
			}
			return device
		}
	}
	
	/**
	* canSwitchCameras
	* Checks whether the camera can be switched. This would require at least two cameras.
	* @return		A boolean of the result, true if yes, false otherwise.
	*/
	public var canSwitchCameras: Bool {
		return 1 < cameraCount
	}
	
	/**
	* switchCamera
	* If it is possible to switch cameras, then the camera will be switched from the opposite facing camera.
	* @return		A boolean of the result, true if switched, false otherwise.
	* @delegate		If the configuration fails, the capture(capture: Capture!, deviceConfigurationFailed error: NSError!) is called.
	*/
	public func switchCamera() -> Bool {
		if !canSwitchCameras {
			return false
		}
		
		var error: NSError?
		var videoDevice: AVCaptureDevice? = inactiveCamera
		var videoInput: AVCaptureDeviceInput? = AVCaptureDeviceInput.deviceInputWithDevice(videoDevice, error: &error) as? AVCaptureDeviceInput
		
		if nil == videoInput {
			session.beginConfiguration()
			session.removeInput(activeVideoInput)
			
			if session.canAddInput(videoInput) {
				activeVideoInput = videoInput
			} else {
				session.addInput(activeVideoInput)
			}
			
			session.commitConfiguration()
		} else {
			delegate?.captureDeviceConfigurationFailed?(self, error: error)
			return false
		}
		
		return true
	}
	
	/**
	* cameraHasFlash
	* Checks whether the camera supports flash.
	* @return		A boolean of the result, true if yes, false otherwise.
	*/
	public var cameraHasFlash: Bool {
		return activeCamera.hasFlash
	}
	
	/**
	* flashMode
	* A mutator and accessor for the flashMode property.
	* @delegate		If the configuration fails, the capture(capture: Capture!, deviceConfigurationFailed error: NSError!) is called.
	*/
	public var flashMode: AVCaptureFlashMode {
		get {
			return activeCamera.flashMode
		}
		set(value) {
			let device: AVCaptureDevice = activeCamera
			if flashMode != device.flashMode && device.isFlashModeSupported(flashMode) {
				var error: NSError?
				if device.lockForConfiguration(&error) {
					device.flashMode = flashMode
					device.unlockForConfiguration()
				} else {
					delegate?.captureDeviceConfigurationFailed?(self, error: error)
				}
			}
		}
	}
	
	/**
	* cameraHasTorch
	* Checks whether the device supports torch feature. 
	* @return		A boolean of the result, true if yes, false otherwise.
	*/
	public var cameraHasTorch: Bool {
		get {
			return activeCamera.hasTorch
		}
	}
	
	/**
	* torchMode
	* A mutator and accessor for the torchMode property.
	* @delegate		If the configuration fails, the capture(capture: Capture!, deviceConfigurationFailed error: NSError!) is called.
	*/
	public var torchMode: AVCaptureTorchMode {
		get {
			return activeCamera.torchMode
		}
		set(value) {
			let device: AVCaptureDevice = activeCamera
			if torchMode != device.torchMode && device.isTorchModeSupported(torchMode) {
				var error: NSError?
				if device.lockForConfiguration(&error) {
					device.torchMode = torchMode
					device.unlockForConfiguration()
				} else {
					delegate?.captureDeviceConfigurationFailed?(self, error: error)
				}
			}
		}
	}
	
	/**
	* cameraSupportsTapToFocus
	* Checks whether the device supports tap to focus.
	* @return		A boolean of the result, true if yes, false otherwise.
	*/
	public var cameraSupportsTapToFocus: Bool {
		get {
			return activeCamera.focusPointOfInterestSupported
		}
	}
	
	/**
	* focusAtpoint
	* Sets the point to focus at on the screen.
	* @param		point: CGPoint
	* @delegate		If the configuration fails, the capture(capture: Capture!, deviceConfigurationFailed error: NSError!) is called.
	*/
	public func focusAtPoint(point: CGPoint) {
		let device: AVCaptureDevice = activeCamera
		if device.focusPointOfInterestSupported && device.isFocusModeSupported(.AutoFocus) {
			var error: NSError?
			if device.lockForConfiguration(&error) {
				device.focusPointOfInterest = point
				device.focusMode = .AutoFocus
				device.unlockForConfiguration()
			} else {
				delegate?.captureDeviceConfigurationFailed?(self, error: error)
			}
		}
	}
	
	/**
	* cameraSupportsTapToExpose
	* Checks whether the device supports tap to expose.
	* @return		A boolean of the result, true if yes, false otherwise.
	*/
	public var cameraSupportsTapToExpose: Bool {
		get {
			return activeCamera.exposurePointOfInterestSupported
		}
	}
	
	/**
	* exposeAtPoint
	* Sets a point for exposure.
	* @delegate		If the configuration fails, the capture(capture: Capture!, deviceConfigurationFailed error: NSError!) is called.
	*/
	public func exposeAtPoint(point: CGPoint) {
		let device: AVCaptureDevice = activeCamera
		var exposureMode: AVCaptureExposureMode = .ContinuousAutoExposure
		
		if device.exposurePointOfInterestSupported && device.isExposureModeSupported(exposureMode) {
			var error: NSError?
			if device.lockForConfiguration(&error) {
				device.exposurePointOfInterest = point
				device.exposureMode = exposureMode
				
				if device.isExposureModeSupported(.Locked) {
					device.addObserver(self, forKeyPath: "adjustingExposure", options: .New, context: &CaptureAdjustingExposureContext)
				}
				device.unlockForConfiguration()
			} else {
				delegate?.captureDeviceConfigurationFailed?(self, error: error)
			}
		}
	}
	
	/**
	* override to set observeValueForKeyPath and handle exposure observance.
	* @delegate		If the configuration fails, the capture(capture: Capture!, deviceConfigurationFailed error: NSError!) is called.
	*/
	override public func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
		if context == &CaptureAdjustingExposureContext {
			let device: AVCaptureDevice = object as! AVCaptureDevice
			
			if device.adjustingExposure && device.isExposureModeSupported(.Locked) {
				object.removeObserver(self, forKeyPath: "adjustingExposure", context: &CaptureAdjustingExposureContext)
				dispatch_async(queue) {
					var error: NSError?
					if device.lockForConfiguration(&error) {
						device.unlockForConfiguration()
					} else {
						self.delegate?.captureDeviceConfigurationFailed?(self, error: error)
					}
				}
			} else {
				super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
			}
		}
	}
	
	/**
	* resetFocusAndExposureModes
	* Resets to default configuration for device focus and exposure mode.
	* @delegate		If the configuration fails, the capture(capture: Capture!, deviceConfigurationFailed error: NSError!) is called.
	*/
	public func resetFocusAndExposureModes() {
		let device: AVCaptureDevice = activeCamera
		
		var exposureMode: AVCaptureExposureMode = .ContinuousAutoExposure
		let canResetExposure: Bool = device.focusPointOfInterestSupported && device.isExposureModeSupported(exposureMode)
		
		var focusMode: AVCaptureFocusMode = .ContinuousAutoFocus
		let canResetFocus: Bool = device.focusPointOfInterestSupported && device.isFocusModeSupported(focusMode)
		
		let centerPoint: CGPoint = CGPointMake(0.5, 0.5)
		
		var error: NSError?
		if device.lockForConfiguration(&error) {
			if canResetFocus {
				device.focusMode = focusMode
				device.focusPointOfInterest = centerPoint
			}
			if canResetExposure {
				device.exposureMode = exposureMode
				device.exposurePointOfInterest = centerPoint
			}
			device.unlockForConfiguration()
		} else {
			delegate?.captureDeviceConfigurationFailed?(self, error: error)
		}
	}
	
	/**
	* captureStillImage
	* Captures the image and write the photo to the user's asset library.
	* @delegate		If the success, the capture(capture: Capture!, assetLibraryDidWrite image: UIImage!) is called.
	* @delegate		If failure, capture(capture: Capture!, assetLibraryWriteFailed error: NSError!) is called.
	*/
	public func captureStillImage() {
		var connection: AVCaptureConnection = imageOutput.connectionWithMediaType(AVMediaTypeVideo)
		if connection.supportsVideoOrientation {
			connection.videoOrientation = currentVideoOrientation
		}
		imageOutput.captureStillImageAsynchronouslyFromConnection(connection) { (sampleBuffer: CMSampleBufferRef?, error: NSError?) in
			if nil == sampleBuffer {
				self.delegate?.captureAsetLibraryWriteFailed?(self, error: error)
			} else {
				let imageData: NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
				let image: UIImage = UIImage(data: imageData)!
				self.writeImageToAssetsLibrary(image)
			}
		}
	}
	
	/**
	* isRecording
	* Checkts whether the device is currently recording. 
	* @return		A boolean of the result, true if yes, false otherwise.
	*/
	public var isRecording: Bool {
		get {
			return movieOutput.recording
		}
	}
	
	/**
	* startRecording
	* If the device is not currently recording, this starts the movie recording.
	* @delegate		If the configuration fails, the capture(capture: Capture!, deviceConfigurationFailed error: NSError!) is called.
	*/
	public func startRecording() {
		if !isRecording {
			let connection: AVCaptureConnection = movieOutput.connectionWithMediaType(AVMediaTypeVideo)
			if connection.supportsVideoOrientation {
				connection.videoOrientation = currentVideoOrientation
			}
			if connection.supportsVideoStabilization {
				connection.preferredVideoStabilizationMode = .Auto
			}
			
			let device: AVCaptureDevice = activeCamera
			
			if device.smoothAutoFocusSupported {
				var error: NSError?
				if device.lockForConfiguration(&error) {
					device.smoothAutoFocusEnabled = false
					device.unlockForConfiguration()
				} else {
					delegate?.captureDeviceConfigurationFailed?(self, error: error)
				}
			}
			movieOutputURL = uniqueURL
			movieOutput.startRecordingToOutputFileURL(movieOutputURL, recordingDelegate: self)
		}
	}
	
	/**
	* stopRecording
	* If the device is currently recoring, this stops the movie recording.
	*/
	public func stopRecording() {
		if isRecording {
			movieOutput.stopRecording()
		}
	}
	
	/**
	* recordedDuration
	* Retrieves the movie recorded duration.
	* @return		A CMTime value.
	*/
	public var recordedDuration: CMTime {
		get {
			return movieOutput.recordedDuration
		}
	}
	
	/**
	* currentVideoOrientation
	* Retrieves the current orientation of the device.
	* @return		A AVCaptureVideoOrientation value, [Portrait, LandscapeLeft, PortraitUpsideDown, LandscapeRight].
	*/
	public var currentVideoOrientation: AVCaptureVideoOrientation {
		var orientation: AVCaptureVideoOrientation?
		switch UIDevice.currentDevice().orientation {
		case .Portrait:
			orientation = .Portrait
			break
		case .LandscapeRight:
			orientation = .LandscapeLeft
			break
		case .PortraitUpsideDown:
			orientation = .PortraitUpsideDown
			break
		default:
			orientation = .LandscapeRight
		}
		return orientation!
	}
	
	/**
	* uniqueURL
	* A unique URL generated for the movie video.
	* @return		An optional NSURL value.
	*/
	private var uniqueURL: NSURL? {
		var error: NSError?
		let fileManager: NSFileManager = NSFileManager.defaultManager()
		let tempDirectoryTemplate: String = NSTemporaryDirectory().stringByAppendingPathComponent("FocusLibrary")
		if fileManager.createDirectoryAtPath(tempDirectoryTemplate, withIntermediateDirectories: true, attributes: nil, error: &error) {
			return NSURL.fileURLWithPath(tempDirectoryTemplate + "/test.mov")
		}
		return nil
	}
	
	/**
	* postAssetLibraryNotification
	* Fires an asynchronous call to the capture(capture: Capture!, assetLibraryDidWrite image: UIImage!) delegate.
	* @param		image: UIImage!
	* @delegate		An asynchronous call to capture(capture: Capture!, assetLibraryDidWrite image: UIImage!) delegate.
	*/
	private func postAssetLibraryNotification(image: UIImage!) {
		dispatch_async(queue) {
			self.delegate?.capture?(self, assetLibraryDidWrite: image)
		}
	}
	
	/**
	* writeImageToAssetsLibrary
	* Writes the image file to the user's asset library.
	* @param		image: UIImage!
	* @delegate		If successful, an asynchronous call to capture(capture: Capture!, assetLibraryDidWrite image: UIImage!) delegate.
	* @delegate		If failure, capture(capture: Capture!, assetLibraryWriteFailed error: NSError!) is called.
	*/
	private func writeImageToAssetsLibrary(image: UIImage) {
		let library: ALAssetsLibrary = ALAssetsLibrary()
		library.writeImageToSavedPhotosAlbum(image.CGImage, orientation: ALAssetOrientation(rawValue: image.imageOrientation.rawValue)!) { (path: NSURL!, error: NSError?) -> Void in
			if nil == error {
				self.postAssetLibraryNotification(image)
			} else {
				self.delegate?.captureAsetLibraryWriteFailed?(self, error: error)
			}
		}
	}
	
	/**
	* writeVideoToAssetsLibrary
	* Writes the video file to the user's asset library.
	* @param		videoURL: NSURL!
	* @delegate		If successful, an asynchronous call to capture(capture: Capture!, assetLibraryDidWrite image: UIImage!) delegate.
	* @delegate		If failure, capture(capture: Capture!, assetLibraryWriteFailed error: NSError!) is called.
	*/
	private func writeVideoToAssetsLibrary(videoURL: NSURL!) {
		let library: ALAssetsLibrary = ALAssetsLibrary()
		if library.videoAtPathIsCompatibleWithSavedPhotosAlbum(videoURL) {
			library.writeVideoAtPathToSavedPhotosAlbum(videoURL) { (path: NSURL!, error: NSError?) in
				if nil == error {
					self.generateThumbnailForVideoAtURL(videoURL)
				} else {
					self.delegate?.captureAsetLibraryWriteFailed?(self, error: error)
				}
			}
		}
	}
	
	/**
	* generateThumbnailForVideoAtURL
	* Generates a thumbnail for the video URL specified.
	* @param		videoURL: NSURL!
	* @delegate		An asynchronous call to capture(capture: Capture!, assetLibraryDidWrite image: UIImage!) delegate.
	*/
	private func generateThumbnailForVideoAtURL(videoURL: NSURL!) {
		dispatch_async(queue) {
			let asset: AVAsset = AVAsset.assetWithURL(videoURL) as! AVAsset
			let imageGenerator: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
			imageGenerator.maximumSize = CGSizeMake(100, 0)
			imageGenerator.appliesPreferredTrackTransform = true
			
			let imageRef: CGImageRef = imageGenerator.copyCGImageAtTime(kCMTimeZero, actualTime: nil, error: nil)
			let image: UIImage = UIImage(CGImage: imageRef)!
			
			dispatch_async(dispatch_get_main_queue()) {
				self.postAssetLibraryNotification(image)
			}
		}
	}
	
	/**
	* delegate method for capturing video file.
	* @delegate		If successful, an asynchronous call to capture(capture: Capture!, assetLibraryDidWrite image: UIImage!) delegate.
	* @delegate		If failure, capture(capture: Capture!, mediaCaptureFailed error: NSError!) is called.
	*/
	public func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
		if nil == error {
			writeVideoToAssetsLibrary(movieOutputURL!.copy() as! NSURL)
		} else {
			delegate?.captureMediaCaptureFailed?(self, error: error)
		}
		movieOutputURL = nil
	}
}