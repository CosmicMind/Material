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

open class Card: PulseView {
    /// A container view for subviews.
    open let container = UIView()
    
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
        container.width = width
        reload()
    }
    
    /// Reloads the layout.
    open func reload() {
        var h: CGFloat = 0
        
        if let v = toolbar {
            h = prepare(view: v, with: toolbarEdgeInsets, from: h)
        }
        
        if let v = contentView {
            h = prepare(view: v, with: contentViewEdgeInsets, from: h)
        }
        
        if let v = bottomBar {
            h = prepare(view: v, with: bottomBarEdgeInsets, from: h)
        }
        
        container.height = h
        bounds.size.height = h
    }
    
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
    open func prepare(view: UIView, with insets: EdgeInsets, from top: CGFloat) -> CGFloat {
        let y = insets.top + top
        
        view.y = y
        view.x = insets.left
        
        let w = container.width - insets.left - insets.right
        var h = view.height
        
        if 0 == h || nil != view as? UILabel {
            (view as? UILabel)?.sizeToFit()
            h = view.sizeThatFits(CGSize(width: w, height: CGFloat.greatestFiniteMagnitude)).height
        }
        
        view.width = w
        view.height = h
        
        return y + h + insets.bottom
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

extension Card {
    /// Prepares the container.
    fileprivate func prepareContainer() {
        container.clipsToBounds = true
        addSubview(container)
    }
}
