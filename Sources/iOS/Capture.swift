/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import AVFoundation

@objc(CaptureMode)
public enum CaptureMode: Int {
	case photo
	case video
}

@objc(CaptureDelegate)
public protocol CaptureDelegate {
	/**
     A delegation method that is fired when the record timer has started.
     - Parameter capture: A reference to the calling capture.
	*/
	@objc
    optional func captureDidStartRecordTimer(capture: Capture)
	
    /**
     A delegation method that is fired when the record timer was updated.
     - Parameter capture: A reference to the calling capture.
     - Parameter hours: An integer representing hours.
     - Parameter minutes: An integer representing minutes.
     - Parameter seconds: An integer representing seconds.
     */
    @objc
    optional func captureDidUpdateRecordTimer(capture: Capture, hours: Int, minutes: Int, seconds: Int)
	
    /**
     A delegation method that is fired when the record timer has stopped.
     - Parameter capture: A reference to the calling capture.
     - Parameter hours: An integer representing hours.
     - Parameter minutes: An integer representing minutes.
     - Parameter seconds: An integer representing seconds.
     */
    @objc
    optional func captureDidStopRecordTimer(capture: Capture, hours: Int, minutes: Int, seconds: Int)
	
    /**
     A delegation method that is fired when the user tapped to adjust the focus.
     - Parameter capture: A reference to the calling capture.
     - Parameter point: CGPoint that the user tapped at.
     */
    @objc
    optional func captureDidTapToFocusAtPoint(capture: Capture, point: CGPoint)
	
    /**
     A delegation method that is fired when the user tapped to adjust the exposure.
     - Parameter capture: A reference to the calling capture.
     - Parameter point: CGPoint that the user tapped at.
     */
    @objc
    optional func captureDidTapToExposeAtPoint(capture: Capture, point: CGPoint)
	
    /**
     A delegation method that is fired when the user tapped to reset.
     - Parameter capture: A reference to the calling capture.
     - Parameter point: CGPoint that the user tapped at.
     */
    @objc
    optional func captureDidTapToResetAtPoint(capture: Capture, point: CGPoint)
	
    /**
     A delegation method that is fired when the user pressed the flash button.
     - Parameter capture: A reference to the calling capture.
     - Parameter button: A reference to the UIButton that the user pressed.
     */
    @objc
    optional func captureDidPressFlashButton(capture: Capture, button: UIButton)
	
    /**
     A delegation method that is fired when the user pressed the switch camera button.
     - Parameter capture: A reference to the calling capture.
     - Parameter button: A reference to the UIButton that the user pressed.
     */
	@objc
    optional func captureDidPressSwitchCamerasButton(capture: Capture, button: UIButton)
	
    /**
     A delegation method that is fired when the user pressed capture button.
     - Parameter capture: A reference to the calling capture.
     - Parameter button: A reference to the UIButton that the user pressed.
     */
    @objc
    optional func captureDidPressCaptureButton(capture: Capture, button: UIButton)
	
    /**
     A delegation method that is fired when the user enabled the photo camera.
     - Parameter capture: A reference to the calling capture.
     - Parameter button: A reference to the UIButton that the user pressed.
     */
    @objc
    optional func captureDidPressCameraButton(capture: Capture, button: UIButton)
	
    /**
     A delegation method that is fired when the user enabled the video camera.
     - Parameter capture: A reference to the calling capture.
     - Parameter button: A reference to the UIButton that the user pressed.
     */
    @objc
    optional func captureDidPressVideoButton(capture: Capture, button: UIButton)
}

open class Capture: View, UIGestureRecognizerDelegate {
    /// A delegation reference.
    open weak var delegate: CaptureDelegate?
    
    /// A Timer reference for when recording is enabled.
	private var timer: Timer?
	
	/// A tap gesture reference for focus events.
	private var tapToFocusGesture: UITapGestureRecognizer?
	
    /// A tap gesture reference for exposure events.
    private var tapToExposeGesture: UITapGestureRecognizer?
	
    /// A tap gesture reference for reset events.
    private var tapToResetGesture: UITapGestureRecognizer?
	
    /// A reference to the capture mode.
    open lazy var captureMode: CaptureMode = .video
	
