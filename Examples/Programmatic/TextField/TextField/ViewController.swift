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
 *	*	Neither the name of CosmicMind nor the names of its
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
import Material

class ViewController: UIViewController {
    private var nameField: TextField!
    private var emailField: ErrorTextField!
    private var passwordField: TextField!
    
    /// A constant to layout the textFields.
    private let constant: CGFloat = 32
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        prepareNameField()
        prepareEmailField()
        preparePasswordField()
        prepareResignResponderButton()
    }
    
    /// Programmatic update for the textField as it rotates.
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        emailField.width = view.height - 2 * constant
    }
    
    /// Prepares the resign responder button.
    private func prepareResignResponderButton() {
        let btn = RaisedButton(title: "Resign", titleColor: Color.blue.base)
        btn.addTarget(self, action: #selector(handleResignResponderButton(button:)), for: .touchUpInside)
        
        view.layout(btn).width(100).height(constant).top(24).right(24)
    }
    
    /// Handle the resign responder button.
    @objc
    internal func handleResignResponderButton(button: UIButton) {
        nameField?.resignFirstResponder()
        emailField?.resignFirstResponder()
        passwordField?.resignFirstResponder()
    }
    
    private func prepareNameField() {
        nameField = TextField()
        nameField.placeholder = "Name"
        nameField.detail = "Your given name"
        nameField.isClearIconButtonEnabled = true
        
        let leftView = UIImageView()
        leftView.image = Icon.phone?.tint(with: Color.blue.base)
        
        nameField.leftView = leftView
        nameField.leftViewMode = .always
        
        view.layout(nameField).top(4 * constant).horizontally(left: constant, right: constant)
    }
    
    private func prepareEmailField() {
        emailField = ErrorTextField(frame: CGRect(x: constant, y: 7 * constant, width: view.width - (2 * constant), height: constant))
        emailField.placeholder = "Email"
        emailField.detail = "Error, incorrect email"
        emailField.isClearIconButtonEnabled = true
        emailField.delegate = self
        
        let leftView = UIImageView()
        leftView.image = Icon.email?.tint(with: Color.blue.base)
        
        emailField.leftView = leftView
        emailField.leftViewMode = .always
        
        // Set the colors for the emailField, different from the defaults.
//        emailField.placeholderNormalColor = Color.amber.darken4
//        emailField.placeholderActiveColor = Color.pink.base
//        emailField.dividerNormalColor = Color.cyan.base
        
        view.addSubview(emailField)
    }
    
    private func preparePasswordField() {
        passwordField = TextField()
        passwordField.placeholder = "Password"
        passwordField.detail = "At least 8 characters"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        
        // Setting the visibilityIconButton color.
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        
        view.layout(passwordField).top(10 * constant).horizontally(left: constant, right: constant)
    }
}

extension UIViewController: TextFieldDelegate {
    /// Executed when the 'return' key is pressed when using the emailField.
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = true
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? ErrorTextField)?.isErrorRevealed = false
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(textField: UITextField, didChange text: String?) {
        print("did change", text)
    }
    
    public func textField(textField: UITextField, willClear text: String?) {
        print("will clear", text)
    }
    
    public func textField(textField: UITextField, didClear text: String?) {
        print("did clear", text)
    }
}

