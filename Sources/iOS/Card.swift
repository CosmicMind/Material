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

open class Card: PulseView {
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
            layoutSubviews()
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
            layoutSubviews()
        }
    }
    
    /// A reference to the toolbar.
    @IBInspectable
    open var toolbar: Toolbar? {
        didSet {
            layoutSubviews()
        }
    }
    
    /// A reference to the contentView.
    @IBInspectable
    open var contentView: UIView? {
        didSet {
            layoutSubviews()
        }
    }
    
    /// A reference to the bottomBar.
    @IBInspectable
    open var bottomBar: Bar? {
        didSet {
            layoutSubviews()
        }
    }
    
    /**
     An initializer that accepts a NSCoder.
     - Parameter coder aDecoder: A NSCoder.
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     An initializer that accepts a CGRect.
     - Parameter frame: A CGRect.
     */
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// A convenience initializer.
    public convenience init() {
        self.init(frame: .zero)
    }
    
    /**
     A convenience initiazlier.
     - Parameter toolbar: An optional Toolbar.
     - Parameter contentView: An optional UIView.
     - Parameter bottomBar: An optional Bar.
     */
    public convenience init?(toolbar: Toolbar?, contentView: UIView?, bottomBar: Bar?) {
        self.init(frame: .zero)
        prepareProperties(toolbar: toolbar, contentView: contentView, bottomBar: bottomBar)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        reload()
    }
    
    /// Reloads the layout.
    open func reload() {
        guard willLayout else {
            return
        }
        
        // clear constraints so new ones do not conflict
        removeConstraints(constraints)
        for v in subviews {
            v.removeFromSuperview()
        }
        
        layout()
    }
    
    /// Lays out view.
    open func layout() {
        var format = "V:|"
        var views = [String: Any]()
        
        if let v = toolbar {
            format += "[toolbar]"
            views["toolbar"] = v
            layout(v).horizontally().height(v.height)
            v.grid.reload()
        }
        
        if let v = contentView {
            format += "-(top)-[contentView]-(bottom)-"
            views["contentView"] = v
            layout(v).horizontally(left: contentEdgeInsets.left, right: contentEdgeInsets.right)
        }
        
        if let v = bottomBar {
            format += "[bottomBar]"
            views["bottomBar"] = v
            layout(v).horizontally().height(v.height)
        }
        
        guard 0 < views.count else {
            return
        }
        
        var metrics = [String: Any]()
        metrics["top"] = contentEdgeInsets.top
        metrics["bottom"] = contentEdgeInsets.bottom
        
        addConstraints(Layout.constraint(format: "\(format)|", options: [], metrics: metrics, views: views))
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
        depthPreset = .depth1
        pulseAnimation = .none
    }
    
    /**
     A preparation method that sets the base UI elements.
     - Parameter toolbar: An optional Toolbar.
     - Parameter contentView: An optional UIView.
     - Parameter bottomBar: An optional Bar.
     */
    internal func prepareProperties(toolbar: Toolbar?, contentView: UIView?, bottomBar: Bar?) {
        self.toolbar = toolbar
        self.contentView = contentView
        self.bottomBar = bottomBar
    }
}
