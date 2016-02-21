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
	override var floatingViewController: UIViewController? {
		didSet {
			if nil == floatingViewController {
				/*
				To lighten the status bar - add the
				"View controller-based status bar appearance = NO"
				to your info.plist file and set the following property.
				*/
				navigationBarView.statusBarStyle = .LightContent
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareNavigationBarView()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		/*
		To lighten the status bar - add the
		"View controller-based status bar appearance = NO"
		to your info.plist file and set the following property.
		*/
		navigationBarView.statusBarStyle = .LightContent
	}
	
	/// Prepares view.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Toggle SideNavigationViewController left UIViewController.
	internal func handleMenuButton() {
		sideNavigationViewController?.toggleLeftView()
	}
	
	/// Toggle SideNavigationViewController right UIViewController.
	internal func handleSearchButton() {
		guard let v: AppSearchBarViewController = AppSearchBarViewController(mainViewController: SearchListViewController()) else {
			return
		}
		
		navigationBarViewController?.floatingViewController = v
	}
	
	/// Prepares the navigationBarView.
	private func prepareNavigationBarView() {
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Feed"
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
		menuButton.pulseColor = MaterialColor.white
		menuButton.pulseScale = false
		menuButton.setImage(image, forState: .Normal)
		menuButton.setImage(image, forState: .Highlighted)
		menuButton.addTarget(self, action: "handleMenuButton", forControlEvents: .TouchUpInside)
		
		// Switch control.
		let switchControl: MaterialSwitch = MaterialSwitch(state: .Off, style: .LightContent, size: .Small)
		
		// Search button.
		image = UIImage(named: "ic_search_white")
		let searchButton: FlatButton = FlatButton()
		searchButton.pulseColor = MaterialColor.white
		searchButton.pulseScale = false
		searchButton.setImage(image, forState: .Normal)
		searchButton.setImage(image, forState: .Highlighted)
		searchButton.addTarget(self, action: "handleSearchButton", forControlEvents: .TouchUpInside)
		
		navigationBarView.backgroundColor = MaterialColor.blue.base
		navigationBarView.titleLabel = titleLabel
		navigationBarView.leftControls = [menuButton]
		navigationBarView.rightControls = [switchControl, searchButton]
	}
}

