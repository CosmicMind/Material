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

extension UIViewController {
	/**
	A convenience property that provides access to the MenuController.
	This is the recommended method of accessing the MenuController
	through child UIViewControllers.
	*/
	public var menuController: MenuController? {
		var viewController: UIViewController? = self
		while nil != viewController {
			if viewController is MenuController {
				return viewController as? MenuController
			}
			viewController = viewController?.parent
		}
		return nil
	}
}

open class MenuController: RootController {
	/// Reference to the MenuView.
    open private(set) lazy var menu: Menu = Menu()
	
	/**
     Opens the menu with a callback.
     - Parameter completion: An Optional callback that is executed when
     all menu items have been opened.
     */
	open func openMenu(completion: ((UIView) -> Void)? = nil) {
		if true == isUserInteractionEnabled {
			isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                guard let s = self else {
                    return
                }
                s.rootViewController.view.alpha = 0.15
            })
            menu.open { [completion = completion] (view) in
                completion?(view)
            }
		}
	}
	
    /**
     Opens the menu with a callback.
     - Parameter completion: An Optional callback that is executed when
     all menu items have been closed.
     */
    open func closeMenu(completion: ((UIView) -> Void)? = nil) {
		if false == isUserInteractionEnabled {
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                guard let s = self else {
                    return
                }
                s.rootViewController.view.alpha = 1
            })
            menu.close { [weak self] (view) in
                guard let s = self else {
                    return
                }
                
                completion?(view)
                
                if view == s.menu.views.last {
                    s.isUserInteractionEnabled = true
                }
            }
		}
	}
	
	
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
		prepareMenuView()
	}
	
	/// Prepares the MenuView.
	private func prepareMenuView() {
		menu.zPosition = 1000
		view.addSubview(menu)
	}
}
