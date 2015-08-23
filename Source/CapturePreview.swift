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
import AVFoundation

@objc(PreviewDelegate)
public protocol PreviewDelegate {
	optional func previewTappedToFocusAt(preview: Preview, point: CGPoint)
	optional func previewTappedToExposeAt(preview: Preview, point: CGPoint)
	optional func previewTappedToReset(preview: Preview, focus: UIView, exposure: UIView)
}

public class Preview: UIView {
	/**
		:name:	boxBounds
		:description:	A static property that sets the initial size of the focusBox and exposureBox properties.
	*/
	static public var boxBounds: CGRect = CGRectMake(0, 0, 150, 150)
	
	/**
		:name:	delegate
		:description:	An optional instance of PreviewDelegate to handle events that are triggered during various
		stages of engagement.
	*/
	public weak var delegate: PreviewDelegate?
	
	/**
		:name:	tapToFocusEnabled
		:description:	A mutator and accessor that enables and disables tap to focus gesture.
	*/
	public var tapToFocusEnabled: Bool {
		get {
			return singleTapRecognizer!.enabled
		}
		set(value) {
			singleTapRecognizer!.enabled = value
		}
	}
	
	/**
		:name:	tapToExposeEnabled
		:description:	A mutator and accessor that enables and disables tap to expose gesture.
	*/
	public var tapToExposeEnabled: Bool {
		get {
			return doubleTapRecognizer!.enabled
		}
		set(value) {
			doubleTapRecognizer!.enabled = value
		}
	}
	
	//
	//	override for layerClass
	//
	override public class func layerClass() -> AnyClass {
		return AVCaptureVideoPreviewLayer.self
	}
	
	/**
		:name:	session
		:description:	A mutator and accessor for the preview AVCaptureSession value.
	*/
	public var session: AVCaptureSession {
		get {
			return (layer as! AVCaptureVideoPreviewLayer).session
		}
		set(value) {
			(layer as! AVCaptureVideoPreviewLayer).session = value
		}
	}
	
	/**
		:name:	focusBox
		:description:	An optional UIView for the focusBox animation. This is used when the
		tapToFocusEnabled property is set to true.
	*/
	public var focusBox: UIView?
	
	/**
		:name:	exposureBox
		:description:	An optional UIView for the exposureBox animation. This is used when the
		tapToExposeEnabled property is set to true.
	*/
	public var exposureBox: UIView?
	
	//
	//	:name:	singleTapRecognizer
	//	:description:	Gesture recognizer for single tap.
	//
	private var singleTapRecognizer: UITapGestureRecognizer?
	
	//
	//	:name:	doubleTapRecognizer
	//	:description:	Gesture recognizer for double tap.
	//
	private var doubleTapRecognizer: UITapGestureRecognizer?
	
	//
	//	:name:	doubleDoubleTapRecognizer
	//	:description:	Gesture recognizer for double/double tap.
	//
	private var doubleDoubleTapRecognizer: UITapGestureRecognizer?
	
	required public init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupView()
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	public init() {
		super.init(frame: CGRectZero)
		setTranslatesAutoresizingMaskIntoConstraints(false)
		setupView()
	}
	
	//
	//	:name:	handleSingleTap
	//
	internal func handleSingleTap(recognizer: UIGestureRecognizer) {
		let point: CGPoint = recognizer.locationInView(self)
		runBoxAnimationOnView(focusBox, point: point)
		delegate?.previewTappedToFocusAt?(self, point: captureDevicePointForPoint(point))
	}
	
	//
	//	:name:	handleDoubleTap
	//	
	internal func handleDoubleTap(recognizer: UIGestureRecognizer) {
		let point: CGPoint = recognizer.locationInView(self)
		runBoxAnimationOnView(exposureBox, point: point)
		delegate?.previewTappedToExposeAt?(self, point: captureDevicePointForPoint(point))
	}
	
