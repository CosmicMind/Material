/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.
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
*	*	Neither the name of MaterialKit nor the names of its
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
import MaterialKit

class ViewController: UIViewController, TextFieldDelegate {
	private lazy var nameField: TextField = TextField()
	private lazy var emailField: TextField = TextField()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		
		prepareNameField()
		prepareEmailField()
	}
	
	/**
	:name:	prepareView
	*/
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/**
	:name:	prepareNameField
	:description:	A preparation helper for nameField.
	*/
	private func prepareNameField() {
		nameField.delegate = self
		nameField.frame = CGRectMake(57, 100, 300, 24)
		nameField.placeholder = "First Name"
		nameField.font = RobotoFont.regularWithSize(20)
		nameField.textColor = MaterialColor.black
		nameField.titleLabel = UILabel()
		nameField.titleLabel!.font = RobotoFont.mediumWithSize(12)
		nameField.titleLabelColor = MaterialColor.grey.lighten1
		nameField.titleLabelActiveColor = MaterialColor.blue.accent3
		nameField.clearButtonMode = .WhileEditing
		view.addSubview(nameField)
	}
	
	/**
	:name:	prepareEmailField
	:description:	A preparation helper for emailField.
	*/
	private func prepareEmailField() {
		emailField.delegate = self
		emailField.frame = CGRectMake(57, 200, 300, 24)
		emailField.placeholder = "Email"
		emailField.font = RobotoFont.regularWithSize(20)
		emailField.textColor = MaterialColor.black
		emailField.titleLabel = UILabel()
		emailField.titleLabel!.font = RobotoFont.mediumWithSize(12)
		emailField.titleLabelColor = MaterialColor.grey.lighten1
		emailField.titleLabelActiveColor = MaterialColor.blue.accent3
		emailField.clearButtonMode = .WhileEditing
		emailField.detailLabel = UILabel()
		emailField.detailLabel!.text = "Email is incorrect."
		emailField.detailLabel!.font = RobotoFont.mediumWithSize(12)
		emailField.detailLabelActiveColor = MaterialColor.red.accent3
		view.addSubview(emailField)
	}
	
	/**
	:name:	textFieldShouldReturn
	:description: This is called when the user presses the Return
				  key on the keyboard.
	*/
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		if textField == emailField {
			(textField as! TextField).detailLabelHidden = false
		}
		return false
	}
	
}
