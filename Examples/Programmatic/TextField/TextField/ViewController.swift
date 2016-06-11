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
The following is an example of using a TextField. TextFields offer details
that describe the usage and input results of text. For example, when a
user enters an incorrect email, it is possible to display an error message
under the TextField.
*/

import UIKit
import Material

class ViewController: UIViewController, TextFieldDelegate {
	private var nameField: TextField!
	private var emailField: ErrorTextField!
	private var passwordField: TextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareNameField()
		prepareEmailField()
		preparePasswordField()
		prepareResignResponderButton()
	}
	
	/// Programmatic update for the textField as it rotates.
	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		emailField.width = view.bounds.height - 80
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the resign responder button.
	private func prepareResignResponderButton() {
		let btn: RaisedButton = RaisedButton()
		btn.addTarget(self, action: #selector(handleResignResponderButton), forControlEvents: .TouchUpInside)
		btn.setTitle("Resign", forState: .Normal)
		btn.setTitleColor(MaterialColor.blue.base, forState: .Normal)
		btn.setTitleColor(MaterialColor.blue.base, forState: .Highlighted)
		
		view.layout(btn).width(100).height(50).bottom(24).right(24)
	}
	
	/// Handle the resign responder button.
	internal func handleResignResponderButton() {
		nameField?.resignFirstResponder()
		emailField?.resignFirstResponder()
		passwordField?.resignFirstResponder()
		
	}
	
	/// Prepares the name TextField.
	private func prepareNameField() {
		nameField = TextField()
		nameField.text = "Daniel Dahan"
		nameField.placeholder = "Name"
		nameField.detail = "Your given name"
		nameField.textAlignment = .Center
		nameField.clearButtonMode = .WhileEditing
		
		// Size the TextField to the maximum width, less 40 pixels on either side
		// with a top margin of 40 pixels.
		view.layout(nameField).top(40).horizontally(left: 40, right: 40)
	}
	
	/// Prepares the email TextField.
	private func prepareEmailField() {
		emailField = ErrorTextField(frame: CGRectMake(40, 120, view.bounds.width - 80, 32))
		emailField.placeholder = "Email"
		emailField.detail = "Error, incorrect email"
		emailField.enableClearIconButton = true
		emailField.delegate = self 
		
		emailField.placeholderColor = MaterialColor.amber.darken4
		emailField.placeholderActiveColor = MaterialColor.pink.base
		emailField.dividerColor = MaterialColor.cyan.base
		
		view.addSubview(emailField)
	}
	
	/// Prepares the password TextField.
	private func preparePasswordField() {
		passwordField = TextField()
		passwordField.placeholder = "Password"
		passwordField.detail = "At least 8 characters"
		passwordField.clearButtonMode = .WhileEditing
		passwordField.enableVisibilityIconButton = true
		
		// Setting the visibilityFlatButton color.
		passwordField.visibilityIconButton?.tintColor = MaterialColor.green.base.colorWithAlphaComponent(passwordField.secureTextEntry ? 0.38 : 0.54)
		
		// Size the TextField to the maximum width, less 40 pixels on either side
		// with a top margin of 200 pixels.
		view.layout(passwordField).top(200).horizontally(left: 40, right: 40)		
	}
	
	/// Executed when the 'return' key is pressed when using the emailField.
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		(textField as? ErrorTextField)?.revealError = true
		return true
	}
	
	func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		return true
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
	}
	
	func textFieldShouldEndEditing(textField: UITextField) -> Bool {
		return true
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		(textField as? ErrorTextField)?.revealError = false
	}
	
	func textFieldShouldClear(textField: UITextField) -> Bool {
		(textField as? ErrorTextField)?.revealError = false
		return true
	}
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		(textField as? ErrorTextField)?.revealError = false
		return true
	}
}
