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

@objc(MaterialCollectionViewCellDelegate)
public protocol MaterialCollectionViewCellDelegate : MaterialDelegate {
	optional func materialCollectionViewCellWillPassThresholdForLeftLayer(cell: MaterialCollectionViewCell)
	optional func materialCollectionViewCellWillPassThresholdForRightLayer(cell: MaterialCollectionViewCell)
	optional func materialCollectionViewCellDidRevealLeftLayer(cell: MaterialCollectionViewCell)
	optional func materialCollectionViewCellDidRevealRightLayer(cell: MaterialCollectionViewCell)
	optional func materialCollectionViewCellDidCloseLeftLayer(cell: MaterialCollectionViewCell)
	optional func materialCollectionViewCellDidCloseRightLayer(cell: MaterialCollectionViewCell)
}

@objc(MaterialCollectionViewCell)
public class MaterialCollectionViewCell : UICollectionViewCell, UIGestureRecognizerDelegate {
	//
	//	:name:	panRecognizer
	//
	private var panRecognizer: UIPanGestureRecognizer!
	
	//
	//	:name:	leftOnDragRelease
	//
	private var leftOnDragRelease: Bool = false
	
	//
	//	:name:	rightOnDragRelease
	//
	private var rightOnDragRelease: Bool = false
	
	//
	//	:name:	originalPosition
	//
	private var originalPosition: CGPoint!
	
	/**
		:name:	visualLayer
	*/
	public private(set) lazy var visualLayer: CAShapeLayer = CAShapeLayer()
	
	/**
		:name:	pulseLayer
	*/
	public private(set) lazy var pulseLayer: CAShapeLayer = CAShapeLayer()
	
	/**
		:name:	revealed
	*/
	public private(set) lazy var revealed: Bool = false
	
	/**
		:name:	delegate
	*/
	public weak var delegate: MaterialCollectionViewCellDelegate?
	
	/**
		:name:	pulseScale
	*/
	public lazy var pulseScale: Bool = true
	
	/**
		:name:	pulseColorOpacity
	*/
	public var pulseColorOpacity: CGFloat = MaterialTheme.pulseView.pulseColorOpacity {
		didSet {
			preparePulseLayer()
		}
	}
	
	/**
		:name:	pulseColor
	*/
	public var pulseColor: UIColor? {
		didSet {
			preparePulseLayer()
		}
	}
	
