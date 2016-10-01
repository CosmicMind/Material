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
    
    /// A preset wrapper around toolbarEdgeInsets.
    open var toolbarEdgeInsetsPreset = EdgeInsetsPreset.none {
        didSet {
            toolbarEdgeInsets = EdgeInsetsPresetToValue(preset: toolbarEdgeInsetsPreset)
        }
    }
    
    /// A reference to toolbarEdgeInsets.
    @IBInspectable
    open var toolbarEdgeInsets = EdgeInsets.zero {
        didSet {
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
    
    /// A preset wrapper around contentViewEdgeInsets.
    open var contentViewEdgeInsetsPreset = EdgeInsetsPreset.none {
        didSet {
            contentViewEdgeInsets = EdgeInsetsPresetToValue(preset: contentViewEdgeInsetsPreset)
        }
    }
    
    /// A reference to contentViewEdgeInsets.
    @IBInspectable
    open var contentViewEdgeInsets = EdgeInsets.zero {
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
    
    /// A preset wrapper around bottomBarEdgeInsets.
    open var bottomBarEdgeInsetsPreset = EdgeInsetsPreset.none {
        didSet {
            bottomBarEdgeInsets = EdgeInsetsPresetToValue(preset: bottomBarEdgeInsetsPreset)
        }
    }
    
    /// A reference to bottomBarEdgeInsets.
    @IBInspectable
    open var bottomBarEdgeInsets = EdgeInsets.zero {
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
        var metrics = [String: Any]()
        
        if let v = toolbar {
            metrics["toolbarTop"] = toolbarEdgeInsets.top
            metrics["toolbarBottom"] = toolbarEdgeInsets.bottom
            
            format += "-(toolbarTop)-[toolbar]-(toolbarBottom)"
            views["toolbar"] = v
            layout(v).horizontally(left: toolbarEdgeInsets.left, right: toolbarEdgeInsets.right).height(v.height)
            v.grid.reload()
            v.divider.reload()
        }
        
        if let v = contentView {
            metrics["contentViewBottom"] = contentViewEdgeInsets.bottom
            
            if nil != toolbar {
                metrics["toolbarBottom"] = (metrics["toolbarBottom"] as! CGFloat) + contentViewEdgeInsets.top
                format += "-[contentView]-(contentViewBottom)"
            } else {
                metrics["contentViewTop"] = contentViewEdgeInsets.top
                format += "-(contentViewTop)-[contentView]-(contentViewBottom)"
            }
            
            views["contentView"] = v
            layout(v).horizontally(left: contentViewEdgeInsets.left, right: contentViewEdgeInsets.right)
            v.grid.reload()
            v.divider.reload()
        }
        
        if let v = bottomBar {
            metrics["bottomBarBottom"] = bottomBarEdgeInsets.bottom
            
            if nil != contentView {
                metrics["contentViewBottom"] = (metrics["contentViewBottom"] as! CGFloat) + bottomBarEdgeInsets.top
                format += "-[bottomBar]-(bottomBarBottom)"
            } else if nil != toolbar {
                metrics["toolbarBottom"] = (metrics["toolbarBottom"] as! CGFloat) + bottomBarEdgeInsets.top
                format += "-[bottomBar]-(bottomBarBottom)"
            } else {
                metrics["bottomBarTop"] = bottomBarEdgeInsets.top
                format += "-(bottomBarTop)-[bottomBar]-(bottomBarBottom)"
            }
            
            views["bottomBar"] = v
            layout(v).horizontally(left: bottomBarEdgeInsets.left, right: bottomBarEdgeInsets.right).height(v.height)
            v.grid.reload()
            v.divider.reload()
        }
        
        guard 0 < views.count else {
            return
        }
        
        addConstraints(Layout.constraint(format: "\(format)-|", options: [], metrics: metrics, views: views))
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
