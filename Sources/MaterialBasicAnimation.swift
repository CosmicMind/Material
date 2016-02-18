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
*	*	Neither the name of Material nor the names of its
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
		if let d: CFTimeInterval = duration {
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
		if let d: CFTimeInterval = duration {
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
		if let d: CFTimeInterval = duration {
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
		if let d: CFTimeInterval = duration {
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
		if let d: CFTimeInterval = duration {
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
		if let d: CFTimeInterval = duration {
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
		if let d: CFTimeInterval = duration {
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
		if let d: CFTimeInterval = duration {
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
		if let d: CFTimeInterval = duration {
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
		if let d: CFTimeInterval = duration {
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
		if let d: CFTimeInterval = duration {
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
		if let d: CFTimeInterval = duration {
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
		if let d: CFTimeInterval = duration {
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
		if let d: CFTimeInterval = duration {
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
		if let d: CFTimeInterval = duration {
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
		if let d: CFTimeInterval = duration {
			animation.duration = d
		}
		return animation
	}
}