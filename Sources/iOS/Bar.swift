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

@objc(ContentViewAlignment)
public enum ContentViewAlignment: Int {
    case full
    case center
}

open class Bar: View {
    /// Will layout the view.
    open var willLayout: Bool {
        return 0 < width && 0 < height && nil != superview && !grid.deferred
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
    
    /// Should center the contentView.
    open var contentViewAlignment = ContentViewAlignment.full {
        didSet {
            layoutSubviews()
        }
    }
    
    /// A preset wrapper around contentEdgeInsets.
    open var contentEdgeInsetsPreset: EdgeInsetsPreset {
        get {
            return grid.contentEdgeInsetsPreset
        }
        set(value) {
            grid.contentEdgeInsetsPreset = value
        }
    }
    
    /// A reference to EdgeInsets.
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
    open var interimSpacePreset: InterimSpacePreset {
        get {
            return grid.interimSpacePreset
        }
        set(value) {
            grid.interimSpacePreset = value
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
    
    /// Grid cell factor.
    @IBInspectable
    open var gridFactor: CGFloat = 12 {
        didSet {
            assert(0 < gridFactor, "[Material Error: gridFactor must be greater than 0.]")
            layoutSubviews()
        }
    }
    
    /// ContentView that holds the any desired subviews.
    open let contentView = UIView()
    
    /// Left side UIViews.
    open var leftViews: [UIView] {
        didSet {
            for v in oldValue {
                v.removeFromSuperview()
            }
            layoutSubviews()
        }
    }
    
    /// Right side UIViews.
    open var rightViews: [UIView] {
        didSet {
            for v in oldValue {
                v.removeFromSuperview()
            }
            layoutSubviews()
        }
    }
    
    /// Center UIViews.
    open var centerViews: [UIView] {
        get {
            return contentView.grid.views
        }
        set(value) {
            contentView.grid.views = value
        }
    }
    
    /**
     An initializer that initializes the object with a NSCoder object.
     - Parameter aDecoder: A NSCoder instance.
     */
    public required init?(coder aDecoder: NSCoder) {
        leftViews = []
        rightViews = []
        super.init(coder: aDecoder)
    }
    
    /**
     An initializer that initializes the object with a CGRect object.
     If AutoLayout is used, it is better to initilize the instance
     using the init() initializer.
     - Parameter frame: A CGRect instance.
     */
    public override init(frame: CGRect) {
        leftViews = []
        rightViews = []
        super.init(frame: frame)
    }
    
    /// Convenience initializer.
    public convenience init() {
        self.init(frame: .zero)
    }
    
    /**
     A convenience initializer with parameter settings.
     - Parameter leftViews: An Array of UIViews that go on the left side.
     - Parameter rightViews: An Array of UIViews that go on the right side.
     - Parameter centerViews: An Array of UIViews that go in the center.
     */
    public convenience init(leftViews: [UIView]? = nil, rightViews: [UIView]? = nil, centerViews: [UIView]? = nil) {
        self.init()
        self.leftViews = leftViews ?? []
        self.rightViews = rightViews ?? []
        self.centerViews = centerViews ?? []
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard willLayout else {
            return
        }
        
        var lc = 0
        var rc = 0
        
        grid.begin()
        grid.views.removeAll()
        
        for v in leftViews {
            if let b = v as? UIButton {
                b.contentEdgeInsets = .zero
                b.titleEdgeInsets = .zero
            }
            
            v.width = v.intrinsicContentSize.width
            v.sizeToFit()
            v.grid.columns = Int(ceil(v.width / gridFactor)) + 2
            
            lc += v.grid.columns
            
            grid.views.append(v)
        }
        
        grid.views.append(contentView)
        
        for v in rightViews {
            if let b = v as? UIButton {
                b.contentEdgeInsets = .zero
                b.titleEdgeInsets = .zero
            }
            
            v.width = v.intrinsicContentSize.width
            v.sizeToFit()
            v.grid.columns = Int(ceil(v.width / gridFactor)) + 2
            
            rc += v.grid.columns
            
            grid.views.append(v)
        }
        
        contentView.grid.begin()
        contentView.grid.offset.columns = 0
        
        var l: CGFloat = 0
        var r: CGFloat = 0
        
        if .center == contentViewAlignment {
            if leftViews.count < rightViews.count {
                r = CGFloat(rightViews.count) * interimSpace
                l = r
            } else {
                l = CGFloat(leftViews.count) * interimSpace
                r = l
            }
        }
        
        let p = width - l - r - contentEdgeInsets.left - contentEdgeInsets.right
        let columns = Int(ceil(p / gridFactor))
        
        if .center == contentViewAlignment {
            if lc < rc {
                contentView.grid.columns = columns - 2 * rc
                contentView.grid.offset.columns = rc - lc
            } else {
                contentView.grid.columns = columns - 2 * lc
                rightViews.first?.grid.offset.columns = lc - rc
            }
        } else {
            contentView.grid.columns = columns - lc - rc
        }
        
        grid.axis.columns = columns
        grid.commit()
        contentView.grid.commit()
        
        layoutDivider()
    }
    
    open override func prepare() {
        super.prepare()
        heightPreset = .normal
        autoresizingMask = .flexibleWidth
        interimSpacePreset = .interimSpace3
        contentEdgeInsetsPreset = .square1
        
        prepareContentView()
    }
}

extension Bar {
    /// Prepares the contentView.
    fileprivate func prepareContentView() {
        contentView.contentScaleFactor = Screen.scale
    }
}
