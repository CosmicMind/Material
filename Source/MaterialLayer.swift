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

@objc(MaterialLayer)
public class MaterialLayer : CAShapeLayer {
	/**
		:name:	animationDelegate
	*/
	public var animationDelegate: MaterialAnimationDelegate?
	
	/**
		:name: init
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
		:name: init
	*/
	public override init(layer: AnyObject) {
		super.init(layer: layer)
	}
	
	/**
		:name: init
	*/
	public override init() {
		super.init()
	}
	
	/**
		:name:	animation
	*/
	public func animation(animation: CAAnimation) {
		animation.delegate = self
		if let a: CABasicAnimation = animation as? CABasicAnimation {
			a.fromValue = (nil == presentationLayer() ? self : presentationLayer() as! CALayer).valueForKeyPath(a.keyPath!)
		}
		if let a: CAPropertyAnimation = animation as? CAPropertyAnimation {
			addAnimation(a, forKey: a.keyPath!)
		} else if let a: CAAnimationGroup = animation as? CAAnimationGroup {
			addAnimation(a, forKey: nil)
		} else if let a: CATransition = animation as? CATransition {
			addAnimation(a, forKey: kCATransition)
		}
	}
	
	/**
		:name:	animationDidStart
	*/
	public override func animationDidStart(anim: CAAnimation) {
		animationDelegate?.materialAnimationDidStart?(anim)
	}
	
	/**
		:name:	animationDidStop
	*/
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		if let a: CAPropertyAnimation = anim as? CAPropertyAnimation {
			if let b: CABasicAnimation = a as? CABasicAnimation {
				MaterialAnimation.animationDisabled({
					self.setValue(nil == b.toValue ? b.byValue : b.toValue, forKey: b.keyPath!)
				})
			}
			animationDelegate?.materialAnimationDidStop?(anim, finished: flag)
			removeAnimationForKey(a.keyPath!)
		} else if let a: CAAnimationGroup = anim as? CAAnimationGroup {
			for x in a.animations! {
				animationDidStop(x, finished: true)
			}
		}
	}
}

