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
*	*	Neither the name of Material nor the names of its
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
	
	override func openMenu(completion: (() -> Void)? = nil) {
		super.openMenu(completion)
		sideNavigationViewController?.enabled = false
		mainViewController.view.alpha = 0.5
		(menuView.menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(0.125))
	}
	
	override func closeMenu(completion: (() -> Void)? = nil) {
		super.closeMenu(completion)
		sideNavigationViewController?.enabled = true
		mainViewController.view.alpha = 1
		(menuView.menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(-0.125))
	}
	
	/// Handler for blue button.
	func handleBlueButton() {
		closeMenu()
	}
	
	/// Handler for green button.
	func handleGreenButton() {
		closeMenu()
	}
	
	/// Handler for yellow button.
	func handleYellowButton() {
		closeMenu()
	}
	
	/// Handle the menuView touch event.
	func handleMenu() {
		if menuView.menu.opened {
			closeMenu()
		} else {
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
		let menuButton: FabButton = FabButton()
		menuButton.setImage(image, forState: .Normal)
		menuButton.setImage(image, forState: .Highlighted)
		menuButton.addTarget(self, action: "handleMenu", forControlEvents: .TouchUpInside)
		menuView.addSubview(menuButton)
		
		image = UIImage(named: "ic_create_white")
		let blueButton: FabButton = FabButton()
		blueButton.backgroundColor = MaterialColor.blue.base
		blueButton.setImage(image, forState: .Normal)
		blueButton.setImage(image, forState: .Highlighted)
		menuView.addSubview(blueButton)
		blueButton.addTarget(self, action: "handleBlueButton", forControlEvents: .TouchUpInside)
		
		image = UIImage(named: "ic_photo_camera_white")
		let greenButton: FabButton = FabButton()
		greenButton.backgroundColor = MaterialColor.green.base
		greenButton.setImage(image, forState: .Normal)
		greenButton.setImage(image, forState: .Highlighted)
		menuView.addSubview(greenButton)
		greenButton.addTarget(self, action: "handleGreenButton", forControlEvents: .TouchUpInside)
		
		image = UIImage(named: "ic_note_add_white")
		let yellowButton: FabButton = FabButton()
		yellowButton.backgroundColor = MaterialColor.yellow.base
		yellowButton.setImage(image, forState: .Normal)
		yellowButton.setImage(image, forState: .Highlighted)
		menuView.addSubview(yellowButton)
		yellowButton.addTarget(self, action: "handleYellowButton", forControlEvents: .TouchUpInside)
		
		// Initialize the menu and setup the configuration options.
		menuView.menu.baseViewSize = baseViewSize
		menuView.menu.views = [menuButton, blueButton, greenButton, yellowButton]
		
		view.addSubview(menuView)
		menuView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.size(view, child: menuView, width: baseViewSize.width, height: baseViewSize.height)
		MaterialLayout.alignFromBottomRight(view, child: menuView, bottom: menuViewInset, right: menuViewInset)
	}
}

