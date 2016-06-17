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

import UIKit
import Material

class YellowViewController: UIViewController {
	/// NavigationBar menu button.
	private var menuButton: IconButton!
	
	/// NavigationBar switch control.
	private var switchControl: MaterialSwitch!
	
	/// NavigationBar more button.
	private var moreButton: IconButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareMenuButton()
		prepareSwitchControl()
		prepareSearchButton()
		prepareNavigationItem()
		prepareNavigationBar()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		navigationDrawerController?.enabled = true
	}
	
	internal func handleMenuButton() {
		navigationDrawerController?.openLeftView()
	}
	
	internal func handleMoreButton() {
		navigationDrawerController?.openRightView()
	}
	
	/// Prepares the view.
	private func prepareView() {
		view.backgroundColor = MaterialColor.yellow.base
	}
	
	/// Prepares the menuButton.
	private func prepareMenuButton() {
		let image: UIImage? = MaterialIcon.cm.menu
		menuButton = IconButton()
		menuButton.pulseColor = MaterialColor.white
		menuButton.setImage(image, forState: .Normal)
		menuButton.setImage(image, forState: .Highlighted)
		menuButton.addTarget(self, action: #selector(handleMenuButton), forControlEvents: .TouchUpInside)
	}
	
	/// Prepares the switchControl.
	private func prepareSwitchControl() {
		switchControl = MaterialSwitch(state: .Off, style: .LightContent, size: .Small)
	}
	
	/// Prepares the searchButton.
	private func prepareSearchButton() {
		let image: UIImage? = MaterialIcon.cm.moreVertical
		moreButton = IconButton()
		moreButton.pulseColor = MaterialColor.white
		moreButton.setImage(image, forState: .Normal)
		moreButton.setImage(image, forState: .Highlighted)
		moreButton.addTarget(self, action: #selector(handleMoreButton), forControlEvents: .TouchUpInside)
	}
	
	/// Prepares the navigationItem.
	private func prepareNavigationItem() {
		navigationItem.title = "Yellow"
		navigationItem.titleLabel.textAlignment = .Left
		
		navigationItem.detailLabel.textAlignment = .Left
		
		navigationItem.leftControls = [menuButton]
		navigationItem.rightControls = [switchControl, moreButton]
	}
	
	/// Prepares the navigationBar.
	private func prepareNavigationBar() {
		/**
		To control this setting, set the "View controller-based status bar appearance"
		to "NO" in the info.plist.
		*/
		navigationController?.navigationBar.statusBarStyle = .Default
	}
}
