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
	:name:	switchCamerasButton
	*/
	public var switchCamerasButton: MaterialButton? {
		didSet {
			if let v: MaterialButton = switchCamerasButton {
				v.translatesAutoresizingMaskIntoConstraints = false
			}
			reloadView()
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
		
//		var verticalFormat: String = "V:|"
//		var views: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
//		var metrics: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
		
		addSubview(previewView)
		MaterialLayout.alignToParent(self, child: previewView)
		
		if let v: MaterialButton = switchCamerasButton {
			addSubview(v)
			MaterialLayout.alignFromBottomRight(self, child: v, bottom: contentInsetsRef.bottom, right: contentInsetsRef.right)
			MaterialLayout.size(self, child: v, width: switchCamerasButtonSize.width, height: switchCamerasButtonSize.height)
			v.removeTarget(self, action: "handleSwitchCameras", forControlEvents: .TouchUpInside)
			v.addTarget(self, action: "handleSwitchCameras", forControlEvents: .TouchUpInside)
		}
		
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
	:name:	handleSwitchCameras
	*/
	internal func handleSwitchCameras() {
		previewView.captureSession.switchCameras()
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