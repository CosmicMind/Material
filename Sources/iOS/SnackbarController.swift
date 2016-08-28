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
     A convenience property that provides access to the SnackbarController.
     This is the recommended method of accessing the SnackbarController
     through child UIViewControllers.
     */
    public var snackbarController: SnackbarController? {
        var viewController: UIViewController? = self
        while nil != viewController {
            if viewController is SnackbarController {
                return viewController as? SnackbarController
            }
            viewController = viewController?.parent
        }
        return nil
    }
}

open class SnackbarController: RootController {
    /**
     A boolean that indicates whether to move the view controller
     when the Snackbar animates.
    */
    open var isSnackbarAttachedToController = false
    
    /// Reference to the Snackbar.
    open internal(set) var snackbar: Snackbar!
    
    /**
     To execute in the order of the layout chain, override this
     method. LayoutSubviews should be called immediately, unless you
     have a certain need.
     */
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard let v = snackbar else {
            return
        }
        
        let w = view.width
        let h = view.height
        let p = v.intrinsicContentSize.height + v.grid.layoutEdgeInsets.top + v.grid.layoutEdgeInsets.bottom
        
        v.width = w
        v.height = p
        
        rootViewController.view.x = 0
        rootViewController.view.y = 0
        rootViewController.view.width = w
        
        switch v.status {
        case .visible:
            let y = h - p
            v.y = y
            v.isHidden = false
            rootViewController.view.height = y
        case .notVisible:
            v.y = h
            v.isHidden = true
            rootViewController.view.height = h
        case .animating:break
        }
        
        v.divider.reload()
    }
    
    /**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepareView method
     to initialize property values and other setup operations.
     The super.prepareView method should always be called immediately
     when subclassing.
     */
    open override func prepareView() {
        super.prepareView()
        prepareSnackbar()
    }
    
    /// Prepares the snackbar.
    private func prepareSnackbar() {
        if nil == snackbar {
            snackbar = Snackbar()
            snackbar.zPosition = 10000
            view.addSubview(snackbar)
        }
    }
}
