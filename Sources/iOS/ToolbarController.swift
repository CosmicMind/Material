/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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
     A convenience property that provides access to the ToolbarController.
     This is the recommended method of accessing the ToolbarController
     through child UIViewControllers.
     */
	public var toolbarController: ToolbarController? {
		var viewController: UIViewController? = self
		while nil != viewController {
			if viewController is ToolbarController {
				return viewController as? ToolbarController
			}
			viewController = viewController?.parent
		}
		return nil
	}
}

@objc(ToolbarControllerDelegate)
public protocol ToolbarControllerDelegate {
	/// Delegation method that executes when the floatingViewController will open.
	@objc
    optional func toolbarControllerWillOpenFloatingViewController(toolbarController: ToolbarController)
	
	/// Delegation method that executes when the floatingViewController will close.
	@objc
    optional func toolbarControllerWillCloseFloatingViewController(toolbarController: ToolbarController)
	
	/// Delegation method that executes when the floatingViewController did open.
	@objc
    optional func toolbarControllerDidOpenFloatingViewController(toolbarController: ToolbarController)
	
	/// Delegation method that executes when the floatingViewController did close.
	@objc
    optional func toolbarControllerDidCloseFloatingViewController(toolbarController: ToolbarController)
}

@objc(ToolbarController)
open class ToolbarController: StatusBarController {
    /// Reference to the Toolbar.
    @IBInspectable
    open let toolbar = Toolbar()
    
    /// Internal reference to the floatingViewController.
	private var internalFloatingViewController: UIViewController?
	
	/// Delegation handler.
	open weak var delegate: ToolbarControllerDelegate?
	
	/// A floating UIViewController.
	open var floatingViewController: UIViewController? {
		get {
			return internalFloatingViewController
		}
		set(value) {
			if let v = internalFloatingViewController {
				v.view.layer.rasterizationScale = Screen.scale
				v.view.layer.shouldRasterize = true
				delegate?.toolbarControllerWillCloseFloatingViewController?(toolbarController: self)
				internalFloatingViewController = nil
				UIView.animate(withDuration: 0.5,
					animations: { [weak self] in
                        guard let s = self else {
                            return
                        }
                        
                        v.view.center.y = 2 * s.view.bounds.height
                        s.toolbar.alpha = 1
                        s.rootViewController.view.alpha = 1
					}) { [weak self] _ in
                        guard let s = self else {
                            return
                        }
                        
                        v.willMove(toParentViewController: nil)
                        v.view.removeFromSuperview()
                        v.removeFromParentViewController()
                        v.view.layer.shouldRasterize = false
                        s.isUserInteractionEnabled = true
                        s.toolbar.isUserInteractionEnabled = true
                        DispatchQueue.main.async { [weak self] in
                            guard let s = self else {
                                return
                            }
                            
                            s.delegate?.toolbarControllerDidCloseFloatingViewController?(toolbarController: s)
                        }
					}
			}
			
			if let v = value {
				// Add the noteViewController! to the view.
				addChildViewController(v)
				v.view.frame = view.bounds
				v.view.center.y = 2 * view.bounds.height
				v.view.isHidden = true
				view.insertSubview(v.view, aboveSubview: toolbar)
				v.view.layer.zPosition = 1500
				v.didMove(toParentViewController: self)
				v.view.isHidden = false
				v.view.layer.rasterizationScale = Screen.scale
				v.view.layer.shouldRasterize = true
				view.layer.rasterizationScale = Screen.scale
				view.layer.shouldRasterize = true
				internalFloatingViewController = v
				isUserInteractionEnabled = false
				toolbar.isUserInteractionEnabled = false
				delegate?.toolbarControllerWillOpenFloatingViewController?(toolbarController: self)
				UIView.animate(withDuration: 0.5,
					animations: { [weak self, v = v] in
						guard let s = self else {
                            return
                        }
                        
                        v.view.center.y = s.view.bounds.height / 2
                        s.toolbar.alpha = 0.5
                        s.rootViewController.view.alpha = 0.5
					}) { [weak self, v = v] _ in
                        guard let s = self else {
                            return
                        }
                        
                        v.view.layer.shouldRasterize = false
                        s.view.layer.shouldRasterize = false
                        DispatchQueue.main.async { [weak self] in
                            guard let s = self else {
                                return
                            }
                            
                            s.delegate?.toolbarControllerDidOpenFloatingViewController?(toolbarController: s)
                        }
					}
			}
		}
	}
	
	
	open override func layoutSubviews() {
		super.layoutSubviews()
        
        let y = Application.shouldStatusBarBeHidden || statusBar.isHidden ? 0 : statusBar.height
        
        toolbar.y = y
        toolbar.width = view.width
        
        switch displayStyle {
        case .partial:
            let h = y + toolbar.height
            rootViewController.view.y = h
            rootViewController.view.height = view.height - h
        case .full:
            rootViewController.view.frame = view.bounds
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
        displayStyle = .partial
        prepareStatusBar()
        prepareToolbar()
	}
}

extension ToolbarController {
    /// Prepares the statusBar.
    fileprivate func prepareStatusBar() {
        shouldHideStatusBarOnRotation = false
    }

    /// Prepares the toolbar.
    fileprivate func prepareToolbar() {
        toolbar.depthPreset = .depth1
        view.addSubview(toolbar)
    }
}
