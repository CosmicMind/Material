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

@objc(MaterialCaptureDelegate)
public protocol MaterialCaptureDelegate {
	/**
		:name:	materialCaptureSessionFailedWithError
	*/
	optional func materialCaptureSessionFailedWithError(capture: MaterialCapture, error: NSError)
}

@objc(MaterialCapture)
public class MaterialCapture : NSObject {
	/**
		:name:	cameraInput
	*/
	private var cameraInput: AVCaptureDeviceInput?
	
	/**
		:name:	imageOutput
	*/
	private lazy var imageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
	
	/**
		:name: session
	*/
	public private(set) lazy var session: AVCaptureSession = AVCaptureSession()
	
	/**
		:name:	ccameraDevice
	*/
	public private(set) lazy var cameraDevice: AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
	
	/**
		:name:	delegate
	*/
	public weak var delegate: MaterialCaptureDelegate?
	
	//
	//	:name:	prepareSession
	//
	public func prepareSession() {
		prepareCamera()
	}
	
	//
	//	:name:	prepareCamera
	//
	private func prepareCamera() {
		do {
			cameraInput = try AVCaptureDeviceInput(device: cameraDevice)
			if session.canAddInput(cameraInput) {
				session.addInput(cameraInput)
			}
			if session.canAddOutput(imageOutput) {
				session.addOutput(imageOutput)
			}
			session.startRunning()
		} catch let e as NSError {
			delegate?.materialCaptureSessionFailedWithError?(self, error: e)
		}
	}
}
