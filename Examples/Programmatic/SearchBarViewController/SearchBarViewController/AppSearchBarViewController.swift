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
	
	/// Loads the BlueViewController into the searchBarViewControllers mainViewController.
	func handleBlueButton() {
		if mainViewController is BlueViewController {
			return
		}
		
		MaterialAnimation.delay(0.75) { [weak self] in
			self?.transitionFromMainViewController(BlueViewController(), options: [.TransitionCrossDissolve])
		}
	}
	
	/// Loads the GreenViewController into the searchBarViewControllers mainViewController.
	func handleGreenButton() {
		if mainViewController is GreenViewController {
			return
		}
		
		MaterialAnimation.delay(0.75) { [weak self] in
			self?.transitionFromMainViewController(GreenViewController(), options: [.TransitionCrossDissolve])
		}
	}
	
	/// Loads the YellowViewController into the searchBarViewControllers mainViewController.
	func handleYellowButton() {
		if (mainViewController as? NavigationBarViewController)?.mainViewController is YellowViewController {
			return
		}
		
		MaterialAnimation.delay(0.75) { [weak self] in
			self?.transitionFromMainViewController(YellowViewController(), options: [.TransitionCrossDissolve])
			self?.searchBarView.textField.resignFirstResponder()
		}
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
		clearButton.pulseColor = MaterialColor.blueGrey.darken4
		clearButton.pulseScale = false
		clearButton.tintColor = MaterialColor.blueGrey.darken4
		clearButton.setImage(image, forState: .Normal)
		clearButton.setImage(image, forState: .Highlighted)
		clearButton.addTarget(self, action: "handleYellowButton", forControlEvents: .TouchUpInside)
		
		// Back button.
		image = UIImage(named: "ic_arrow_back_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let backButton: FlatButton = FlatButton()
		backButton.pulseColor = MaterialColor.blueGrey.darken4
		backButton.pulseScale = false
		backButton.tintColor = MaterialColor.blueGrey.darken4
		backButton.setImage(image, forState: .Normal)
		backButton.setImage(image, forState: .Highlighted)
		backButton.addTarget(self, action: "handleBlueButton", forControlEvents: .TouchUpInside)
		
		// More button.
		image = UIImage(named: "ic_more_horiz_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let moreButton: FlatButton = FlatButton()
		moreButton.pulseColor = MaterialColor.blueGrey.darken4
		moreButton.pulseScale = false
		moreButton.tintColor = MaterialColor.blueGrey.darken4
		moreButton.setImage(image, forState: .Normal)
		moreButton.setImage(image, forState: .Highlighted)
		moreButton.addTarget(self, action: "handleGreenButton", forControlEvents: .TouchUpInside)
		
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
		searchBarView.textField.font = RobotoFont.regularWithSize(20)
		searchBarView.textField.delegate = self
		
		searchBarView.clearButton = clearButton
		searchBarView.leftControls = [backButton]
		searchBarView.rightControls = [moreButton]
	}
}

extension AppSearchBarViewController: TextFieldDelegate {
	func textFieldDidBeginEditing(textField: UITextField) {
		mainViewController.view.alpha = 0.5
		mainViewController.view.userInteractionEnabled = false
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		mainViewController.view.alpha = 1
		mainViewController.view.userInteractionEnabled = true
	}
}
