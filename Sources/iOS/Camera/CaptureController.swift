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
    /// A reference to the Capture instance.
    open private(set) lazy var capture: Capture = Capture()
    
    /// A reference to capture's cameraButton.
    open var cameraButton: IconButton {
        return capture.cameraButton
    }
    
    /// A reference to capture's videoButton.
    open var videoButton: IconButton {
        return capture.videoButton
    }
    
    /// A reference to capture's switchCamerasButton.
    open var switchCamerasButton: IconButton {
        return capture.switchCamerasButton
    }
    
    /// A reference to capture's flashButton.
    open var flashButton: IconButton {
        return capture.flashButton
    }
    
    /// A reference to capture's captureButton.
    open var captureButton: FabButton {
        return capture.captureButton
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
        view.backgroundColor = .black
        display = .full
        
        prepareStatusBar()
        prepareToolbar()
        prepareCapture()
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
        capture.delegate = self
        capture.session.delegate = self
    }
}
