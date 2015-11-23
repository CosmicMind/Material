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

public class BasicCaptureView : MaterialView, CaptureSessionDelegate {
	/**
		:name:	previewView
	*/
	public private(set) lazy var previewView: CapturePreviewView = CapturePreviewView()
	
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
	public var contentInsets: MaterialInsets = .None {
		didSet {
			contentInsetsRef = MaterialInsetsToValue(contentInsets)
		}
	}
	
	/**
		:name:	contentInsetsRef
	*/
	public var contentInsetsRef: MaterialInsetsType = MaterialTheme.basicCardView.contentInsetsRef {
		didSet {
			reloadView()
		}
	}
	
	/**
		:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
		:name:	init
	*/
	public override init(frame: CGRect) {
		super.init(frame: frame)
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
		:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		preparePreviewView()
		reloadView()
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
			MaterialLayout.alignFromBottomRight(self, child: v, bottom: 16, right: 16)
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
	
	internal func handleSwitchCameras() {
		previewView.captureSession.switchCameras()
	}
	
	//
	//	:name:	preparePreviewView
	//
	private func preparePreviewView() {
		previewView.translatesAutoresizingMaskIntoConstraints = false
		previewView.captureSession.delegate = self
		previewView.captureSession.startSession()
	}
}