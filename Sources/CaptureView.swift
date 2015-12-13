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
	:name:	navigationBarView
	*/
	public private(set) lazy var navigationBarView: NavigationBarView = NavigationBarView()
	
	/**
	:name:	flashAutoButton
	*/
	public var flashAutoButton: MaterialButton? {
		didSet {
			if let v: MaterialButton = flashAutoButton {
				v.removeTarget(self, action: "handleFlashAuto:", forControlEvents: .TouchUpInside)
				v.addTarget(self, action: "handleFlashAuto:", forControlEvents: .TouchUpInside)
			} else {
				flashAutoButton?.removeFromSuperview()
				flashAutoButton = nil
			}
		}
	}
	
	/**
	:name:	switchCamerasButton
	*/
	public var switchCamerasButton: MaterialButton? {
		didSet {
			if let v: MaterialButton = switchCamerasButton {
				v.removeTarget(self, action: "handleSwitchCamera:", forControlEvents: .TouchUpInside)
				v.addTarget(self, action: "handleSwitchCamera:", forControlEvents: .TouchUpInside)
			} else {
				switchCamerasButton?.removeFromSuperview()
				switchCamerasButton = nil
			}
		}
	}
	
	/**
	:name:	switchCamerasButtonSize
	*/
	public var switchCamerasButtonSize: CGSize = CGSizeMake(48, 48) {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	contentInsets
	*/
	public var contentInsets: MaterialEdgeInsets = .None {
		didSet {
			contentInsetsRef = MaterialEdgeInsetsToValue(contentInsets)
		}
	}
	
	/**
	:name:	contentInsetsRef
	*/
	public var contentInsetsRef: UIEdgeInsets = MaterialTheme.basicCaptureView.contentInsetsRef {
		didSet {
			reloadView()
		}
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
		// clear constraints so new ones do not conflict
		removeConstraints(constraints)
		for v in subviews {
			v.removeFromSuperview()
		}
		
		addSubview(previewView)
		MaterialLayout.alignToParent(self, child: previewView)
		
		addSubview(navigationBarView)
		
//		var verticalFormat: String = "V:|"
//		var views: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
//		var metrics: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
		
//		if 0 < views.count {
//			addConstraints(MaterialLayout.constraint(verticalFormat, options: [], metrics: metrics, views: views))
//		}
	}
	
	/**
	:name:	captureSessionFailedWithError
	*/
	public func captureSessionFailedWithError(capture: CaptureSession, error: NSError) {
		print(error)
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
		prepareNavigationBarView()
		prepareFocusLayer()
		prepareExposureLayer()
		reloadView()
	}
	
	/**
	:name:	handleSwitchCamera
	*/
	internal func handleSwitchCamera(button: MaterialButton) {
		previewView.captureSession.switchCameras()
	}
	
	/**
	:name:	handleFlashAuto
	*/
	internal func handleFlashAuto(button: MaterialButton) {
		switch previewView.captureSession.flashMode {
		case .Off:
			previewView.captureSession.flashMode = .On
			print("On")
		case .On:
			previewView.captureSession.flashMode = .Off
			print("Auto")
		case .Auto:
			print("Off")
			previewView.captureSession.flashMode = .On
		}
	}
	
	/**
	:name:	prepareNavigationBarView
	*/
	private func prepareNavigationBarView() {
		navigationBarView.backgroundColor = MaterialColor.black.colorWithAlphaComponent(0.3)
		navigationBarView.shadowDepth = .None
		navigationBarView.statusBarStyle = .LightContent
	}
	
	/**
	:name:	preparePreviewView
	*/
	private func preparePreviewView() {
		previewView.translatesAutoresizingMaskIntoConstraints = false
		previewView.captureSession.delegate = self
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