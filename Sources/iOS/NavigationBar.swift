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

/// NavigationBar styles.
@objc(NavigationBarStyle)
public enum NavigationBarStyle: Int {
	case small
	case medium
	case large
}

@IBDesignable
open class NavigationBar: UINavigationBar {
    /// A reference to the divider.
    open internal(set) var divider: Divider!
    
    open override var intrinsicContentSize: CGSize {
        switch navigationBarStyle {
        case .small:
            return CGSize(width: Device.width, height: 32)
        case .medium:
            return CGSize(width: Device.width, height: 44)
        case .large:
            return CGSize(width: Device.width, height: 56)
        }
    }
    
	/// NavigationBarStyle value.
	open var navigationBarStyle = NavigationBarStyle.medium
	
	internal var animating = false
	
	/// Will render the view.
	open var willRenderView: Bool {
		return 0 < width && 0 < height && nil != superview
	}
	
	/// A preset wrapper around contentInset.
	open var contentEdgeInsetsPreset = EdgeInsetsPreset.none {
		didSet {
            contentEdgeInsets = EdgeInsetsPresetToValue(preset: contentEdgeInsetsPreset)
		}
	}
	
	/// A wrapper around grid.contentInset.
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
    open var gridFactor: CGFloat = 24 {
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
	
	/// A property that accesses the backing layer's backgroundColor.
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
		prepareView()
	}
	
	/**
     An initializer that initializes the object with a CGRect object.
     If AutoLayout is used, it is better to initilize the instance
     using the init() initializer.
     - Parameter frame: A CGRect instance.
     */
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepareView()
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
        if self.layer == layer {
            layoutShape()
        }
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
        
        if let v = divider {
            v.reload()
        }
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
		if willRenderView {
			prepareItem(item: item)
			
			let titleView = prepareTitleView(item: item)
            let contentView = prepareContentView(item: item)
            
            let l = (CGFloat(item.leftControls.count) * interimSpace)
            let r = (CGFloat(item.rightControls.count) * interimSpace)
            let p = width - l - r - contentEdgeInsets.left - contentEdgeInsets.right
            let columns = Int(p / gridFactor)
            
            titleView.frame.origin = .zero
            titleView.frame.size = intrinsicContentSize
            titleView.grid.views.removeAll()
            titleView.grid.axis.columns = columns
            
            contentView.grid.columns = columns
            
            for v in item.leftControls {
                var w: CGFloat = 0
                if let b = v as? UIButton {
                    b.contentEdgeInsets = .zero
                    b.sizeToFit()
                    w = b.width
                }
                v.height = frame.size.height - contentEdgeInsets.top - contentEdgeInsets.bottom
                v.grid.columns = Int(ceil(w / gridFactor)) + 1
                
                contentView.grid.columns -= v.grid.columns
                
                titleView.grid.views.append(v)
            }
            
            titleView.grid.views.append(contentView)
            
            for v in item.rightControls {
                var w: CGFloat = 0
                if let b = v as? UIButton {
                    b.contentEdgeInsets = .zero
                    b.sizeToFit()
                    w = b.width
                }
                v.height = frame.size.height - contentEdgeInsets.top - contentEdgeInsets.bottom
                v.grid.columns = Int(ceil(w / gridFactor)) + 1
                
                contentView.grid.columns -= v.grid.columns
                
                titleView.grid.views.append(v)
            }
            
            titleView.grid.contentEdgeInsets = contentEdgeInsets
            titleView.grid.interimSpace = interimSpace
            titleView.grid.reload()
            
            // contentView alignment.
            if nil != item.title && "" != item.title {
                if nil == item.titleLabel.superview {
                    contentView.addSubview(item.titleLabel)
                }
                item.titleLabel.frame = contentView.bounds
            } else {
                item.titleLabel.removeFromSuperview()
            }
            
            if nil != item.detail && "" != item.detail {
                if nil == item.detailLabel.superview {
                    contentView.addSubview(item.detailLabel)
                }
                
                if nil == item.titleLabel.superview {
                    item.detailLabel.frame = contentView.bounds
                } else {
                    item.titleLabel.sizeToFit()
                    item.detailLabel.sizeToFit()
                    
                    let diff = (contentView.frame.height - item.titleLabel.frame.height - item.detailLabel.frame.height) / 2
                    
                    item.titleLabel.frame.size.height += diff
                    item.titleLabel.frame.size.width = contentView.frame.width
                    
                    item.detailLabel.frame.size.height += diff
                    item.detailLabel.frame.size.width = contentView.frame.width
                    item.detailLabel.frame.origin.y = item.titleLabel.frame.height
                }
            } else {
                item.detailLabel.removeFromSuperview()
            }
            
            contentView.grid.reload()
        }
	}
	
	/**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepareView method
     to initialize property values and other setup operations.
     The super.prepareView method should always be called immediately
     when subclassing.
     */
	public func prepareView() {
        barStyle = .black
		isTranslucent = false
		depthPreset = .depth1
		interimSpacePreset = .interimSpace1
		contentEdgeInsetsPreset = .square1
		contentScaleFactor = Device.scale
		backButtonImage = Icon.cm.arrowBack
        let image = UIImage.imageWithColor(color: Color.clear, size: CGSize(width: 1, height: 1))
		shadowImage = image
		setBackgroundImage(image, for: .default)
		backgroundColor = Color.white
        prepareDivider()
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
     - Returns: A UIView, which is the item.titleView.
     */
	private func prepareTitleView(item: UINavigationItem) -> UIView {
		if nil == item.titleView {
			item.titleView = UIView(frame: .zero)
		}
		return item.titleView!
	}
	
	/**
     Prepare the contentView.
     - Parameter item: A UINavigationItem to layout.
     - Returns: A UIView, which is the item.contentView.
     */
	private func prepareContentView(item: UINavigationItem) -> UIView {
		if nil == item.contentView {
			item.contentView = UIView(frame: .zero)
		}
		item.contentView!.grid.axis.direction = .vertical
		return item.contentView!
	}
    
    /// Prepares the divider.
    private func prepareDivider() {
        divider = Divider(view: self)
    }
}
