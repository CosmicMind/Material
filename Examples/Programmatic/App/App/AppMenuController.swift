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
The following is an example of using a MenuController to control the
flow of your application.
*/

import UIKit
import Material

class AppMenuController: MenuController {
	/// MenuView diameter.
	private let baseSize: CGSize = CGSizeMake(56, 56)
	
    /// MenuView bottom inset.
    private let menuViewBottomInset: CGFloat = 65
	
	/// MenuView right inset.
	private let menuViewRightInset: CGFloat = 16
	
	/// Reference if the menuView is hidden.
	private(set) var isMenuViewHidden: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareMenuView()
	}
	
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        closeMenu()
    }
    
	override func openMenu(completion: (() -> Void)? = nil) {
		super.openMenu(completion)
		navigationDrawerController?.enabled = false
		(menuView.menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(angle: 45))
	}
	
	override func closeMenu(completion: (() -> Void)? = nil) {
		super.closeMenu(completion)
		navigationDrawerController?.enabled = true
		(menuView.menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(angle: 0))
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
    
    /// Shows the menuView.
    func showMenuView() {
		if isMenuViewHidden {
			isMenuViewHidden = false
			menuView.animate(MaterialAnimation.animationGroup([
				MaterialAnimation.rotate(rotation: 3),
				MaterialAnimation.translateY(0)
			]))
		}
    }
    
    /// Hides the menuView.
    func hideMenuView() {
		if !isMenuViewHidden {
			isMenuViewHidden = true
			menuView.animate(MaterialAnimation.animationGroup([
				MaterialAnimation.rotate(rotation: 3),
				MaterialAnimation.translateY(150)
			]))
		}
    }

	/// Prepares the menuView.
	private func prepareMenuView() {
        var image: UIImage? = MaterialIcon.cm.add
		let menuButton: FabButton = FabButton()
		menuButton.tintColor = MaterialColor.white
		menuButton.setImage(image, forState: .Normal)
		menuButton.setImage(image, forState: .Highlighted)
		menuButton.addTarget(self, action: #selector(handleMenu), forControlEvents: .TouchUpInside)
		menuView.addSubview(menuButton)
		
		image = MaterialIcon.cm.pen
		let blueButton: FabButton = FabButton()
		blueButton.tintColor = MaterialColor.white
		blueButton.backgroundColor = MaterialColor.blue.base
		blueButton.setImage(image, forState: .Normal)
		blueButton.setImage(image, forState: .Highlighted)
		menuView.addSubview(blueButton)
		blueButton.addTarget(self, action: #selector(handleBlueButton), forControlEvents: .TouchUpInside)
		
		image = MaterialIcon.cm.photoCamera
		let greenButton: FabButton = FabButton()
		greenButton.tintColor = MaterialColor.white
		greenButton.backgroundColor = MaterialColor.green.base
		greenButton.setImage(image, forState: .Normal)
		greenButton.setImage(image, forState: .Highlighted)
		menuView.addSubview(greenButton)
		greenButton.addTarget(self, action: #selector(handleGreenButton), forControlEvents: .TouchUpInside)
		
		image = MaterialIcon.cm.star
		let yellowButton: FabButton = FabButton()
		yellowButton.tintColor = MaterialColor.white
		yellowButton.backgroundColor = MaterialColor.yellow.base
		yellowButton.setImage(image, forState: .Normal)
		yellowButton.setImage(image, forState: .Highlighted)
		menuView.addSubview(yellowButton)
		yellowButton.addTarget(self, action: #selector(handleYellowButton), forControlEvents: .TouchUpInside)
		
		// Initialize the menu and setup the configuration options.
		menuView.menu.baseSize = baseSize
		menuView.menu.views = [menuButton, blueButton, greenButton, yellowButton]
		menuView.delegate = self
        
        view.layout(menuView)
			.width(baseSize.width)
			.height(baseSize.height)
			.bottom(menuViewBottomInset)
			.right(menuViewRightInset)
        
	}
}

/// MenuViewDelegate.
extension AppMenuController: MenuViewDelegate {
	func menuViewDidTapOutside(menuView: MenuView) {
		closeMenu()
	}
}

