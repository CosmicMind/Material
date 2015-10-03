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

public extension MaterialAnimation {
	/**
		:name:	backgroundColorAnimation
	*/
	public static func backgroundColorAnimation(color: UIColor) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "backgroundColor"
		animation.toValue = color.CGColor
		return animation
	}
	
	/**
		:name:	backgroundColor
	*/
	public static func backgroundColor(view: UIView, color: UIColor, duration: CFTimeInterval = 0.25, completion: (() -> Void)? = nil) -> CABasicAnimation {
		return backgroundColor(view.layer, color: color, duration: duration, completion: completion)
	}
	
	/**
		:name:	backgroundColor
	*/
	public static func backgroundColor(layer: CALayer, color: UIColor, duration: CFTimeInterval = 0.25, completion: (() -> Void)? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = backgroundColorAnimation(color)
		animation.duration = duration
		applyBasicAnimation(animation, toLayer: layer, completion: completion)
		return animation
	}
	
	/**
		:name:	cornerRadiusAnimation
	*/
	public static func cornerRadiusAnimation(radius: CGFloat) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "cornerRadius"
		animation.toValue = radius
		return animation
	}
	
	/**
		:name:	cornerRadius
	*/
	public static func cornerRadius(view: UIView, radius: CGFloat, duration: CFTimeInterval = 0.25, completion: (() -> Void)? = nil) -> CABasicAnimation {
		return cornerRadius(view.layer, radius: radius, duration: duration, completion: completion)
	}
	
	/**
		:name:	cornerRadius
	*/
	public static func cornerRadius(layer: CALayer, radius: CGFloat, duration: CFTimeInterval = 0.25, completion: (() -> Void)? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = cornerRadiusAnimation(radius)
		animation.duration = duration
		applyBasicAnimation(animation, toLayer: layer, completion: completion)
		return animation
	}
	
	/**
		:name:	rotationAnimation
	*/
	public static func rotationAnimation(rotations: Int = 1) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform.rotation"
		animation.byValue = M_PI * 2 * Double(rotations)
		return animation
	}
	
	/**
		:name:	rotation
	*/
	public static func rotation(view: UIView, rotations: Int = 1, duration: CFTimeInterval = 0.5, completion: (() -> Void)? = nil) -> CABasicAnimation {
		return rotation(view.layer, rotations: rotations, duration: duration, completion: completion)
	}
	
	/**
		:name:	rotation
	*/
	public static func rotation(layer: CALayer, rotations: Int = 1, duration: CFTimeInterval = 0.5, completion: (() -> Void)? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = rotationAnimation(rotations)
		animation.duration = duration
		applyBasicAnimation(animation, toLayer: layer, completion: completion)
		return animation
	}
	
	/**
		:name:	scaleAnimation
	*/
	public static func scaleAnimation(transform: CATransform3D) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform"
		animation.toValue = NSValue(CATransform3D: transform)
		return animation
	}
	
	/**
		:name:	scale
	*/
	public static func scale(view: UIView, transform: CATransform3D, duration: CFTimeInterval = 0.25, completion: (() -> Void)? = nil) -> CABasicAnimation {
		return scale(view.layer, transform: transform, duration: duration, completion: completion)
	}
	
	/**
		:name:	scale
	*/
	public static func scale(layer: CALayer, transform: CATransform3D, duration: CFTimeInterval = 0.25, completion: (() -> Void)? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = scaleAnimation(transform)
		animation.duration = duration
		applyBasicAnimation(animation, toLayer: layer, completion: completion)
		return animation
	}
	
	/**
		:name:	positionAnimation
	*/
	public static func positionAnimation(point: CGPoint) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "position"
		animation.toValue = NSValue(CGPoint: point)
		return animation
	}
	
	/**
		:name:	position
	*/
	public static func position(view: UIView, point: CGPoint, duration: CFTimeInterval = 0.5, completion: (() -> Void)? = nil) -> CABasicAnimation {
		return position(view.layer, point: point, duration: duration, completion: completion)
	}
	
	/**
		:name:	position
	*/
	public static func position(layer: CALayer, point: CGPoint, duration: CFTimeInterval = 0.5, completion: (() -> Void)? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = positionAnimation(point)
		animation.duration = duration
		applyBasicAnimation(animation, toLayer: layer, completion: completion)
		return animation
	}
}