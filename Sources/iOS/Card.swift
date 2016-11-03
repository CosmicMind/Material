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

open class Card: PulseView {
    /// Will layout the view.
    open var willLayout: Bool {
        return 0 < width && nil != superview
    }
    
    /// A container view for subviews.
    open private(set) lazy var container = UIView()
    
    @IBInspectable
    open override var cornerRadiusPreset: CornerRadiusPreset {
        didSet {
            container.cornerRadiusPreset = cornerRadiusPreset
        }
    }
    
    @IBInspectable
    open override var cornerRadius: CGFloat {
        didSet {
            container.cornerRadius = cornerRadius
        }
    }
    
    open override var shapePreset: ShapePreset {
        didSet {
            container.shapePreset = shapePreset
        }
    }
    
    @IBInspectable
    open override var backgroundColor: UIColor? {
        didSet {
            container.backgroundColor = backgroundColor
        }
    }
    
    /// A reference to the toolbar.
    @IBInspectable
    open var toolbar: Toolbar? {
        didSet {
            oldValue?.removeFromSuperview()
            if let v = toolbar {
                container.addSubview(v)
            }
            layoutSubviews()
        }
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
    
    /// A reference to the contentView.
    @IBInspectable
    open var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let v = contentView {
                v.clipsToBounds = true
                container.addSubview(v)
            }
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
    
    /// A reference to the bottomBar.
    @IBInspectable
    open var bottomBar: Bar? {
        didSet {
            oldValue?.removeFromSuperview()
            if let v = bottomBar {
                container.addSubview(v)
            }
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
        guard willLayout else {
            return
        }
        
        container.width = width
        
        reload()
    }
    
    /// Reloads the layout.
    open func reload() {
        var h: CGFloat = 0
        
        h = prepare(view: toolbar, with: toolbarEdgeInsets, from: h)
        h = prepare(view: contentView, with: contentViewEdgeInsets, from: h)
        h = prepare(view: bottomBar, with: bottomBarEdgeInsets, from: h)
        
        container.height = h
        bounds.size.height = h
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
        cornerRadiusPreset = .cornerRadius1
        prepareContainer()
    }
    
    /**
     Prepare the view size from a given top position.
     - Parameter view: A UIView.
     - Parameter edge insets: An EdgeInsets.
     - Parameter from top: A CGFloat.
     - Returns: A CGFloat.
     */
    @discardableResult
    open func prepare(view: UIView?, with insets: EdgeInsets, from top: CGFloat) -> CGFloat {
        guard let v = view else {
            return top
        }
        
        let t = insets.top + top
        
        v.y = t
        v.x = insets.left
        
        let w = container.width - insets.left - insets.right
        var h = v.height
        
        if 0 == h {
            (v as? UILabel)?.sizeToFit()
            h = v.sizeThatFits(CGSize(width: w, height: CGFloat.greatestFiniteMagnitude)).height
        }
        
        v.width = w
        v.height = h
        
        return t + h + insets.bottom
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
    
    /// Prepares the container.
    private func prepareContainer() {
        container.clipsToBounds = true
        addSubview(container)
    }
}
