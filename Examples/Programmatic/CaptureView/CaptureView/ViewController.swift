//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io> and other CosmicMind contributors
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
import MaterialKit
import AVFoundation

enum CaptureMode {
	case Photo
	case Video
}

class ViewController: UIViewController, CapturePreviewViewDelegate, CaptureSessionDelegate {
	private lazy var navigationBarView: NavigationBarView = NavigationBarView()
	private lazy var captureView: CaptureView = CaptureView()
	private lazy var cameraButton: FlatButton = FlatButton()
	private lazy var captureButton: FabButton = FabButton()
	private lazy var videoButton: FlatButton = FlatButton()
	private lazy var switchCameraButton: FlatButton = FlatButton()
	private lazy var flashButton: FlatButton = FlatButton()
	private lazy var closeButton: FlatButton = FlatButton()
	
	private lazy var captureMode: CaptureMode = .Photo
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		
		prepareCaptureView()
		prepareNavigationBarView()
		prepareCaptureButton()
		prepareCameraButton()
		prepareVideoButton()
		prepareCloseButton()
		prepareSwitchCameraButton()
		prepareFlashButton()
	}
	
	/**
	:name:	prepareView
	*/
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/**
	:name:	prepareNavigationBarView
	*/
	private func prepareNavigationBarView() {
		navigationBarView.backgroundColor = MaterialColor.black.colorWithAlphaComponent(0.3)
		navigationBarView.shadowDepth = .None
		navigationBarView.statusBarStyle = .LightContent
		
		view.addSubview(navigationBarView)
		navigationBarView.leftButtons = [closeButton]
		navigationBarView.rightButtons = [switchCameraButton, flashButton]
	}
	
	/**
	:name:	prepareCaptureButton
	*/
	private func prepareCaptureButton() {
		captureButton.pulseColor = MaterialColor.white
		captureButton.pulseFill = true
		captureButton.backgroundColor = MaterialColor.blue.darken1.colorWithAlphaComponent(0.3)
		captureButton.borderWidth = .Border2
		captureButton.borderColor = MaterialColor.white
		captureButton.shadowDepth = .None
		captureButton.addTarget(self, action: "handleCaptureButton:", forControlEvents: .TouchUpInside)
		
		view.addSubview(captureButton)
		captureButton.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromBottomRight(view, child: captureButton, bottom: 24, right: (view.bounds.width - 72) / 2)
		MaterialLayout.size(view, child: captureButton, width: 72, height: 72)
	}
	
	/**
	:name:	prepareCameraButton
	*/
	private func prepareCameraButton() {
		let img4: UIImage? = UIImage(named: "ic_photo_camera_white_36pt")
		cameraButton.pulseColor = nil
		cameraButton.setImage(img4, forState: .Normal)
		cameraButton.setImage(img4, forState: .Highlighted)
		cameraButton.addTarget(self, action: "handleCameraButton:", forControlEvents: .TouchUpInside)
		
		view.addSubview(cameraButton)
		cameraButton.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromBottomLeft(view, child: cameraButton, bottom: 24, left: 24)
	}
	
	/**
	:name:	prepareVideoButton
	*/
	private func prepareVideoButton() {
		let img5: UIImage? = UIImage(named: "ic_videocam_white_36pt")
		videoButton.pulseColor = nil
		videoButton.setImage(img5, forState: .Normal)
		videoButton.setImage(img5, forState: .Highlighted)
		videoButton.addTarget(self, action: "handleVideoButton:", forControlEvents: .TouchUpInside)

		view.addSubview(videoButton)
		videoButton.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromBottomRight(view, child: videoButton, bottom: 24, right: 24)
	}
	
	/**
	:name:	prepareCloseButton
	*/
	private func prepareCloseButton() {
		let img: UIImage? = UIImage(named: "ic_close_white")
		closeButton.pulseColor = MaterialColor.white
		closeButton.pulseFill = true
		closeButton.setImage(img, forState: .Normal)
		closeButton.setImage(img, forState: .Highlighted)
	}
	
	/**
	:name:	prepareSwitchCameraButton
	*/
	private func prepareSwitchCameraButton() {
		let img: UIImage? = UIImage(named: "ic_camera_front_white")
		switchCameraButton.pulseColor = MaterialColor.white
		switchCameraButton.pulseFill = true
		switchCameraButton.setImage(img, forState: .Normal)
		switchCameraButton.setImage(img, forState: .Highlighted)
		switchCameraButton.addTarget(self, action: "handleSwitchCameraButton:", forControlEvents: .TouchUpInside)
	}
	
	/**
	:name:	prepareFlashButton
	*/
	private func prepareFlashButton() {
		captureView.captureSession.flashMode = .Auto
		
		let img: UIImage? = UIImage(named: "ic_flash_auto_white")
		flashButton.pulseColor = MaterialColor.white
		flashButton.pulseFill = true
		flashButton.setImage(img, forState: .Normal)
		flashButton.setImage(img, forState: .Highlighted)
		flashButton.addTarget(self, action: "handleFlashButton:", forControlEvents: .TouchUpInside)
	}
	
	/**
	:name:	prepareCaptureView
	*/
	private func prepareCaptureView() {
		captureView.captureSession.delegate = self
		captureView.captureButton = captureButton
		captureView.flashButton = flashButton
		captureView.switchCamerasButton = switchCameraButton
		
		view.addSubview(captureView)
		captureView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignToParent(view, child: captureView)
	}
	
	/**
	:name:	handleCaptureButton
	*/
	internal func handleCaptureButton(button: UIButton) {
		if .Photo == captureMode {
			captureView.captureSession.captureStillImage()
		} else if .Video == captureMode {
			if captureView.captureSession.isRecording {
				captureView.captureSession.stopRecording()
			} else {
				captureView.captureSession.startRecording()
			}
		}
	}
	
	/**
	:name:	handleSwitchCameraButton
	*/
	internal func handleSwitchCameraButton(button: UIButton) {
		var img: UIImage?
		
		if .Back == captureView.captureSession.cameraPosition {
			img = UIImage(named: "ic_camera_rear_white")
			captureView.captureSession.switchCameras()
		} else if .Front == captureView.captureSession.cameraPosition {
			img = UIImage(named: "ic_camera_front_white")
			captureView.captureSession.switchCameras()
		}
		
		switchCameraButton.setImage(img, forState: .Normal)
		switchCameraButton.setImage(img, forState: .Highlighted)
	}
	
	/**
	:name:	handleFlashButton
	*/
	internal func handleFlashButton(button: UIButton) {
		var img: UIImage?
		
		switch captureView.captureSession.flashMode {
		case .Off:
			img = UIImage(named: "ic_flash_on_white")
			captureView.captureSession.flashMode = .On
		case .On:
			img = UIImage(named: "ic_flash_auto_white")
			captureView.captureSession.flashMode = .Auto
		case .Auto:
			img = UIImage(named: "ic_flash_off_white")
			captureView.captureSession.flashMode = .Off
		}
		
		flashButton.setImage(img, forState: .Normal)
		flashButton.setImage(img, forState: .Highlighted)
	}
	
	/**
	:name:	handleCameraButton
	*/
	func handleCameraButton(button: UIButton) {
		captureButton.backgroundColor = MaterialColor.blue.darken1.colorWithAlphaComponent(0.3)
		captureMode = .Photo
	}
	
	/**
	:name:	handleVideoButton
	*/
	func handleVideoButton(button: UIButton) {
		captureButton.backgroundColor = MaterialColor.red.darken1.colorWithAlphaComponent(0.3)
		captureMode = .Video
	}
	
	/**
	:name:	captureSessionFailedWithError
	*/
	func captureSessionFailedWithError(capture: CaptureSession, error: NSError) {
		print(error)
	}
	
	/**
	:name:	captureStillImageAsynchronously
	*/
	func captureStillImageAsynchronously(capture: CaptureSession, image: UIImage) {
		print("Capture Image \(image)")
	}
	
	/**
	:name:	captureCreateMovieFileFailedWithError
	*/
	func captureCreateMovieFileFailedWithError(capture: CaptureSession, error: NSError) {
		print("Capture Failed \(error)")
	}

	/**
	:name:	captureDidStartRecordingToOutputFileAtURL
	*/
	func captureDidStartRecordingToOutputFileAtURL(capture: CaptureSession, captureOutput: AVCaptureFileOutput, fileURL: NSURL, fromConnections connections: [AnyObject]) {
		print("Capture Started Recording \(fileURL)")
	}
	
	/**
	:name:	captureDidFinishRecordingToOutputFileAtURL
	*/
	func captureDidFinishRecordingToOutputFileAtURL(capture: CaptureSession, captureOutput: AVCaptureFileOutput, outputFileURL: NSURL, fromConnections connections: [AnyObject], error: NSError!) {
		print("Capture Stopped Recording \(outputFileURL)")
	}
}

