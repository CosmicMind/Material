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

open class ContentCard: PulseView {
    /// An internal reference to the titleToolbar.
    internal var internalTitleToolbar: Toolbar?
    
    /// A reference to the titleToolbar.
    open var titleToolbar: Toolbar {
        prepareTitleToolbar()
        return internalTitleToolbar!
    }
    
    /// An internal reference to the contentView.
    internal var internalContentView: UIView?
    
    /// A reference to the contentView.
    open var contentView: UIView {
        prepareContentView()
        return internalContentView!
    }
    
    /// An internal reference to the detailToolbar.
    internal var internalDetailToolbar: Toolbar?
    
    /// A reference to the detailToolbar.
    open var detailToolbar: Toolbar {
        prepareDetailToolbar()
        return internalDetailToolbar!
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
        pulseAnimation = .none
    }
    
    /// Reloads the
    open func reload() {
        // clear constraints so new ones do not conflict
        removeConstraints(constraints)
        for v in subviews {
            v.removeFromSuperview()
        }
        
        
    }
    
    /// Prepares the titleToolbar.
    private func prepareTitleToolbar() {
        guard nil == internalTitleToolbar else {
            return
        }
        internalTitleToolbar = Toolbar()
    }
    
    /// Prepares the contentView.
    private func prepareContentView() {
        guard nil == internalContentView else {
            return
        }
        internalContentView = UIView()
    }
    
    /// Prepares the detailToolbar.
    private func prepareDetailToolbar() {
        guard nil == internalDetailToolbar else {
            return
        }
        internalDetailToolbar = Toolbar()
    }
}
