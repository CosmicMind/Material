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
	private lazy var titleField: TextField = TextField()
	private lazy var descriptionField: TextField = TextField()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		
		prepareTitleField()
		prepareDescriptionField()
	}
	
	/**
	:name:	prepareView
	*/
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/**
	:name:	prepareTitleField
	:description:	A preparation helper for titleField.
	*/
	private func prepareTitleField() {
		titleField.delegate = self
		titleField.frame = CGRectMake(57, 100, 300, 24)
		titleField.placeholder = "Title"
		titleField.font = RobotoFont.regularWithSize(20)
		titleField.textColor = MaterialColor.black
		titleField.titleLabel = UILabel()
		titleField.titleLabel!.font = RobotoFont.mediumWithSize(12)
		titleField.titleLabelNormalColor = MaterialColor.grey.lighten1
		titleField.titleLabelHighlightedColor = MaterialColor.blue.accent3
		titleField.clearButtonMode = .WhileEditing
		view.addSubview(titleField)
	}
	
	/**
	:name:	prepareDescriptionField
	:description:	A preparation helper for descriptionField.
	*/
	private func prepareDescriptionField() {
		descriptionField.delegate = self
		descriptionField.frame = CGRectMake(57, 150, 300, 24)
		descriptionField.placeholder = "Description"
		descriptionField.font = RobotoFont.regularWithSize(20)
		descriptionField.textColor = MaterialColor.black
		descriptionField.titleLabel = UILabel()
		descriptionField.titleLabel!.font = RobotoFont.mediumWithSize(12)
		descriptionField.titleLabelNormalColor = MaterialColor.grey.lighten1
		descriptionField.titleLabelHighlightedColor = MaterialColor.blue.accent3
		descriptionField.clearButtonMode = .WhileEditing
		view.addSubview(descriptionField)
	}
	
	/**
	:name:	textFieldShouldReturn
	:description: This is called when the user presses the Return
				  key on the keyboard.
	*/
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}
	
}
