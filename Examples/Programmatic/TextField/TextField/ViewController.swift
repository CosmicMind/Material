//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io> and other CosmicMind contributors
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit
import MaterialKit

class ViewController: UIViewController, TextFieldDelegate {
	private lazy var titleTextField: TextField = TextField()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		
		prepareTitleTextField()
	}
	
	/**
	:name:	prepareView
	*/
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/**
	:name:	prepareTitleTextField
	:description:	A preparation helper method for titleTextField.
	*/
	private func prepareTitleTextField() {
		titleTextField.frame = CGRectMake(100, 100, 200, 35)
		titleTextField.placeholder = "Title"
		titleTextField.textColor = MaterialColor.black
		titleTextField.titleLabel = UILabel()
		titleTextField.titleLabel!.font = RobotoFont.boldWithSize(12)
		titleTextField.font = RobotoFont.boldWithSize(24)
		titleTextField.delegate = self
		titleTextField.titleNormalColor = MaterialColor.grey.lighten1
		titleTextField.titleHighlightedColor = MaterialColor.blue.accent3
		view.addSubview(titleTextField)
	}
	
	/**
	:name:	textFieldShouldReturn
	:description: This is called when the user presses the Return
				  key on the keyboard.
	*/
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		if textField == titleTextField {
			titleTextField.resignFirstResponder()
		}
		return false
	}
	
}
