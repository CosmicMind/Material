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
	
	/**
	:name:	capturePreviewViewDidTapToExposeAtPoint
	*/
	optional func capturePreviewViewDidTapToExposeAtPoint(capturePreviewView: CapturePreviewView, point: CGPoint)
	
	/**
	:name:	capturePreviewViewDidTapToResetAtPoint
	*/
	optional func capturePreviewViewDidTapToResetAtPoint(capturePreviewView: CapturePreviewView, point: CGPoint)
}

public class CapturePreviewView : MaterialView, UIGestureRecognizerDelegate {
	/**
	:name:	tapToFocusGesture
	*/
	private var tapToFocusGesture: UITapGestureRecognizer?
	
	/**
	:name:	tapToExposeGesture
	*/
	private var tapToExposeGesture: UITapGestureRecognizer?
	
	/**
	:name:	tapToResetGesture
	*/
	private var tapToResetGesture: UITapGestureRecognizer?
	
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
				tapToResetEnabled = true
				prepareTapGesture(&tapToFocusGesture, numberOfTapsRequired: 1, numberOfTouchesRequired: 1, selector: "handleTapToFocusGesture:")
				if let v: UITapGestureRecognizer = tapToExposeGesture {
					tapToFocusGesture!.requireGestureRecognizerToFail(v)
				}
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
			if tapToExposeEnabled {
				tapToResetEnabled = true
				prepareTapGesture(&tapToExposeGesture, numberOfTapsRequired: 2, numberOfTouchesRequired: 1, selector: "handleTapToExposeGesture:")
				if let v: UITapGestureRecognizer = tapToFocusGesture {
					v.requireGestureRecognizerToFail(tapToExposeGesture!)
				}
			} else {
				removeTapGesture(&tapToExposeGesture)
			}
		}
	}
	
	/**
	:name:	tapToResetEnabled
	*/
	public var tapToResetEnabled: Bool {
		didSet {
			if tapToResetEnabled {
				prepareTapGesture(&tapToResetGesture, numberOfTapsRequired: 2, numberOfTouchesRequired: 2, selector: "handleTapToResetGesture:")
				if let v: UITapGestureRecognizer = tapToFocusGesture {
					v.requireGestureRecognizerToFail(tapToResetGesture!)
				}
				if let v: UITapGestureRecognizer = tapToExposeGesture {
					v.requireGestureRecognizerToFail(tapToResetGesture!)
				}
			} else {
				removeTapGesture(&tapToResetGesture)
			}
		}
	}
	
	/**
	:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		tapToFocusEnabled = true
		tapToExposeEnabled = true
		tapToResetEnabled = true
		super.init(coder: aDecoder)
	}
	
	/**
	:name:	init
	*/
	public override init(frame: CGRect) {
		tapToFocusEnabled = true
		tapToExposeEnabled = true
		tapToResetEnabled = true
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
	:name:	handleTapToFocusGesture
	*/
	internal func handleTapToFocusGesture(recognizer: UITapGestureRecognizer) {
		if tapToFocusEnabled && captureSession.cameraSupportsTapToFocus {
			let point: CGPoint = recognizer.locationInView(self)
			captureSession.focusAtPoint(captureDevicePointOfInterestForPoint(point))
			(delegate as? CapturePreviewViewDelegate)?.capturePreviewViewDidTapToFocusAtPoint?(self, point: point)
		}
	}
	
	/**
	:name:	handleTapToExposeGesture
	*/
	internal func handleTapToExposeGesture(recognizer: UITapGestureRecognizer) {
		if tapToExposeEnabled && captureSession.cameraSupportsTapToExpose {
			let point: CGPoint = recognizer.locationInView(self)
			captureSession.exposeAtPoint(captureDevicePointOfInterestForPoint(point))
			(delegate as? CapturePreviewViewDelegate)?.capturePreviewViewDidTapToExposeAtPoint?(self, point: point)
		}
	}
	
	/**
	:name:	handleTapToResetGesture
	*/
	internal func handleTapToResetGesture(recognizer: UITapGestureRecognizer) {
		if tapToResetEnabled {
			captureSession.resetFocusAndExposureModes()
			(delegate as? CapturePreviewViewDelegate)?.capturePreviewViewDidTapToResetAtPoint?(self, point: pointForCaptureDevicePointOfInterest(CGPointMake(0.5, 0.5)))
		}
	}
	
	/**
	:name:	preparePreviewLayer
	*/
	private func preparePreviewLayer() {
		previewLayer.session = captureSession.session
		visualLayer.addSublayer(previewLayer)
	}
	
	/**
	:name:	layoutPreviewLayer
	*/
	private func layoutPreviewLayer() {
		previewLayer.frame = visualLayer.bounds
		previewLayer.position = CGPointMake(width / 2, height / 2)
		previewLayer.cornerRadius = visualLayer.cornerRadius
		previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
	}
	
	/**
	:name:	prepareTapGesture
	*/
	private func prepareTapGesture(inout gesture: UITapGestureRecognizer?, numberOfTapsRequired: Int, numberOfTouchesRequired: Int, selector: Selector) {
		removeTapGesture(&gesture)
		gesture = UITapGestureRecognizer(target: self, action: selector)
		gesture!.delegate = self
		gesture!.numberOfTapsRequired = numberOfTapsRequired
		gesture!.numberOfTouchesRequired = numberOfTouchesRequired
		addGestureRecognizer(gesture!)
	}
	
	/**
	:name:	removeTapToFocusGesture
	*/
	private func removeTapGesture(inout gesture: UITapGestureRecognizer?) {
		if let v: UIGestureRecognizer = gesture {
			removeGestureRecognizer(v)
			gesture = nil
		}
	}
}