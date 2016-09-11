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

@objc(SnackbarControllerDelegate)
public protocol SnackbarControllerDelegate {
    /**
     A delegation method that is executed when a Snackbar will show.
     - Parameter snackbarController: A SnackbarController.
     */
    @objc
    optional func snackbarControllerWillShow(snackbarController: SnackbarController)
    
    /**
     A delegation method that is executed when a Snackbar did show.
     - Parameter snackbarController: A SnackbarController.
     */
    @objc
    optional func snackbarControllerDidShow(snackbarController: SnackbarController)
    
    /**
     A delegation method that is executed when a Snackbar will hide.
     - Parameter snackbarController: A SnackbarController.
     */
    @objc
    optional func snackbarControllerWillHide(snackbarController: SnackbarController)
    
    /**
     A delegation method that is executed when a Snackbar did hide.
     - Parameter snackbarController: A SnackbarController.
     */
    @objc
    optional func snackbarControllerDidHide(snackbarController: SnackbarController)
}

@objc(SnackbarAlignment)
public enum SnackbarAlignment: Int {
    case top
    case bottom
}

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
    /// Reference to the Snackbar.
    open private(set) lazy var snackbar: Snackbar = Snackbar()
    
    /// A boolean indicating if the Snacbar is animating.
    open internal(set) var isAnimating = false
    
    /// Delegation handler.
    open weak var delegate: SnackbarControllerDelegate?
    
    /// Snackbar alignment setting.
    open var snackbarAlignment = SnackbarAlignment.bottom
    
    /**
     Animates to a SnackbarStatus.
     - Parameter status: A SnackbarStatus enum value.
     */
    open func animate(snackbar status: SnackbarStatus, delay: TimeInterval = 0, animations: ((Snackbar) -> Void)? = nil, completion: ((Snackbar) -> Void)? = nil) -> AnimationDelayCancelBlock {
        return Animation.delay(time: delay) { [weak self, status = status, animations = animations, completion = completion] in
            guard let s = self else {
                return
            }
            
            if .visible == status {
                s.delegate?.snackbarControllerWillShow?(snackbarController: s)
            } else {
                s.delegate?.snackbarControllerWillHide?(snackbarController: s)
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
                
                if .visible == status {
                    s.delegate?.snackbarControllerDidShow?(snackbarController: s)
                } else {
                    s.delegate?.snackbarControllerDidHide?(snackbarController: s)
                }
                
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
        
        snackbar.width = view.width
        snackbar.height = snackbar.intrinsicContentSize.height + snackbar.grid.layoutEdgeInsets.top + snackbar.grid.layoutEdgeInsets.bottom
        layoutSnackbar(status: snackbar.status)
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
        if .bottom == snackbarAlignment {
            snackbar.y = .visible == status ? view.height - snackbar.height : view.height
        } else {
            snackbar.y = .visible == status ? 0 : -snackbar.height
        }
    }
}
