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

//extension TextField {
//	
//	func setDefaultLabelSpecs(titleColor titleColor: UIColor, detailColor: UIColor) {
//		// ref: https://www.google.com/design/spec/components/text-fields.html#text-fields-labels
//		// ref: https://www.google.com/design/spec/patterns/errors.html#errors-user-input-errors
//		// ref: https://www.google.com/design/spec/layout/metrics-keylines.html#metrics-keylines-touch-target-size
//		assert(height == 80, "Height must be 80, based on Material design spec.")
//		
//		backgroundColor = nil
//		
//		let derivedDetailLabelHeight: CGFloat = 15
//		let paddingAboveAndBelowErrorText: CGFloat = 4
//		
//		detailLabel.font = RobotoFont.regularWithSize(12)
//		detailLabelActiveColor = detailColor
//		detailLabelAnimationDistance = lineLayerThickness + paddingAboveAndBelowErrorText
//		
//		lineLayerActiveColor = titleColor
//		lineLayerColor = MaterialColor.darkText.dividers
//		lineLayerDistance = 0 - (derivedDetailLabelHeight + (paddingAboveAndBelowErrorText * 2) + lineLayerThickness)
//		
//		let derivedTitleLabelHeight: CGFloat = 20
//		let paddingAboveLabelText: CGFloat = 8
//		
//		titleLabelActiveColor = lineLayerActiveColor
//		titleLabelAnimationDistance = 0 - (derivedTitleLabelHeight + paddingAboveLabelText)
//		
//		if let clearButton = clearButton {
//			let touchTargetHeight: CGFloat = 48
//			let spacing = (height - touchTargetHeight) / 2
//			let origin = CGPoint(x: width - touchTargetHeight - spacing, y: spacing)
//			let size = CGSize(width: touchTargetHeight, height: touchTargetHeight)
//			
//			clearButton.frame = CGRect(origin: origin, size: size)
//			
//			clearButton.contentHorizontalAlignment = .Right
//			
//			// Use PDF for better rendering
//			let clearImage = UIImage(named: "Material/Navigation/Close")
//			clearButton.setImage(clearImage, forState: .Normal)
//			clearButton.setImage(clearImage, forState: .Highlighted)
//			
//			// Hide it since it bleeds over the lineLayer, and doesn't look good
//			// with the horizontal alignment.
//			clearButton.pulseOpacity = 0
//		}
//	}
//}

class ViewController: UIViewController, TextFieldDelegate {
	private var nameField: MTextField!
	private var emailField: MTextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareResignResponderButton()
		prepareNameField()
		prepareEmailField()
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
		btn.translatesAutoresizingMaskIntoConstraints = false
		btn.addTarget(self, action: #selector(handleResignResponderButton), forControlEvents: .TouchUpInside)
		btn.setTitle("Resign", forState: .Normal)
		btn.setTitleColor(MaterialColor.blue.base, forState: .Normal)
		btn.setTitleColor(MaterialColor.blue.base, forState: .Highlighted)
		view.addSubview(btn)
		
		MaterialLayout.alignFromBottomRight(view, child: btn, bottom: 24, right: 24)
		MaterialLayout.size(view, child: btn, width: 100, height: 50)
	}
	
	/// Handle the resign responder button.
	internal func handleResignResponderButton() {
		nameField?.resignFirstResponder()
		emailField?.resignFirstResponder()
	}
	
	/// Prepares the name TextField.
	private func prepareNameField() {
		nameField = MTextField()
		nameField.placeholder = "Email"
		nameField.detail = "Enter your email address.yyypppggg"
		nameField.clearButtonMode = .WhileEditing
		nameField.textAlignment = .Center
		nameField.text = "daniel@dahan"
		nameField.backgroundColor = MaterialColor.green.accent1
		nameField.placeholderLabel.backgroundColor = MaterialColor.green.accent3
		
		// The translatesAutoresizingMaskIntoConstraints property must be set to enable AutoLayout correctly.
		nameField.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(nameField)
		
		// Size the TextField to the maximum width, less 20 pixels on either side
		// with a top margin of 100 pixels.
		MaterialLayout.alignFromTop(view, child: nameField, top: 40)
		MaterialLayout.alignToParentHorizontally(view, child: nameField, left: 40, right: 40)
	}
	
	/// Prepares the email TextField.
	private func prepareEmailField() {
		emailField = MTextField(frame: CGRectMake(40, 120, view.bounds.width - 80, 32))
		emailField.placeholder = "Email"
		emailField.detail = "Error, incorrect email.yyppggg"
		emailField.delegate = self
		emailField.clearButtonMode = .WhileEditing
		
		emailField.placeholderColor = MaterialColor.amber.darken4
		emailField.placeholderActiveColor = MaterialColor.pink.base
		emailField.dividerColor = MaterialColor.cyan.base
		emailField.detailColor = MaterialColor.indigo.accent1
		
		emailField.backgroundColor = MaterialColor.green.accent1
		emailField.placeholderLabel.backgroundColor = MaterialColor.green.accent3
		
		view.addSubview(emailField)
	}
	
	/// Executed when the 'return' key is pressed when using the emailField.
	func textFieldShouldReturn(textField: UITextField) -> Bool {
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
	}
	
	func textFieldShouldClear(textField: UITextField) -> Bool {
		return true
	}
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		return true
	}
}
