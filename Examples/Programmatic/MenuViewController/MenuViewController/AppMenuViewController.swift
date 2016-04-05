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
	
	/// Loads the BlueViewController into the menuViewControllers rootViewController.
	func handleBlueButton() {
		if rootViewController is BlueViewController {
			return
		}
		
		closeMenu { [weak self] in
			self?.transitionFromRootViewController(BlueViewController(), options: [.TransitionCrossDissolve])
		}
	}
	
	/// Loads the GreenViewController into the menuViewControllers rootViewController.
	func handleGreenButton() {
		if rootViewController is GreenViewController {
			return
		}
		
		closeMenu { [weak self] in
			self?.transitionFromRootViewController(GreenViewController(), options: [.TransitionCrossDissolve])
		}
	}
	
	/// Loads the YellowViewController into the menuViewControllers rootViewController.
	func handleYellowButton() {
//		if (rootViewController as? ToolbarController)?.rootViewController is YellowViewController {
//			return
//		}
		
		closeMenu { [weak self] in
			self?.transitionFromRootViewController(YellowViewController(), options: [.TransitionCrossDissolve])
		}
	}
	
	/// Handle the menuView touch event.
	func handleMenu() {
		if menuView.menu.opened {
			menuViewController?.rootViewController.view.alpha = 1
			closeMenu()
		} else {
			menuViewController?.rootViewController.view.alpha = 0.5
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
		btn1.addTarget(self, action: #selector(handleMenu), forControlEvents: .TouchUpInside)
		menuView.addSubview(btn1)
		
		image = UIImage(named: "ic_create_white")
		let btn2: FabButton = FabButton()
		btn2.backgroundColor = MaterialColor.blue.base
		btn2.setImage(image, forState: .Normal)
		btn2.setImage(image, forState: .Highlighted)
		menuView.addSubview(btn2)
		btn2.addTarget(self, action: #selector(handleBlueButton), forControlEvents: .TouchUpInside)
		
		image = UIImage(named: "ic_photo_camera_white")
		let btn3: FabButton = FabButton()
		btn3.backgroundColor = MaterialColor.green.base
		btn3.setImage(image, forState: .Normal)
		btn3.setImage(image, forState: .Highlighted)
		menuView.addSubview(btn3)
		btn3.addTarget(self, action: #selector(handleGreenButton), forControlEvents: .TouchUpInside)
		
		image = UIImage(named: "ic_note_add_white")
		let btn4: FabButton = FabButton()
		btn4.backgroundColor = MaterialColor.yellow.base
		btn4.setImage(image, forState: .Normal)
		btn4.setImage(image, forState: .Highlighted)
		menuView.addSubview(btn4)
		btn4.addTarget(self, action: #selector(handleYellowButton), forControlEvents: .TouchUpInside)
		
		// Initialize the menu and setup the configuration options.
		menuView.menu.baseViewSize = baseViewSize
		menuView.menu.views = [btn1, btn2, btn3, btn4]
		
		view.addSubview(menuView)
		menuView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.size(view, child: menuView, width: baseViewSize.width, height: baseViewSize.height)
		MaterialLayout.alignFromBottomRight(view, child: menuView, bottom: menuViewInset, right: menuViewInset)
	}
}

