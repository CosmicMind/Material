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
import AVFoundation

public enum CaptureMode {
	case Photo
	case Video
}

public class CameraView : CaptureView, CaptureViewDelegate, CaptureSessionDelegate {
	/**
	:name:	navigationBarView
	*/
	public var navigationBarView: NavigationBarView = NavigationBarView(frame: CGRectNull)
	
	/**
	:name:	captureMode
	*/
	public private(set) lazy var captureMode: CaptureMode = .Video
	
	/**
	:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		prepareCaptureButton()
		prepareCameraButton()
		prepareVideoButton()
		prepareCloseButton()
		prepareSwitchCameraButton()
		prepareFlashButton()
		prepareNavigationBarView()
	}
	
	/**
	:name:	captureViewDidUpdateRecordTimer
	*/
	public func captureViewDidUpdateRecordTimer(captureView: CaptureView, duration: CMTime, time: Double, hours: Int, minutes: Int, seconds: Int) {
		MaterialAnimation.animationDisabled {
			self.navigationBarView.titleLabel!.text = String(format: "%02i:%02i:%02i", arguments: [hours, minutes, seconds])
		}
		
	}
	
	/**
	:name:	captureViewDidStopRecordTimer
	*/
	public func captureViewDidStopRecordTimer(captureView: CaptureView, duration: CMTime, time: Double, hours: Int, minutes: Int, seconds: Int) {
		navigationBarView.titleLabel!.hidden = true
		navigationBarView.detailLabel!.hidden = true
		navigationBarView.detailLabel!.textColor = MaterialColor.white
	}
	
	/**
	:name:	captureSessionFailedWithError
	*/
	public func captureSessionFailedWithError(capture: CaptureSession, error: NSError) {
		print(error)
	}
	
	/**
	:name:	captureSessionWillSwitchCameras
	*/
	public func captureSessionWillSwitchCameras(capture: CaptureSession, position: AVCaptureDevicePosition) {
		if .Back == position {
			let img: UIImage? = UIImage(named: "ic_flash_off_white")
			captureSession.flashMode = .Off
			flashButton!.setImage(img, forState: .Normal)
			flashButton!.setImage(img, forState: .Highlighted)
		}
	}
	
	/**
	:name:	captureSessionDidSwitchCamerapublic s
	*/
	public func captureSessionDidSwitchCameras(capture: CaptureSession, position: AVCaptureDevicePosition) {
		if .Back == position {
			let img: UIImage? = UIImage(named: "ic_flash_auto_white")
			captureSession.flashMode = .Auto
			flashButton!.setImage(img, forState: .Normal)
			flashButton!.setImage(img, forState: .Highlighted)
		}
	}
	
	/**
	:name:	handleCameraButton
	*/
	internal func handleCameraButton(button: UIButton) {
		captureButton!.backgroundColor = MaterialColor.blue.darken1.colorWithAlphaComponent(0.3)
		captureMode = .Photo
	}
	
	/**
	:name:	handleVideoButton
	*/
	internal func handleVideoButton(button: UIButton) {
		captureButton!.backgroundColor = MaterialColor.red.darken1.colorWithAlphaComponent(0.3)
		captureMode = .Video
	}
	
