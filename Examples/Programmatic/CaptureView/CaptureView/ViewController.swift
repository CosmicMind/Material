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
import Material
import AVFoundation

class ViewController: UIViewController, CaptureViewDelegate, CaptureSessionDelegate {
	lazy var captureView: CaptureView = CaptureView()
	lazy var toolbar: Toolbar = Toolbar()
	lazy var cameraButton: IconButton = IconButton()
	lazy var videoButton: IconButton = IconButton()
	lazy var switchCamerasButton: IconButton = IconButton()
	lazy var flashButton: IconButton = IconButton()
	lazy var captureButton: FabButton = FabButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareCaptureButton()
		prepareCameraButton()
		prepareVideoButton()
		prepareSwitchCamerasButton()
		prepareFlashButton()
		prepareCaptureView()
		prepareToolbar()
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
		
		cameraButton.hidden = true
		videoButton.hidden = true
		switchCamerasButton.hidden = true
		flashButton.hidden = true
	}
	
	/**
	:name:	captureDidFinishRecordingToOutputFileAtURL
	*/
	func captureDidFinishRecordingToOutputFileAtURL(capture: CaptureSession, captureOutput: AVCaptureFileOutput, outputFileURL: NSURL, fromConnections connections: [AnyObject], error: NSError!) {
		print("Capture Stopped Recording \(outputFileURL)")
		
		cameraButton.hidden = false
		videoButton.hidden = false
		switchCamerasButton.hidden = false
		flashButton.hidden = false
	}
	
	func captureViewDidStartRecordTimer(captureView: CaptureView) {
		toolbar.titleLabel!.text = "00:00:00"
		toolbar.titleLabel!.hidden = false
		toolbar.detailLabel!.hidden = false
	}
	
	/**
	:name:	captureViewDidUpdateRecordTimer
	*/
	func captureViewDidUpdateRecordTimer(captureView: CaptureView, hours: Int, minutes: Int, seconds: Int) {
		toolbar.titleLabel!.text = String(format: "%02i:%02i:%02i", arguments: [hours, minutes, seconds])
	}
	
	/**
	:name:	captureViewDidStopRecordTimer
	*/
	func captureViewDidStopRecordTimer(captureView: CaptureView, hours: Int, minutes: Int, seconds: Int) {
		toolbar.titleLabel!.hidden = true
		toolbar.detailLabel!.hidden = true
	}
	
	/**
	:name:	captureSessionWillSwitchCameras
	*/
	func captureSessionWillSwitchCameras(capture: CaptureSession, position: AVCaptureDevicePosition) {
		// ... do something
	}
	
	/**
	:name:	captureSessionDidSwitchCameras
	*/
	func captureSessionDidSwitchCameras(capture: CaptureSession, position: AVCaptureDevicePosition) {
		var img: UIImage?
		if .Back == position {
			captureView.captureSession.flashMode = .Auto
			
			img = UIImage(named: "ic_flash_auto_white")
			flashButton.setImage(img, forState: .Normal)
			flashButton.setImage(img, forState: .Highlighted)
			
			img = UIImage(named: "ic_camera_front_white")
			switchCamerasButton.setImage(img, forState: .Normal)
			switchCamerasButton.setImage(img, forState: .Highlighted)
		} else {
			captureView.captureSession.flashMode = .Off
			
			img = UIImage(named: "ic_flash_off_white")
			flashButton.setImage(img, forState: .Normal)
			flashButton.setImage(img, forState: .Highlighted)
			
			img = UIImage(named: "ic_camera_rear_white")
			switchCamerasButton.setImage(img, forState: .Normal)
			switchCamerasButton.setImage(img, forState: .Highlighted)
		}
	}
	
	/**
	:name:	captureViewDidPressFlashButton
	*/
	func captureViewDidPressFlashButton(captureView: CaptureView, button: UIButton) {
		if .Back == captureView.captureSession.cameraPosition {
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
			
			button.setImage(img, forState: .Normal)
			button.setImage(img, forState: .Highlighted)
		}
	}
	
	/**
	:name:	captureViewDidPressCameraButton
	*/
	func captureViewDidPressCameraButton(captureView: CaptureView, button: UIButton) {
		captureButton.backgroundColor = MaterialColor.blue.darken1.colorWithAlphaComponent(0.3)
	}
	
	/**
	:name:	captureViewDidPressVideoButton
	*/
	func captureViewDidPressVideoButton(captureView: CaptureView, button: UIButton) {
		captureButton.backgroundColor = MaterialColor.red.darken1.colorWithAlphaComponent(0.3)
	}
	
	/**
	:name:	captureViewDidPressCaptureButton
	*/
	func captureViewDidPressCaptureButton(captureView: CaptureView, button: UIButton) {
		if .Photo == captureView.captureMode {
			// ... do something
		} else if .Video == captureView.captureMode {
			// ... do something
		}
	}
	
	/**
	:name:	captureViewDidPressSwitchCamerasButton
	*/
	func captureViewDidPressSwitchCamerasButton(captureView: CaptureView, button: UIButton) {
		// ... do something
	}
	
	/**
	:name:	prepareView
	*/
	private func prepareView() {
		view.backgroundColor = MaterialColor.black
	}
	
	/**
	:name:	prepareCaptureView
	*/
	private func prepareCaptureView() {
		view.addSubview(captureView)
		captureView.tapToFocusEnabled = true
		captureView.tapToExposeEnabled = true
		captureView.delegate = self
		captureView.captureSession.delegate = self
		view.layout(captureView).edges()
	}
	
	/**
	:name:	prepareToolbar
	*/
	private func prepareToolbar() {
		toolbar.backgroundColor = nil
		toolbar.depth = .None
		
		// Title label.
		toolbar.titleLabel.hidden = true
		toolbar.titleLabel.textColor = MaterialColor.white
		
		// Detail label.
		toolbar.detail = "Recording"
		toolbar.detailLabel.hidden = true
		toolbar.detailLabel.textColor = MaterialColor.red.accent1
		
		toolbar.leftControls = [switchCamerasButton]
		toolbar.rightControls = [flashButton]
		
		view.addSubview(toolbar)
	}
	
	/**
	:name:	prepareCaptureButton
	*/
	private func prepareCaptureButton() {
		captureButton.width = 72
		captureButton.height = 72
		captureButton.pulseColor = MaterialColor.white
		captureButton.backgroundColor = MaterialColor.red.darken1.colorWithAlphaComponent(0.3)
		captureButton.borderWidth =  2
		captureButton.borderColor = MaterialColor.white
		captureButton.depth = .None
		
		captureView.captureButton = captureButton
	}
	
	/**
	:name:	prepareCameraButton
	*/
	private func prepareCameraButton() {
		let img4: UIImage? = UIImage(named: "ic_photo_camera_white_36pt")
		cameraButton.width = 72
		cameraButton.height = 72
		cameraButton.setImage(img4, forState: .Normal)
		cameraButton.setImage(img4, forState: .Highlighted)
		
		captureView.cameraButton = cameraButton
	}
	
	/**
	:name:	prepareVideoButton
	*/
	private func prepareVideoButton() {
		let img5: UIImage? = UIImage(named: "ic_videocam_white_36pt")
		videoButton.width = 72
		videoButton.height = 72
		videoButton.setImage(img5, forState: .Normal)
		videoButton.setImage(img5, forState: .Highlighted)
		
		captureView.videoButton = videoButton
	}
	
	/**
	:name:	prepareSwitchCamerasButton
	*/
	private func prepareSwitchCamerasButton() {
		let img: UIImage? = UIImage(named: "ic_camera_front_white")
		switchCamerasButton.setImage(img, forState: .Normal)
		switchCamerasButton.setImage(img, forState: .Highlighted)
		
		captureView.switchCamerasButton = switchCamerasButton
	}
	
	/**
	:name:	prepareFlashButton
	*/
	private func prepareFlashButton() {
		let img: UIImage? = UIImage(named: "ic_flash_auto_white")
		flashButton.setImage(img, forState: .Normal)
		flashButton.setImage(img, forState: .Highlighted)
		
		captureView.captureSession.flashMode = .Auto
		captureView.flashButton = flashButton
	}
}
