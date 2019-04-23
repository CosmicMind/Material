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

open class ErrorTextField: TextField {
  
  /// The errorLabel UILabel that is displayed.
  @IBInspectable
  public let errorLabel = UILabel()
  
  /// The errorLabel text value.
  @IBInspectable
  open var error: String? {
    get {
      return errorLabel.text
    }
    set(value) {
      errorLabel.text = value
      layoutSubviews()
    }
  }
  
  /// Error text color
  @IBInspectable
  open var errorColor = Color.red.base {
    didSet {
      errorLabel.textColor = errorColor
    }
  }
  
  /// Vertical distance for the errorLabel from the divider.
  @IBInspectable
  open var errorVerticalOffset: CGFloat = 8 {
    didSet {
      layoutSubviews()
    }
  }
  
  /// Hide or show error text.
  open var isErrorRevealed: Bool {
    get {
      return !errorLabel.isHidden
    }
    set(value) {
      errorLabel.isHidden = !value
      detailLabel.isHidden = value
      layoutSubviews()
    }
  }
  
  open override func prepare() {
    super.prepare()
    isErrorRevealed = false
    prepareErrorLabel()
  }
  
  /// Prepares the errorLabel.
  func prepareErrorLabel() {
    errorLabel.font = Theme.font.regular(with: 12)
    errorLabel.numberOfLines = 0
    errorColor = { errorColor }() // call didSet
    addSubview(errorLabel)
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    layoutBottomLabel(label: errorLabel, verticalOffset: errorVerticalOffset)
  }
  
  open override func apply(theme: Theme) {
    super.apply(theme: theme)
    
    errorColor = theme.error
  }
}