	/**
	:name:	handleCaptureButton
	*/
	internal func handleCaptureButton(button: UIButton) {
		if .Photo == captureMode {
			captureSession.captureStillImage()
		} else if .Video == captureMode {
			if captureSession.isRecording {
				captureSession.stopRecording()
				stopTimer()
				
				cameraButton!.hidden = false
				videoButton!.hidden = false
				
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
				previewView.layer.addAnimation(MaterialAnimation.transition(.Fade), forKey: kCATransition)
				captureSession.startRecording()
				startTimer()
				
				cameraButton!.hidden = true
				videoButton!.hidden = true
				
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
		
		previewView.layer.addAnimation(MaterialAnimation.transition(.Fade), forKey: kCATransition)
		
		if .Back == captureSession.cameraPosition {
			img = UIImage(named: "ic_camera_rear_white")
			captureSession.switchCameras()
		} else if .Front == captureSession.cameraPosition {
			img = UIImage(named: "ic_camera_front_white")
			captureSession.switchCameras()
		}
		
		switchCameraButton!.setImage(img, forState: .Normal)
		switchCameraButton!.setImage(img, forState: .Highlighted)
	}
	
	/**
	:name:	handleFlashButton
	*/
	internal func handleFlashButton(button: UIButton) {
		if .Back == captureSession.cameraPosition {
			var img: UIImage?
			
			switch captureSession.flashMode {
			case .Off:
				img = UIImage(named: "ic_flash_on_white")
				captureSession.flashMode = .On
			case .On:
				img = UIImage(named: "ic_flash_auto_white")
				captureSession.flashMode = .Auto
			case .Auto:
				img = UIImage(named: "ic_flash_off_white")
				captureSession.flashMode = .Off
			}
			
			flashButton!.setImage(img, forState: .Normal)
			flashButton!.setImage(img, forState: .Highlighted)
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
		
		navigationBarView.leftButtons = [closeButton!]
		navigationBarView.rightButtons = [switchCameraButton!, flashButton!]
		
		addSubview(navigationBarView)
		navigationBarView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(self, child: navigationBarView)
		MaterialLayout.alignToParentHorizontally(self, child: navigationBarView)
		MaterialLayout.height(self, child: navigationBarView, height: 70)
	}
	
	/**
	:name:	prepareCaptureButton
	*/
	private func prepareCaptureButton() {
		captureButton = FlatButton()
		captureButton!.pulseColor = MaterialColor.white
		captureButton!.pulseFill = true
		captureButton!.backgroundColor = MaterialColor.red.darken1.colorWithAlphaComponent(0.3)
		captureButton!.borderWidth = .Border2
		captureButton!.borderColor = MaterialColor.white
		captureButton!.shadowDepth = .None
		captureButton!.addTarget(self, action: "handleCaptureButton:", forControlEvents: .TouchUpInside)
		
		addSubview(captureButton!)
		captureButton!.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromBottomRight(self, child: captureButton!, bottom: 24, right: (bounds.width - 72) / 2)
		MaterialLayout.size(self, child: captureButton!, width: 72, height: 72)
	}
	
	/**
	:name:	prepareCameraButton
	*/
	private func prepareCameraButton() {
		let img4: UIImage? = UIImage(named: "ic_photo_camera_white_36pt")
		cameraButton = FlatButton()
		cameraButton!.pulseColor = nil
		cameraButton!.setImage(img4, forState: .Normal)
		cameraButton!.setImage(img4, forState: .Highlighted)
		cameraButton!.addTarget(self, action: "handleCameraButton:", forControlEvents: .TouchUpInside)
		
		addSubview(cameraButton!)
		cameraButton!.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromBottomLeft(self, child: cameraButton!, bottom: 24, left: 24)
	}
	
	/**
	:name:	prepareVideoButton
	*/
	private func prepareVideoButton() {
		let img5: UIImage? = UIImage(named: "ic_videocam_white_36pt")
		videoButton = FlatButton()
		videoButton!.pulseColor = nil
		videoButton!.setImage(img5, forState: .Normal)
		videoButton!.setImage(img5, forState: .Highlighted)
		videoButton!.addTarget(self, action: "handleVideoButton:", forControlEvents: .TouchUpInside)
		
		addSubview(videoButton!)
		videoButton!.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromBottomRight(self, child: videoButton!, bottom: 24, right: 24)
	}
	
	/**
	:name:	prepareCloseButton
	*/
	private func prepareCloseButton() {
		let img: UIImage? = UIImage(named: "ic_close_white")
		closeButton = FlatButton()
		closeButton!.pulseColor = nil
		closeButton!.setImage(img, forState: .Normal)
		closeButton!.setImage(img, forState: .Highlighted)
	}
	
	/**
	:name:	prepareSwitchCameraButton
	*/
	private func prepareSwitchCameraButton() {
		let img: UIImage? = UIImage(named: "ic_camera_front_white")
		switchCameraButton = FlatButton()
		switchCameraButton!.pulseColor = nil
		switchCameraButton!.setImage(img, forState: .Normal)
		switchCameraButton!.setImage(img, forState: .Highlighted)
		switchCameraButton!.addTarget(self, action: "handleSwitchCameraButton:", forControlEvents: .TouchUpInside)
	}
	
	/**
	:name:	prepareFlashButton
	*/
	private func prepareFlashButton() {
		captureSession.flashMode = .Auto
		
		let img: UIImage? = UIImage(named: "ic_flash_auto_white")
		flashButton = FlatButton()
		flashButton!.pulseColor = nil
		flashButton!.setImage(img, forState: .Normal)
		flashButton!.setImage(img, forState: .Highlighted)
		flashButton!.addTarget(self, action: "handleFlashButton:", forControlEvents: .TouchUpInside)
	}
}

