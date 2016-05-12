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

import UIKit

public class SearchBar : StatusBarView {
	/// The UITextField for the searchBar.
	public private(set) var textField: UITextField!
	
	/// Reference to the clearButton.
	public private(set) var clearButton: IconButton!
	
	/// Handle the clearButton manually.
	@IBInspectable public var clearButtonAutoHandleEnabled: Bool = true {
		didSet {
			clearButton.removeTarget(self, action: #selector(handleClearButton), forControlEvents: .TouchUpInside)
			if clearButtonAutoHandleEnabled {
				clearButton.addTarget(self, action: #selector(handleClearButton), forControlEvents: .TouchUpInside)
			}
		}
	}
	
	/// TintColor for searchBar.
	@IBInspectable public override var tintColor: UIColor? {
		get {
			return textField.tintColor
		}
		set(value) {
			textField.tintColor = value
		}
	}
	
	/// TextColor for searchBar.
	@IBInspectable public var textColor: UIColor? {
		get {
			return textField.textColor
		}
		set(value) {
			textField.textColor = value
		}
	}
	
	/// Sets the textField placeholder value.
	@IBInspectable public var placeholder: String? {
		didSet {
			if let v: String = placeholder {
				textField.attributedPlaceholder = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderTextColor])
			}
		}
	}
	
	/// Placeholder textColor.
	@IBInspectable public var placeholderTextColor: UIColor = MaterialColor.darkText.others {
		didSet {
			if let v: String = placeholder {
				textField.attributedPlaceholder = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderTextColor])
			}
		}
	}
	
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: CGRectZero)
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		if willRenderView {
			textField.frame = contentView.bounds
			layoutClearButton()
		}
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public override func prepareView() {
		super.prepareView()
		prepareTextField()
		prepareClearButton()
	}
	
	/// Clears the textField text.
	internal func handleClearButton() {
		textField.text = ""
	}
	
	/// Prepares the textField.
	private func prepareTextField() {
		textField = UITextField()
		textField.font = RobotoFont.regularWithSize(20)
		textField.backgroundColor = MaterialColor.clear
		textField.clearButtonMode = .WhileEditing
		tintColor = placeholderTextColor
		textColor = MaterialColor.darkText.primary
		placeholder = "Search"
		contentView.addSubview(textField)
	}
	
	/// Prepares the clearButton.
	private func prepareClearButton() {
		let image: UIImage? = MaterialIcon.cm.close
		clearButton = IconButton()
		clearButton.contentEdgeInsets = UIEdgeInsetsZero
		clearButton.tintColor = placeholderTextColor
		clearButton.setImage(image, forState: .Normal)
		clearButton.setImage(image, forState: .Highlighted)
		clearButtonAutoHandleEnabled = true
		textField.clearButtonMode = .Never
		textField.rightViewMode = .WhileEditing
		textField.rightView = clearButton
	}
	
	/// Layout the clearButton.
	private func layoutClearButton() {
		let h: CGFloat = textField.frame.height
		clearButton.frame = CGRectMake(textField.frame.width - h, 0, h, h)
	}
}
