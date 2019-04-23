/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
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
  @IBInspectable
  public let textField = UITextField()
  
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
        textField.attributedPlaceholder = NSAttributedString(string: v, attributes: [.foregroundColor: placeholderColor])
      }
    }
  }
  
  /// Placeholder text
  @IBInspectable
  open var placeholderColor = Color.darkText.others {
    didSet {
      if let v = placeholder {
        textField.attributedPlaceholder = NSAttributedString(string: v, attributes: [.foregroundColor: placeholderColor])
      }
    }
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
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    guard willLayout else {
      return
    }
    
    layoutTextField()
    layoutLeftView()
    layoutClearButton()
  }
  
  open override func prepare() {
    super.prepare()
    prepareTextField()
    prepareClearButton()
  }
}

extension SearchBar {
  /// Layout the textField.
  open func layoutTextField() {
    textField.frame = contentView.bounds
  }
  
  /// Layout the leftView.
  open func layoutLeftView() {
    guard let v = textField.leftView else {
      return
    }
    
    let h = textField.frame.height
    v.frame = CGRect(x: 4, y: 4, width: h, height: h - 8)
    
    (v as? UIImageView)?.contentMode = .scaleAspectFit
  }
  
  /// Layout the clearButton.
  open func layoutClearButton() {
    let h = textField.frame.height
    clearButton.frame = CGRect(x: textField.frame.width - h - 4, y: 4, width: h, height: h - 8)
  }
}

fileprivate extension SearchBar {
  /// Clears the textField text.
  @objc
  func handleClearButton() {
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
  func handleEditingChanged(textField: UITextField) {
    delegate?.searchBar?(searchBar: self, didChange: textField, with: textField.text)
  }
}

fileprivate extension SearchBar {
  /// Prepares the textField.
  func prepareTextField() {
    textField.contentScaleFactor = Screen.scale
    textField.font = Theme.font.regular(with: 17)
    textField.backgroundColor = Color.clear
    textField.clearButtonMode = .whileEditing
    textField.addTarget(self, action: #selector(handleEditingChanged(textField:)), for: .editingChanged)
    tintColor = placeholderColor
    textColor = Color.darkText.primary
    placeholder = "Search"
    contentView.addSubview(textField)
  }
  
  /// Prepares the clearButton.
  func prepareClearButton() {
    clearButton = IconButton(image: Icon.cm.close, tintColor: placeholderColor)
    clearButton.contentEdgeInsets = .zero
    isClearButtonAutoHandleEnabled = true
    textField.clearButtonMode = .never
    textField.rightViewMode = .whileEditing
    textField.rightView = clearButton
  }
}
