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

import UIKit
import Material

class ViewController: UIViewController {
	/// NavigationBar title label.
	private var titleLabel: UILabel!
	
	/// NavigationBar menu button.
	private var menuButton: FlatButton!
	
	/// NavigationBar switch control.
	private var switchControl: MaterialSwitch!
	
	/// NavigationBar search button.
	private var searchButton: FlatButton!
	
	/// Reference for NavigationBar.
	private var navigationBar: NavigationBar!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareTitleLabel()
		prepareMenuButton()
		prepareSwitchControl()
		prepareSearchButton()
		prepareNavigationBar()
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		navigationBar.frame = CGRectMake(0, 0, view.bounds.width, MaterialDevice.landscape ? .iPad == MaterialDevice.type ? 64 : navigationBar.intrinsicContentSize().height : 64)
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the titleLabel.
	private func prepareTitleLabel() {
		titleLabel = UILabel()
		titleLabel.text = "Recipes"
		titleLabel.textAlignment = .Left
		titleLabel.textColor = MaterialColor.white
	}
	
	/// Prepares the menuButton.
	private func prepareMenuButton() {
		let image: UIImage? = MaterialIcon.menu
		menuButton = FlatButton()
		menuButton.pulseScale = false
		menuButton.pulseColor = MaterialColor.white
		menuButton.setImage(image, forState: .Normal)
		menuButton.setImage(image, forState: .Highlighted)
	}
	
	/// Prepares the switchControl.
	private func prepareSwitchControl() {
		switchControl = MaterialSwitch(state: .Off, style: .LightContent, size: .Small)
	}
	
	/// Prepares the searchButton.
	private func prepareSearchButton() {
		let image: UIImage? = MaterialIcon.search
		searchButton = FlatButton()
		searchButton.pulseScale = false
		searchButton.pulseColor = MaterialColor.white
		searchButton.setImage(image, forState: .Normal)
		searchButton.setImage(image, forState: .Highlighted)
	}
	
	/// Prepare navigationBar.
	private func prepareNavigationBar() {
		navigationBar = NavigationBar()
		navigationBar.statusBarStyle = .LightContent
		navigationBar.tintColor = MaterialColor.white
		navigationBar.backgroundColor = MaterialColor.blue.base
		
		view.addSubview(navigationBar)
		
		let item: UINavigationItem = UINavigationItem()
		item.titleLabel = titleLabel
		item.leftControls = [menuButton]
		item.rightControls = [switchControl, searchButton]
		navigationBar.pushNavigationItem(item, animated: true)
	}
}
