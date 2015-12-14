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

public class CaptureView : MaterialView, CaptureSessionDelegate, CapturePreviewViewDelegate {
	/**
	:name:	previewView
	*/
	public private(set) lazy var previewView: CapturePreviewView = CapturePreviewView()
	
	/**
	:name:	focusLayer
	*/
	public private(set) lazy var focusLayer: MaterialLayer = MaterialLayer()
	
	/**
	:name:	exposureLayer
	*/
	public private(set) lazy var exposureLayer: MaterialLayer = MaterialLayer()
	
	/**
	:name:	captureButton
	*/
	public var captureButton: UIButton? {
		didSet {
			if let v: UIButton = captureButton {
				v.removeTarget(self, action: "handleCaptureButton:", forControlEvents: .TouchUpInside)
				v.addTarget(self, action: "handleCaptureButton:", forControlEvents: .TouchUpInside)
			} else {
				captureButton?.removeFromSuperview()
				captureButton = nil
			}
		}
	}
	
	/**
	:name:	flashButton
	*/
	public var flashButton: UIButton? {
		didSet {
			if let v: UIButton = flashButton {
				v.removeTarget(self, action: "handleFlashButton:", forControlEvents: .TouchUpInside)
				v.addTarget(self, action: "handleFlashButton:", forControlEvents: .TouchUpInside)
			} else {
				flashButton?.removeFromSuperview()
				flashButton = nil
			}
		}
	}
	
	/**
	:name:	switchCamerasButton
	*/
	public var switchCamerasButton: UIButton? {
		didSet {
			if let v: UIButton = switchCamerasButton {
				v.removeTarget(self, action: "handleSwitchCameraButton:", forControlEvents: .TouchUpInside)
				v.addTarget(self, action: "handleSwitchCameraButton:", forControlEvents: .TouchUpInside)
			} else {
				switchCamerasButton?.removeFromSuperview()
				switchCamerasButton = nil
			}
		}
	}
	
	/**
	:name:	captureSession
	*/
	public var captureSession: CaptureSession {
		return previewView.captureSession
	}
	
	/**
	:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectNull)
	}
	
	/**
	:name:	layoutSublayersOfLayer
	*/
	public override func layoutSublayersOfLayer(layer: CALayer) {
		super.layoutSublayersOfLayer(layer)
		if self.layer == layer {
			
		}
	}
	
	/**
	:name:	reloadView
	*/
	public func reloadView() {
		previewView.removeFromSuperview()
		addSubview(previewView)
		MaterialLayout.alignToParent(self, child: previewView)
	}
	
	/**
	:name:	capturePreviewViewDidTapToFocusAtPoint
	*/
	public func capturePreviewViewDidTapToFocusAtPoint(capturePreviewView: CapturePreviewView, point: CGPoint) {
		MaterialAnimation.animationDisabled {
			self.focusLayer.position = point
			self.focusLayer.hidden = false
		}
		MaterialAnimation.animateWithDuration(0.25, animations: {
			self.focusLayer.transform = CATransform3DMakeScale(0, 0, 1)
		}) {
			MaterialAnimation.animationDisabled {
				self.focusLayer.hidden = true
				self.focusLayer.transform = CATransform3DIdentity
			}
		}
	}
	
	/**
	:name:	capturePreviewViewDidTapToExposeAtPoint
	*/
	public func capturePreviewViewDidTapToExposeAtPoint(capturePreviewView: CapturePreviewView, point: CGPoint) {
		MaterialAnimation.animationDisabled {
			self.exposureLayer.position = point
			self.exposureLayer.hidden = false
		}
		MaterialAnimation.animateWithDuration(0.25, animations: {
			self.exposureLayer.transform = CATransform3DMakeScale(0, 0, 1)
		}) {
			MaterialAnimation.animationDisabled {
				self.exposureLayer.hidden = true
				self.exposureLayer.transform = CATransform3DIdentity
			}
		}
	}

	/**
	:name:	capturePreviewViewDidTapToResetAtPoint
	*/
	public func capturePreviewViewDidTapToResetAtPoint(capturePreviewView: CapturePreviewView, point: CGPoint) {
		capturePreviewViewDidTapToFocusAtPoint(capturePreviewView, point: point)
		capturePreviewViewDidTapToExposeAtPoint(capturePreviewView, point: point)
	}
	
	/**
	:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		preparePreviewView()
		prepareFocusLayer()
		prepareExposureLayer()
		reloadView()
	}
	
	/**
	:name:	handleCaptureButton
	*/
	internal func handleCaptureButton(button: UIButton) {
		captureSession.captureStillImage()
	}
	
	/**
	:name:	handleSwitchCameraButton
	*/
	internal func handleSwitchCameraButton(button: UIButton) {
		captureSession.switchCameras()
	}
	
	/**
	:name:	handleFlashButton
	*/
	internal func handleFlashButton(button: UIButton) {
		print(captureSession.flashMode == .Off)
		
		switch captureSession.flashMode {
		case .Off:
			captureSession.flashMode = .On
			print("On")
		case .On:
			captureSession.flashMode = .Off
			print("Auto")
		case .Auto:
			print("Off")
			captureSession.flashMode = .On
		}
	}
	
	/**
	:name:	preparePreviewView
	*/
	private func preparePreviewView() {
		previewView.translatesAutoresizingMaskIntoConstraints = false
		previewView.delegate = self
		previewView.captureSession.startSession()
	}
	
	/**
	:name:	prepareFocusLayer
	*/
	private func prepareFocusLayer() {
		focusLayer.hidden = true
		focusLayer.backgroundColor = MaterialColor.blue.base.colorWithAlphaComponent(0.25).CGColor
		focusLayer.bounds = CGRectMake(0, 0, 150, 150)
		focusLayer.cornerRadius = 75
		previewView.layer.addSublayer(focusLayer)
	}
	
	/**
	:name:	prepareExposureLayer
	*/
	private func prepareExposureLayer() {
		exposureLayer.hidden = true
		exposureLayer.backgroundColor = MaterialColor.red.base.colorWithAlphaComponent(0.25).CGColor
		exposureLayer.bounds = CGRectMake(0, 0, 150, 150)
		exposureLayer.cornerRadius = 75
		previewView.layer.addSublayer(exposureLayer)
	}
}