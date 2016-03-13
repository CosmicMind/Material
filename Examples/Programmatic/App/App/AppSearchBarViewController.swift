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
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		sideNavigationViewController?.enabled = true
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		searchBarView.statusBarStyle = .Default
		sideNavigationViewController?.delegate = self
		sideNavigationViewController?.enabled = false
	}
	
	/// Toggle SideSearchViewController left UIViewController.
	internal func handleBackButton() {
		searchBarView.textField.resignFirstResponder()
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	/// Toggle SideSearchViewController right UIViewController.
	internal func handleMoreButton() {
		searchBarView.textField.resignFirstResponder()
		print(presentingViewController?.view.layer.zPosition)
		sideNavigationViewController?.enabledRightView = true
		sideNavigationViewController?.toggleRightView()
	}
	
	/// Prepares view.
	override func prepareView() {
		super.prepareView()
		view.backgroundColor = MaterialColor.black
	}
	
	/// Prepares the searchBarView.
	private func prepareSearchBarView() {
		var image = UIImage(named: "ic_close_white")?.imageWithRenderingMode(.AlwaysTemplate)
		
		let clearButton: FlatButton = FlatButton()
		clearButton.pulseScale = false
		clearButton.pulseColor = MaterialColor.grey.darken4
		clearButton.tintColor = MaterialColor.grey.darken4
		clearButton.setImage(image, forState: .Normal)
		clearButton.setImage(image, forState: .Highlighted)
		
		// Back button.
		image = MaterialIcon.arrowDownward
		let backButton: FlatButton = FlatButton()
		backButton.pulseScale = false
		backButton.pulseColor = MaterialColor.grey.darken4
		backButton.tintColor = MaterialColor.grey.darken4
		backButton.setImage(image, forState: .Normal)
		backButton.setImage(image, forState: .Highlighted)
		backButton.addTarget(self, action: "handleBackButton", forControlEvents: .TouchUpInside)
		
		// More button.
		image = UIImage(named: "ic_more_horiz_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let moreButton: FlatButton = FlatButton()
		moreButton.pulseScale = false
		moreButton.pulseColor = MaterialColor.grey.darken4
		moreButton.tintColor = MaterialColor.grey.darken4
		moreButton.setImage(image, forState: .Normal)
		moreButton.setImage(image, forState: .Highlighted)
		
		searchBarView.placeholder = "Search"
		searchBarView.tintColor = MaterialColor.grey.darken4
		searchBarView.textColor = MaterialColor.grey.darken4
		searchBarView.placeholderTextColor = MaterialColor.grey.darken4
		searchBarView.textField.font = RobotoFont.regular
		searchBarView.textField.delegate = self
		searchBarView.contentInset.left = 8
		searchBarView.contentInset.right = 8
		
		searchBarView.clearButton = clearButton
		searchBarView.leftControls = [backButton]
		searchBarView.rightControls = [moreButton]
	}
}

extension AppSearchBarViewController: TextFieldDelegate {
	func textFieldDidBeginEditing(textField: UITextField) {
		print("Begin searching....")
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		print("End searching....")
	}
}

extension AppSearchBarViewController: SideNavigationViewControllerDelegate {
	func sideNavigationViewDidClose(sideNavigationViewController: SideNavigationViewController, position: SideNavigationPosition) {
		sideNavigationViewController.enabled = false
	}
}
