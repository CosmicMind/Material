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

open class NavigationBar: UINavigationBar {
    /// Will layout the view.
    open var willLayout: Bool {
        return 0 < bounds.width && 0 < bounds.height && nil != superview
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    
    /// A preset wrapper around contentEdgeInsets.
    open var contentEdgeInsetsPreset = EdgeInsetsPreset.none {
        didSet {
            contentEdgeInsets = EdgeInsetsPresetToValue(preset: contentEdgeInsetsPreset)
        }
    }
    
    /// A reference to EdgeInsets.
    @IBInspectable
    open var contentEdgeInsets = EdgeInsets.zero {
        didSet {
            layoutSubviews()
        }
    }
    
    /// A preset wrapper around interimSpace.
    open var interimSpacePreset = InterimSpacePreset.interimSpace3 {
        didSet {
            interimSpace = InterimSpacePresetToValue(preset: interimSpacePreset)
        }
    }
    
    /// A wrapper around grid.interimSpace.
    @IBInspectable
    open var interimSpace: InterimSpace = 0 {
        didSet {
            layoutSubviews()
        }
    }
	
	/**
     The back button image writes to the backIndicatorImage property and
     backIndicatorTransitionMaskImage property.
     */
	@IBInspectable
    open var backButtonImage: UIImage? {
		get {
			return backIndicatorImage
		}
		set(value) {
			let image: UIImage? = value
			backIndicatorImage = image
			backIndicatorTransitionMaskImage = image
		}
	}
	
	/// A property that accesses the backing layer's background
	@IBInspectable
    open override var backgroundColor: UIColor? {
        get {
            return barTintColor
        }
        set(value) {
            barTintColor = value
        }
	}
	
	/**
     An initializer that initializes the object with a NSCoder object.
     - Parameter aDecoder: A NSCoder instance.
     */
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepare()
	}
	
	/**
     An initializer that initializes the object with a CGRect object.
     If AutoLayout is used, it is better to initilize the instance
     using the init() initializer.
     - Parameter frame: A CGRect instance.
     */
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepare()
	}
	
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: .zero)
	}
	
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return intrinsicContentSize
	}
    
	open override func layoutSubviews() {
		super.layoutSubviews()
        layoutShape()
        layoutShadowPath()
		
        if let v = topItem {
			layoutNavigationItem(item: v)
		}
		
		if let v = backItem {
			layoutNavigationItem(item: v)
		}
        
        layoutDivider()
	}
	
	/**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
	open func prepare() {
        barStyle = .black
        isTranslucent = false
        depthPreset = .depth1
        contentScaleFactor = Screen.scale
		backButtonImage = Icon.cm.arrowBack
        contentEdgeInsetsPreset = .square1
        interimSpacePreset = .interimSpace3
        
        let image = UIImage()
        shadowImage = image
		setBackgroundImage(image, for: .default)
		backgroundColor = .white
	}
}

internal extension NavigationBar {
    /**
     Lays out the UINavigationItem.
     - Parameter item: A UINavigationItem to layout.
     */
    func layoutNavigationItem(item: UINavigationItem) {
        guard willLayout else {
            return
        }
        
        item.toolbar.backgroundColor = .clear
        
        item.titleView = item.toolbar
        
        guard let v = item.titleView as? Toolbar else {
            return
        }
        
        removeConstraints(constraints)
        v.contentEdgeInsets = contentEdgeInsets
        v.interimSpace = interimSpace
        v.frame = bounds
    }
}
