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
The following is an example of using a SearchBarController to control the
flow of your application.
*/

import UIKit
import Material

class AppSearchBarController: SearchBarController {
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareSearchBar()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		statusBarStyle = .Default
		navigationDrawerController?.enabled = false
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		searchBar.textField.becomeFirstResponder()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		searchBar.textField.resignFirstResponder()
		navigationDrawerController?.enabled = true
	}
	
	/// Toggle SideSearchViewController left UIViewController.
	internal func handleBackButton() {
		searchBar.textField.resignFirstResponder()
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	/// Prepares view.
	override func prepareView() {
		super.prepareView()
		view.backgroundColor = MaterialColor.black
	}
	
	/// Prepares the searchBar.
	private func prepareSearchBar() {
		var image: UIImage? = MaterialIcon.cm.arrowBack
		
		// Back button.
		let backButton: IconButton = IconButton()
		backButton.pulseColor = MaterialColor.grey.base
		backButton.tintColor = MaterialColor.grey.darken4
		backButton.setImage(image, forState: .Normal)
		backButton.setImage(image, forState: .Highlighted)
		backButton.addTarget(self, action: #selector(handleBackButton), forControlEvents: .TouchUpInside)
		
		// More button.
		image = MaterialIcon.cm.moreHorizontal
		let moreButton: IconButton = IconButton()
		moreButton.pulseColor = MaterialColor.grey.base
		moreButton.tintColor = MaterialColor.grey.darken4
		moreButton.setImage(image, forState: .Normal)
		moreButton.setImage(image, forState: .Highlighted)
		
		searchBar.textField.delegate = self
		searchBar.leftControls = [backButton]
		searchBar.rightControls = [moreButton]
	}
}

extension AppSearchBarController: TextFieldDelegate {
	func textFieldDidBeginEditing(textField: UITextField) {
//		print("Begin searching....")
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
//		print("End searching....")
	}
}
