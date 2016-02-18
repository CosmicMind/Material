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
The following is an example of using a NavigationBarViewController to control the
flow of your application.
*/

import UIKit
import Material

class AppNavigationBarViewController: NavigationBarViewController {
	/// Menu backdrop layer.
	private lazy var menuBackdropLayer: MaterialLayer = MaterialLayer()
	
	/// MenuView diameter.
	private let menuViewDiameter: CGFloat = 56
	
	/// MenuView inset.
	private let menuViewInset: CGFloat = 16
	
	/// MenuView.
	private let menuView: MenuView = MenuView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareNavigationBarView()
		prepareMenuBackdropLayer()
		prepareMenuView()
	}
	
	/**
	Handles the menu button click, which opens the
	SideNavigationBarViewController.
	*/
	func handleMenuButton() {
		sideNavigationBarViewController?.openLeftView()
	}
	
	/**
	Handles the more button click, which opens the
	SideNavigationBarViewController.
	*/
	func handleMoreButton() {
		sideNavigationBarViewController?.openRightView()
	}
	
	/// Handle the menuView touch event.
	func handleMenu() {
		let image: UIImage?
		
		if menuView.menu.opened {
			hideMenuBackdropLayer()
			
			menuView.menu.close()
			image = UIImage(named: "ic_add_white")
		} else {
			showMenuBackdropLayer()
			
			menuView.menu.open() { (v: UIView) in
				(v as? MaterialButton)?.pulse()
			}
			image = UIImage(named: "ic_close_white")
		}
		
		// Add a nice rotation animation to the base button.
		let first: MaterialButton? = menuView.menu.views?.first as? MaterialButton
		first?.animate(MaterialAnimation.rotate(1))
		first?.setImage(image, forState: .Normal)
		first?.setImage(image, forState: .Highlighted)
	}
	
	/// Prepares view.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the navigationBarView.
	private func prepareNavigationBarView() {
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Inbox"
		titleLabel.textAlignment = .Left
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.regularWithSize(20)
		
		// Detail label. Uncomment the code below to use a detail label.
		//		let detailLabel: UILabel = UILabel()
		//		detailLabel.text = "Build Beautiful Software"
		//		detailLabel.textAlignment = .Left
		//		detailLabel.textColor = MaterialColor.white
		//		detailLabel.font = RobotoFont.regularWithSize(12)
		//		titleLabel.font = RobotoFont.regularWithSize(17) // 17 point looks better with the detailLabel.
		//		navigationBarView.detailLabel = detailLabel
		
		var image = UIImage(named: "ic_menu_white")
		
		// Menu button.
		let menuButton: FlatButton = FlatButton()
		menuButton.pulseColor = nil
		menuButton.pulseScale = false
		menuButton.setImage(image, forState: .Normal)
		menuButton.setImage(image, forState: .Highlighted)
		menuButton.addTarget(self, action: "handleMenuButton", forControlEvents: .TouchUpInside)
		
		// Switch control.
		let switchControl: MaterialSwitch = MaterialSwitch(state: .Off, style: .LightContent, size: .Small)
		
		// Search button.
		image = UIImage(named: "ic_more_horiz_white")
		let moreButton: FlatButton = FlatButton()
		moreButton.pulseColor = nil
		moreButton.pulseScale = false
		moreButton.setImage(image, forState: .Normal)
		moreButton.setImage(image, forState: .Highlighted)
		moreButton.addTarget(self, action: "handleMoreButton", forControlEvents: .TouchUpInside)
		
		/*
		To lighten the status bar - add the
		"View controller-based status bar appearance = NO"
		to your info.plist file and set the following property.
		*/
		navigationBarView.statusBarStyle = .LightContent
		
		navigationBarView.backgroundColor = MaterialColor.blue.base
		navigationBarView.titleLabel = titleLabel
		navigationBarView.leftControls = [menuButton]
		navigationBarView.rightControls = [switchControl, moreButton]
	}
	
	/// Prepares the menuBackdropLayer.
	private func prepareMenuBackdropLayer() {
		menuBackdropLayer.backgroundColor = MaterialColor.white.colorWithAlphaComponent(0.75).CGColor
		menuBackdropLayer.hidden = true
		menuBackdropLayer.zPosition = 2000
		view.layer.addSublayer(menuBackdropLayer)
	}
	
	/// Prepares the add button.
	private func prepareMenuView() {
		var image: UIImage? = UIImage(named: "ic_add_white")
		let btn1: FabButton = FabButton()
		btn1.pulseColor = nil
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
		
		image = UIImage(named: "ic_photo_camera_white")
		let btn3: FabButton = FabButton()
		btn3.backgroundColor = MaterialColor.green.base
		btn3.setImage(image, forState: .Normal)
		btn3.setImage(image, forState: .Highlighted)
		menuView.addSubview(btn3)
		
		image = UIImage(named: "ic_note_add_white")
		let btn4: FabButton = FabButton()
		btn4.backgroundColor = MaterialColor.amber.base
		btn4.setImage(image, forState: .Normal)
		btn4.setImage(image, forState: .Highlighted)
		menuView.addSubview(btn4)
		
		// Initialize the menu and setup the configuration options.
		menuView.menu.direction = .Up
		menuView.menu.baseViewSize = CGSizeMake(menuViewDiameter, menuViewDiameter)
		menuView.menu.views = [btn1, btn2, btn3, btn4]
		menuView.zPosition = 3000
		
		view.insertSubview(menuView, aboveSubview: navigationBarView)
		menuView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.size(view, child: menuView, width: menuViewDiameter, height: menuViewDiameter)
		MaterialLayout.alignFromBottomRight(view, child: menuView, bottom: menuViewInset, right: menuViewInset)
	}
	
	/// Displays the menuBackdropLayer.
	private func showMenuBackdropLayer() {
		// Disable the side nav, so users can't swipe while viewing the menu.
		sideNavigationBarViewController?.enabled = false
		
		// Position the menuBackdropLayer for the animation when opening.
		MaterialAnimation.animationDisabled { [unowned self] in
			self.menuBackdropLayer.frame = self.menuView.frame
			self.menuBackdropLayer.shape = .Circle
			self.menuBackdropLayer.hidden = false
		}
		
		menuBackdropLayer.animate(MaterialAnimation.scale(30, duration: 0.25))
	}
	
	/// Hides the menuBackdropLayer.
	private func hideMenuBackdropLayer() {
		// Enable the side nav.
		sideNavigationBarViewController?.enabled = true
		
		// Position the menuBackdropLayer for the animation when closing.
		menuBackdropLayer.animate(MaterialAnimation.animationGroup([
			MaterialAnimation.scale(1),
			MaterialAnimation.position(menuView.center)
			], duration: 0.25))
		
		MaterialAnimation.delay(0.25) { [weak self] in
			self?.menuBackdropLayer.hidden = true
		}
	}
}

