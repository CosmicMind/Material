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
*	*	Neither the name of GraphKit nor the names of its
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

/*
The following is an example of using a MenuViewController to control the
flow of your application.
*/

import UIKit
import Material

class AppMenuViewController: MenuViewController {
	/// MenuView diameter.
	private let baseViewSize: CGSize = CGSizeMake(56, 56)
	
	/// MenuView inset.
	private let menuViewInset: CGFloat = 16
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareMenuView()
	}
	
	/**
	*/
	func handleBtn2() {
		if menuViewController?.mainViewController is BlueViewController {
			return
		}
		
		closeMenu { [weak self] in
			self?.menuViewController?.transitionFromMainViewController(BlueViewController(), options: [.TransitionCrossDissolve])
		}
	}
	
	/**
	*/
	func handleBtn3() {
		if menuViewController?.mainViewController is GreenViewController {
			return
		}
		
		closeMenu { [weak self] in
			self?.menuViewController?.transitionFromMainViewController(GreenViewController(), options: [.TransitionCrossDissolve])
		}
	}
	
	/**
	
	*/
	func handleBtn4() {
		if (menuViewController?.mainViewController as? NavigationBarViewController)?.mainViewController is FeedViewController {
			return
		}
		
		closeMenu { [weak self] in
			self?.menuViewController?.transitionFromMainViewController(AppNavigationBarViewController(mainViewController: FeedViewController()), options: [.TransitionCrossDissolve])
		}
	}
	
	/// Opens the menu with a callback.
	func openMenu(completion: (() -> Void)? = nil) {
		(menuView.menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(0.125))
		menuView.menu.open { [weak self] (v: UIView) in
			(v as? MaterialButton)?.pulse()
			if self?.menuView.menu.views?.last == v {
				completion?()
			}
		}
	}
	
	/// Closes the menu with a callback.
	func closeMenu(completion: (() -> Void)? = nil) {
		(menuView.menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(-0.125))
		menuView.close(completion)
	}
	
	/// Handle the menuView touch event.
	func handleMenu() {
		if true == menuView.menu.opened {
			hideMenuBackdrop()
			closeMenu()
		} else {
			showMenuBackdrop()
			openMenu()
		}
	}
	
	/// Prepares view.
	private func prepareView() {
		view.backgroundColor = MaterialColor.black
	}
	
	/// Prepares the add button.
	private func prepareMenuView() {
		var image: UIImage? = UIImage(named: "ic_add_white")
		let btn1: FabButton = FabButton()
		btn1.setImage(image, forState: .Normal)
		btn1.setImage(image, forState: .Highlighted)
		btn1.addTarget(self, action: "handleMenu", forControlEvents: .TouchUpInside)
		menuView.addSubview(btn1)
		
		image = UIImage(named: "ic_create_white")
		let btn2: FabButton = FabButton()
		btn2.backgroundColor = MaterialColor.blue.base
		btn2.setImage(image, forState: .Normal)
		btn2.setImage(image, forState: .Highlighted)
		menuView.addSubview(btn2)
		btn2.addTarget(self, action: "handleBtn2", forControlEvents: .TouchUpInside)
		
		image = UIImage(named: "ic_photo_camera_white")
		let btn3: FabButton = FabButton()
		btn3.backgroundColor = MaterialColor.green.base
		btn3.setImage(image, forState: .Normal)
		btn3.setImage(image, forState: .Highlighted)
		menuView.addSubview(btn3)
		btn3.addTarget(self, action: "handleBtn3", forControlEvents: .TouchUpInside)
		
		image = UIImage(named: "ic_note_add_white")
		let btn4: FabButton = FabButton()
		btn4.backgroundColor = MaterialColor.yellow.base
		btn4.setImage(image, forState: .Normal)
		btn4.setImage(image, forState: .Highlighted)
		menuView.addSubview(btn4)
		btn4.addTarget(self, action: "handleBtn4", forControlEvents: .TouchUpInside)
		
		// Initialize the menu and setup the configuration options.
		menuView.menu.baseViewSize = baseViewSize
		menuView.menu.views = [btn1, btn2, btn3, btn4]
		
		view.addSubview(menuView)
		menuView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.size(view, child: menuView, width: baseViewSize.width, height: baseViewSize.height)
		MaterialLayout.alignFromBottomRight(view, child: menuView, bottom: menuViewInset, right: menuViewInset)
	}
	
	/// Displays the menuBackdrop.
	private func showMenuBackdrop() {
		// Disable the side nav, so users can't swipe while viewing the menu.
		sideNavigationViewController?.enabled = false
		navigationBarViewController?.navigationBarView.userInteractionEnabled = false
		navigationBarViewController?.navigationBarView.alpha = 0.5
		menuViewController?.mainViewController.view.userInteractionEnabled = false
		menuViewController?.mainViewController.view.alpha = 0.5
	}
	
	/// Hides the menuBackdrop.
	private func hideMenuBackdrop() {
		// Enable the side nav.
		sideNavigationViewController?.enabled = true
		navigationBarViewController?.navigationBarView.userInteractionEnabled = true
		navigationBarViewController?.navigationBarView.alpha = 1
		menuViewController?.mainViewController.view.userInteractionEnabled = true
		menuViewController?.mainViewController.view.alpha = 1
	}
}

