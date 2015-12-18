//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io> and other CosmicMind contributors
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
	:name:	backgroundColor
	*/
	public static func backgroundColor(color: UIColor, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "backgroundColor"
		animation.toValue = color.CGColor
		animation.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		animation.removedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		if let d = duration {
			animation.duration = d
		}
		return animation
	}
	
	/**
	:name:	cornerRadius
	*/
	public static func cornerRadius(radius: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "cornerRadius"
		animation.toValue = radius
		animation.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		animation.removedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		if let d = duration {
			animation.duration = d
		}
		return animation
	}
	
	/**
	:name:	translation
	*/
	public static func transform(transform: CATransform3D, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform"
		animation.toValue = NSValue(CATransform3D: transform)
		animation.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		animation.removedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		if let d = duration {
			animation.duration = d
		}
		return animation
	}
	
	/**
	:name:	rotate
	*/
	public static func rotate(rotations: Double = 1, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform.rotation"
		animation.byValue = (M_PI * 2 * rotations) as NSNumber
		animation.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		animation.removedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		if let d = duration {
			animation.duration = d
		}
		return animation
	}
	
	/**
	:name:	rotateX
	*/
	public static func rotateX(rotations: Double = 1, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform.rotation.x"
		animation.byValue = (M_PI_4 * rotations) as NSNumber
		animation.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		animation.removedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		if let d = duration {
			animation.duration = d
		}
		return animation
	}
	
	/**
	:name:	rotateY
	*/
	public static func rotateY(rotations: Double = 1, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform.rotation.y"
		animation.byValue = (M_PI_4 * rotations) as NSNumber
		animation.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		animation.removedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		if let d = duration {
			animation.duration = d
		}
		return animation
	}
	
	/**
	:name:	rotateZ
	*/
	public static func rotateZ(rotations: Double = 1, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform.rotation.z"
		animation.byValue = (M_PI_4 * rotations) as NSNumber
		animation.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		animation.removedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		if let d = duration {
			animation.duration = d
		}
		return animation
	}

	/**
	:name:	scale
	*/
	public static func scale(scale: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform.scale"
		animation.toValue = scale as NSNumber
		animation.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		animation.removedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		if let d = duration {
			animation.duration = d
		}
		return animation
	}
	
	/**
	:name:	scaleX
	*/
	public static func scaleX(scale: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform.scale.x"
		animation.toValue = scale as NSNumber
		animation.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		animation.removedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		if let d = duration {
			animation.duration = d
		}
		return animation
	}
	
	/**
	:name:	scaleY
	*/
	public static func scaleY(scale: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform.scale.y"
		animation.toValue = scale as NSNumber
		animation.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		animation.removedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		if let d = duration {
			animation.duration = d
		}
		return animation
	}
	
	/**
	:name:	scaleZ
	*/
	public static func scaleZ(scale: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform.scale.z"
		animation.toValue = scale as NSNumber
		animation.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		animation.removedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		if let d = duration {
			animation.duration = d
		}
		return animation
	}
	
	/**
	:name:	translate
	*/
	public static func translate(translation: CGSize, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform.translation"
		animation.toValue = NSValue(CGSize: translation)
		animation.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		animation.removedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		if let d = duration {
			animation.duration = d
		}
		return animation
	}
	
	/**
	:name:	translateX
	*/
	public static func translateX(translation: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform.translation.x"
		animation.toValue = translation as NSNumber
		animation.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		animation.removedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		if let d = duration {
			animation.duration = d
		}
		return animation
	}
	
	/**
	:name:	translateY
	*/
	public static func translateY(translation: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform.translation.y"
		animation.toValue = translation as NSNumber
		animation.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		animation.removedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		if let d = duration {
			animation.duration = d
		}
		return animation
	}
	
	/**
	:name:	translateZ
	*/
	public static func translateZ(translation: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "transform.translation.z"
		animation.toValue = translation as NSNumber
		animation.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		animation.removedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		if let d = duration {
			animation.duration = d
		}
		return animation
	}
	
	/**
	:name:	position
	*/
	public static func position(point: CGPoint, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation()
		animation.keyPath = "position"
		animation.toValue = NSValue(CGPoint: point)
		animation.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		animation.removedOnCompletion = false
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		if let d = duration {
			animation.duration = d
		}
		return animation
	}
}