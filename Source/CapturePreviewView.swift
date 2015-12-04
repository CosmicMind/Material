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

@objc(CapturePreviewViewDelegate)
public protocol CapturePreviewViewDelegate : MaterialDelegate {
	/**
		:name:	capturePreviewViewDidTapToFocusAtPoint
	*/
	optional func capturePreviewViewDidTapToFocusAtPoint(capturePreviewView: CapturePreviewView, point: CGPoint)
}

public class CapturePreviewView : MaterialView, UIGestureRecognizerDelegate {
	//
	//	:name:	tapToFocusGesture
	//
	private var tapToFocusGesture: UITapGestureRecognizer?
	
	/**
		:name:	previewLayer
	*/
	public private(set) lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
	
	/**
		:name:	capture
	*/
	public private(set) lazy var captureSession: CaptureSession = CaptureSession()
	
	/**
		:name:	tapToFocusEnabled
	*/
	public var tapToFocusEnabled: Bool {
		didSet {
			if tapToFocusEnabled {
				prepareTapGesture(&tapToFocusGesture, selector: "handleTapToFocusGesture:")
			} else {
				removeTapGesture(&tapToFocusGesture)
			}
		}
	}
	
	/**
		:name:	tapToExposeEnabled
	*/
	public var tapToExposeEnabled: Bool {
		didSet {
		}
	}
	
	/**
		:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		tapToFocusEnabled = true
		tapToExposeEnabled = true
		super.init(coder: aDecoder)
	}
	
	/**
		:name:	init
	*/
	public override init(frame: CGRect) {
		tapToFocusEnabled = true
		tapToExposeEnabled = true
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
			layoutPreviewLayer()
		}
	}
	
	/**
		:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		preparePreviewLayer()
		tapToFocusEnabled = true
		tapToExposeEnabled = true
	}
	
	/**
		:name:	captureDevicePointOfInterestForPoint
	*/
	public func captureDevicePointOfInterestForPoint(point: CGPoint) -> CGPoint {
		return previewLayer.captureDevicePointOfInterestForPoint(point)
	}
	
	/**
		:name:	pointForCaptureDevicePointOfInterest
	*/
	public func pointForCaptureDevicePointOfInterest(point: CGPoint) -> CGPoint {
		return previewLayer.pointForCaptureDevicePointOfInterest(point)
	}
	
	//
	//	:name:	handleTapToFocusGesture
	//
	internal func handleTapToFocusGesture(recognizer: UITapGestureRecognizer) {
		if tapToFocusEnabled && captureSession.cameraSupportsTapToFocus {
			let point: CGPoint = recognizer.locationInView(self)
			captureSession.focusAtPoint(captureDevicePointOfInterestForPoint(point))
			(delegate as? CapturePreviewViewDelegate)?.capturePreviewViewDidTapToFocusAtPoint?(self, point: point)
		}
	}
	
	//
	//	:name:	preparePreviewLayer
	//
	private func preparePreviewLayer() {
		previewLayer.session = captureSession.session
		visualLayer.addSublayer(previewLayer)
	}
	
	//
	//	:name:	layoutPreviewLayer
	//
	private func layoutPreviewLayer() {
		previewLayer.frame = visualLayer.bounds
		previewLayer.position = CGPointMake(width / 2, height / 2)
		previewLayer.cornerRadius = visualLayer.cornerRadius
	}
	
	//
	//	:name:	prepareTapGesture
	//
	private func prepareTapGesture(inout gesture: UITapGestureRecognizer?, selector: Selector) {
		gesture = UITapGestureRecognizer(target: self, action: selector)
		gesture!.delegate = self
		addGestureRecognizer(gesture!)
	}
	
	//
	//	:name:	removeTapToFocusGesture
	//
	private func removeTapGesture(inout gesture: UITapGestureRecognizer?) {
		if let v: UIGestureRecognizer = gesture {
			removeGestureRecognizer(v)
			gesture = nil
		}
	}
}