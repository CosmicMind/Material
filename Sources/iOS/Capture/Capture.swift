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
    /// A reference to the capture mode.
    open var mode = CaptureMode.video
	
    /// Delegation handler.
    open weak var delegate: CaptureDelegate?
    
	/// A reference to the CapturePreview view.
	open internal(set) var preview: CapturePreview!
	
	/// A reference to the CaptureSession.
	open internal(set) var session: CaptureSession!
	
    /// A Timer reference for when recording is enabled.
    internal var timer: Timer?
    
    /// A tap gesture reference for focus events.
    private var tapToFocusGesture: UITapGestureRecognizer?
    
    /// A tap gesture reference for exposure events.
    private var tapToExposeGesture: UITapGestureRecognizer?
    
    /// A tap gesture reference for reset events.
    private var tapToResetGesture: UITapGestureRecognizer?
    
    /// A reference to the captureButton.
    @IBInspectable
    open var captureButton: UIButton? {
        didSet {
            prepareCaptureButton()
        }
    }
    
    /// A reference to the cameraButton.
    @IBInspectable
    open var cameraButton: UIButton? {
        didSet {
            prepareCameraButton()
        }
    }
    
    /// A reference to the videoButton.
    @IBInspectable
    open var videoButton: UIButton? {
        didSet {
            prepareVideoButton()
        }
    }
    
    /// A reference to the switchCameraButton.
    @IBInspectable
    open var switchCamerasButton: UIButton? {
        didSet {
            prepareSwitchCamerasButton()
        }
    }
    
    /// A reference to the flashButton.
    @IBInspectable
    open var flashButton: UIButton? {
        didSet {
            prepareFlashButton()
        }
    }
    
    /// A boolean indicating whether to enable tap to focus.
    @IBInspectable
    open var isTapToFocusEnabled = false {
        didSet {
            guard isTapToFocusEnabled else {
                removeTapGesture(gesture: &tapToFocusGesture)
                return
            }
            
            isTapToResetEnabled = true
            
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
                return
            }
            
            isTapToResetEnabled = true
            
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
                return
            }
            
            prepareTapGesture(gesture: &tapToResetGesture, numberOfTapsRequired: 2, numberOfTouchesRequired: 2, selector: #selector(handleTapToResetGesture))
            
            if let v = tapToFocusGesture {
                v.require(toFail: tapToResetGesture!)
            }
            
            if let v = tapToExposeGesture {
                v.require(toFail: tapToResetGesture!)
            }
        }
    }
    
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: .zero)
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		reload()
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
        preparePreview()
        
        isTapToFocusEnabled = true
        isTapToExposeEnabled = true
	}
	
	/// Reloads the view.
	open func reload() {
        preview.frame = bounds
	}
    
	/// Prepare the session.
    private func prepareCaptureSession() {
        session = CaptureSession()
    }
    
	/// Prepares the preview.
    private func preparePreview() {
		preview = CapturePreview()
        addSubview(preview)
        
        (preview.layer as! AVCaptureVideoPreviewLayer).session = session.session
		session.startSession()
	}
    
    /// Prepares the captureButton.
    private func prepareCaptureButton() {
        captureButton?.addTarget(self, action: #selector(handleCaptureButton), for: .touchUpInside)
    }
    
    /// Prepares the cameraButton.
    private func prepareCameraButton() {
        cameraButton?.addTarget(self, action: #selector(handleCameraButton), for: .touchUpInside)
    }
    
    /// Preapres the videoButton.
    private func prepareVideoButton() {
        videoButton?.addTarget(self, action: #selector(handleVideoButton), for: .touchUpInside)
    }
    
    /// Prepares the switchCameraButton.
    private func prepareSwitchCamerasButton() {
        switchCamerasButton?.addTarget(self, action: #selector(handleSwitchCamerasButton), for: .touchUpInside)
    }
    
    /// Prepares the flashButton.
    private func prepareFlashButton() {
        flashButton?.addTarget(self, action: #selector(handleFlashButton), for: .touchUpInside)
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
        guard nil == gesture else {
            return
        }
        
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
}

extension Capture {
    /**
     Handler for the captureButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleCaptureButton(button: UIButton) {
        switch mode {
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
        mode = .photo
        delegate?.captureDidPressCameraButton?(capture: self, button: button)
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
     Handler for the videoButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleVideoButton(button: UIButton) {
        mode = .video
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
        
        let point = recognizer.location(in: self)
        session.focus(at: preview.captureDevicePointOfInterestForPoint(point: point))
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
        
        let point = recognizer.location(in: self)
        session.expose(at: preview.captureDevicePointOfInterestForPoint(point: point))
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
        
        let point = preview.pointForCaptureDevicePointOfInterest(point: CGPoint(x: 0.5, y: 0.5))
        delegate?.captureDidTapToResetAtPoint?(capture: self, point: point)
    }
}

extension Capture {
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
}
