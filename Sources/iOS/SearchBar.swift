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
	public private(set) var clearButton: FlatButton!
	
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
	
	/// A wrapper for searchBar.placeholder.
	@IBInspectable public var placeholder: String? {
		get {
			return textField.placeholder
		}
		set(value) {
			textField.placeholder = value
		}
	}
	
	/// Placeholder textColor.
	@IBInspectable public var placeholderTextColor: UIColor = MaterialColor.grey.base {
		didSet {
			if let v: String = textField.placeholder {
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
			contentView.grid.views?.append(textField)
			contentView.grid.reloadLayout()
			reloadView()
		}
	}
	
	/// Reloads the view.
	public func reloadView() {
		/// Align the clearButton.
		let h: CGFloat = textField.frame.height
		clearButton.frame = CGRectMake(textField.frame.width - h, 0, h, h)
	}
	
	/// Prepares the contentView.
	public override func prepareContentView() {
		super.prepareContentView()
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
		tintColor = MaterialColor.grey.base
		textColor = MaterialColor.grey.darken4
		placeholder = "Search"
		placeholderTextColor = MaterialColor.grey.base
		contentView.addSubview(textField)
	}
	
	/// Prepares the clearButton.
	private func prepareClearButton() {
		let image: UIImage? = MaterialIcon.cm.close
		clearButton = FlatButton()
		clearButton.contentEdgeInsets = UIEdgeInsetsZero
		clearButton.pulseColor = MaterialColor.grey.base
		clearButton.pulseScale = false
		clearButton.tintColor = MaterialColor.grey.base
		clearButton.setImage(image, forState: .Normal)
		clearButton.setImage(image, forState: .Highlighted)
		clearButtonAutoHandleEnabled = true
		textField.clearButtonMode = .Never
		textField.rightViewMode = .WhileEditing
		textField.rightView = clearButton
	}
}
