/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

@objc(SearchBarDelegate)
public protocol SearchBarDelegate {
    /**
     A delegation method that is executed when the textField changed.
     - Parameter searchBar: A SearchBar.
     - Parameter didChange textField: A UITextField.
     - Parameter with text: An optional String.
     */
    @objc
    optional func searchBar(searchBar: SearchBar, didChange textField: UITextField, with text: String?)
    
    /**
     A delegation method that is executed when the textField will clear.
     - Parameter searchBar: A SearchBar.
     - Parameter willClear textField: A UITextField.
     - Parameter with text: An optional String.
     */
    @objc
    optional func searchBar(searchBar: SearchBar, willClear textField: UITextField, with text: String?)
    
    /**
     A delegation method that is executed when the textField is cleared.
     - Parameter searchBar: A SearchBar.
     - Parameter didClear textField: A UITextField.
     - Parameter with text: An optional String.
     */
    @objc
    optional func searchBar(searchBar: SearchBar, didClear textField: UITextField, with text: String?)
}

open class SearchBar: Bar {
	/// The UITextField for the searchBar.
	open let textField = UITextField()
	
	/// Reference to the clearButton.
	open fileprivate(set) var clearButton: IconButton!
	
    /// A reference to the delegate.
    open weak var delegate: SearchBarDelegate?
    
	/// Handle the clearButton manually.
	@IBInspectable
    open var isClearButtonAutoHandleEnabled = true {
		didSet {
			clearButton.removeTarget(self, action: #selector(handleClearButton), for: .touchUpInside)
			if isClearButtonAutoHandleEnabled {
				clearButton.addTarget(self, action: #selector(handleClearButton), for: .touchUpInside)
			}
		}
	}
	
	/// TintColor for searchBar.
	@IBInspectable
    open override var tintColor: UIColor? {
		get {
			return textField.tintColor
		}
		set(value) {
			textField.tintColor = value
		}
	}
	
	/// TextColor for searchBar.
	@IBInspectable
    open var textColor: UIColor? {
		get {
			return textField.textColor
		}
		set(value) {
			textField.textColor = value
		}
	}
	
	/// Sets the textField placeholder value.
	@IBInspectable
    open var placeholder: String? {
		didSet {
			if let v = placeholder {
				textField.attributedPlaceholder = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderColor])
			}
		}
	}
	
	/// Placeholder text
	@IBInspectable
    open var placeholderColor = Color.darkText.others {
		didSet {
			if let v = placeholder {
				textField.attributedPlaceholder = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderColor])
			}
		}
	}
    
	open override func layoutSubviews() {
		super.layoutSubviews()
        guard willLayout else {
            return
        }
        
        textField.frame = contentView.bounds
        layoutClearButton()
	}
	
	/**
     An initializer that initializes the object with a NSCoder object.
     - Parameter aDecoder: A NSCoder instance.
     */
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
     An initializer that initializes the object with a CGRect object.
     If AutoLayout is used, it is better to initilize the instance
     using the init() initializer.
     - Parameter frame: A CGRect instance.
     */
	public override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	/**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
	open override func prepare() {
		super.prepare()
        prepareTextField()
		prepareClearButton()
	}
	
	/// Layout the clearButton.
	open func layoutClearButton() {
		let h = textField.frame.height
        clearButton.frame = CGRect(x: textField.frame.width - h, y: 0, width: h, height: h)
	}
	
	/// Clears the textField text.
	@objc
    internal func handleClearButton() {
        guard nil == textField.delegate?.textFieldShouldClear || true == textField.delegate?.textFieldShouldClear?(textField) else {
            return
        }
        
        let t = textField.text
        
        delegate?.searchBar?(searchBar: self, willClear: textField, with: t)
        
        textField.text = nil
        
        delegate?.searchBar?(searchBar: self, didClear: textField, with: t)
    }
	
    // Live updates the search results.
    @objc
    internal func handleEditingChanged(textField: UITextField) {
        delegate?.searchBar?(searchBar: self, didChange: textField, with: textField.text)
    }
    
	/// Prepares the textField.
	private func prepareTextField() {
		textField.contentScaleFactor = Screen.scale
		textField.font = RobotoFont.regular(with: 17)
		textField.backgroundColor = Color.clear
		textField.clearButtonMode = .whileEditing
		tintColor = placeholderColor
		textColor = Color.darkText.primary
		placeholder = "Search"
		contentView.addSubview(textField)
        textField.addTarget(self, action: #selector(handleEditingChanged(textField:)), for: .editingChanged)
	}
	
	/// Prepares the clearButton.
	private func prepareClearButton() {
        clearButton = IconButton(image: Icon.cm.close, tintColor: placeholderColor)
		clearButton.contentEdgeInsets = .zero
		isClearButtonAutoHandleEnabled = true
		textField.clearButtonMode = .never
		textField.rightViewMode = .whileEditing
		textField.rightView = clearButton
	}
}
