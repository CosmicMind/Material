/*
 * Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

extension NSMutableAttributedString {
  /**
   Updates a NSAttributedStringKey for a given range.
   - Parameter _ name: A NSAttributedStringKey.
   - Parameter value: Any type.
   - Parameter range: A NSRange.
   */
  open func updateAttribute(_ name: NSAttributedStringKey, value: Any, range: NSRange) {
    removeAttribute(name, range: range)
    addAttribute(name, value: value, range: range)
  }
  
  /**
   Updates a Dictionary of NSAttributedStringKeys for a given range.
   - Parameter _ attrs: A Dictionary of NSAttributedStringKey type keys and Any type values.
   - Parameter range: A NSRange.
   */
  open func updateAttributes(_ attrs: [NSAttributedStringKey: Any], range: NSRange) {
    for (k, v) in attrs {
      updateAttribute(k, value: v, range: range)
    }
  }
  
  /**
   Removes a Dictionary of NSAttributedStringKeys for a given range.
   - Parameter _ attrs: An Array of attributedStringKeys.
   - Parameter range: A NSRange.
   */
  open func removeAttributes(_ attrs: [NSAttributedStringKey], range: NSRange) {
    for k in attrs {
      removeAttribute(k, range: range)
    }
  }
}
