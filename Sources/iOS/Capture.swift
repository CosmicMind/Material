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
    open var captureMode = CaptureMode.video
	
	/// A boolean indicating whether to enable tap to focus.
	@IBInspectable
    open var isTapToFocusEnabled = false {
		didSet {
			guard isTapToFocusEnabled else {
                removeTapGesture(gesture: &tapToFocusGesture)
                focusView?.removeFromSuperview()
                focusView = nil
                return
            }
            
            isTapToResetEnabled = true
				
            prepareFocusLayer()
            prepareTapGesture(gesture: &tapToFocusGesture, numberOfTapsRequired: 1, numberOfTouchesRequired: 1, selector: #selector(handleTapToFocusGesture))
				
            if let v = tapToExposeGesture {
                tapToFocusGesture!.require(toFail: v)
            }
		}
	}
	
	/// A boolean indicating whether to enable tap to expose.
	@IBInspectable
    open var isTapToExposeEnabled = false {
		didSet {
			guard isTapToExposeEnabled else {
                removeTapGesture(gesture: &tapToExposeGesture)
                exposureView?.removeFromSuperview()
                exposureView = nil
                return
            }
            
            isTapToResetEnabled = true
            
            prepareExposureLayer()
            prepareTapGesture(gesture: &tapToExposeGesture, numberOfTapsRequired: 2, numberOfTouchesRequired: 1, selector: #selector(handleTapToExposeGesture))
            
            if let v = tapToFocusGesture {
                v.require(toFail: tapToExposeGesture!)
            }
		}
	}
	
	/// A boolean indicating whether to enable tap to reset.
	@IBInspectable
    open var isTapToResetEnabled = false {
		didSet {
			guard isTapToResetEnabled else {
                removeTapGesture(gesture: &tapToResetGesture)
                resetView?.removeFromSuperview()
                resetView = nil
                return
            }
            
            prepareResetLayer()
            prepareTapGesture(gesture: &tapToResetGesture, numberOfTapsRequired: 2, numberOfTouchesRequired: 2, selector: #selector(handleTapToResetGesture))
            
            if let v = tapToFocusGesture {
                v.require(toFail: tapToResetGesture!)
            }
            
            if let v = tapToExposeGesture {
                v.require(toFail: tapToResetGesture!)
            }
		}
	}
	
	/// Insets preset value for content.
	open var contentEdgeInsetsPreset = EdgeInsetsPreset.none {
		didSet {
			contentEdgeInsets = EdgeInsetsPresetToValue(preset: contentEdgeInsetsPreset)
		}
	}
	
	/// Content insert value.
    @IBInspectable
    open var contentEdgeInsets = EdgeInsets.zero {
		didSet {
			reloadView()
		}
	}
	
	/// A reference to the CapturePreview view.
	open internal(set) var preview: CapturePreview!
	
	/// A reference to the CaptureSession.
	open internal(set) var session: CaptureSession!
	
	/// A reference to the focusView used in focus animations.
	open internal(set) var focusView: UIView?
	
    /// A reference to the exposureView used in exposure animations.
    open internal(set) var exposureView: UIView?
	
    /// A reference to the resetView used in reset animations.
    open internal(set) var resetView: UIView?
	
	/// A reference to the cameraButton.
	open private(set) var cameraButton: IconButton! {
		didSet {
			if let v = cameraButton {
				v.addTarget(self, action: #selector(handleCameraButton), for: .touchUpInside)
			}
			reloadView()
		}
	}
	
	/// A reference to the captureButton.
	open private(set) var captureButton: FabButton! {
		didSet {
			if let v = captureButton {
				v.addTarget(self, action: #selector(handleCaptureButton), for: .touchUpInside)
			}
			reloadView()
		}
	}

	
	/// A reference to the videoButton.
	open private(set) var videoButton: IconButton! {
		didSet {
			if let v = videoButton {
				v.addTarget(self, action: #selector(handleVideoButton), for: .touchUpInside)
			}
			reloadView()
		}
	}
	
	/// A reference to the switchCameraButton.
	open private(set) var switchCamerasButton: IconButton! {
		didSet {
			if let v = switchCamerasButton {
				v.addTarget(self, action: #selector(handleSwitchCamerasButton), for: .touchUpInside)
			}
		}
	}
	
	/// A reference to the flashButton.
	open private(set) var flashButton: IconButton! {
		didSet {
			if let v = flashButton {
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
		preview.frame = bounds
		
		if let v = cameraButton {
			v.y = bounds.height - contentEdgeInsets.bottom - v.bounds.height
			v.x = contentEdgeInsets.left
		}
        
		if let v = captureButton {
			v.y = bounds.height - contentEdgeInsets.bottom - v.bounds.height
			v.x = (bounds.width - v.width) / 2
		}
		
        if let v = videoButton {
			v.y = bounds.height - contentEdgeInsets.bottom - v.bounds.height
			v.x = bounds.width - v.width - contentEdgeInsets.right
		}
		
        if let v = (preview.layer as! AVCaptureVideoPreviewLayer).connection {
			v.videoOrientation = session.videoOrientation
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
		backgroundColor = .black
        
        prepareCaptureSession()
        preparePreviewView()
        prepareCaptureButton()
        prepareCameraButton()
        prepareVideoButton()
        prepareSwitchCamerasButton()
        prepareFlashButton()
        
        isTapToFocusEnabled = true
        isTapToExposeEnabled = true
	}
	
	/// Reloads the view.
	open func reloadView() {
		// clear constraints so new ones do not conflict
		removeConstraints(constraints)
		for v in subviews {
			v.removeFromSuperview()
		}
		
		insertSubview(preview, at: 0)
		
		if let v = captureButton {
			insertSubview(v, at: 1)
		}
		
		if let v = cameraButton {
			insertSubview(v, at: 2)
		}
		
		if let v = videoButton {
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
		let duration = session.recordedDuration
		let time = CMTimeGetSeconds(duration)
		let hours = Int(time / 3600)
		let minutes = Int((time / 60).truncatingRemainder(dividingBy: 60))
		let seconds = Int(time.truncatingRemainder(dividingBy: 60))
		
        delegate?.captureDidUpdateRecordTimer?(capture: self, hours: hours, minutes: minutes, seconds: seconds)
	}
	
	/// Stops the timer when recording.
	internal func stopTimer() {
		let duration = session.recordedDuration
		let time = CMTimeGetSeconds(duration)
        let hours = Int(time / 3600)
        let minutes = Int((time / 60).truncatingRemainder(dividingBy: 60))
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        
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
		session.switchCameras()
		delegate?.captureDidPressSwitchCamerasButton?(capture: self, button: button)
	}
	
    /**
     Handler for the captureButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleCaptureButton(button: UIButton) {
        switch captureMode {
        case .photo:
            session.captureStillImage()
        case .video:
            if session.isRecording {
                session.stopRecording()
                stopTimer()
            } else {
                session.startRecording()
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
        guard isTapToFocusEnabled && session.isFocusPointOfInterestSupported else {
            return
        }
        
        let point: CGPoint = recognizer.location(in: self)
        session.focus(at: preview.captureDevicePointOfInterestForPoint(point: point))
        animateTap(view: focusView!, point: point)
        delegate?.captureDidTapToFocusAtPoint?(capture: self, point: point)
	}
	
    /**
     Handler for the tapToExposeGesture.
     - Parameter recognizer: A UITapGestureRecognizer that is associated with the event.
     */
    @objc
	internal func handleTapToExposeGesture(recognizer: UITapGestureRecognizer) {
        guard isTapToExposeEnabled && session.isExposurePointOfInterestSupported else {
            return
        }
        
        let point: CGPoint = recognizer.location(in: self)
        session.expose(at: preview.captureDevicePointOfInterestForPoint(point: point))
        animateTap(view: exposureView!, point: point)
        delegate?.captureDidTapToExposeAtPoint?(capture: self, point: point)
	}
	
    /**
     Handler for the tapToResetGesture.
     - Parameter recognizer: A UITapGestureRecognizer that is associated with the event.
     */
    @objc
	internal func handleTapToResetGesture(recognizer: UITapGestureRecognizer) {
        guard isTapToResetEnabled else {
            return
        }
        
        session.reset()
        
        let point: CGPoint = preview.pointForCaptureDevicePointOfInterest(point: CGPoint(x: 0.5, y: 0.5))
        animateTap(view: resetView!, point: point)
        delegate?.captureDidTapToResetAtPoint?(capture: self, point: point)
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
		guard let v = gesture else {
            return
        }
        
        removeGestureRecognizer(v)
        gesture = nil
	}
	
    /// Prepare the session.
    private func prepareCaptureSession() {
        session = CaptureSession()
    }
    
	/// Prepares the preview.
    private func preparePreviewView() {
		preview = CapturePreview()
        (preview.layer as! AVCaptureVideoPreviewLayer).session = session.session
		session.startSession()
	}
    
    /// Prepares the captureButton.
    private func prepareCaptureButton() {
        captureButton = FabButton()
    }
    
    /// Prepares the cameraButton.
    private func prepareCameraButton() {
        cameraButton = IconButton(image: Icon.cm.photoCamera, tintColor: .white)
    }
    
    /// Preapres the videoButton.
    private func prepareVideoButton() {
        videoButton = IconButton(image: Icon.cm.videocam, tintColor: .white)
    }
    
    /// Prepares the switchCameraButton.
    private func prepareSwitchCamerasButton() {
        switchCamerasButton = IconButton(image: UIImage(named: "ic_camera_front_white"), tintColor: .white)
    }
    
    /// Prepares the flashButton.
    private func prepareFlashButton() {
        flashButton = IconButton(image: UIImage(named: "ic_flash_auto_white"), tintColor: .white)
        session.flashMode = .auto
    }
	
	/// Prepares the focusLayer.
	private func prepareFocusLayer() {
		guard nil == focusView else {
            return
        }
        
        focusView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        focusView!.isHidden = true
        focusView!.borderWidth = 2
        focusView!.borderColor = .white
        preview.addSubview(focusView!)
	}
	
	/// Prepares the exposureLayer.
	private func prepareExposureLayer() {
		guard nil == exposureView else {
            return
        }
        
        exposureView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        exposureView!.isHidden = true
        exposureView!.borderWidth = 2
        exposureView!.borderColor = Color.yellow.darken1
        
        preview.addSubview(exposureView!)
	}
	
	/// Prepares the resetLayer.
	private func prepareResetLayer() {
		guard nil == resetView else {
            return
        }
        
        resetView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        resetView!.isHidden = true
        resetView!.borderWidth = 2
        resetView!.borderColor = Color.red.accent1
        
        preview.addSubview(resetView!)
	}
	
	/// Animates the tap and layer.
	private func animateTap(view: UIView, point: CGPoint) {
//		Animation.animationDisabled { [weak layer] in
//            guard let v = layer else {
//                return
//            }
//			v.transform = CATransform3DIdentity
//			v.position = point
//			v.isHidden = false
//		}
//		Animation.animateWithDuration(duration: 0.25, animations: { [weak layer] in
//            guard let v = layer else {
//                return
//            }
//			v.transform = CATransform3DMakeScale(0.5, 0.5, 1)
//		}) {
//			Animation.delay(time: 0.4) { [weak layer] in
//                Animation.animationDisabled { [weak layer] in
//                    guard let v = layer else {
//                        return
//                    }
//					v.isHidden = true
//				}
//			}
//		}
	}
}
