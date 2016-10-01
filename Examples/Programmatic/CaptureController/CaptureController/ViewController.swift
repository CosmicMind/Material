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
import Material

public class ViewController: UIViewController {
    internal lazy var capture: Capture = Capture()
    internal var toolbar: Toolbar!
    internal var cameraButton: IconButton!
    internal var videoButton: IconButton!
    internal var switchCamerasButton: IconButton!
    internal var flashButton: IconButton!
    internal var captureButton: FabButton!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.black
        
        prepareCaptureButton()
        prepareCameraButton()
        prepareVideoButton()
        prepareSwitchCamerasButton()
        prepareFlashButton()
        prepareCapture()
        prepareToolbar()
    }
    
    private func prepareCapture() {
        capture.enableTapToFocus = true
        capture.enableTapToExpose = true
        capture.delegate = self
        capture.captureSession.delegate = self
        view.layout(capture).edges()
    }
    
    private func prepareToolbar() {
        toolbar = Toolbar()
        toolbar.backgroundColor = Color.clear
        toolbar.depthPreset = .none
        
        toolbar.titleLabel.isHidden = true
        toolbar.titleLabel.textColor = Color.white
        
        toolbar.detailLabel.isHidden = true
        toolbar.detail = "Recording"
        toolbar.detailLabel.textColor = Color.red.accent1
        
        toolbar.leftViews = [switchCamerasButton]
        toolbar.rightViews = [flashButton]
        
        view.layout(toolbar).horizontally().top(20)
    }
    
    private func prepareCaptureButton() {
        captureButton = FabButton()
        captureButton.width = 72
        captureButton.height = 72
        captureButton.pulseColor = Color.white
        captureButton.backgroundColor = Color.red.darken1.withAlphaComponent(0.3)
        captureButton.borderColor = Color.white
        captureButton.borderWidthPreset =  .border3
        captureButton.depthPreset = .none
        
        capture.captureButton = captureButton
    }
    
    private func prepareCameraButton() {
        cameraButton = IconButton(image: Icon.cm.photoCamera, tintColor: Color.white)
        cameraButton.width = 72
        cameraButton.height = 72
        cameraButton.pulseAnimation = .centerRadialBeyondBounds
        cameraButton.shapePreset = .circle
        
        capture.cameraButton = cameraButton
    }
    
    private func prepareVideoButton() {
        videoButton = IconButton(image: Icon.cm.videocam, tintColor: Color.white)
        videoButton.width = 72
        videoButton.height = 72
        videoButton.pulseAnimation = .centerRadialBeyondBounds
        videoButton.shapePreset = .circle
        
        capture.videoButton = videoButton
    }
    
    private func prepareSwitchCamerasButton() {
        switchCamerasButton = IconButton(image: UIImage(named: "ic_camera_front_white"))
        
        capture.switchCamerasButton = switchCamerasButton
    }
    
    private func prepareFlashButton() {
        flashButton = IconButton(image: UIImage(named: "ic_flash_auto_white"))
        
        capture.flashButton = flashButton
        capture.captureSession.flashMode = .auto
    }
}

/// CaptureSessionDelegate.
extension ViewController: CaptureSessionDelegate {
    public func captureSessionFailedWithError(captureSession: CaptureSession, error: Error) {
        print(error)
    }
    
    public func captureSessionStillImageAsynchronously(captureSession: CaptureSession, image: UIImage) {
        print("captureStillImageAsynchronously")
    }
    
    public func captureSessionCreateMovieFileFailedWithError(captureSession: CaptureSession, error: Error) {
        print("Capture Failed \(error)")
    }
    
    public func captureSessionDidStartRecordingToOutputFileAtURL(captureSession: CaptureSession, captureOutput: AVCaptureFileOutput, fileURL: NSURL, fromConnections connections: [Any]) {
        print("Capture Started Recording \(fileURL)")
        cameraButton.isHidden = true
        videoButton.isHidden = true
        switchCamerasButton.isHidden = true
        flashButton.isHidden = true
    }
    
    public func captureSessionDidFinishRecordingToOutputFileAtURL(captureSession: CaptureSession, captureOutput: AVCaptureFileOutput, outputFileURL: NSURL, fromConnections connections: [Any], error: Error!) {
        print("Capture Stopped Recording \(outputFileURL)")
        cameraButton.isHidden = false
        videoButton.isHidden = false
        switchCamerasButton.isHidden = false
        flashButton.isHidden = false
    }
    
    public func captureDidStartRecordTimer(capture: Capture) {
        toolbar.titleLabel.text = "00:00:00"
        toolbar.titleLabel.isHidden = false
        toolbar.detailLabel.isHidden = false
    }
    
    public func captureDidUpdateRecordTimer(capture: Capture, hours: Int, minutes: Int, seconds: Int) {
        toolbar.title = String(format: "%02i:%02i:%02i", arguments: [hours, minutes, seconds])
    }
    
    public func captureDidStopRecordTimer(capture: Capture, hours: Int, minutes: Int, seconds: Int) {
        toolbar.titleLabel.isHidden = true
        toolbar.detailLabel.isHidden = true
    }
    
    public func captureSessionWillSwitchCameras(captureSession: CaptureSession, position: AVCaptureDevicePosition) {
        // ... do something
    }
    
    public func captureSessionDidSwitchCameras(captureSession: CaptureSession, position: AVCaptureDevicePosition) {
        if .back == position {
            capture.captureSession.flashMode = .auto
            flashButton.image = UIImage(named: "ic_flash_auto_white")
            switchCamerasButton.image = UIImage(named: "ic_camera_front_white")
        } else {
            capture.captureSession.flashMode = .off
            flashButton.image = UIImage(named: "ic_flash_off_white")
            switchCamerasButton.image = UIImage(named: "ic_camera_rear_white")
        }
    }
}

/// CaptureDelegate.
extension ViewController: CaptureDelegate {
    public func captureDidPressFlashButton(capture: Capture, button: UIButton) {
        guard .back == capture.captureSession.position else {
            return
        }
        
        guard let b = button as? Button else {
            return
        }
        
        switch capture.captureSession.flashMode {
        case .off:
            b.image = UIImage(named: "ic_flash_on_white")
            capture.captureSession.flashMode = .on
        case .on:
            b.image = UIImage(named: "ic_flash_auto_white")
            capture.captureSession.flashMode = .auto
        case .auto:
            b.image = UIImage(named: "ic_flash_off_white")
            capture.captureSession.flashMode = .off
        }
    }
    
    public func captureDidPressCameraButton(capture: Capture, button: UIButton) {
        captureButton.backgroundColor = Color.blue.darken1.withAlphaComponent(0.3)
    }
    
    public func captureDidPressVideoButton(capture: Capture, button: UIButton) {
        captureButton.backgroundColor = Color.red.darken1.withAlphaComponent(0.3)
    }
    
    public func captureDidPressCaptureButton(capture: Capture, button: UIButton) {
        if .photo == capture.captureMode {
            // ... do something
        } else if .video == capture.captureMode {
            // ... do something
        }
    }
    
    public func captureDidPressSwitchCamerasButton(capture: Capture, button: UIButton) {
        // ... do something
    }
}
