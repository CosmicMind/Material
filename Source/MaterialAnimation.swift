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

public struct MaterialAnimation {
	/**
		:name:	backgroundColor
	*/
	public static func backgroundColor(layer: CALayer, color: UIColor, duration: CFTimeInterval = 0.25, completion: (() -> Void)? = nil) {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "backgroundColor"
		animation.duration = duration
		animation.toValue = color.CGColor
		applyBasicAnimation(animation, layer: layer, completion: completion)
	}
	
	/**
		:name:	rotate
	*/
	public static func rotate(layer: CALayer, rotations: Int = 1, duration: CFTimeInterval = 0.5, completion: (() -> Void)? = nil) {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform.rotation"
		animation.duration = duration
		animation.byValue = M_PI * 2 * Double(rotations)
		applyBasicAnimation(animation, layer: layer, completion: completion)
	}
	
	/**
		:name:	transform
	*/
	public static func transform(layer: CALayer, scale: CATransform3D, duration: CFTimeInterval = 0.25, completion: (() -> Void)? = nil) {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform"
		animation.duration = duration
		animation.toValue = NSValue(CATransform3D: scale)
		applyBasicAnimation(animation, layer: layer, completion: completion)
	}
	
	/**
		:name:	position
	*/
	public static func position(layer: CALayer, point: CGPoint, duration: CFTimeInterval = 0.25, completion: (() -> Void)? = nil) {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "position"
		animation.duration = duration
		animation.toValue = NSValue(CGPoint: point)
		applyBasicAnimation(animation, layer: layer, completion: completion)
	}
	
	/**
		:name:	cornerRadius
	*/
	public static func cornerRadius(layer: CALayer, radius: CGFloat, duration: CFTimeInterval = 0.25, completion: (() -> Void)? = nil) {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "cornerRadius"
		animation.duration = duration
		animation.toValue = radius
		applyBasicAnimation(animation, layer: layer, completion: completion)
	}
	
	/**
		:name:	applyBasicAnimation
	*/
	public static func applyBasicAnimation(animation: CABasicAnimation, layer: CALayer, completion: (() -> Void)? = nil) {
		// use presentation layer if available
		animation.fromValue = (nil == layer.presentationLayer() ? layer : layer.presentationLayer() as! CALayer).valueForKeyPath(animation.keyPath!)
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		CATransaction.setCompletionBlock(completion)
		if let v = animation.toValue {
			layer.setValue(v, forKey: animation.keyPath!)
		} else if let v = animation.byValue {
			layer.setValue(v, forKey: animation.keyPath!)
		}
		CATransaction.commit()
		layer.addAnimation(animation, forKey: nil)
	}
	
	/**
		:name:	disableAnimation
	*/
	public static func disableAnimation(block: (() -> Void)) {
		CATransaction.begin()
		CATransaction.setAnimationDuration(0)
		block()
		CATransaction.commit()
	}
}
