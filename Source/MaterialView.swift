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

@objc(MaterialView)
public class MaterialView : UIView {
	/**
		:name:	layerClass
	*/
	public override class func layerClass() -> AnyClass {
		return MaterialLayer.self
	}
	
	/**
		:name:	materialLayer
	*/
	public var materialLayer: MaterialLayer {
		return layer as! MaterialLayer
	}
	
	/**
		:name:	delegate
	*/
	public weak var delegate: MaterialAnimationDelegate? {
		get {
			return materialLayer.animationDelegate
		}
		set(value) {
			materialLayer.animationDelegate = delegate
		}
	}
	
	/**
		:name:	image
	*/
	public var image: UIImage? {
		get {
			return materialLayer.image
		}
		set(value) {
			materialLayer.image = value
		}
	}
	
	/**
		:name:	contentsRect
	*/
	public var contentsRect: CGRect {
		get {
			return materialLayer.contentsRect
		}
		set(value) {
			materialLayer.contentsRect = value
		}
	}
	
	/**
		:name:	contentsCenter
	*/
	public var contentsCenter: CGRect {
		get {
			return materialLayer.contentsCenter
		}
		set(value) {
			materialLayer.contentsCenter = value
		}
	}
	
	/**
		:name:	contentsScale
	*/
	public var contentsScale: CGFloat {
		get {
			return materialLayer.contentsScale
		}
		set(value) {
			materialLayer.contentsScale = value
		}
	}
	
	/**
		:name:	contentsGravity
	*/
	public var contentsGravity: MaterialGravity {
		didSet {
			materialLayer.contentsGravity = MaterialGravityToString(contentsGravity)
		}
	}
	
	/**
		:name:	masksToBounds
	*/
	public var masksToBounds: Bool {
		get {
			return materialLayer.masksToBounds
		}
		set(value) {
			materialLayer.masksToBounds = value
		}
	}
	
	/**
		:name:	backgroundColor
	*/
	public override var backgroundColor: UIColor? {
		didSet {
			materialLayer.backgroundColor = backgroundColor?.CGColor
		}
	}
	
	/**
		:name:	x
	*/
	public var x: CGFloat {
		get {
			return materialLayer.x
		}
		set(value) {
			materialLayer.x = value
		}
	}
	
	/**
		:name:	y
	*/
	public var y: CGFloat {
		get {
			return materialLayer.y
		}
		set(value) {
			materialLayer.y = value
		}
	}
	
	/**
		:name:	width
	*/
	public var width: CGFloat {
		get {
			return materialLayer.width
		}
		set(value) {
			materialLayer.width = value
		}
	}
	
	/**
		:name:	height
	*/
	public var height: CGFloat {
		get {
			return materialLayer.height
		}
		set(value) {
			materialLayer.height = value
		}
	}
	
	/**
		:name:	shadowColor
	*/
	public var shadowColor: UIColor? {
		didSet {
			layer.shadowColor = shadowColor?.CGColor
		}
	}
	
	/**
		:name:	shadowOffset
	*/
	public var shadowOffset: CGSize {
		get {
			return layer.shadowOffset
		}
		set(value) {
			layer.shadowOffset = value
		}
	}
	
	/**
		:name:	shadowOpacity
	*/
	public var shadowOpacity: Float {
		get {
			return layer.shadowOpacity
		}
		set(value) {
			layer.shadowOpacity = value
		}
	}
	
	/**
		:name:	shadowRadius
	*/
	public var shadowRadius: CGFloat {
		get {
			return layer.shadowRadius
		}
		set(value) {
			layer.shadowRadius = value
		}
	}
	
	/**
		:name:	cornerRadius
	*/
	public var cornerRadius: MaterialRadius {
		didSet {
			materialLayer.cornerRadius = MaterialRadiusToValue(cornerRadius)
		}
	}
	
	/**
		:name:	shape
	*/
	public var shape: MaterialShape {
		didSet {
			if .None != shape {
				if width < height {
					width = height
				} else {
					height = width
				}
			}
		}
	}
	
	/**
		:name:	borderWidth
	*/
	public var borderWidth: MaterialBorder {
		didSet {
			materialLayer.borderWidth = MaterialBorderToValue(borderWidth)
		}
	}
	
	/**
		:name:	borderColor
	*/
	public var borderColor: UIColor? {
		didSet {
			materialLayer.borderColor = borderColor?.CGColor
		}
	}
	
	/**
		:name:	shadowDepth
	*/
	public var shadowDepth: MaterialDepth {
		didSet {
			let value: MaterialDepthType = MaterialDepthToValue(shadowDepth)
			shadowOffset = value.offset
			shadowOpacity = value.opacity
			shadowRadius = value.radius
		}
	}
	
	/**
		:name:	position
	*/
	public var position: CGPoint {
		get {
			return layer.position
		}
		set(value) {
			layer.position = value
		}
	}
	
	/**
		:name:	zPosition
	*/
	public var zPosition: CGFloat {
		get {
			return layer.zPosition
		}
		set(value) {
			layer.zPosition = value
		}
	}
	
	/**
		:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		contentsGravity = MaterialTheme.view.contentsGravity
		cornerRadius = .None
		shape = .None
		borderWidth = MaterialTheme.view.borderWidth
		shadowDepth = .None
		super.init(coder: aDecoder)
	}
	
	/**
		:name:	init
	*/
	public override init(frame: CGRect) {
		contentsGravity = MaterialTheme.view.contentsGravity
		cornerRadius = .None
		shape = .None
		borderWidth = MaterialTheme.view.borderWidth
		shadowDepth = .None
		super.init(frame: frame)
		prepareView()
	}
	
	/**
		:name:	layoutSublayersOfLayer
	*/
	public override func layoutSublayersOfLayer(layer: CALayer) {
		super.layoutSublayersOfLayer(layer)
		if self.layer == layer {
			prepareShape()
		}
	}
	
	/**
		:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectNull)
	}
	
	/**
		:name:	animation
	*/
	public func animation(animation: CAAnimation) {
		materialLayer.animation(animation)
	}
	
	//
	//	:name:	prepareView
	//
	public func prepareView() {
		userInteractionEnabled = MaterialTheme.view.userInteractionEnabled
		backgroundColor = MaterialTheme.view.backgroundColor

		contentsRect = MaterialTheme.view.contentsRect
		contentsCenter = MaterialTheme.view.contentsCenter
		contentsScale = MaterialTheme.view.contentsScale
		shape = .None
		
		shadowColor = MaterialTheme.view.shadowColor
		zPosition = MaterialTheme.view.zPosition
		masksToBounds = MaterialTheme.view.masksToBounds
		cornerRadius = MaterialTheme.view.cornerRadius
		borderColor = MaterialTheme.view.bordercolor
	}
	
	//
	//	:name:	prepareShape
	//
	internal func prepareShape() {
		if .Circle == shape {
			materialLayer.cornerRadius = width / 2
		}
	}
}

