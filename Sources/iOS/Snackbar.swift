/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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
  open let textLabel = UILabel()
  
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
    textLabel.font = RobotoFont.medium(with: 14)
    textLabel.textAlignment = .left
    textLabel.textColor = .white
    textLabel.numberOfLines = 0
  }
}
