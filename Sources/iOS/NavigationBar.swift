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

open class NavigationBar: UINavigationBar {
    /// Will layout the view.
    open var willLayout: Bool {
        return 0 < width && 0 < height && nil != superview
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: Device.width, height: height)
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
	open var interimSpacePreset = InterimSpacePreset.none {
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
	
	/// Grid cell factor.
	@IBInspectable
    open var gridFactor: CGFloat = 12 {
		didSet {
			assert(0 < gridFactor, "[Material Error: gridFactor must be greater than 0.]")
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
		didSet {
			barTintColor = backgroundColor
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
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        guard self.layer == layer else {
            return
        }
        
        layoutShape()
    }
	
	open override func layoutSubviews() {
		super.layoutSubviews()
        layoutShadowPath()
		
        if let v = topItem {
			layoutNavigationItem(item: v)
		}
		
		if let v = backItem {
			layoutNavigationItem(item: v)
		}
        
        divider.reload()
	}
	
	open override func pushItem(_ item: UINavigationItem, animated: Bool) {
		super.pushItem(item, animated: animated)
		layoutNavigationItem(item: item)
	}
	
	/**
     Lays out the UINavigationItem.
     - Parameter item: A UINavigationItem to layout.
     */
	internal func layoutNavigationItem(item: UINavigationItem) {
        guard willLayout else {
            return
        }
        
        prepareItem(item: item)
        prepareTitleView(item: item)
        
        item.titleView!.frame.origin = .zero
        item.titleView!.frame.size = intrinsicContentSize

        var lc = 0
        var rc = 0
        
        item.titleView!.grid.begin()
        item.titleView!.grid.views.removeAll()
        
        for v in item.leftViews {
            if let b = v as? UIButton {
                b.contentEdgeInsets = .zero
                b.titleEdgeInsets = .zero
            }
            
            v.width = v.intrinsicContentSize.width
            v.sizeToFit()
            v.grid.columns = Int(ceil(v.width / gridFactor)) + 2
            
            lc += v.grid.columns
            
            item.titleView!.grid.views.append(v)
        }
        
        item.titleView!.grid.views.append(item.contentView)
        
        for v in item.rightViews {
            if let b = v as? UIButton {
                b.contentEdgeInsets = .zero
                b.titleEdgeInsets = .zero
            }
            
            v.width = v.intrinsicContentSize.width
            v.sizeToFit()
            v.grid.columns = Int(ceil(v.width / gridFactor)) + 2
            
            rc += v.grid.columns
            
            item.titleView!.grid.views.append(v)
        }
        
        item.contentView.grid.begin()
        item.contentView.grid.offset.columns = 0
        
        var l: CGFloat = 0
        var r: CGFloat = 0
        
        if .center == item.contentViewAlignment {
            if item.leftViews.count < item.rightViews.count {
                r = CGFloat(item.rightViews.count) * interimSpace
                l = r
            } else {
                l = CGFloat(item.leftViews.count) * interimSpace
                r = l
            }
        }
        
        let p = width - l - r - contentEdgeInsets.left - contentEdgeInsets.right
        let columns = Int(ceil(p / gridFactor))
        
        if .center == item.contentViewAlignment {
            if lc < rc {
                item.contentView.grid.columns = columns - 2 * rc
                item.contentView.grid.offset.columns = rc - lc
            } else {
                item.contentView.grid.columns = columns - 2 * lc
                item.rightViews.first?.grid.offset.columns = lc - rc
            }
        } else {
            item.contentView.grid.columns = columns - lc - rc
        }
        
        item.titleView!.grid.axis.columns = columns
        item.titleView!.grid.interimSpace = interimSpace
        item.titleView!.grid.contentEdgeInsets = contentEdgeInsets
        item.titleView!.grid.commit()
        item.contentView.grid.commit()
        
        // contentView alignment.
        if nil != item.title && "" != item.title {
            if nil == item.titleLabel.superview {
                item.contentView.addSubview(item.titleLabel)
            }
            item.titleLabel.frame = item.contentView.bounds
        } else {
            item.titleLabel.removeFromSuperview()
        }
        
        if nil != item.detail && "" != item.detail {
            if nil == item.detailLabel.superview {
                item.contentView.addSubview(item.detailLabel)
            }
            
            if nil == item.titleLabel.superview {
                item.detailLabel.frame = item.contentView.bounds
            } else {
                item.titleLabel.sizeToFit()
                item.detailLabel.sizeToFit()
                
                let diff = (item.contentView.height - item.titleLabel.height - item.detailLabel.height) / 2
                
                item.titleLabel.height += diff
                item.titleLabel.width = item.contentView.width
                
                item.detailLabel.height += diff
                item.detailLabel.width = item.contentView.width
                item.detailLabel.y = item.titleLabel.height
            }
        } else {
            item.detailLabel.removeFromSuperview()
        }
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
        interimSpacePreset = .interimSpace3
        contentEdgeInsetsPreset = .square1
        contentScaleFactor = Device.scale
		backButtonImage = Icon.cm.arrowBack
        let image = UIImage.image(with: .clear, size: CGSize(width: 1, height: 1))
		shadowImage = image
		setBackgroundImage(image, for: .default)
		backgroundColor = .white
	}
	
	/**
     Prepare the item by setting the title property to equal an empty string.
     - Parameter item: A UINavigationItem to layout.
     */
	private func prepareItem(item: UINavigationItem) {
		item.hidesBackButton = false
		item.setHidesBackButton(true, animated: false)
	}
	
	/**
     Prepare the titleView.
     - Parameter item: A UINavigationItem to layout.
     */
	private func prepareTitleView(item: UINavigationItem) {
        guard nil == item.titleView else {
            return
        }
        item.titleView = UIView(frame: .zero)
	}
}
