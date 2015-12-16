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

class ViewController: UIViewController, CaptureViewDelegate, CaptureSessionDelegate {
	lazy var captureView: CaptureView = CaptureView()
	lazy var navigationBarView: NavigationBarView = NavigationBarView(frame: CGRectNull)
	lazy var closeButton: FlatButton = FlatButton()
	lazy var cameraButton: FlatButton = FlatButton()
	lazy var videoButton: FlatButton = FlatButton()
	lazy var switchCameraButton: FlatButton = FlatButton()
	lazy var flashButton: FlatButton = FlatButton()
	lazy var captureButton: FabButton = FabButton()
	lazy var captureMode: CaptureMode = .Video
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareCaptureButton()
		prepareCameraButton()
		prepareVideoButton()
		prepareCloseButton()
		prepareSwitchCameraButton()
		prepareFlashButton()
		prepareNavigationBarView()
		prepareCaptureView()
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		captureButton.frame = CGRectMake((view.bounds.width - 72) / 2, view.bounds.height - 100, 72, 72)
	}
	
	private func prepareCaptureView() {
		view.addSubview(captureView)
		captureView.translatesAutoresizingMaskIntoConstraints = false
		captureView.delegate = self
		MaterialLayout.alignToParent(view, child: captureView)
	}
	
	/**
	:name:	prepareView
	*/
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
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
	
	/**
	:name:	captureViewDidUpdateRecordTimer
	*/
	func captureViewDidUpdateRecordTimer(captureView: CaptureView, duration: CMTime, time: Double, hours: Int, minutes: Int, seconds: Int) {
		MaterialAnimation.animationDisabled {
			self.navigationBarView.titleLabel!.text = String(format: "%02i:%02i:%02i", arguments: [hours, minutes, seconds])
		}
		
	}
	
	/**
	:name:	captureViewDidStopRecordTimer
	*/
	func captureViewDidStopRecordTimer(captureView: CaptureView, duration: CMTime, time: Double, hours: Int, minutes: Int, seconds: Int) {
		navigationBarView.titleLabel!.hidden = true
		navigationBarView.detailLabel!.hidden = true
		navigationBarView.detailLabel!.textColor = MaterialColor.white
	}
	
	/**
	:name:	captureSessionWillSwitchCameras
	*/
	func captureSessionWillSwitchCameras(capture: CaptureSession, position: AVCaptureDevicePosition) {
		if .Back == position {
			let img: UIImage? = UIImage(named: "ic_flash_off_white")
			captureView.captureSession.flashMode = .Off
			flashButton.setImage(img, forState: .Normal)
			flashButton.setImage(img, forState: .Highlighted)
		}
	}
	
	/**
	:name:	captureSessionDidSwitchCamerapublic s
	*/
	func captureSessionDidSwitchCameras(capture: CaptureSession, position: AVCaptureDevicePosition) {
		if .Back == position {
			let img: UIImage? = UIImage(named: "ic_flash_auto_white")
			captureView.captureSession.flashMode = .Auto
			flashButton.setImage(img, forState: .Normal)
			flashButton.setImage(img, forState: .Highlighted)
		}
	}
	
	/**
	:name:	handleCameraButton
	*/
	internal func handleCameraButton(button: UIButton) {
		captureButton.backgroundColor = MaterialColor.blue.darken1.colorWithAlphaComponent(0.3)
		captureMode = .Photo
	}
	
	/**
	:name:	handleVideoButton
	*/
	internal func handleVideoButton(button: UIButton) {
		captureButton.backgroundColor = MaterialColor.red.darken1.colorWithAlphaComponent(0.3)
		captureMode = .Video
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
				captureView.stopTimer()
				
				cameraButton.hidden = false
				videoButton.hidden = false
				
				if let v: Array<UIButton> = navigationBarView.leftButtons {
					for x in v {
						x.hidden = false
					}
				}
				
				if let v: Array<UIButton> = navigationBarView.rightButtons {
					for x in v {
						x.hidden = false
					}
				}
				
				navigationBarView.backgroundColor = MaterialColor.black.colorWithAlphaComponent(0.3)
				
			} else {
				captureView.previewView.layer.addAnimation(MaterialAnimation.transition(.Fade), forKey: kCATransition)
				captureView.captureSession.startRecording()
				captureView.startTimer()
				
				cameraButton.hidden = true
				videoButton.hidden = true
				
				if let v: Array<UIButton> = navigationBarView.leftButtons {
					for x in v {
						x.hidden = true
					}
				}
				
				if let v: Array<UIButton> = navigationBarView.rightButtons {
					for x in v {
						x.hidden = true
					}
				}
				
				navigationBarView.backgroundColor = nil
			}
		}
	}
	
	/**
	:name:	handleSwitchCameraButton
	*/
	internal func handleSwitchCameraButton(button: UIButton) {
		var img: UIImage?
		
		captureView.previewView.layer.addAnimation(MaterialAnimation.transition(.Fade), forKey: kCATransition)
		
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
			
			flashButton.setImage(img, forState: .Normal)
			flashButton.setImage(img, forState: .Highlighted)
		}
	}
	
	/**
	:name:	prepareNavigationBarView
	*/
	private func prepareNavigationBarView() {
		navigationBarView.backgroundColor = MaterialColor.black.colorWithAlphaComponent(0.3)
		navigationBarView.shadowDepth = .None
		navigationBarView.statusBarStyle = .LightContent
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.hidden = true
		titleLabel.textAlignment = .Center
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.regularWithSize(20)
		navigationBarView.titleLabel = titleLabel
		
		// Detail label
		let detailLabel: UILabel = UILabel()
		detailLabel.hidden = true
		detailLabel.text = "Recording"
		detailLabel.textAlignment = .Center
		detailLabel.textColor = MaterialColor.white
		detailLabel.font = RobotoFont.regularWithSize(12)
		navigationBarView.detailLabel = detailLabel
		
		navigationBarView.leftButtons = [closeButton]
		navigationBarView.rightButtons = [switchCameraButton, flashButton]
		
		view.addSubview(navigationBarView)
		navigationBarView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: navigationBarView)
		MaterialLayout.alignToParentHorizontally(view, child: navigationBarView)
		MaterialLayout.height(view, child: navigationBarView, height: 70)
	}
	
	/**
	:name:	prepareCaptureButton
	*/
	private func prepareCaptureButton() {
		captureButton.pulseColor = MaterialColor.white
		captureButton.pulseFill = true
		captureButton.backgroundColor = MaterialColor.red.darken1.colorWithAlphaComponent(0.3)
		captureButton.borderWidth = .Border2
		captureButton.borderColor = MaterialColor.white
		captureButton.shadowDepth = .None
		captureButton.addTarget(self, action: "handleCaptureButton:", forControlEvents: .TouchUpInside)
		view.addSubview(captureButton)
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
		
		captureView.captureButton = cameraButton
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
		
		captureView.videoButton = videoButton
	}
	
	/**
	:name:	prepareCloseButton
	*/
	private func prepareCloseButton() {
		let img: UIImage? = UIImage(named: "ic_close_white")
		closeButton.pulseColor = nil
		closeButton.setImage(img, forState: .Normal)
		closeButton.setImage(img, forState: .Highlighted)
		
		captureView.closeButton = closeButton
	}
	
	/**
	:name:	prepareSwitchCameraButton
	*/
	private func prepareSwitchCameraButton() {
		let img: UIImage? = UIImage(named: "ic_camera_front_white")
		switchCameraButton.pulseColor = nil
		switchCameraButton.setImage(img, forState: .Normal)
		switchCameraButton.setImage(img, forState: .Highlighted)
		switchCameraButton.addTarget(self, action: "handleSwitchCameraButton:", forControlEvents: .TouchUpInside)
		
		captureView.switchCameraButton = switchCameraButton
	}
	
	/**
	:name:	prepareFlashButton
	*/
	private func prepareFlashButton() {
		captureView.captureSession.flashMode = .Auto
		
		let img: UIImage? = UIImage(named: "ic_flash_auto_white")
		flashButton.pulseColor = nil
		flashButton.setImage(img, forState: .Normal)
		flashButton.setImage(img, forState: .Highlighted)
		flashButton.addTarget(self, action: "handleFlashButton:", forControlEvents: .TouchUpInside)
		
		captureView.flashButton = flashButton
	}
}
