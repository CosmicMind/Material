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

extension NSMutableAttributedString {
  /**
   Updates a NSAttributedStringKey for a given range.
   - Parameter _ name: A NSAttributedStringKey.
   - Parameter value: Any type.
   - Parameter range: A NSRange.
   */
  open func updateAttribute(_ name: NSAttributedString.Key, value: Any, range: NSRange) {
    removeAttribute(name, range: range)
    addAttribute(name, value: value, range: range)
  }
  
  /**
   Updates a Dictionary of NSAttributedStringKeys for a given range.
   - Parameter _ attrs: A Dictionary of NSAttributedStringKey type keys and Any type values.
   - Parameter range: A NSRange.
   */
  open func updateAttributes(_ attrs: [NSAttributedString.Key: Any], range: NSRange) {
    for (k, v) in attrs {
      updateAttribute(k, value: v, range: range)
    }
  }
  
  /**
   Removes a Dictionary of NSAttributedStringKeys for a given range.
   - Parameter _ attrs: An Array of attributedStringKeys.
   - Parameter range: A NSRange.
   */
  open func removeAttributes(_ attrs: [NSAttributedString.Key], range: NSRange) {
    for k in attrs {
      removeAttribute(k, range: range)
    }
  }
}
