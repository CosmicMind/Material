//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

public class MaterialView: UIView {
	/**
		:name:	image
	*/
	public var image: UIImage? {
		didSet {
			layer.contents = image?.CGImage
		}
	}
	
	/**
		:name:	contentsRect
	*/
	public var contentsRect: CGRect! {
		didSet {
			layer.contentsRect = contentsRect
		}
	}
	
	/**
		:name:	contentsCenter
	*/
	public var contentsCenter: CGRect! {
		didSet {
			layer.contentsCenter = contentsCenter
		}
	}
	
	/**
		:name:	contentsScale
	*/
	public var contentsScale: CGFloat! {
		didSet {
			layer.contentsScale = contentsScale
		}
	}
	
	/**
		:name:	contentsGravity
	*/
	public var contentsGravity: MaterialGravity! {
		didSet {
			layer.contentsGravity = MaterialGravityToString(contentsGravity)
		}
	}
	
	/**
		:name:	backgroundColor
	*/
	public override var backgroundColor: UIColor? {
		get {
			return nil == layer.backgroundColor ? nil : UIColor(CGColor: layer.backgroundColor!)
		}
		set(value) {
			layer.backgroundColor = value?.CGColor
		}
	}
	
	/**
		:name:	x
	*/
	public var x: CGFloat! {
		didSet {
			layer.bounds.origin.x = x
		}
	}
	
	/**
		:name:	y
	*/
	public var y: CGFloat! {
		didSet {
			layer.bounds.origin = CGPointMake(x, y)
		}
	}
	
	/**
		:name:	width
	*/
	public var width: CGFloat! {
		didSet {
			layer.bounds.size.width = width
		}
	}
	
	/**
		:name:	height
	*/
	public var height: CGFloat! {
		didSet {
			layer.bounds.size.height = height
		}
	}
	
	/**
		:name:	shadowColor
	*/
	public var shadowColor: UIColor! {
		didSet {
			layer.shadowColor = shadowColor.CGColor
		}
	}
	
	/**
		:name:	shadowOffset
	*/
	public var shadowOffset: CGSize! {
		didSet {
			layer.shadowOffset = shadowOffset
		}
	}
	
	/**
		:name:	shadowOpacity
	*/
	public var shadowOpacity: Float! {
		didSet {
			layer.shadowOpacity = shadowOpacity
		}
	}
	
	/**
		:name:	shadowRadius
	*/
	public var shadowRadius: CGFloat! {
		didSet {
			layer.shadowRadius = shadowRadius
		}
	}
	
	/**
		:name:	masksToBounds
	*/
	public var masksToBounds: Bool! {
		didSet {
			layer.masksToBounds = masksToBounds
		}
	}
	
	/**
		:name:	shadow
	*/
	public var shadow: MaterialShadow! {
		didSet {
			let value: (offset: CGSize, opacity: Float, radius: CGFloat) = MaterialShadowToValues(shadow)
			shadowOffset = value.offset
			shadowOpacity = value.opacity
			shadowRadius = value.radius
		}
	}
	
	/**
		:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
		:name:	init
	*/
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepareView()
		prepareLayer()
		prepareBounds()
	}
	
	/**
		:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectMake(MaterialTheme.view.x, MaterialTheme.view.y, MaterialTheme.view.width, MaterialTheme.view.height))
		prepareView()
		prepareLayer()
		prepareBounds()
	}
	
	/**
		:name:	prepareView
	*/
	internal func prepareView() {
		userInteractionEnabled = MaterialTheme.view.userInteractionEnabled
		backgroundColor = MaterialTheme.view.backgroudColor
	}
	
	/**
		:name:	prepareBounds
	*/
	internal func prepareBounds() {
		x = frame.origin.x
		y = frame.origin.y
		width = frame.size.width
		height = frame.size.height
	}
	
	/**
		:name:	prepareLayer
	*/
	internal func prepareLayer() {
		contentsRect = MaterialTheme.view.contentsRect
		contentsCenter = MaterialTheme.view.contentsCenter
		contentsScale = MaterialTheme.view.contentsScale
		contentsGravity = MaterialTheme.view.contentsGravity
		shadow = MaterialTheme.view.shadow
		shadowColor = MaterialTheme.view.shadowColor
		masksToBounds = MaterialTheme.view.masksToBounds
	}
}

