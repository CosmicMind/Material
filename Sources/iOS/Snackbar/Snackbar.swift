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

@objc(SnackbarStatus)
public enum SnackbarStatus: Int {
  case visible
  case hidden
}

open class Snackbar: Bar {
  /// A convenience property to set the titleLabel text.
  open var text: String? {
    get {
      return textLabel.text
    }
    set(value) {
      textLabel.text = value
      layoutSubviews()
    }
  }
  
  /// A convenience property to set the titleLabel attributedText.
  open var attributedText: NSAttributedString? {
    get {
      return textLabel.attributedText
    }
    set(value) {
      textLabel.attributedText = value
      layoutSubviews()
    }
  }
  
  /// Text label.
  @IBInspectable
  public let textLabel = UILabel()
  
  open override var intrinsicContentSize: CGSize {
    return CGSize(width: bounds.width, height: 49)
  }
  
  /// The status of the snackbar.
  open internal(set) var status = SnackbarStatus.hidden
  
  open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    for v in subviews {
      let p = v.convert(point, from: self)
      if v.bounds.contains(p) {
        return v.hitTest(p, with: event)
      }
    }
    
    return super.hitTest(point, with: event)
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    guard willLayout else {
      return
    }
    
    centerViews = [textLabel]
  }
  
  open override func prepare() {
    super.prepare()
    depthPreset = .none
    interimSpacePreset = .interimSpace8
    contentEdgeInsets.left = interimSpace
    contentEdgeInsets.right = interimSpace
    backgroundColor = Color.grey.darken3
    clipsToBounds = false
    prepareTextLabel()
  }
  
  /// Prepares the textLabel.
  private func prepareTextLabel() {
    textLabel.contentScaleFactor = Screen.scale
    textLabel.font = Theme.font.medium(with: 14)
    textLabel.textAlignment = .left
    textLabel.textColor = .white
    textLabel.numberOfLines = 0
  }
}