	/// A boolean indicating whether to enable tap to focus.
	@IBInspectable open var enableTapToFocus = false {
		didSet {
			if enableTapToFocus {
				enableTapToReset = true
				prepareFocusLayer()
				prepareTapGesture(gesture: &tapToFocusGesture, numberOfTapsRequired: 1, numberOfTouchesRequired: 1, selector: #selector(handleTapToFocusGesture))
				if let v: UITapGestureRecognizer = tapToExposeGesture {
					tapToFocusGesture!.require(toFail: v)
				}
			} else {
				removeTapGesture(gesture: &tapToFocusGesture)
				focusLayer?.removeFromSuperlayer()
				focusLayer = nil
			}
		}
	}
	
	/// A boolean indicating whether to enable tap to expose.
	@IBInspectable open var enableTapToExpose = false {
		didSet {
			if enableTapToExpose {
				enableTapToReset = true
				prepareExposureLayer()
				prepareTapGesture(gesture: &tapToExposeGesture, numberOfTapsRequired: 2, numberOfTouchesRequired: 1, selector: #selector(handleTapToExposeGesture))
				if let v: UITapGestureRecognizer = tapToFocusGesture {
					v.require(toFail: tapToExposeGesture!)
				}
			} else {
				removeTapGesture(gesture: &tapToExposeGesture)
				exposureLayer?.removeFromSuperlayer()
				exposureLayer = nil
			}
		}
	}
	
	/// A boolean indicating whether to enable tap to reset.
	@IBInspectable open var enableTapToReset = false {
		didSet {
			if enableTapToReset {
				prepareResetLayer()
				prepareTapGesture(gesture: &tapToResetGesture, numberOfTapsRequired: 2, numberOfTouchesRequired: 2, selector: #selector(handleTapToResetGesture))
				if let v: UITapGestureRecognizer = tapToFocusGesture {
					v.require(toFail: tapToResetGesture!)
				}
				if let v: UITapGestureRecognizer = tapToExposeGesture {
					v.require(toFail: tapToResetGesture!)
				}
			} else {
				removeTapGesture(gesture: &tapToResetGesture)
				resetLayer?.removeFromSuperlayer()
				resetLayer = nil
			}
		}
	}
	
	/// Insets preset value for content.
	open var contentEdgeInsetsPreset: EdgeInsetsPreset = .none {
		didSet {
			contentInset = EdgeInsetsPresetToValue(preset: contentEdgeInsetsPreset)
		}
	}
	
	/// Content insert value.
	open var contentInset = EdgeInsetsPresetToValue(preset: .square4) {
		didSet {
			reloadView()
		}
	}
	
	/// A reference to the CapturePreview view.
	open internal(set) var previewView: CapturePreview!
	
	/// A reference to the CaptureSession.
	open internal(set) var captureSession: CaptureSession!
	
	/// A reference to the focus layer used in focus animations.
	open internal(set) var focusLayer: Layer?
	
    /// A reference to the exposure layer used in exposure animations.
    open internal(set) var exposureLayer: Layer?
	
    /// A reference to the reset layer used in reset animations.
    open internal(set) var resetLayer: Layer?
	
	/// A reference to the cameraButton.
	open var cameraButton: UIButton? {
		didSet {
			if let v: UIButton = cameraButton {
				v.addTarget(self, action: #selector(handleCameraButton), for: .touchUpInside)
			}
			reloadView()
		}
	}
	
	/// A reference to the captureButton.
	open var captureButton: UIButton? {
		didSet {
			if let v: UIButton = captureButton {
				v.addTarget(self, action: #selector(handleCaptureButton), for: .touchUpInside)
			}
			reloadView()
		}
	}

	
	/// A reference to the videoButton.
	open var videoButton: UIButton? {
		didSet {
			if let v: UIButton = videoButton {
				v.addTarget(self, action: #selector(handleVideoButton), for: .touchUpInside)
			}
			reloadView()
		}
	}
	
	/// A reference to the switchCameraButton.
	open var switchCamerasButton: UIButton? {
		didSet {
			if let v: UIButton = switchCamerasButton {
				v.addTarget(self, action: #selector(handleSwitchCamerasButton), for: .touchUpInside)
			}
		}
	}
	
	/// A reference to the flashButton.
	open var flashButton: UIButton? {
		didSet {
			if let v: UIButton = flashButton {
				v.addTarget(self, action: #selector(handleFlashButton), for: .touchUpInside)
			}
		}
	}
	
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: .zero)
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		previewView.frame = bounds
		
		if let v: UIButton = cameraButton {
			v.frame.origin.y = bounds.height - contentInset.bottom - v.bounds.height
			v.frame.origin.x = contentInset.left
		}
		if let v: UIButton = captureButton {
			v.frame.origin.y = bounds.height - contentInset.bottom - v.bounds.height
			v.frame.origin.x = (bounds.width - v.bounds.width) / 2
		}
		if let v: UIButton = videoButton {
			v.frame.origin.y = bounds.height - contentInset.bottom - v.bounds.height
			v.frame.origin.x = bounds.width - v.bounds.width - contentInset.right
		}
		if let v: AVCaptureConnection = (previewView.layer as! AVCaptureVideoPreviewLayer).connection {
			v.videoOrientation = captureSession.videoOrientation
		}
	}
	
    /**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
	open override func prepare() {
		super.prepare()
		backgroundColor = Color.black
        prepareCaptureSession()
		preparePreviewView()
	}
	
	/// Reloads the view.
	open func reloadView() {
		// clear constraints so new ones do not conflict
		removeConstraints(constraints)
		for v in subviews {
			v.removeFromSuperview()
		}
		
		insertSubview(previewView, at: 0)
		
		if let v: UIButton = captureButton {
			insertSubview(v, at: 1)
		}
		
		if let v: UIButton = cameraButton {
			insertSubview(v, at: 2)
		}
		
		if let v: UIButton = videoButton {
			insertSubview(v, at: 3)
		}
	}
	
	/// Starts the timer for recording.
	internal func startTimer() {
		timer?.invalidate()
		timer = Timer(timeInterval: 0.5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
		RunLoop.main.add(timer!, forMode: .commonModes)
		delegate?.captureDidStartRecordTimer?(capture: self)
	}
	
	/// Updates the timer when recording.
	internal func updateTimer() {
		let duration: CMTime = captureSession.recordedDuration
		let time: Double = CMTimeGetSeconds(duration)
		let hours: Int = Int(time / 3600)
		let minutes: Int = Int((time / 60).truncatingRemainder(dividingBy: 60))
		let seconds: Int = Int(time.truncatingRemainder(dividingBy: 60))
		delegate?.captureDidUpdateRecordTimer?(capture: self, hours: hours, minutes: minutes, seconds: seconds)
	}
	
	/// Stops the timer when recording.
	internal func stopTimer() {
		let duration: CMTime = captureSession.recordedDuration
		let time: Double = CMTimeGetSeconds(duration)
        let hours: Int = Int(time / 3600)
        let minutes: Int = Int((time / 60).truncatingRemainder(dividingBy: 60))
        let seconds: Int = Int(time.truncatingRemainder(dividingBy: 60))
        timer?.invalidate()
		timer = nil
		delegate?.captureDidStopRecordTimer?(capture: self, hours: hours, minutes: minutes, seconds: seconds)
	}
	
	/**
     Handler for the flashButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
	internal func handleFlashButton(button: UIButton) {
		delegate?.captureDidPressFlashButton?(capture: self, button: button)
	}
	
    /**
     Handler for the switchCameraButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleSwitchCamerasButton(button: UIButton) {
		captureSession.switchCameras()
		delegate?.captureDidPressSwitchCamerasButton?(capture: self, button: button)
	}
	
    /**
     Handler for the captureButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleCaptureButton(button: UIButton) {
		if .photo == captureMode {
			captureSession.captureStillImage()
		} else if .video == captureMode {
			if captureSession.isRecording {
				captureSession.stopRecording()
				stopTimer()
			} else {
				captureSession.startRecording()
				startTimer()
			}
		}
		delegate?.captureDidPressCaptureButton?(capture: self, button: button)
	}
	
    /**
     Handler for the cameraButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleCameraButton(button: UIButton) {
		captureMode = .photo
		delegate?.captureDidPressCameraButton?(capture: self, button: button)
	}
	
    /**
     Handler for the videoButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleVideoButton(button: UIButton) {
		captureMode = .video
		delegate?.captureDidPressVideoButton?(capture: self, button: button)
	}
	
    /**
     Handler for the tapToFocusGesture.
     - Parameter recognizer: A UITapGestureRecognizer that is associated with the event.
     */
    @objc
	internal func handleTapToFocusGesture(recognizer: UITapGestureRecognizer) {
		if enableTapToFocus && captureSession.isFocusPointOfInterestSupported {
			let point: CGPoint = recognizer.location(in: self)
			captureSession.focus(at: previewView.captureDevicePointOfInterestForPoint(point: point))
			animateTapLayer(layer: focusLayer!, point: point)
			delegate?.captureDidTapToFocusAtPoint?(capture: self, point: point)
		}
	}
	
    /**
     Handler for the tapToExposeGesture.
     - Parameter recognizer: A UITapGestureRecognizer that is associated with the event.
     */
    @objc
	internal func handleTapToExposeGesture(recognizer: UITapGestureRecognizer) {
		if enableTapToExpose && captureSession.isExposurePointOfInterestSupported {
			let point: CGPoint = recognizer.location(in: self)
			captureSession.expose(at: previewView.captureDevicePointOfInterestForPoint(point: point))
			animateTapLayer(layer: exposureLayer!, point: point)
			delegate?.captureDidTapToExposeAtPoint?(capture: self, point: point)
		}
	}
	
    /**
     Handler for the tapToResetGesture.
     - Parameter recognizer: A UITapGestureRecognizer that is associated with the event.
     */
    @objc
	internal func handleTapToResetGesture(recognizer: UITapGestureRecognizer) {
		if enableTapToReset {
			captureSession.reset()
            let point: CGPoint = previewView.pointForCaptureDevicePointOfInterest(point: CGPoint(x: 0.5, y: 0.5))
			animateTapLayer(layer: resetLayer!, point: point)
			delegate?.captureDidTapToResetAtPoint?(capture: self, point: point)
		}
	}
	
	/**
     Prepares a given tap gesture.
     - Parameter gesture: An optional UITapGestureRecognizer to prepare.
     - Parameter numberOfTapsRequired: An integer of the number of taps required
     to activate the gesture.
     - Parameter numberOfTouchesRequired: An integer of the number of touches, fingers, 
     required to activate the gesture.
     - Parameter selector: A Selector to handle the event.
     */
    private func prepareTapGesture(gesture: inout UITapGestureRecognizer?, numberOfTapsRequired: Int, numberOfTouchesRequired: Int, selector: Selector) {
		removeTapGesture(gesture: &gesture)
		gesture = UITapGestureRecognizer(target: self, action: selector)
		gesture!.delegate = self
		gesture!.numberOfTapsRequired = numberOfTapsRequired
		gesture!.numberOfTouchesRequired = numberOfTouchesRequired
		addGestureRecognizer(gesture!)
	}
	
	/**
     Removes a given tap gesture.
     - Parameter gesture: An optional UITapGestureRecognizer to remove.
     */
    private func removeTapGesture(gesture: inout UITapGestureRecognizer?) {
		if let v: UIGestureRecognizer = gesture {
			removeGestureRecognizer(v)
			gesture = nil
		}
	}
	
    /// Prepare the captureSession.
    private func prepareCaptureSession() {
        captureSession = CaptureSession()
    }
    
	/// Prepares the previewView.
    private func preparePreviewView() {
		previewView = CapturePreview()
        (previewView.layer as! AVCaptureVideoPreviewLayer).session = captureSession.session
		captureSession.startSession()
	}
	
	/// Prepares the focusLayer.
	private func prepareFocusLayer() {
		if nil == focusLayer {
            focusLayer = Layer(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
			focusLayer!.isHidden = true
			focusLayer!.borderWidth = 2
			focusLayer!.borderColor = Color.white.cgColor
			previewView.layer.addSublayer(focusLayer!)
		}
	}
	
	/// Prepares the exposureLayer.
	private func prepareExposureLayer() {
		if nil == exposureLayer {
            exposureLayer = Layer(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
			exposureLayer!.isHidden = true
			exposureLayer!.borderWidth = 2
			exposureLayer!.borderColor = Color.yellow.darken1.cgColor
			previewView.layer.addSublayer(exposureLayer!)
		}
	}
	
	/// Prepares the resetLayer.
	private func prepareResetLayer() {
		if nil == resetLayer {
			resetLayer = Layer(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
			resetLayer!.isHidden = true
			resetLayer!.borderWidth = 2
			resetLayer!.borderColor = Color.red.accent1.cgColor
			previewView.layer.addSublayer(resetLayer!)
		}
	}
	
	/// Animates the tap and layer.
	private func animateTapLayer(layer: Layer, point: CGPoint) {
		Animation.animationDisabled { [weak layer] in
            guard let v = layer else {
                return
            }
			v.transform = CATransform3DIdentity
			v.position = point
			v.isHidden = false
		}
		Animation.animateWithDuration(duration: 0.25, animations: { [weak layer] in
            guard let v = layer else {
                return
            }
			v.transform = CATransform3DMakeScale(0.5, 0.5, 1)
		}) {
			_ = Animation.delay(time: 0.4) { [weak layer] in
                Animation.animationDisabled { [weak layer] in
                    guard let v = layer else {
                        return
                    }
					v.isHidden = true
				}
			}
		}
	}
}
