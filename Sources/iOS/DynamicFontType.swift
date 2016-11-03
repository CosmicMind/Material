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

@objc(DynamicFontTypeDelegate)
public protocol DynamicFontTypeDelegate {
    /**
     A delegation method that is executed when the dynamic type
     is changed.
     - Parameter dynamicFontType: A DynamicFontType.
     */
    func dynamicFontType(dynamicFontType: DynamicFontType)
}

@objc(DynamicFontType)
open class DynamicFontType: NSObject {
    /// A weak reference to a DynamicFontTypeDelegate.
    open weak var delegate: DynamicFontTypeDelegate?
    
    /// Initializer.
    public override init() {
        super.init()
        prepare()
    }
    
    @objc
    internal func handleContentSizeChange() {
        delegate?.dynamicFontType(dynamicFontType: self)
    }
    
    /// Prepare the instance object.
    private func prepare() {
        prepareContentSizeObservation()
    }
    
    /// Prepares observation for content size changes.
    private func prepareContentSizeObservation() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeChange), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
}
