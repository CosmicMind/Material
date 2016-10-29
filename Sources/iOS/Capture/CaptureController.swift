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

extension UIViewController {
    /**
     A convenience property that provides access to the CaptureController.
     This is the recommended method of accessing the CaptureController
     through child UIViewControllers.
     */
    public var captureController: CaptureController? {
        var viewController: UIViewController? = self
        while nil != viewController {
            if viewController is CaptureController {
                return viewController as? CaptureController
            }
            viewController = viewController?.parent
        }
        return nil
    }
}

@objc(CaptureControllerDelegate)
public protocol CaptureControllerDelegate: ToolbarControllerDelegate {
    /**
     A delegation method that is fired when the record timer has started.
     - Parameter capture: A reference to the calling capture.
     */
    @objc
    optional func captureDidStartRecordTimer( capture: Capture)
    
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

open class CaptureController: ToolbarController, CaptureControllerDelegate, CaptureSessionDelegate, UIGestureRecognizerDelegate {
    /// A reference to the Capture instance.
    open private(set) lazy var capture: Capture = Capture()
    
    /// A Timer reference for when recording is enabled.
    internal var timer: Timer?
    
    /// A tap gesture reference for focus events.
    private var tapToFocusGesture: UITapGestureRecognizer?
    
    /// A tap gesture reference for exposure events.
    private var tapToExposeGesture: UITapGestureRecognizer?
    
    /// A tap gesture reference for reset events.
    private var tapToResetGesture: UITapGestureRecognizer?
    
    /// A reference to the cameraButton.
    open private(set) var cameraButton: IconButton!
    
    /// A reference to the captureButton.
    open private(set) var captureButton: FabButton!
    
    /// A reference to the videoButton.
    open private(set) var videoButton: IconButton!
    
    /// A reference to the switchCameraButton.
    open private(set) var switchCamerasButton: IconButton!
    
    /// A reference to the flashButton.
    open private(set) var flashButton: IconButton!
    
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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        /**
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
         */
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
        display = .full
        delegate = self
        view.backgroundColor = .black
        isTapToFocusEnabled = true
        isTapToExposeEnabled = true
        
        prepareStatusBar()
        prepareToolbar()
        prepareCapture()
        prepareCaptureButton()
        prepareCameraButton()
        prepareVideoButton()
        prepareSwitchCamerasButton()
        prepareFlashButton()
    }
    
    /// Prepares the statusBar.
    private func prepareStatusBar() {
        statusBar.backgroundColor = .clear
    }
    
    /// Prepares the toolbar.
    private func prepareToolbar() {
        toolbar.backgroundColor = .clear
        toolbar.depthPreset = .none
    }
    
    /// Prepares capture.
    private func prepareCapture() {
        capture.session.delegate = self
    }
    
