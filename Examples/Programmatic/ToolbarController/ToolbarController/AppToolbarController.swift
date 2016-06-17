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
The following is an example of using a ToolbarController to control the
flow of your application.
*/

import UIKit
import Material

class AppToolbarController: ToolbarController {
	/// Prepares the view.
	override func prepareView() {
		super.prepareView()
		statusBarStyle = .LightContent
		prepareToolbar()
	}
	
	/// Swaps rootViewControllers.
	func handleMenuButton() {
		transitionFromRootViewController(rootViewController.isKindOfClass(YellowViewController) ? GreenViewController() : YellowViewController())
	}
	
	/// Toggle NavigationDrawerController right UIViewController.
	func handleSearchButton() {
		floatingViewController = GreenViewController()
		
		MaterialAnimation.delay(1.5) { [weak self] in
			// Removes the ViewController from the view stack.
			self?.floatingViewController = nil
		}
	}
	
	/// Prepares the toolbar.
	private func prepareToolbar() {
		// Title label.
		toolbar.title = "Material"
		toolbar.titleLabel.textColor = MaterialColor.white
		
		toolbar.detail = "Build Beautiful Software"
		toolbar.detailLabel.textAlignment = .Left
		toolbar.detailLabel.textColor = MaterialColor.white
		
		var image: UIImage? = MaterialIcon.cm.menu
		
		// Menu button.
		let menuButton: IconButton = IconButton()
		menuButton.tintColor = MaterialColor.white
		menuButton.pulseColor = MaterialColor.white
		menuButton.setImage(image, forState: .Normal)
		menuButton.setImage(image, forState: .Highlighted)
		menuButton.addTarget(self, action: #selector(handleMenuButton), forControlEvents: .TouchUpInside)
		
		// Switch control.
		let switchControl: MaterialSwitch = MaterialSwitch(state: .Off, style: .LightContent, size: .Small)
		
		// Search button.
		image = MaterialIcon.cm.search
		let searchButton: IconButton = IconButton()
		searchButton.tintColor = MaterialColor.white
		searchButton.pulseColor = MaterialColor.white
		searchButton.setImage(image, forState: .Normal)
		searchButton.setImage(image, forState: .Highlighted)
		searchButton.addTarget(self, action: #selector(handleSearchButton), forControlEvents: .TouchUpInside)
		
		toolbar.backgroundColor = MaterialColor.blue.base
		toolbar.leftControls = [menuButton]
		toolbar.rightControls = [switchControl, searchButton]
	}
}
