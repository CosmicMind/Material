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
The following is an example of using a SearchBarViewController to control the
flow of your application.
*/

import UIKit
import Material

class AppSearchBarViewController: SearchBarViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareSearchBarView()
	}
	
	/// Prepares view.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Toggle SideSearchViewController left UIViewController.
	internal func handleBackButton() {
		navigationBarViewController?.floatingViewController = nil
	}
	
	/// Toggle SideSearchViewController right UIViewController.
	internal func handleMoreButton() {
		searchBarView.textField.resignFirstResponder()
		sideNavigationViewController?.delegate = self
		sideNavigationViewController?.enabledRightView = true
		sideNavigationViewController?.toggleRightView()
	}
	
	/// Prepares the searchBarView.
	private func prepareSearchBarView() {
		var image = UIImage(named: "ic_close_white")?.imageWithRenderingMode(.AlwaysTemplate)
		
		let clearButton: FlatButton = FlatButton()
		clearButton.pulseColor = MaterialColor.blueGrey.darken4
		clearButton.pulseScale = false
		clearButton.tintColor = MaterialColor.blueGrey.darken4
		clearButton.setImage(image, forState: .Normal)
		clearButton.setImage(image, forState: .Highlighted)
		
		// Back button.
		image = UIImage(named: "ic_arrow_back_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let backButton: FlatButton = FlatButton()
		backButton.pulseColor = MaterialColor.blueGrey.darken4
		backButton.pulseScale = false
		backButton.tintColor = MaterialColor.blueGrey.darken4
		backButton.setImage(image, forState: .Normal)
		backButton.setImage(image, forState: .Highlighted)
		backButton.addTarget(self, action: "handleBackButton", forControlEvents: .TouchUpInside)
		
		// Search button.
		image = UIImage(named: "ic_more_horiz_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let searchButton: FlatButton = FlatButton()
		searchButton.pulseColor = MaterialColor.blueGrey.darken4
		searchButton.pulseScale = false
		searchButton.tintColor = MaterialColor.blueGrey.darken4
		searchButton.setImage(image, forState: .Normal)
		searchButton.setImage(image, forState: .Highlighted)
		searchButton.addTarget(self, action: "handleMoreButton", forControlEvents: .TouchUpInside)
		
		/*
		To lighten the status bar - add the
		"View controller-based status bar appearance = NO"
		to your info.plist file and set the following property.
		*/
		searchBarView.statusBarStyle = .Default
		
		searchBarView.delegate = self
		searchBarView.placeholder = "Search"
		searchBarView.tintColor = MaterialColor.blueGrey.darken4
		searchBarView.textColor = MaterialColor.blueGrey.darken4
		searchBarView.placeholderTextColor = MaterialColor.blueGrey.darken4
		searchBarView.textField.font = RobotoFont.regularWithSize(17)
		
		searchBarView.clearButton = clearButton
		searchBarView.leftControls = [backButton]
		searchBarView.rightControls = [searchButton]
	}
}

extension AppSearchBarViewController: SideNavigationViewControllerDelegate {
	func sideNavigationViewWillClose(sideNavigationViewController: SideNavigationViewController, position: SideNavigationPosition) {
		sideNavigationViewController.enabledRightView = false
		sideNavigationViewController.delegate = nil
		searchBarView.textField.becomeFirstResponder()
	}
}
