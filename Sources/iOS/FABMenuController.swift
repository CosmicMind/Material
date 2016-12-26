/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

public enum FABMenuBacking {
    case fade
    case blur
}

extension UIViewController {
    /**
     A convenience property that provides access to the FABMenuController.
     This is the recommended method of accessing the FABMenuController
     through child UIViewControllers.
     */
    public var fabMenuController: FABMenuController? {
        var viewController: UIViewController? = self
        while nil != viewController {
            if viewController is FABMenuController {
                return viewController as? FABMenuController
            }
            viewController = viewController?.parent
        }
        return nil
    }
}

open class FABMenuController: RootController {
    /// Reference to the MenuView.
    @IBInspectable
    open let fabMenu = FABMenu()
    
    /// A FABMenuBacking value type.
    open var fabMenuBacking = FABMenuBacking.blur
    
    /// The fabMenuBacking UIBlurEffectStyle.
    open var fabMenuBackingBlurEffectStyle = UIBlurEffectStyle.light
    
    /// A reference to the blurView.
    open fileprivate(set) var blurView: UIView?
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        rootViewController.view.frame = view.bounds
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
        prepareFABMenu()
    }
}

extension FABMenuController {
    /// Prepares the fabMenu.
    fileprivate func prepareFABMenu() {
        fabMenu.delegate = self
        fabMenu.zPosition = 1000
        view.addSubview(fabMenu)
    }
}

extension FABMenuController {
    /// Shows the fabMenuBacking.
    fileprivate func showFabMenuBacking() {
        showFade()
        showBlurView()
    }
    
    /// Hides the fabMenuBacking.
    fileprivate func hideFabMenuBacking() {
        hideFade()
        hideBlurView()
    }
    
    /// Shows the blurView.
    fileprivate func showBlurView() {
        guard .blur == fabMenuBacking else {
            return
        }
        
        guard !fabMenu.isOpened, fabMenu.isEnabled else {
            return
        }
        
        guard nil == blurView else {
            return
        }
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: fabMenuBackingBlurEffectStyle))
        blurView = UIView()
        blurView?.layout(blur).edges()
        view.layout(blurView!).edges()
        view.bringSubview(toFront: fabMenu)
    }
    
    /// Hides the blurView.
    fileprivate func hideBlurView() {
        guard fabMenu.isOpened, fabMenu.isEnabled else {
            return
        }
        
        blurView?.removeFromSuperview()
        blurView = nil
    }
    
    /// Shows the fade.
    fileprivate func showFade() {
        guard .fade == fabMenuBacking else {
            return
        }
        
        guard !fabMenu.isOpened, fabMenu.isEnabled else {
            return
        }
        
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            self?.rootViewController.view.alpha = 0.15
        })
    }
    
    /// Hides the fade.
    fileprivate func hideFade() {
        guard fabMenu.isOpened, fabMenu.isEnabled else {
            return
        }
        
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            self?.rootViewController.view.alpha = 1
        })
    }
}

extension FABMenuController: FABMenuDelegate {
    @objc
    open func fabMenuWillOpen(fabMenu: FABMenu) {
        isUserInteractionEnabled = false
        showFabMenuBacking()
    }
    
    @objc
    open func fabMenuDidOpen(fabMenu: FABMenu) {
        isUserInteractionEnabled = true
    }
    
    @objc
    open func fabMenuWillClose(fabMenu: FABMenu) {
        isUserInteractionEnabled = false
        hideFabMenuBacking()
    }
    
    @objc
    open func fabMenuDidClose(fabMenu: FABMenu) {
        isUserInteractionEnabled = true
    }
    
    @objc
    open func fabMenu(fabMenu: FABMenu, tappedAt point: CGPoint, isOutside: Bool) {
        guard isOutside else {
            return
        }
    }
}
