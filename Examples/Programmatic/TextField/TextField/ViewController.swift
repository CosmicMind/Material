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
	private var emailField: TextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareNameField()
		prepareEmailField()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the name TextField.
	private func prepareNameField() {
		nameField = TextField()
		nameField.placeholder = "Name"
		view.addSubview(nameField)
		
		nameField.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: nameField, top: 100)
		MaterialLayout.alignToParentHorizontally(view, child: nameField, left: 20, right: 20)
		
	}
	
	/// Prepares the email TextField.
	private func prepareEmailField() {
		let w: CGFloat = 300
		let x: CGFloat = (MaterialDevice.width - w) / 2
		emailField = TextField(frame: CGRectMake(x, 200, w, 24))
		emailField.placeholder = "Email"
		emailField.delegate = self

		/*
		Used to display the error message, which is displayed when
		the user presses the 'return' key.
		*/
		emailField.detailLabel.text = "Email is incorrect."
		emailField.detailLabel.font = RobotoFont.regularWithSize(12)
		emailField.detailLabelActiveColor = MaterialColor.red.accent3
//		emailField.detailLabelAutoHideEnabled = false // Uncomment this line to have manual hiding.
		
		view.addSubview(emailField)
	}
	
	/// Executed when the 'return' key is pressed when using the emailField.
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		(textField as! TextField).detailLabelHidden = 0 == textField.text?.utf16.count
		return true
	}
	
	func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		print("Should Begin")
		return true
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		print("Did Begin")
	}
	
	func textFieldShouldEndEditing(textField: UITextField) -> Bool {
		print("Should End")
		return true
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		print("Did End")
	}
	
	func textFieldShouldClear(textField: UITextField) -> Bool {
		print("Should Clear")
		return true
	}
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		print("Should Change")
		return true
	}
}
