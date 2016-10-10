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
import Material

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

open class CaptureController: ToolbarController, CaptureDelegate, CaptureSessionDelegate {
    open private(set) lazy var capture: Capture = Capture()
    open private(set) var cameraButton: IconButton!
    open private(set) var videoButton: IconButton!
    open private(set) var switchCamerasButton: IconButton!
    open private(set) var flashButton: IconButton!
    open private(set) var captureButton: FabButton!
    
    open override func prepare() {
        super.prepare()
        view.backgroundColor = Color.black
        display = .full
        
        prepareToolbar()
        prepareCaptureButton()
        prepareCameraButton()
        prepareVideoButton()
        prepareSwitchCamerasButton()
        prepareFlashButton()
        prepareCapture()
    }
    
    /// Prepares the Toolbar.
    private func prepareToolbar() {
        toolbar.backgroundColor = Color.clear
        toolbar.depthPreset = .none
    }
    
    /// Prepares the captureButton.
    private func prepareCaptureButton() {
        captureButton = FabButton()
        capture.captureButton = captureButton
    }
    
    /// Prepares the cameraButton.
    private func prepareCameraButton() {
        cameraButton = IconButton(image: Icon.cm.photoCamera, tintColor: Color.white)
        capture.cameraButton = cameraButton
    }
    
    /// Preapres the videoButton.
    private func prepareVideoButton() {
        videoButton = IconButton(image: Icon.cm.videocam, tintColor: Color.white)
        capture.videoButton = videoButton
    }
    
    /// Prepares the switchCameraButton.
    private func prepareSwitchCamerasButton() {
        switchCamerasButton = IconButton(image: UIImage(named: "ic_camera_front_white"), tintColor: Color.white)
        capture.switchCamerasButton = switchCamerasButton
    }
    
    /// Prepares the flashButton.
    private func prepareFlashButton() {
        flashButton = IconButton(image: UIImage(named: "ic_flash_auto_white"), tintColor: Color.white)
        capture.flashButton = flashButton
        capture.captureSession.flashMode = .auto
    }
    
    /// Prepares capture.
    private func prepareCapture() {
        capture.enableTapToFocus = true
        capture.enableTapToExpose = true
        capture.delegate = self
        capture.captureSession.delegate = self
    }
}
