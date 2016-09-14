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
    /// Will render the view.
    open var willLayout: Bool {
        return 0 < width && nil != superview
    }
    
    /// A preset wrapper around contentInset.
    open var contentEdgeInsetsPreset: EdgeInsetsPreset {
        get {
            return grid.contentEdgeInsetsPreset
        }
        set(value) {
            grid.contentEdgeInsetsPreset = value
        }
    }
    
    /// A wrapper around grid.contentInset.
    @IBInspectable
    open var contentEdgeInsets: EdgeInsets {
        get {
            return grid.contentEdgeInsets
        }
        set(value) {
            grid.contentEdgeInsets = value
        }
    }
    
    /// A preset wrapper around interimSpace.
    open var interimSpacePreset = InterimSpacePreset.none {
        didSet {
            interimSpace = InterimSpacePresetToValue(preset: interimSpacePreset)
        }
    }
    
    /// A wrapper around grid.interimSpace.
    @IBInspectable
    open var interimSpace: InterimSpace {
        get {
            return grid.interimSpace
        }
        set(value) {
            grid.interimSpace = value
        }
    }
    
    /// A reference to the titleBar.
    open var titleBar: Toolbar? {
        didSet {
            layoutSubviews()
        }
    }
    
    /// A reference to the contentView.
    open var contentView = UIView() {
        didSet {
            layoutSubviews()
        }
    }
    
    /// A reference to the bottomBar.
    open var bottomBar: BarView? {
        didSet {
            layoutSubviews()
        }
    }
    
    /// Grid cell factor.
    @IBInspectable
    open var gridFactor: CGFloat = 24 {
        didSet {
            assert(0 < gridFactor, "[Material Error: gridFactor must be greater than 0.]")
            layoutSubviews()
        }
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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard willLayout else {
            return
        }
        
        // clear constraints so new ones do not conflict
        removeConstraints(constraints)
        for v in subviews {
            v.removeFromSuperview()
        }
        
        var views = [String: Any]()
        var format = "V:|"
        
        if let v = titleBar {
            views["titleBar"] = v
            format += "[titleBar]"
            _ = layout(v).horizontally()
        }
        
        views["contentView"] = contentView
        format += "[contentView]"
        _ = layout(contentView).horizontally()
        contentView.layoutIfNeeded()
        
        if let v = bottomBar {
            views["bottomBar"] = v
            format += "[bottomBar]"
            _ = layout(v).horizontally()
        }
        
        addConstraints(Layout.constraint(format: "\(format)|", options: [], metrics: nil, views: views))
    }
}
