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

@available(iOS 9.0, *)
open class PresenterCard: Card {
    /// A preset wrapper around presenterViewEdgeInsets.
    open var presenterViewEdgeInsetsPreset = EdgeInsetsPreset.none {
        didSet {
            presenterViewEdgeInsets = EdgeInsetsPresetToValue(preset: presenterViewEdgeInsetsPreset)
        }
    }
    
    /// A reference to presenterViewEdgeInsets.
    @IBInspectable
    open var presenterViewEdgeInsets = EdgeInsets.zero {
        didSet {
            layoutSubviews()
        }
    }
    
    /// A reference to the presenterView.
    @IBInspectable
    open var presenterView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            layoutSubviews()
        }
    }
    
    open override func reload() {
        var top: CGFloat = 0
        var bottom: CGFloat = 0
        
        container.removeConstraints(container.constraints)
        
        if let v = toolbar {
            top += toolbarEdgeInsets.top
            container.layout(v).top(top).left(toolbarEdgeInsets.left).right(toolbarEdgeInsets.right).height(v.height)
            top += v.height + toolbarEdgeInsets.bottom
        }
        
        if let v = presenterView {
            top += presenterViewEdgeInsets.top
            container.layout(v).top(top).left(presenterViewEdgeInsets.left).right(presenterViewEdgeInsets.right)
            top += v.height + presenterViewEdgeInsets.bottom
        }
//
//        if let v = contentView {
//            top += contentViewEdgeInsets.top
//            container.layout(v).top(top).left(contentViewEdgeInsets.left).right(contentViewEdgeInsets.right)
//            top += v.height + contentViewEdgeInsets.bottom
//        }
//
//        if let v = bottomBar {
//            top += bottomBarEdgeInsets.top
//            container.layout(v).top(top).left(bottomBarEdgeInsets.left).right(bottomBarEdgeInsets.right).bottom(bottomBarEdgeInsets.bottom)
//            bottom += v.height + bottomBarEdgeInsets.top + bottomBarEdgeInsets.bottom
//        }
//        
//        if let v = contentView {
//            bottom += contentViewEdgeInsets.bottom
//            container.layout(v).bottom(bottom)
//            bottom += v.height + contentViewEdgeInsets.top
//        }
//        
//        if let v = presenterView {
//            bottom += presenterViewEdgeInsets.bottom
//            container.layout(v).bottom(bottom)
//            bottom += v.height + presenterViewEdgeInsets.top
//        }
//        
//        if let v = toolbar {
//            bottom += toolbarEdgeInsets.bottom
//            container.layout(v).bottom(bottom)
//        }
    }
}
