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

public enum CaptureSessionPreset {
	case High
}

/**
	:name:	CaptureSessionPresetToString
*/
public func CaptureSessionPresetToString(preset: CaptureSessionPreset) -> String {
	switch preset {
	case .High:
		return AVCaptureSessionPresetHigh
	}
}

@objc(CaptureSessionDelegate)
public protocol CaptureSessionDelegate {
	/**
		:name:	captureSessionFailedWithError
	*/
	optional func captureSessionFailedWithError(capture: CaptureSession, error: NSError)
}

@objc(CaptureSession)
public class CaptureSession : NSObject {
	//
	//	:name:	videoQueue
	//
	private lazy var videoQueue: dispatch_queue_t = dispatch_queue_create("io.materialkit.CaptureSession", nil)
	
	//
	//	:name:	videoDevice
	//
	private lazy var videoDevice: AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
	
	//
	//	:name:	audioDevice
	//
	private lazy var audioDevice: AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
	
	//
	//	:name:	activeVideoInput
	//
	private var activeVideoInput: AVCaptureDeviceInput?
	
	//
	//	:name:	activeAudioInput
	//
	private var activeAudioInput: AVCaptureDeviceInput?
	
	//
	//	:name:	imageOutput
	//
	private lazy var imageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
	
	//
	//	:name:	movieOutput
	//
	private lazy var movieOutput: AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
	
	//
	//	:name: session
	//
	internal lazy var session: AVCaptureSession = AVCaptureSession()
	
	/**
		:name:	isRunning
	*/
	public private(set) lazy var isRunning: Bool = false
	
	/**
		:name:	activeCamera
	*/
	public var activeCamera: AVCaptureDevice? {
		return activeVideoInput?.device
	}
	
	/**
		:name:	init
	*/
	public override init() {
		sessionPreset = .High
		super.init()
		prepareSession()
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
		:name:	focusMode
	*/
	public var focusMode: AVCaptureFocusMode {
		get {
			return videoDevice.focusMode
		}
		set(value) {
			var error: NSError?
			if isFocusModeSupported(focusMode) {
				do {
					try videoDevice.lockForConfiguration()
					videoDevice.focusMode = focusMode
					videoDevice.unlockForConfiguration()
				} catch let e as NSError {
					error = e
				}
				error = NSError(domain: "[MaterialKit Error: Unsupported focusMode.]", code: 0, userInfo: nil)
			}
			if let e: NSError = error {
				delegate?.captureSessionFailedWithError?(self, error: e)
			}
		}
	}
	
	/**
		:name:	sessionPreset
	*/
	public var sessionPreset: CaptureSessionPreset {
		didSet {
			session.sessionPreset = CaptureSessionPresetToString(sessionPreset)
		}
	}
	
	/**
		:name:	delegate
	*/
	public weak var delegate: CaptureSessionDelegate?
	
	/**
		:name:	startSession
	*/
	public func startSession() {
		if !isRunning {
			dispatch_async(videoQueue) {
				self.session.startRunning()
			}
		}
	}
	
	/**
		:name:	startSession
	*/
	public func stopSession() {
		if isRunning {
			dispatch_async(videoQueue) {
				self.session.stopRunning()
			}
		}
	}
	
	/**
		:name:	switchCameras
	*/
	public func switchCameras() {
		if canSwitchCameras {
			dispatch_async(videoQueue) {
				do {
					let videoInput: AVCaptureDeviceInput? = try AVCaptureDeviceInput(device: self.inactiveCamera!)
					self.session.beginConfiguration()
					self.session.removeInput(self.activeVideoInput)
					
					if self.session.canAddInput(videoInput) {
						self.session.addInput(videoInput)
						self.activeVideoInput = videoInput
					} else {
						self.session.addInput(self.activeVideoInput)
					}
					self.session.commitConfiguration()
				} catch let e as NSError {
					self.delegate?.captureSessionFailedWithError?(self, error: e)
				}
			}
		}
	}
	
	/**
		:name:	isFocusModeSupported
	*/
	public func isFocusModeSupported(focusMode: AVCaptureFocusMode) -> Bool {
		return videoDevice.isFocusModeSupported(focusMode)
	}
	
	/**
		:name:	isExposureModeSupported
	*/
	public func isExposureModeSupported(exposureMode: AVCaptureExposureMode) -> Bool {
		return videoDevice.isExposureModeSupported(exposureMode)
	}
	
	//
	//	:name:	prepareSession
	//
	private func prepareSession() {
		prepareVideoInput()
		prepareAudioInput()
		prepareImageOutput()
		prepareMovieOutput()
	}
	
	//
	//	:name:	prepareVideoInput
	//
	private func prepareVideoInput() {
		do {
			activeVideoInput = try AVCaptureDeviceInput(device: videoDevice)
			if session.canAddInput(activeVideoInput) {
				session.addInput(activeVideoInput)
			}
		} catch let e as NSError {
			delegate?.captureSessionFailedWithError?(self, error: e)
		}
	}
	
	//
	//	:name:	prepareAudioInput
	//
	private func prepareAudioInput() {
		do {
			activeAudioInput = try AVCaptureDeviceInput(device: audioDevice)
			if session.canAddInput(activeAudioInput) {
				session.addInput(activeAudioInput)
			}
		} catch let e as NSError {
			delegate?.captureSessionFailedWithError?(self, error: e)
		}
	}
	
	//
	//	:name:	prepareImageOutput
	//
	private func prepareImageOutput() {
		if session.canAddOutput(imageOutput) {
			imageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
			session.addOutput(imageOutput)
		}
	}
	
	//
	//	:name:	prepareMovieOutput
	//
	private func prepareMovieOutput() {
		if session.canAddOutput(movieOutput) {
			session.addOutput(movieOutput)
		}
	}
	
	//
	//	:name:	cameraWithPosition
	//
	private func cameraWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
		let devices: Array<AVCaptureDevice> = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! Array<AVCaptureDevice>
		for device in devices {
			if device.position == position {
				return device
			}
		}
		return nil
	}
}