    /// Prepares the captureButton.
    private func prepareCaptureButton() {
        captureButton = FabButton()
        captureButton.addTarget(self, action: #selector(handleCaptureButton), for: .touchUpInside)
    }
    
    /// Prepares the cameraButton.
    private func prepareCameraButton() {
        cameraButton = IconButton(image: Icon.cm.photoCamera, tintColor: .white)
        cameraButton.addTarget(self, action: #selector(handleCameraButton), for: .touchUpInside)
    }
    
    /// Preapres the videoButton.
    private func prepareVideoButton() {
        videoButton = IconButton(image: Icon.cm.videocam, tintColor: .white)
        videoButton.addTarget(self, action: #selector(handleVideoButton), for: .touchUpInside)
    }
    
    /// Prepares the switchCameraButton.
    private func prepareSwitchCamerasButton() {
        switchCamerasButton = IconButton(image: Icon.cameraFront, tintColor: .white)
        switchCamerasButton.addTarget(self, action: #selector(handleSwitchCamerasButton), for: .touchUpInside)
    }
    
    /// Prepares the flashButton.
    private func prepareFlashButton() {
        flashButton = IconButton(image: Icon.flashAuto, tintColor: .white)
        flashButton.addTarget(self, action: #selector(handleFlashButton), for: .touchUpInside)
        capture.session.flashMode = .auto
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
        view.addGestureRecognizer(gesture!)
    }
    
    /**
     Removes a given tap gesture.
     - Parameter gesture: An optional UITapGestureRecognizer to remove.
     */
    private func removeTapGesture(gesture: inout UITapGestureRecognizer?) {
        guard let v = gesture else {
            return
        }
        
        view.removeGestureRecognizer(v)
        gesture = nil
    }
}

extension CaptureController {
    /**
     Handler for the captureButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleCaptureButton(button: UIButton) {
        switch capture.mode {
        case .photo:
            capture.session.captureStillImage()
        case .video:
            if capture.session.isRecording {
                capture.session.stopRecording()
                stopTimer()
            } else {
                capture.session.startRecording()
                startTimer()
            }
        }
        
        (delegate as? CaptureControllerDelegate)?.captureDidPressCaptureButton?(capture: capture, button: button)
    }
    
    /**
     Handler for the cameraButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleCameraButton(button: UIButton) {
        capture.mode = .photo
        (delegate as? CaptureControllerDelegate)?.captureDidPressCameraButton?(capture: capture, button: button)
    }
    
    /**
     Handler for the flashButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleFlashButton(button: UIButton) {
        (delegate as? CaptureControllerDelegate)?.captureDidPressFlashButton?(capture: capture, button: button)
    }
    
    /**
     Handler for the switchCameraButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleSwitchCamerasButton(button: UIButton) {
        capture.session.switchCameras()
        (delegate as? CaptureControllerDelegate)?.captureDidPressSwitchCamerasButton?(capture: capture, button: button)
    }
    
    /**
     Handler for the videoButton.
     - Parameter button: A UIButton that is associated with the event.
     */
    @objc
    internal func handleVideoButton(button: UIButton) {
        capture.mode = .video
        (delegate as? CaptureControllerDelegate)?.captureDidPressVideoButton?(capture: capture, button: button)
    }
    
    /**
     Handler for the tapToFocusGesture.
     - Parameter recognizer: A UITapGestureRecognizer that is associated with the event.
     */
    @objc
    internal func handleTapToFocusGesture(recognizer: UITapGestureRecognizer) {
        guard isTapToFocusEnabled && capture.session.isFocusPointOfInterestSupported else {
            return
        }
        
        let point = recognizer.location(in: view)
        capture.session.focus(at: capture.preview.captureDevicePointOfInterestForPoint(point: point))
        (delegate as? CaptureControllerDelegate)?.captureDidTapToFocusAtPoint?(capture: capture, point: point)
    }
    
    /**
     Handler for the tapToExposeGesture.
     - Parameter recognizer: A UITapGestureRecognizer that is associated with the event.
     */
    @objc
    internal func handleTapToExposeGesture(recognizer: UITapGestureRecognizer) {
        guard isTapToExposeEnabled && capture.session.isExposurePointOfInterestSupported else {
            return
        }
        
        let point = recognizer.location(in: view)
        capture.session.expose(at: capture.preview.captureDevicePointOfInterestForPoint(point: point))
        (delegate as? CaptureControllerDelegate)?.captureDidTapToExposeAtPoint?(capture: capture, point: point)
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
        
        capture.session.reset()
        
        let point = capture.preview.pointForCaptureDevicePointOfInterest(point: CGPoint(x: 0.5, y: 0.5))
        (delegate as? CaptureControllerDelegate)?.captureDidTapToResetAtPoint?(capture: capture, point: point)
    }
}

extension CaptureController {
    /// Starts the timer for recording.
    internal func startTimer() {
        timer?.invalidate()
        timer = Timer(timeInterval: 0.5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .commonModes)
        
        (delegate as? CaptureControllerDelegate)?.captureDidStartRecordTimer?(capture: capture)
    }
    
    /// Updates the timer when recording.
    internal func updateTimer() {
        let duration = capture.session.recordedDuration
        let time = CMTimeGetSeconds(duration)
        let hours = Int(time / 3600)
        let minutes = Int((time / 60).truncatingRemainder(dividingBy: 60))
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        
        (delegate as? CaptureControllerDelegate)?.captureDidUpdateRecordTimer?(capture: capture, hours: hours, minutes: minutes, seconds: seconds)
    }
    
    /// Stops the timer when recording.
    internal func stopTimer() {
        let duration = capture.session.recordedDuration
        let time = CMTimeGetSeconds(duration)
        let hours = Int(time / 3600)
        let minutes = Int((time / 60).truncatingRemainder(dividingBy: 60))
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        
        timer?.invalidate()
        timer = nil
        
        (delegate as? CaptureControllerDelegate)?.captureDidStopRecordTimer?(capture: capture, hours: hours, minutes: minutes, seconds: seconds)
    }
}
