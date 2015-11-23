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
	//	:name:	videoInput
	//
	private var videoInput: AVCaptureDeviceInput?
	
	//
	//	:name:	audioInput
	//
	private var audioInput: AVCaptureDeviceInput?
	
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
		return videoInput?.device
	}
	
	/**
		:name:	init
	*/
	public override init() {
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
			} else if activeCamera?.position == .Front {
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
		:name:	sessionPreset
	*/
	public func sessionPreset(preset: CaptureSessionPreset) {
		session.sessionPreset = CaptureSessionPresetToString(preset)
	}
	
	/**
		:name:	switchCameras
	*/
	public func switchCameras() -> Bool {
		if canSwitchCameras {
			do {
				let vi: AVCaptureDeviceInput? = try AVCaptureDeviceInput(device: inactiveCamera!)
				if session.canAddInput(vi) {
					session.beginConfiguration()
					session.removeInput(videoInput)
					session.addInput(vi)
					videoInput = vi
					session.commitConfiguration()
					return true
				}
			} catch let e as NSError {
				delegate?.captureSessionFailedWithError?(self, error: e)
			}
		}
		return false
	}
	
	//
	//	:name:	prepareSession
	//
	private func prepareSession() {
		sessionPreset(.High)
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
			videoInput = try AVCaptureDeviceInput(device: videoDevice)
			if session.canAddInput(videoInput) {
				session.addInput(videoInput)
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
			audioInput = try AVCaptureDeviceInput(device: audioDevice)
			if session.canAddInput(audioInput) {
				session.addInput(audioInput)
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
