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

extension NSMutableAttributedString {
    /**
     Adds a Dictionary of NSAttributedStringKeys for a given range.
     - Parameter _ stringKeys: A Dictionary of NSAttributedStringKey type keys and Any type values.
     - Parameter range: A NSRange.
     */
    open func addAttributes(_ stringKeys: [NSAttributedStringKey: Any], range: NSRange) {
        for (k, v) in stringKeys {
            addAttribute(k, value: v, range: range)
        }
    }
    
    /**
     Updates a NSAttributedStringKey for a given range.
     - Parameter _ stringKey: A NSAttributedStringKey.
     - Parameter value: Any type.
     - Parameter range: A NSRange.
     */
    open func updateAttribute(_ stringKey: NSAttributedStringKey, value: Any, range: NSRange) {
        removeAttribute(stringKey, range: range)
        addAttribute(stringKey, value: value, range: range)
    }
    
    /**
     Updates a Dictionary of NSAttributedStringKeys for a given range.
     - Parameter _ stringKeys: A Dictionary of NSAttributedStringKey type keys and Any type values.
     - Parameter range: A NSRange.
     */
    open func updateAttributes(_ stringKeys: [NSAttributedStringKey: Any], range: NSRange) {
        for (k, v) in stringKeys {
            updateAttribute(k, value: v, range: range)
        }
    }
    
    /**
     Removes a Dictionary of NSAttributedStringKeys for a given range.
     - Parameter _ stringKeys: An Array of attributedStringKeys.
     - Parameter range: A NSRange.
     */
    open func removeAttributes(_ stringKeys: [NSAttributedStringKey], range: NSRange) {
        for k in stringKeys {
            removeAttribute(k, range: range)
        }
    }
}
