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

extension UITabBarItem {
	/// Sets the color of the title color for a state.
	public func setTitleColor(color: UIColor, forState state: UIControlState) {
		setTitleTextAttributes([NSForegroundColorAttributeName: color], for: state)
	}
}

open class BottomTabBar: UITabBar {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
    
    /// Automatically aligns the BottomNavigationBar to the superview.
	open var isAlignedToParentAutomatically = true
	
	/// A property that accesses the backing layer's background
	@IBInspectable
    open override var backgroundColor: UIColor? {
		didSet {
			barTintColor = backgroundColor
		}
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
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
	
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        layoutShape()
    }
    
	open override func layoutSubviews() {
		super.layoutSubviews()
        layoutShadowPath()
        
		if let v = items {
			for item in v {
				if .phone == Device.userInterfaceIdiom {
					if nil == item.title {
						let inset: CGFloat = 7
						item.imageInsets = UIEdgeInsetsMake(inset, 0, -inset, 0)
					} else {
						let inset: CGFloat = 6
						item.titlePositionAdjustment.vertical = -inset
					}
				} else if nil == item.title {
                    let inset: CGFloat = 9
                    item.imageInsets = UIEdgeInsetsMake(inset, 0, -inset, 0)
                } else {
                    let inset: CGFloat = 3
                    item.imageInsets = UIEdgeInsetsMake(inset, 0, -inset, 0)
                    item.titlePositionAdjustment.vertical = -inset
                }
			}
		}
        
        divider.reload()
	}
	
	open override func didMoveToSuperview() {
		super.didMoveToSuperview()
		if isAlignedToParentAutomatically {
			if let v = superview {
				v.layout(self).bottom().horizontally()
			}
		}
	}
	
	/**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
	public func prepare() {
		heightPreset = .normal
        depthPreset = .depth1
        dividerAlignment = .top
		contentScaleFactor = Device.scale
		backgroundColor = .white
        let image = UIImage.image(with: .clear, size: CGSize(width: 1, height: 1))
		shadowImage = image
		backgroundImage = image
	}
}
