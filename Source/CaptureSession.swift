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
	
	/**
		:name: session
	*/
	public private(set) lazy var session: AVCaptureSession = AVCaptureSession()
	
	/**
		:name:	isRunning
	*/
	public private(set) lazy var isRunning: Bool = false
	
	/**
		:name:	delegate
	*/
	public weak var delegate: CaptureSessionDelegate?
	
	/**
		:name:	startSession
	*/
	public func startSesstion() {
		if !isRunning {
			dispatch_async(videoQueue) {
				self.session.startRunning()
			}
		}
	}
	
	/**
		:name:	startSession
	*/
	public func stopSesstion() {
		if isRunning {
			dispatch_async(videoQueue) {
				self.session.stopRunning()
			}
		}
	}
	
	//
	//	:name:	prepareSession
	//
	private func prepareSession() {
		session.sessionPreset = AVCaptureSessionPresetHigh
		
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
}
