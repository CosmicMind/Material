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

public enum AnimationKeyPath: String {
    case backgroundColor
    case cornerRadius
    case transform
    case rotation  = "transform.rotation"
    case rotationX = "transform.rotation.x"
    case rotationY = "transform.rotation.y"
    case rotationZ = "transform.rotation.z"
    case scale  = "transform.scale"
    case scaleX = "transform.scale.x"
    case scaleY = "transform.scale.y"
    case scaleZ = "transform.scale.z"
    case translation  = "transform.translation"
    case translationX = "transform.translation.x"
    case translationY = "transform.translation.y"
    case translationZ = "transform.translation.z"
    case position
    case shadowPath
}

extension CABasicAnimation {
    /**
     A convenience initializer that takes a given AnimationKeyPath.
     - Parameter keyPath: An AnimationKeyPath.
     */
    public convenience init(keyPath: AnimationKeyPath) {
        self.init(keyPath: keyPath.rawValue)
    }
}

extension Motion {
	/**
     Creates a CABasicAnimation for the backgroundColor key path.
     - Parameter color: A UIColor.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
	public static func backgroundColor(color: UIColor, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .backgroundColor)
		animation.toValue = color.cgColor
		animation.fillMode = AnimationFillModeToValue(mode: .forwards)
		animation.isRemovedOnCompletion = false
		animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		
        if let v = duration {
			animation.duration = v
		}
		
        return animation
	}
	
    /**
     Creates a CABasicAnimation for the cornerRadius key path.
     - Parameter radius: A CGFloat.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func cornerRadius(radius: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .cornerRadius)
		animation.toValue = radius
		animation.fillMode = AnimationFillModeToValue(mode: .forwards)
		animation.isRemovedOnCompletion = false
		animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		
        if let v = duration {
			animation.duration = v
		}
		
        return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform key path.
     - Parameter transform: A CATransform3D object.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func transform(transform: CATransform3D, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .transform)
		
        animation.toValue = NSValue(caTransform3D: transform)
		animation.fillMode = AnimationFillModeToValue(mode: .forwards)
		animation.isRemovedOnCompletion = false
		animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		
        if let v = duration {
			animation.duration = v
		}
		
        return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.rotation key path.
     - Parameter angle: An optional CGFloat.
     - Parameter rotation: An optional CGFloat.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func rotate(angle: CGFloat? = nil, rotation: CGFloat? = nil, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .rotation)
        
        if let v = angle {
			animation.toValue = (CGFloat(M_PI) * v / 180) as NSNumber
		} else if let v = rotation {
			animation.toValue = (CGFloat(M_PI * 2) * v) as NSNumber
		}
		
        animation.fillMode = AnimationFillModeToValue(mode: .forwards)
		animation.isRemovedOnCompletion = false
		animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		
        if let v = duration {
			animation.duration = v
		}
		return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.rotation.x key path.
     - Parameter angle: An optional CGFloat.
     - Parameter rotation: An optional CGFloat.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func rotateX(angle: CGFloat? = nil, rotation: CGFloat? = nil, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .rotationX)
		
        if let v: CGFloat = angle {
			animation.toValue = (CGFloat(M_PI) * v / 180) as NSNumber
		} else if let v: CGFloat = rotation {
			animation.toValue = (CGFloat(M_PI * 2) * v) as NSNumber
		}
		
        animation.fillMode = AnimationFillModeToValue(mode: .forwards)
		animation.isRemovedOnCompletion = false
		animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		
        if let v = duration {
			animation.duration = v
		}
		
        return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.rotation.y key path.
     - Parameter angle: An optional CGFloat.
     - Parameter rotation: An optional CGFloat.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func rotateY(angle: CGFloat? = nil, rotation: CGFloat? = nil, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .rotationY)
		
        if let v: CGFloat = angle {
			animation.toValue = (CGFloat(M_PI) * v / 180) as NSNumber
		} else if let v: CGFloat = rotation {
			animation.toValue = (CGFloat(M_PI * 2) * v) as NSNumber
		}
		
        animation.fillMode = AnimationFillModeToValue(mode: .forwards)
		animation.isRemovedOnCompletion = false
		animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		
        if let v = duration {
			animation.duration = v
		}
		
        return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.rotation.z key path.
     - Parameter angle: An optional CGFloat.
     - Parameter rotation: An optional CGFloat.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func rotateZ(angle: CGFloat? = nil, rotation: CGFloat? = nil, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .rotationZ)
		
        if let v: CGFloat = angle {
			animation.toValue = (CGFloat(M_PI) * v / 180) as NSNumber
		} else if let v: CGFloat = rotation {
			animation.toValue = (CGFloat(M_PI * 2) * v) as NSNumber
		}
		
        animation.fillMode = AnimationFillModeToValue(mode: .forwards)
		animation.isRemovedOnCompletion = false
		animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		
        if let v = duration {
			animation.duration = v
		}
		
        return animation
	}

    /**
     Creates a CABasicAnimation for the transform.scale key path.
     - Parameter by scale: A CGFloat.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func scale(by scale: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .scale)
		animation.toValue = scale as NSNumber
		animation.fillMode = AnimationFillModeToValue(mode: .forwards)
		animation.isRemovedOnCompletion = false
		animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		if let v = duration {
			animation.duration = v
		}
		return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.scale.x key path.
     - Parameter by scale: A CGFloat.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func scaleX(by scale: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .scaleX)
		animation.toValue = scale as NSNumber
		animation.fillMode = AnimationFillModeToValue(mode: .forwards)
		animation.isRemovedOnCompletion = false
		animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		if let v = duration {
			animation.duration = v
		}
		return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.scale.y key path.
     - Parameter by scale: A CGFloat.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func scaleY(by scale: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .scaleY)
		animation.toValue = scale as NSNumber
		animation.fillMode = AnimationFillModeToValue(mode: .forwards)
		animation.isRemovedOnCompletion = false
		animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		if let v = duration {
			animation.duration = v
		}
		return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.scale.z key path.
     - Parameter by scale: A CGFloat.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func scaleZ(by scale: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .scaleZ)
		animation.toValue = scale as NSNumber
		animation.fillMode = AnimationFillModeToValue(mode: .forwards)
		animation.isRemovedOnCompletion = false
		animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		if let v = duration {
			animation.duration = v
		}
		return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.translation key path.
     - Parameter size: A CGSize.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func translation(size: CGSize, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .translation)
		animation.toValue = NSValue(cgSize: size)
		animation.fillMode = AnimationFillModeToValue(mode: .forwards)
		animation.isRemovedOnCompletion = false
		animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		
        if let v = duration {
			animation.duration = v
		}
		
        return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.translation.x key path.
     - Parameter by translation: A CGFloat.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func translationX(by translation: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .translationX)
		animation.toValue = translation as NSNumber
		animation.fillMode = AnimationFillModeToValue(mode: .forwards)
		animation.isRemovedOnCompletion = false
		animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		
        if let v = duration {
			animation.duration = v
		}
		
        return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.translation.y key path.
     - Parameter by translation: A CGFloat.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func translationY(by translation: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .translationY)
		animation.toValue = translation as NSNumber
        animation.fillMode = AnimationFillModeToValue(mode: .forwards)
        animation.isRemovedOnCompletion = false
        animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		
        if let v = duration {
			animation.duration = v
		}
		
        return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.translation.z key path.
     - Parameter by translation: A CGFloat.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func translationZ(by translation: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .translationZ)
		animation.toValue = translation as NSNumber
        animation.fillMode = AnimationFillModeToValue(mode: .forwards)
        animation.isRemovedOnCompletion = false
        animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		
        if let v = duration {
			animation.duration = v
		}
		
        return animation
	}
	
    /**
     Creates a CABasicAnimation for the position key path.
     - Parameter to point: A CGPoint.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func position(to point: CGPoint, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .position)
		animation.toValue = NSValue(cgPoint: point)
        animation.fillMode = AnimationFillModeToValue(mode: .forwards)
        animation.isRemovedOnCompletion = false
        animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		
        if let v = duration {
			animation.duration = v
		}
		
        return animation
	}
	
    /**
     Creates a CABasicAnimation for the shadowPath key path.
     - Parameter to path: A CGPath.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func shadowPath(to path: CGPath, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .shadowPath)
		animation.toValue = path
        animation.fillMode = AnimationFillModeToValue(mode: .forwards)
        animation.isRemovedOnCompletion = false
        animation.timingFunction = AnimationTimingFunctionToValue(function: .linear)
		
        if let v = duration {
			animation.duration = v
		}
		
        return animation
	}
}
