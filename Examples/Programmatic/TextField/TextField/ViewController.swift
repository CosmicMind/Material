//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io> 
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
        nameField.titleLabelNormalColor = MaterialColor.grey.lighten2
        nameField.titleLabelHighlightedColor = MaterialColor.blue.accent3
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
        emailField.titleLabelNormalColor = MaterialColor.grey.lighten2
        emailField.titleLabelHighlightedColor = MaterialColor.blue.accent3
        emailField.clearButtonMode = .WhileEditing
        //		emailField.detailLabel = UILabel()
        //		emailField.detailLabel!.text = "Email is incorrect."
        //		emailField.detailLabel!.font = RobotoFont.mediumWithSize(12)
        //		emailField.detailLabelHighlightedColor = MaterialColor.red.accent3
        
        emailField.validationBlock = ({(text:String) -> Bool in
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@" , emailRegex)
            
            let isValid = emailTest.evaluateWithObject(text)
            return isValid;
            
        })
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
            //			(textField as! TextField).detailLabelHidden = false
            emailField.validate("Invalid Email Address")
        }
        return false
    }
    
}