	/**
		:name:	backgroundColor
	*/
	public override var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.CGColor
		}
	}
	
	/**
		:name:	x
	*/
	public var x: CGFloat {
		get {
			return frame.origin.x
		}
		set(value) {
			frame.origin.x = value
		}
	}
	
	/**
		:name:	y
	*/
	public var y: CGFloat {
		get {
			return frame.origin.y
		}
		set(value) {
			frame.origin.y = value
		}
	}
	
	/**
		:name:	width
	*/
	public var width: CGFloat {
		get {
			return frame.size.width
		}
		set(value) {
			frame.size.width = value
			if .None != shape {
				frame.size.height = value
			}
		}
	}
	
	/**
		:name:	height
	*/
	public var height: CGFloat {
		get {
			return frame.size.height
		}
		set(value) {
			frame.size.height = value
			if .None != shape {
				frame.size.width = value
			}
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
		:name:	masksToBounds
	*/
	public var masksToBounds: Bool {
		get {
			return visualLayer.masksToBounds
		}
		set(value) {
			visualLayer.masksToBounds = value
		}
	}
	
	/**
		:name:	cornerRadius
	*/
	public var cornerRadius: MaterialRadius? {
		didSet {
			if let v: MaterialRadius = cornerRadius {
				layer.cornerRadius = MaterialRadiusToValue(v)
				if .Circle == shape {
					shape = .None
				}
			}
		}
	}
	
	/**
		:name:	shape
	*/
	public var shape: MaterialShape {
		didSet {
			if .None != shape {
				if width < height {
					frame.size.width = height
				} else {
					frame.size.height = width
				}
			}
		}
	}
	
	/**
		:name:	borderWidth
	*/
	public var borderWidth: MaterialBorder {
		didSet {
			layer.borderWidth = MaterialBorderToValue(borderWidth)
		}
	}
	
	/**
		:name:	borderColor
	*/
	public var borderColor: UIColor? {
		didSet {
			layer.borderColor = borderColor?.CGColor
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
		borderWidth = .None
		shadowDepth = .None
		shape = .None
		super.init(coder: aDecoder)
	}
	
	/**
		:name:	init
	*/
	public override init(frame: CGRect) {
		borderWidth = .None
		shadowDepth = .None
		shape = .None
		super.init(frame: frame)
		prepareView()
	}
	
	/**
		:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectNull)
	}
	
	/**
		:name:	layoutSubviews
	*/
	public override func layoutSubviews() {
		super.layoutSubviews()
		prepareShape()
		
		visualLayer.frame = bounds
		visualLayer.position = CGPointMake(width / 2, height / 2)
		visualLayer.cornerRadius = layer.cornerRadius
	}
	
	/**
		:name:	animation
	*/
	public func animation(animation: CAAnimation) {
		animation.delegate = self
		if let a: CABasicAnimation = animation as? CABasicAnimation {
			a.fromValue = (nil == layer.presentationLayer() ? layer : layer.presentationLayer() as! CALayer).valueForKeyPath(a.keyPath!)
		}
		if let a: CAPropertyAnimation = animation as? CAPropertyAnimation {
			layer.addAnimation(a, forKey: a.keyPath!)
		} else if let a: CAAnimationGroup = animation as? CAAnimationGroup {
			layer.addAnimation(a, forKey: nil)
		} else if let a: CATransition = animation as? CATransition {
			layer.addAnimation(a, forKey: kCATransition)
		}
	}
	
	/**
		:name:	animationDidStart
	*/
	public override func animationDidStart(anim: CAAnimation) {
		(delegate as? MaterialAnimationDelegate)?.materialAnimationDidStart?(anim)
	}
	
	/**
		:name:	animationDidStop
	*/
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		if let a: CAPropertyAnimation = anim as? CAPropertyAnimation {
			if let b: CABasicAnimation = a as? CABasicAnimation {
				MaterialAnimation.animationDisabled({
					self.layer.setValue(nil == b.toValue ? b.byValue : b.toValue, forKey: b.keyPath!)
				})
			}
			(delegate as? MaterialAnimationDelegate)?.materialAnimationDidStop?(anim, finished: flag)
			layer.removeAnimationForKey(a.keyPath!)
		} else if let a: CAAnimationGroup = anim as? CAAnimationGroup {
			for x in a.animations! {
				animationDidStop(x, finished: true)
			}
		}
	}
	
	/**
		:name:	touchesBegan
	*/
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		let point: CGPoint = layer.convertPoint(touches.first!.locationInView(self), fromLayer: layer)
		if true == layer.containsPoint(point) {
			let w: CGFloat = width
			let h: CGFloat = height
			let r: CGFloat = 1.05
			let t: CFTimeInterval = 0.25
			
			if nil != pulseColor && 0 < pulseColorOpacity {
				MaterialAnimation.animationDisabled({
					self.pulseLayer.bounds = CGRectMake(0, 0, 2 * w,  2 * h)
				})
				MaterialAnimation.animationWithDuration(t, animations: {
					self.pulseLayer.hidden = false
				})
			}
			
			if pulseScale {
				layer.addAnimation(MaterialAnimation.scale(r, duration: t), forKey: nil)
			}
		}
	}
	
	/**
		:name:	touchesMoved
	*/
	public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesMoved(touches, withEvent: event)
	}
	
	/**
		:name:	touchesEnded
	*/
	public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesEnded(touches, withEvent: event)
		shrink()
	}
	
	/**
		:name:	touchesCancelled
	*/
	public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		super.touchesCancelled(touches, withEvent: event)
		shrink()
	}
	
	//
	//	:name:	gestureRecognizerShouldBegin
	//
	public override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
		if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
			let translation = panGestureRecognizer.translationInView(superview!)
			return fabs(translation.x) > fabs(translation.y)
		}
		return false
	}
	
	/**
		:name:	prepareView
	*/
	public func prepareView() {
		userInteractionEnabled = MaterialTheme.flatButton.userInteractionEnabled
		backgroundColor = MaterialTheme.flatButton.backgroundColor
		pulseColorOpacity = MaterialTheme.flatButton.pulseColorOpacity
		pulseColor = MaterialTheme.flatButton.pulseColor
		
		shadowDepth = MaterialTheme.flatButton.shadowDepth
		shadowColor = MaterialTheme.flatButton.shadowColor
		zPosition = MaterialTheme.flatButton.zPosition
		cornerRadius = MaterialTheme.flatButton.cornerRadius
		borderWidth = MaterialTheme.flatButton.borderWidth
		borderColor = MaterialTheme.flatButton.bordercolor
		shape = MaterialTheme.flatButton.shape
		
		// visualLayer
		visualLayer.zPosition = -1
		layer.addSublayer(visualLayer)
		
		// pulseLayer
		pulseLayer.hidden = true
		pulseLayer.zPosition = 1
		visualLayer.addSublayer(pulseLayer)
		
		// gesture
		panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
		panRecognizer.delegate = self
		addGestureRecognizer(panRecognizer)
	}
	
	//
	//	:name:	handlePanGesture
	//
	internal func handlePanGesture(recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .Began:
			originalPosition = position
			
			rightOnDragRelease = x < -width / 2
			leftOnDragRelease = x > width / 2
			
		case .Changed:
			let translation = recognizer.translationInView(self)
			MaterialAnimation.animationDisabled({
				self.position.x = self.originalPosition.x + translation.x
			})
			
			rightOnDragRelease = x < -width / 2
			leftOnDragRelease = x > width / 2
			
			if !revealed && (leftOnDragRelease || rightOnDragRelease) {
				revealed = true
				if leftOnDragRelease {
					delegate?.materialCollectionViewCellWillPassThresholdForLeftLayer?(self)
				} else if rightOnDragRelease {
					delegate?.materialCollectionViewCellWillPassThresholdForRightLayer?(self)
				}
			}
			
			if leftOnDragRelease {
				delegate?.materialCollectionViewCellDidRevealLeftLayer?(self)
			} else if rightOnDragRelease {
				delegate?.materialCollectionViewCellDidRevealRightLayer?(self)
			}
			
		case .Ended:
			revealed = false
			
			// snap back
			let a: CABasicAnimation = MaterialAnimation.position(CGPointMake(width / 2, y + height / 2), duration: 0.25)
			a.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
			animation(a)
			
			if leftOnDragRelease {
				delegate?.materialCollectionViewCellDidCloseLeftLayer?(self)
			} else if rightOnDragRelease {
				delegate?.materialCollectionViewCellDidCloseRightLayer?(self)
			}

		default:break
		}
	}
	
	//
	//	:name:	prepareShape
	//
	internal func prepareShape() {
		if .Circle == shape {
			layer.cornerRadius = width / 2
		}
	}
	
	//
	//	:name:	preparePulseLayer
	//
	internal func preparePulseLayer() {
		pulseLayer.backgroundColor = pulseColor?.colorWithAlphaComponent(pulseColorOpacity).CGColor
	}
	
	//
	//	:name:	shrink
	//
	internal func shrink() {
		let t: CFTimeInterval = 0.25
		
		if nil != pulseColor && 0 < pulseColorOpacity {
			MaterialAnimation.animationWithDuration(t, animations: {
				self.pulseLayer.hidden = true
			})
		}
		
		if pulseScale {
			layer.addAnimation(MaterialAnimation.scale(1, duration: t), forKey: nil)
		}
	}
}