	//
	//	:name:	handleDoubleDoubleTap
	//	
	internal func handleDoubleDoubleTap(recognizer: UIGestureRecognizer) {
		runResetAnimation()
	}
	
	//
	//	:name:	setupView
	//	:description:	Common setup for view.
	//	
	private func setupView() {
		let captureLayer: AVCaptureVideoPreviewLayer = layer as! AVCaptureVideoPreviewLayer
		captureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
		
		singleTapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
		singleTapRecognizer!.numberOfTapsRequired = 1
		
		doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
		doubleTapRecognizer!.numberOfTapsRequired = 2
		
		doubleDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "handleDoubleDoubleTap:")
		doubleDoubleTapRecognizer!.numberOfTapsRequired = 2
		doubleDoubleTapRecognizer!.numberOfTouchesRequired = 2
		
		addGestureRecognizer(singleTapRecognizer!)
		addGestureRecognizer(doubleTapRecognizer!)
		addGestureRecognizer(doubleDoubleTapRecognizer!)
		singleTapRecognizer!.requireGestureRecognizerToFail(doubleTapRecognizer!)
		
		focusBox = viewWithColor(.redColor())
		exposureBox = viewWithColor(.blueColor())
		addSubview(focusBox!)
		addSubview(exposureBox!)
	}
	
	//
	//	:name:	viewWithColor
	//	:description:	Initializes a UIView with a set UIColor.
	//	
	private func viewWithColor(color: UIColor) -> UIView {
		let view: UIView = UIView(frame: Preview.boxBounds)
		view.backgroundColor = .clearColor()
		view.layer.borderColor = color.CGColor
		view.layer.borderWidth = 5
		view.hidden = true
		return view
	}
	
	//
	//	:name:	runBoxAnimationOnView
	//	:description:	Runs the animation used for focusBox and exposureBox on single and double
	//	taps respectively at a given point.
	//	
	private func runBoxAnimationOnView(view: UIView!, point: CGPoint) {
		view.center = point
		view.hidden = false
		UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseInOut, animations: { _ in
			view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0)
		}) { _ in
			let delayInSeconds: Double = 0.5
			let popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
			dispatch_after(popTime, dispatch_get_main_queue()) {
				view.hidden = true
				view.transform = CGAffineTransformIdentity
			}
		}
	}
	
	//
	//	:name:	captureDevicePointForPoint
	//	:description:	Interprets the correct point from touch to preview layer.
	//	
	private func captureDevicePointForPoint(point: CGPoint) -> CGPoint {
		let previewLayer: AVCaptureVideoPreviewLayer = layer as! AVCaptureVideoPreviewLayer
		return previewLayer.captureDevicePointOfInterestForPoint(point)
	}
	
	//
	//	:name:	runResetAnimation
	//	:description:	Executes the reset animation for focus and exposure.
	//	
	private func runResetAnimation() {
		if !tapToFocusEnabled && !tapToExposeEnabled {
			return
		}
		
		let previewLayer: AVCaptureVideoPreviewLayer = layer as! AVCaptureVideoPreviewLayer
		let centerPoint: CGPoint = previewLayer.pointForCaptureDevicePointOfInterest(CGPointMake(0.5, 0.5))
		focusBox!.center = centerPoint
		exposureBox!.center = centerPoint
		exposureBox!.transform = CGAffineTransformMakeScale(1.2, 1.2)
		focusBox!.hidden = false
		exposureBox!.hidden = false
		
		UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseInOut, animations: { _ in
			self.focusBox!.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0)
			self.exposureBox!.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1.0)
		}) { _ in
			let delayInSeconds: Double = 0.5
			let popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
			dispatch_after(popTime, dispatch_get_main_queue()) {
				self.focusBox!.hidden = true
				self.exposureBox!.hidden = true
				self.focusBox!.transform = CGAffineTransformIdentity
				self.exposureBox!.transform = CGAffineTransformIdentity
				self.delegate?.previewTappedToReset?(self, focus: self.focusBox!, exposure: self.exposureBox!)
			}
		}
	}
}
