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

@objc(CaptureViewDelegate)
public protocol CaptureViewDelegate : MaterialDelegate {
	/**
	:name:	captureViewDidStartRecordTimer
	*/
	optional func captureViewDidStartRecordTimer(captureView: CaptureView)
	
	/**
	:name:	captureViewDidUpdateRecordTimer
	*/
	optional func captureViewDidUpdateRecordTimer(captureView: CaptureView, hours: Int, minutes: Int, seconds: Int)
	
	/**
	:name:	captureViewDidStopRecordTimer
	*/
	optional func captureViewDidStopRecordTimer(captureView: CaptureView, hours: Int, minutes: Int, seconds: Int)
	
	/**
	:name:	captureViewDidTapToFocusAtPoint
	*/
	optional func captureViewDidTapToFocusAtPoint(captureView: CaptureView, point: CGPoint)
	
	/**
	:name:	captureViewDidTapToExposeAtPoint
	*/
	optional func captureViewDidTapToExposeAtPoint(captureView: CaptureView, point: CGPoint)
	
	/**
	:name:	captureViewDidTapToResetAtPoint
	*/
	optional func captureViewDidTapToResetAtPoint(captureView: CaptureView, point: CGPoint)
}

public class CaptureView : MaterialView, UIGestureRecognizerDelegate {
	/**
	:name:	timer
	*/
	private var timer: NSTimer?
	
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
	:name:	tapToResetEnabled
	*/
	private var tapToResetEnabled: Bool = false {
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
	public var contentInsetsRef: UIEdgeInsets = MaterialTheme.captureView.contentInsetsRef {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	previewView
	*/
	public private(set) lazy var previewView: CapturePreviewView = CapturePreviewView()
	
	/**
	:name:	capture
	*/
	public private(set) lazy var captureSession: CaptureSession = CaptureSession()
	
	/**
	:name:	focusView
	*/
	public var focusView: MaterialView? {
		didSet {
			if nil == focusView {
				removeTapGesture(&tapToFocusGesture)
			} else {
				tapToResetEnabled = true
				prepareFocusView()
				prepareTapGesture(&tapToFocusGesture, numberOfTapsRequired: 1, numberOfTouchesRequired: 1, selector: "handleTapToFocusGesture:")
				if let v: UITapGestureRecognizer = tapToExposeGesture {
					tapToFocusGesture!.requireGestureRecognizerToFail(v)
				}
			}
		}
	}
	
	/**
	:name:	exposureView
	*/
	public var exposureView: MaterialView? {
		didSet {
			if nil == exposureView {
				removeTapGesture(&tapToExposeGesture)
			} else {
				tapToResetEnabled = true
				prepareExposureView()
				prepareTapGesture(&tapToExposeGesture, numberOfTapsRequired: 2, numberOfTouchesRequired: 1, selector: "handleTapToExposeGesture:")
				if let v: UITapGestureRecognizer = tapToFocusGesture {
					v.requireGestureRecognizerToFail(tapToExposeGesture!)
				}
			}
		}
	}
	
	/**
	:name:	closeButton
	*/
	public var closeButton: MaterialButton?
	
	/**
	:name:	cameraButton
	*/
	public var cameraButton: MaterialButton? {
		didSet {
			cameraButton?.translatesAutoresizingMaskIntoConstraints = false
			reloadView()
		}
	}
	
	/**
	:name:	captureButton
	*/
	public var captureButton: MaterialButton?
	
	/**
	:name:	videoButton
	*/
	public var videoButton: MaterialButton? {
		didSet {
			videoButton?.translatesAutoresizingMaskIntoConstraints = false
			reloadView()
		}
	}
	
	/**
	:name:	switchCameraButton
	*/
	public var switchCameraButton: MaterialButton?
	
	/**
	:name:	flashButton
	*/
	public var flashButton: MaterialButton?
	
	/**
	:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectNull)
	}
	
	/**
	:name:	layoutSubviews
	*/
	public override func layoutSubviews() {
		super.layoutSubviews()
		if let v: MaterialButton = captureButton {
			v.y = bounds.height - contentInsetsRef.bottom - v.height
			v.x = (bounds.width - v.width) / 2
		}
		(previewView.layer as! AVCaptureVideoPreviewLayer).connection.videoOrientation = captureSession.currentVideoOrientation
	}
	
	/**
	:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		userInteractionEnabled = MaterialTheme.captureView.userInteractionEnabled
		backgroundColor = MaterialTheme.captureView.backgroundColor
		
		contentsRect = MaterialTheme.captureView.contentsRect
		contentsCenter = MaterialTheme.captureView.contentsCenter
		contentsScale = MaterialTheme.captureView.contentsScale
		contentsGravity = MaterialTheme.captureView.contentsGravity
		shadowDepth = MaterialTheme.captureView.shadowDepth
		shadowColor = MaterialTheme.captureView.shadowColor
		zPosition = MaterialTheme.captureView.zPosition
		borderWidth = MaterialTheme.captureView.borderWidth
		borderColor = MaterialTheme.captureView.bordercolor
		
		preparePreviewView()
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
		
		if let v: MaterialButton = cameraButton {
			addSubview(v)
			MaterialLayout.alignFromBottomLeft(self, child: v, bottom: contentInsetsRef.bottom, left: contentInsetsRef.left)
		}
		
		if let v: MaterialButton = videoButton {
			addSubview(v)
			MaterialLayout.alignFromBottomRight(self, child: v, bottom: contentInsetsRef.bottom, right: contentInsetsRef.right)
		}
	}
	
	/**
	:name:	startTimer
	*/
	public func startTimer() {
		timer?.invalidate()
		timer = NSTimer(timeInterval: 0.5, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
		NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
		(delegate as? CaptureViewDelegate)?.captureViewDidStartRecordTimer?(self)
	}
	
	/**
	:name:	updateTimer
	*/
	public func updateTimer() {
		let duration: CMTime = captureSession.recordedDuration
		let time: Double = CMTimeGetSeconds(duration)
		let hours: Int = Int(time / 3600)
		let minutes: Int = Int((time / 60) % 60)
		let seconds: Int = Int(time % 60)
		(delegate as? CaptureViewDelegate)?.captureViewDidUpdateRecordTimer?(self, hours: hours, minutes: minutes, seconds: seconds)
	}
	
	/**
	:name:	stopTimer
	*/
	public func stopTimer() {
		let duration: CMTime = captureSession.recordedDuration
		let time: Double = CMTimeGetSeconds(duration)
		let hours: Int = Int(time / 3600)
		let minutes: Int = Int((time / 60) % 60)
		let seconds: Int = Int(time % 60)
		timer?.invalidate()
		timer = nil
		(delegate as? CaptureViewDelegate)?.captureViewDidStopRecordTimer?(self, hours: hours, minutes: minutes, seconds: seconds)
	}
	
	/**
	:name:	handleTapToFocusGesture
	*/
	internal func handleTapToFocusGesture(recognizer: UITapGestureRecognizer) {
		if let v: MaterialView = focusView {
			if captureSession.cameraSupportsTapToFocus {
				let point: CGPoint = recognizer.locationInView(self)
				captureSession.focusAtPoint(previewView.captureDevicePointOfInterestForPoint(point))
				MaterialAnimation.animationDisabled {
					v.layer.transform = CATransform3DIdentity
					v.position = point
					v.hidden = false
				}
				MaterialAnimation.animateWithDuration(0.25, animations: {
					v.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
				}) {
					MaterialAnimation.delay(0.4) {
						MaterialAnimation.animationDisabled {
							v.hidden = true
						}
					}
				}
				(delegate as? CaptureViewDelegate)?.captureViewDidTapToFocusAtPoint?(self, point: point)
			}
		}
	}
	
	/**
	:name:	handleTapToExposeGesture
	*/
	internal func handleTapToExposeGesture(recognizer: UITapGestureRecognizer) {
		if nil != exposureView && captureSession.cameraSupportsTapToExpose {
			let point: CGPoint = recognizer.locationInView(self)
			captureSession.exposeAtPoint(previewView.captureDevicePointOfInterestForPoint(point))
			(delegate as? CaptureViewDelegate)?.captureViewDidTapToExposeAtPoint?(self, point: point)
		}
	}
	
	/**
	:name:	handleTapToResetGesture
	*/
	internal func handleTapToResetGesture(recognizer: UITapGestureRecognizer) {
		if tapToResetEnabled {
			captureSession.resetFocusAndExposureModes()
			let point: CGPoint = previewView.pointForCaptureDevicePointOfInterest(CGPointMake(0.5, 0.5))
			(delegate as? CaptureViewDelegate)?.captureViewDidTapToResetAtPoint?(self, point: point)
		}
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
	
	/**
	:name:	preparePreviewView
	*/
	private func preparePreviewView() {
		previewView.translatesAutoresizingMaskIntoConstraints = false
		(previewView.layer as! AVCaptureVideoPreviewLayer).session = captureSession.session
		captureSession.startSession()
	}
	
	/**
	:name:	prepareFocusView
	*/
	private func prepareFocusView() {
		if let v: MaterialView = focusView {
			v.hidden = true
		}
	}
	
	/**
	:name:	prepareExposureView
	*/
	private func prepareExposureView() {
		if let v: MaterialView = exposureView {
			v.hidden = true
		}
	}
}