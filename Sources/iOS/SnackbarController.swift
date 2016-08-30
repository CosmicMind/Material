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

//@objc(SnackbarDelegate)
//public protocol SnackbarDelegate {
//    /**
//     A delegation method that is executed when a Snackbar will show.
//     - Parameter snackbar: A Snackbar.
//     */
//    @objc
//    optional func snackbarWillShow(snackbar: Snackbar)
//    
//    /**
//     A delegation method that is executed when a Snackbar did show.
//     - Parameter snackbar: A Snackbar.
//     */
//    @objc
//    optional func snackbarDidShow(snackbar: Snackbar)
//    
//    /**
//     A delegation method that is executed when a Snackbar will hide.
//     - Parameter snackbar: A Snackbar.
//     */
//    @objc
//    optional func snackbarWillHide(snackbar: Snackbar)
//    
//    /**
//     A delegation method that is executed when a Snackbar did hide.
//     - Parameter snackbar: A Snackbar.
//     */
//    @objc
//    optional func snackbarDidHide(snackbar: Snackbar)
//}

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
    /// A boolean indicating if the Snacbar is animating.
    open internal(set) var isAnimating = false
    
    /// Reference to the Snackbar.
    open internal(set) lazy var snackbar: Snackbar = Snackbar()
    
    /**
     Animates to a SnackbarStatus.
     - Parameter status: A SnackbarStatus enum value.
     */
    open func animate(snackbar status: SnackbarStatus, delay: TimeInterval = 0, animations: (@escaping (Snackbar) -> Void)? = nil, completion: (@escaping (Snackbar) -> Void)? = nil) -> AnimationDelayCancelBlock {
        return Animation.delay(time: delay) { [weak self, status = status, animations = animations, completion = completion] in
            guard let s = self else {
                return
            }
            
            s.isAnimating = true
            s.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.25, animations: { [weak self, status = status, animations = animations] in
                guard let s = self else {
                    return
                }
                
                s.layoutSnackbar(status: status)
                
                animations?(s.snackbar)
            }) { [weak self, status = status, completion = completion] _ in
                guard let s = self else {
                    return
                }
                
                s.isAnimating = false
                s.isUserInteractionEnabled = true
                s.snackbar.status = status
                
                completion?(s.snackbar)
            }
        }
    }
    
    /**
     To execute in the order of the layout chain, override this
     method. LayoutSubviews should be called immediately, unless you
     have a certain need.
     */
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard !isAnimating else {
            return
        }
        
        layoutSnackbar(status: snackbar.status)
        layoutRootViewController(status: snackbar.status)
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
        snackbar.zPosition = 10000
        view.addSubview(snackbar)
    }
    
    /**
     Lays out the Snackbar.
     - Parameter status: A SnackbarStatus enum value.
     */
    private func layoutSnackbar(status: SnackbarStatus) {
        let p = snackbar.intrinsicContentSize.height + snackbar.grid.layoutEdgeInsets.top + snackbar.grid.layoutEdgeInsets.bottom
        snackbar.width = view.width
        snackbar.height = p
        snackbar.y = .visible == status ? view.height - p : view.height
        snackbar.divider.reload()
    }
    
    /**
     Lays out the rootViewController.
     - Parameter status: A SnackbarStatus enum value.
     */
    private func layoutRootViewController(status: SnackbarStatus) {
        guard let vc = rootViewController else {
            return
        }
        
        vc.view.x = 0
        vc.view.y = 0
        vc.view.width = view.width
        vc.view.height = .visible == status ? view.height - snackbar.height : view.height
    }
}
